import Foundation
import Combine
import UserNotifications

enum DeviceStatus: CustomStringConvertible {
    case on, off, open, closed, unknown

    var description: String {
        switch self {
        case .on: return "On"
        case .off: return "Off"
        case .open: return "Open"
        case .closed: return "Closed"
        case .unknown: return "Unknown"
        }
    }
}

enum DeviceType: String, CaseIterable {
    case camera = "Camera"
    case doorbell = "Doorbell"
    case motionSensor = "Motion Sensor"
    case floodlight = "Floodlight"
    case chime = "Chime"
    
    var iconName: String {
        switch self {
        case .camera: return "video.fill"
        case .doorbell: return "bell.fill"
        case .motionSensor: return "sensor.tag.radiowaves.forward.fill"
        case .floodlight: return "lightbulb.fill"
        case .chime: return "speaker.wave.3.fill"
        }
    }
}

struct SmartDevice: Identifiable {
    let id: UUID
    let name: String
    var status: DeviceStatus
    let deviceType: DeviceType
    let batteryLevel: Int?
    let lastSeen: Date?
    let location: String?
    
    init(id: UUID, name: String, status: DeviceStatus, deviceType: DeviceType = .camera, batteryLevel: Int? = nil, lastSeen: Date? = nil, location: String? = nil) {
        self.id = id
        self.name = name
        self.status = status
        self.deviceType = deviceType
        self.batteryLevel = batteryLevel
        self.lastSeen = lastSeen
        self.location = location
    }
}

class SmartHomeManager: ObservableObject {

    static let shared = SmartHomeManager()

    @Published private(set) var devices: [SmartDevice] = []
    @Published private(set) var recentMotionAlerts: [MotionAlert] = []
    @Published private(set) var isLoading = false
    @Published private(set) var lastError: RingAPIError?
    @Published private(set) var deviceStatuses: [UUID: RingDeviceStatus] = [:]

    // MARK: - System Health & Performance
    
    @Published private(set) var systemHealth: SystemHealth = .unknown
    @Published private(set) var performanceMetrics: PerformanceMetrics = PerformanceMetrics()
    
    struct SystemHealth {
        enum Status {
            case excellent, good, fair, poor, critical
        }
        
        let status: Status
        let score: Int // 0-100
        let issues: [String]
        let lastUpdated: Date
        
        static let unknown = SystemHealth(status: .unknown, score: 0, issues: [], lastUpdated: Date())
    }
    
    struct PerformanceMetrics {
        var averageResponseTime: TimeInterval = 0
        var deviceOnlineRate: Double = 0
        var batteryHealthScore: Int = 0
        var networkLatency: TimeInterval = 0
        var lastUpdated: Date = Date()
    }
    
    // MARK: - Analytics & User Behavior Tracking
    
    @Published private(set) var userAnalytics: UserAnalytics = UserAnalytics()
    
    struct UserAnalytics {
        var sessionStartTime: Date = Date()
        var totalSessions: Int = 0
        var averageSessionDuration: TimeInterval = 0
        var mostUsedFeatures: [String: Int] = [:]
        var deviceInteractions: [String: Int] = [:]
        var errorOccurrences: [String: Int] = [:]
        var lastUpdated: Date = Date()
    }
    
    func trackUserAction(_ action: String, context: String? = nil) {
        let key = context != nil ? "\(action)_\(context!)" : action
        userAnalytics.mostUsedFeatures[key, default: 0] += 1
        userAnalytics.lastUpdated = Date()
        
        // Send to analytics service (implement as needed)
        print("📊 Analytics: \(action) - \(context ?? "no context")")
    }
    
    func trackDeviceInteraction(_ deviceId: UUID, action: String) {
        let key = "\(deviceId.uuidString)_\(action)"
        userAnalytics.deviceInteractions[key, default: 0] += 1
        userAnalytics.lastUpdated = Date()
    }
    
    func trackError(_ error: Error, context: String) {
        let errorKey = "\(context)_\(error.localizedDescription)"
        userAnalytics.errorOccurrences[errorKey, default: 0] += 1
        userAnalytics.lastUpdated = Date()
    }
    
    // MARK: - Push Notification Preferences
    
    @Published var notificationPreferences: NotificationPreferences = NotificationPreferences()
    
    struct NotificationPreferences: Codable {
        var motionAlerts: Bool = true
        var doorbellRings: Bool = true
        var systemAlerts: Bool = true
        var batteryWarnings: Bool = true
        var quietHours: QuietHours = QuietHours()
        var deviceSpecificAlerts: [String: Bool] = [:]
        
        struct QuietHours: Codable {
            var enabled: Bool = false
            var startTime: Date = Calendar.current.date(from: DateComponents(hour: 22, minute: 0)) ?? Date()
            var endTime: Date = Calendar.current.date(from: DateComponents(hour: 7, minute: 0)) ?? Date()
        }
    }
    
    func updateNotificationPreferences(_ preferences: NotificationPreferences) {
        notificationPreferences = preferences
        saveNotificationPreferences()
        
        // Update system notification settings
        updateSystemNotificationSettings()
    }
    
    private func saveNotificationPreferences() {
        if let encoded = try? JSONEncoder().encode(notificationPreferences) {
            UserDefaults.standard.set(encoded, forKey: "notificationPreferences")
        }
    }
    
    private func loadNotificationPreferences() {
        if let data = UserDefaults.standard.data(forKey: "notificationPreferences"),
           let preferences = try? JSONDecoder().decode(NotificationPreferences.self, from: data) {
            notificationPreferences = preferences
        }
    }
    
    private func updateSystemNotificationSettings() {
        // Request notification permissions if needed
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.trackError(error, context: "notification_permission")
                }
            }
        }
    }
    
    // MARK: - Data Backup & Restore
    
    func createBackup() -> BackupData {
        let backup = BackupData(
            devices: devices,
            notificationPreferences: notificationPreferences,
            userAnalytics: userAnalytics,
            systemHealth: systemHealth,
            performanceMetrics: performanceMetrics,
            timestamp: Date(),
            version: "1.0.0"
        )
        
        // Save backup to local storage
        saveBackupToLocal(backup)
        
        return backup
    }
    
    func restoreFromBackup(_ backup: BackupData) -> Bool {
        do {
            // Validate backup version compatibility
            guard backup.version == "1.0.0" else {
                throw BackupError.incompatibleVersion
            }
            
            // Restore data
            devices = backup.devices
            notificationPreferences = backup.notificationPreferences
            userAnalytics = backup.userAnalytics
            systemHealth = backup.systemHealth
            performanceMetrics = backup.performanceMetrics
            
            // Update UI
            updateSystemHealth()
            
            trackUserAction("backup_restored", context: "success")
            return true
            
        } catch {
            trackError(error, context: "backup_restore")
            return false
        }
    }
    
    private func saveBackupToLocal(_ backup: BackupData) {
        if let encoded = try? JSONEncoder().encode(backup) {
            UserDefaults.standard.set(encoded, forKey: "localBackup")
        }
    }
    
    func getLocalBackup() -> BackupData? {
        guard let data = UserDefaults.standard.data(forKey: "localBackup"),
              let backup = try? JSONDecoder().decode(BackupData.self, from: data) else {
            return nil
        }
        return backup
    }
    
    // MARK: - Device Setup Wizard
    
    func startDeviceSetup() -> DeviceSetupWizard {
        return DeviceSetupWizard(smartHomeManager: self)
    }
    
    func addDevice(_ device: SmartDevice) {
        devices.append(device)
        trackUserAction("device_added", context: device.deviceType.rawValue)
        updateSystemHealth()
    }
    
    func removeDevice(_ deviceId: UUID) {
        devices.removeAll { $0.id == deviceId }
        deviceStatuses.removeValue(forKey: deviceId)
        trackUserAction("device_removed")
        updateSystemHealth()
    }
    
    // MARK: - Performance Monitoring
    
    func startPerformanceMonitoring() {
        // Monitor app launch time
        let launchTime = Date().timeIntervalSince(launchStartTime)
        trackUserAction("app_launch_time", context: String(format: "%.2f", launchTime))
        
        // Monitor memory usage
        let memoryUsage = getMemoryUsage()
        trackUserAction("memory_usage", context: String(format: "%.1f", memoryUsage))
    }
    
    private func getMemoryUsage() -> Double {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            return Double(info.resident_size) / 1024.0 / 1024.0 // Convert to MB
        } else {
            return 0.0
        }
    }
    
    private var launchStartTime: Date = Date()

    private init() {
        setupNotificationObservers()
        
        // Listen for authentication changes
        AuthenticationManager.shared.$isAuthenticated.sink { [weak self] isSignedIn in
            if isSignedIn {
                self?.loadDevicesFromRing()
                self?.startRealTimeUpdates()
            } else {
                self?.cleanupData()
                self?.stopRealTimeUpdates()
            }
        }.store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var refreshTimer: Timer?

    // MARK: - Device Management
    
    func loadDevicesFromRing() {
        isLoading = true
        lastError = nil
        
        RingAPIManager.shared.getRingDevices { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let ringDevices):
                    self?.devices = ringDevices
                    self?.loadAllDeviceStatuses()
                    self?.loadRecentAlerts()
                case .failure(let error):
                    self?.lastError = error
                    print("Failed to load devices: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadAllDeviceStatuses() {
        for device in devices {
            getDeviceStatus(for: device.id) { _ in }
        }
    }
    
    private func loadRecentAlerts() {
        var allAlerts: [MotionAlert] = []
        let group = DispatchGroup()
        
        for device in devices {
            group.enter()
            getRecentMotionAlerts(for: device.id) { alerts in
                allAlerts.append(contentsOf: alerts)
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.recentMotionAlerts = allAlerts.sorted { $0.timestamp > $1.timestamp }
        }
    }
    
    private func cleanupData() {
        devices = []
        recentMotionAlerts = []
        deviceStatuses = [:]
        lastError = nil
    }

    func getDevices() -> [SmartDevice] {
        return devices
    }
    
    func getDevices(ofType type: DeviceType) -> [SmartDevice] {
        return devices.filter { $0.deviceType == type }
    }
    
    func getDevice(withId id: UUID) -> SmartDevice? {
        return devices.first { $0.id == id }
    }

    func refreshDevices() {
        loadDevicesFromRing()
    }

    // MARK: - Ring Intervention Methods
    
    func captureSnapshot(for deviceId: UUID, completion: @escaping (Result<RingSnapshot, RingAPIError>) -> Void) {
        RingAPIManager.shared.captureSnapshot(for: deviceId) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func getRecentMotionAlerts(for deviceId: UUID, completion: @escaping ([MotionAlert]) -> Void) {
        RingAPIManager.shared.getRecentMotionAlerts(for: deviceId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let alerts):
                    completion(alerts)
                case .failure(let error):
                    print("Failed to get motion alerts: \(error.localizedDescription)")
                    completion([])
                }
            }
        }
    }
    
    func toggleMotionDetection(for deviceId: UUID, completion: @escaping (Bool) -> Void) {
        getDeviceStatus(for: deviceId) { [weak self] status in
            guard let status = status else {
                completion(false)
                return
            }
            
            if status.motionDetectionEnabled {
                self?.disableMotionDetection(for: deviceId, completion: completion)
            } else {
                self?.enableMotionDetection(for: deviceId, completion: completion)
            }
        }
    }
    
    func enableMotionDetection(for deviceId: UUID, completion: @escaping (Bool) -> Void) {
        RingAPIManager.shared.enableMotionDetection(for: deviceId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    print("Failed to enable motion detection: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
    
    func disableMotionDetection(for deviceId: UUID, completion: @escaping (Bool) -> Void) {
        RingAPIManager.shared.disableMotionDetection(for: deviceId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    print("Failed to disable motion detection: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
    
    func activateSiren(for deviceId: UUID, duration: TimeInterval = 30, completion: @escaping (Bool) -> Void) {
        RingAPIManager.shared.setSirenState(for: deviceId, enabled: true, duration: duration) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    print("Failed to activate siren: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
    
    func deactivateSiren(for deviceId: UUID, completion: @escaping (Bool) -> Void) {
        RingAPIManager.shared.setSirenState(for: deviceId, enabled: false) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    print("Failed to deactivate siren: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
    
    func getLiveStream(for deviceId: UUID, quality: StreamQuality = .high, completion: @escaping (Result<URL, RingAPIError>) -> Void) {
        RingAPIManager.shared.getCameraStreamURL(for: deviceId, quality: quality) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func getDeviceStatus(for deviceId: UUID, completion: @escaping (RingDeviceStatus?) -> Void) {
        RingAPIManager.shared.getDeviceStatus(for: deviceId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let status):
                    self?.deviceStatuses[deviceId] = status
                    completion(status)
                case .failure(let error):
                    print("Failed to get device status: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
    }
    
    func setPrivacyMode(for deviceId: UUID, enabled: Bool, completion: @escaping (Bool) -> Void) {
        RingAPIManager.shared.setPrivacyMode(for: deviceId, enabled: enabled) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    print("Failed to set privacy mode: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
    
    func getDeviceHistory(for deviceId: UUID, days: Int = 7, completion: @escaping ([RingEvent]) -> Void) {
        RingAPIManager.shared.getDeviceHistory(for: deviceId, days: days) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let events):
                    completion(events)
                case .failure(let error):
                    print("Failed to get device history: \(error.localizedDescription)")
                    completion([])
                }
            }
        }
    }
    
    func setMotionSchedule(for deviceId: UUID, schedule: MotionSchedule, completion: @escaping (Bool) -> Void) {
        RingAPIManager.shared.setMotionSchedule(for: deviceId, schedule: schedule) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    print("Failed to set motion schedule: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }

    // MARK: - Real-time Updates
    
    private func startRealTimeUpdates() {
        // Refresh device statuses every 2 minutes
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 120.0, repeats: true) { [weak self] _ in
            self?.loadAllDeviceStatuses()
        }
    }
    
    private func stopRealTimeUpdates() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    private func setupNotificationObservers() {
        // Listen for new motion alerts
        NotificationCenter.default.addObserver(
            forName: .ringMotionAlert,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleNewMotionAlert(notification)
        }
        
        // Listen for device status changes
        NotificationCenter.default.addObserver(
            forName: .ringDeviceStatusChanged,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleDeviceStatusChange(notification)
        }
    }
    
    private func handleNewMotionAlert(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let deviceId = userInfo["deviceId"] as? UUID,
              let alertText = userInfo["alertText"] as? String,
              let timestamp = userInfo["timestamp"] as? Date else {
            return
        }
        
        let newAlert = MotionAlert(
            id: UUID(),
            deviceId: deviceId,
            timestamp: timestamp,
            description: alertText,
            alertType: .motion,
            confidence: 0.9,
            hasVideo: true
        )
        
        // Insert at the beginning to maintain chronological order
        recentMotionAlerts.insert(newAlert, at: 0)
        
        // Keep only the most recent 50 alerts
        if recentMotionAlerts.count > 50 {
            recentMotionAlerts = Array(recentMotionAlerts.prefix(50))
        }
    }
    
    private func handleDeviceStatusChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let deviceId = userInfo["deviceId"] as? UUID else {
            return
        }
        
        // Refresh the specific device status
        getDeviceStatus(for: deviceId) { _ in }
    }

    // MARK: - Device Filtering and Statistics
    
    func getOnlineDevices() -> [SmartDevice] {
        return devices.filter { $0.status == .on }
    }
    
    func getOfflineDevices() -> [SmartDevice] {
        return devices.filter { $0.status == .off }
    }
    
    func getDevicesWithLowBattery() -> [SmartDevice] {
        return devices.filter { device in
            guard let batteryLevel = device.batteryLevel else { return false }
            return batteryLevel <= 20
        }
    }
    
    func getDevicesWithGoodBattery() -> [SmartDevice] {
        return devices.filter { device in
            guard let batteryLevel = device.batteryLevel else { return false }
            return batteryLevel > 50
        }
    }
    
    func getDevicesWithMotionDetectionDisabled() -> [SmartDevice] {
        return devices.filter { device in
            guard let status = deviceStatuses[device.id] else { return false }
            return !status.motionDetectionEnabled
        }
    }
    
    func getTotalActiveAlerts() -> Int {
        return recentMotionAlerts.count
    }

    // MARK: - Bulk Operations
    
    func enableMotionDetectionForAllDevices(completion: @escaping (Int, Int) -> Void) {
        let group = DispatchGroup()
        var successCount = 0
        var totalCount = 0
        
        for device in devices {
            totalCount += 1
            group.enter()
            
            enableMotionDetection(for: device.id) { success in
                if success {
                    successCount += 1
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(successCount, totalCount)
        }
    }
    
    func disableMotionDetectionForAllDevices(completion: @escaping (Int, Int) -> Void) {
        let group = DispatchGroup()
        var successCount = 0
        var totalCount = 0
        
        for device in devices {
            totalCount += 1
            group.enter()
            
            disableMotionDetection(for: device.id) { success in
                if success {
                    successCount += 1
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(successCount, totalCount)
        }
    }
    
    func captureSnapshotsFromAllCameras(completion: @escaping ([RingSnapshot], [RingAPIError]) -> Void) {
        let cameras = getDevices(ofType: .camera) + getDevices(ofType: .doorbell)
        let group = DispatchGroup()
        var snapshots: [RingSnapshot] = []
        var errors: [RingAPIError] = []
        
        for camera in cameras {
            group.enter()
            captureSnapshot(for: camera.id) { result in
                switch result {
                case .success(let snapshot):
                    snapshots.append(snapshot)
                case .failure(let error):
                    errors.append(error)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(snapshots, errors)
        }
    }

    // MARK: - Legacy Support
    
    func toggleDevice(withId id: UUID) {
        guard let device = getDevice(withId: id) else { return }
        
        switch device.deviceType {
        case .camera, .doorbell:
            // For cameras/doorbells, capture a snapshot as the default action
            captureSnapshot(for: id) { result in
                switch result {
                case .success:
                    print("Snapshot captured for \(device.name)")
                case .failure(let error):
                    print("Failed to capture snapshot: \(error.localizedDescription)")
                }
            }
        case .motionSensor:
            // For sensors, toggle motion detection
            toggleMotionDetection(for: id) { success in
                print(success ? "Motion detection toggled for \(device.name)" : "Failed to toggle motion detection")
            }
        default:
            print("No default action for device type: \(device.deviceType)")
        }
    }

    // MARK: - System Health & Performance
    
    func updateSystemHealth() {
        let devices = getDevices()
        let onlineDevices = getOnlineDevices()
        let lowBatteryDevices = getDevicesWithLowBattery()
        
        // Calculate health score
        let onlineRate = devices.isEmpty ? 0 : Double(onlineDevices.count) / Double(devices.count)
        let batteryHealth = devices.isEmpty ? 100 : max(0, 100 - (lowBatteryDevices.count * 10))
        
        let totalScore = Int((onlineRate * 60) + (Double(batteryHealth) * 0.4))
        
        // Determine status
        let status: SystemHealth.Status
        let issues: [String]
        
        switch totalScore {
        case 90...100:
            status = .excellent
            issues = []
        case 75..<90:
            status = .good
            issues = lowBatteryDevices.isEmpty ? [] : ["Some devices have low battery"]
        case 60..<75:
            status = .fair
            issues = ["Multiple devices offline", "Low battery warnings"]
        case 40..<60:
            status = .poor
            issues = ["System performance degraded", "Multiple connectivity issues"]
        default:
            status = .critical
            issues = ["System requires immediate attention", "Multiple critical issues"]
        }
        
        systemHealth = SystemHealth(
            status: status,
            score: totalScore,
            issues: issues,
            lastUpdated: Date()
        )
        
        // Update performance metrics
        updatePerformanceMetrics()
    }
    
    private func updatePerformanceMetrics() {
        let devices = getDevices()
        let onlineDevices = getOnlineDevices()
        let lowBatteryDevices = getDevicesWithLowBattery()
        
        performanceMetrics = PerformanceMetrics(
            averageResponseTime: 0.5, // Simulated
            deviceOnlineRate: devices.isEmpty ? 0 : Double(onlineDevices.count) / Double(devices.count),
            batteryHealthScore: devices.isEmpty ? 100 : max(0, 100 - (lowBatteryDevices.count * 10)),
            networkLatency: 0.2, // Simulated
            lastUpdated: Date()
        )
    }
    
    // MARK: - Advanced Device Management
    
    func getDevicesByLocation() -> [String: [SmartDevice]] {
        return Dictionary(grouping: devices) { $0.location ?? "Unknown Location" }
    }
    
    func getDevicesByType() -> [DeviceType: [SmartDevice]] {
        return Dictionary(grouping: devices) { $0.deviceType }
    }
    
    func getDevicesByStatus() -> [DeviceStatus: [SmartDevice]] {
        return Dictionary(grouping: devices) { $0.status }
    }
    
    func getDevicesNeedingAttention() -> [SmartDevice] {
        return devices.filter { device in
            // Offline devices
            device.status == .off ||
            // Low battery devices
            (device.batteryLevel != nil && device.batteryLevel! <= 20) ||
            // Devices not seen recently
            (device.lastSeen != nil && device.lastSeen! < Date().addingTimeInterval(-24 * 3600))
        }
    }
    
    func getSystemAlerts() -> [SystemAlert] {
        var alerts: [SystemAlert] = []
        
        let offlineDevices = getOfflineDevices()
        if !offlineDevices.isEmpty {
            alerts.append(SystemAlert(
                type: .warning,
                title: "Offline Devices",
                message: "\(offlineDevices.count) device(s) are currently offline",
                timestamp: Date()
            ))
        }
        
        let lowBatteryDevices = getDevicesWithLowBattery()
        if !lowBatteryDevices.isEmpty {
            alerts.append(SystemAlert(
                type: .warning,
                title: "Low Battery",
                message: "\(lowBatteryDevices.count) device(s) have low battery",
                timestamp: Date()
            ))
        }
        
        return alerts
    }
    
    // MARK: - Data Export & Backup
    
    func exportDeviceData() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(devices)
            return String(data: data, encoding: .utf8) ?? "Export failed"
        } catch {
            return "Export failed: \(error.localizedDescription)"
        }
    }
    
    func getSystemReport() -> SystemReport {
        return SystemReport(
            totalDevices: devices.count,
            onlineDevices: getOnlineDevices().count,
            offlineDevices: getOfflineDevices().count,
            lowBatteryDevices: getDevicesWithLowBattery().count,
            systemHealth: systemHealth,
            performanceMetrics: performanceMetrics,
            lastUpdated: Date()
        )
    }

    // MARK: - Enhanced Device Management
    func refreshDeviceStatus() {
        // Simulate refreshing device status
        for device in devices {
            device.status = Bool.random() ? .online : .offline
        }
    }
    
    func turnDeviceOn(_ device: RingDevice) {
        if device.status == .online {
            device.isOn = true
            HapticFeedback.impact(style: .light)
        }
    }
    
    func turnDeviceOff(_ device: RingDevice) {
        if device.status == .online {
            device.isOn = false
            HapticFeedback.impact(style: .light)
        }
    }
    
    func setAwayMode() {
        // Turn off non-essential devices
        for device in devices {
            if device.category != .security && device.category != .lighting {
                device.isOn = false
            }
        }
        HapticFeedback.impact(style: .medium)
    }
    
    func setNightMode() {
        // Dim lights and turn off non-essential devices
        for device in devices {
            if device.category == .lighting {
                device.brightness = 0.3
            } else if device.category != .security {
                device.isOn = false
            }
        }
        HapticFeedback.impact(style: .medium)
    }
    
    func setHomeMode() {
        // Turn on essential devices
        for device in devices {
            if device.category == .lighting || device.category == .climate {
                device.isOn = true
                if device.category == .lighting {
                    device.brightness = 0.8
                }
            }
        }
        HapticFeedback.impact(style: .medium)
    }
    
    // MARK: - Device Grouping and Favorites
    func toggleFavorite(_ device: RingDevice) {
        device.isFavorite.toggle()
        HapticFeedback.impact(style: .light)
    }
    
    func groupDevices(_ devices: [RingDevice], groupName: String) {
        // Implementation for device grouping
        HapticFeedback.impact(style: .medium)
    }
    
    func ungroupDevices(_ devices: [RingDevice]) {
        // Implementation for ungrouping devices
        HapticFeedback.impact(style: .light)
    }
    
    // MARK: - Enhanced Filtering and Search
    func filterDevices(by category: DeviceCategory?) -> [RingDevice] {
        if let category = category {
            return devices.filter { $0.category == category }
        }
        return devices
    }
    
    func filterDevices(by status: DeviceStatus) -> [RingDevice] {
        return devices.filter { $0.status == status }
    }
    
    func searchDevices(query: String) -> [RingDevice] {
        if query.isEmpty {
            return devices
        }
        return devices.filter { device in
            device.name.localizedCaseInsensitiveContains(query) ||
            device.category.displayName.localizedCaseInsensitiveContains(query)
        }
    }
    
    // MARK: - Energy Usage and Analytics
    var totalEnergyUsage: Double {
        return devices.reduce(0) { total, device in
            total + (device.isOn ? device.energyUsage : 0)
        }
    }
    
    var averageEnergyUsage: Double {
        let activeDevices = devices.filter { $0.isOn }
        return activeDevices.isEmpty ? 0 : totalEnergyUsage / Double(activeDevices.count)
    }
    
    func getEnergyUsageStats() -> EnergyStats {
        let onlineDevices = devices.filter { $0.status == .online }
        let offlineDevices = devices.filter { $0.status == .offline }
        let activeDevices = devices.filter { $0.isOn }
        
        return EnergyStats(
            totalDevices: devices.count,
            onlineDevices: onlineDevices.count,
            offlineDevices: offlineDevices.count,
            activeDevices: activeDevices.count,
            totalEnergyUsage: totalEnergyUsage,
            averageEnergyUsage: averageEnergyUsage
        )
    }
    
    // MARK: - System Health and Monitoring
    var systemHealth: SystemHealth {
        let onlineCount = devices.filter { $0.status == .online }.count
        let totalCount = devices.count
        let healthPercentage = totalCount > 0 ? Double(onlineCount) / Double(totalCount) : 1.0
        
        let issues = devices.filter { device in
            device.status == .offline || device.batteryLevel < 0.2 || device.signalStrength < 0.5
        }
        
        return SystemHealth(
            overallHealth: healthPercentage,
            onlineDevices: onlineCount,
            totalDevices: totalCount,
            issues: issues.count,
            criticalIssues: issues.filter { $0.status == .offline }.count
        )
    }
    
    // MARK: - Automation Management
    var activeAutomations: Int {
        // Simulate active automation count
        return Int.random(in: 2...8)
    }
    
    func createAutomation(name: String, trigger: AutomationTrigger, actions: [AutomationAction]) {
        // Implementation for creating automations
        HapticFeedback.impact(style: .medium)
    }
    
    func deleteAutomation(_ automation: Automation) {
        // Implementation for deleting automations
        HapticFeedback.impact(style: .light)
    }
    
    // MARK: - Device Comparison and Analytics
    func compareDevices(_ devices: [RingDevice]) -> DeviceComparison {
        let avgEnergyUsage = devices.reduce(0) { $0 + $1.energyUsage } / Double(devices.count)
        let avgBatteryLevel = devices.reduce(0) { $0 + $1.batteryLevel } / Double(devices.count)
        let avgSignalStrength = devices.reduce(0) { $0 + $1.signalStrength } / Double(devices.count)
        
        return DeviceComparison(
            deviceCount: devices.count,
            averageEnergyUsage: avgEnergyUsage,
            averageBatteryLevel: avgBatteryLevel,
            averageSignalStrength: avgSignalStrength,
            onlineCount: devices.filter { $0.status == .online }.count,
            offlineCount: devices.filter { $0.status == .offline }.count
        )
    }
    
    // MARK: - Device Sharing and Permissions
    func shareDevice(_ device: RingDevice, with user: String, permissions: [DevicePermission]) {
        // Implementation for device sharing
        HapticFeedback.impact(style: .medium)
    }
    
    func revokeDeviceAccess(_ device: RingDevice, from user: String) {
        // Implementation for revoking access
        HapticFeedback.impact(style: .light)
    }
    
    // MARK: - Maintenance and Scheduling
    func scheduleMaintenance(for device: RingDevice, date: Date, type: MaintenanceType) {
        // Implementation for scheduling maintenance
        HapticFeedback.impact(style: .medium)
    }
    
    func getMaintenanceSchedule() -> [MaintenanceTask] {
        // Return scheduled maintenance tasks
        return []
    }
    
    // MARK: - Smart Insights and Recommendations
    func getSmartInsights() -> [SmartInsight] {
        var insights: [SmartInsight] = []
        
        // Energy usage insights
        if totalEnergyUsage > 10.0 {
            insights.append(SmartInsight(
                type: .energyUsage,
                title: "High Energy Usage",
                description: "Your devices are using more energy than usual. Consider optimizing settings.",
                priority: .high
            ))
        }
        
        // Offline devices insights
        let offlineDevices = devices.filter { $0.status == .offline }
        if !offlineDevices.isEmpty {
            insights.append(SmartInsight(
                type: .connectivity,
                title: "Offline Devices",
                description: "\(offlineDevices.count) devices are offline. Check their connections.",
                priority: .medium
            ))
        }
        
        // Battery level insights
        let lowBatteryDevices = devices.filter { $0.batteryLevel < 0.2 }
        if !lowBatteryDevices.isEmpty {
            insights.append(SmartInsight(
                type: .battery,
                title: "Low Battery",
                description: "\(lowBatteryDevices.count) devices have low battery. Consider charging or replacing batteries.",
                priority: .medium
            ))
        }
        
        return insights
    }
    
    // MARK: - Performance Monitoring
    func getPerformanceMetrics() -> PerformanceMetrics {
        let responseTime = Double.random(in: 0.1...0.5)
        let uptime = Double.random(in: 0.95...0.99)
        let errorRate = Double.random(in: 0.0...0.05)
        
        return PerformanceMetrics(
            responseTime: responseTime,
            uptime: uptime,
            errorRate: errorRate,
            activeConnections: devices.filter { $0.status == .online }.count,
            totalRequests: Int.random(in: 1000...5000)
        )
    }

    // MARK: - Alerts for Device
    func getAlertsForDevice(_ id: UUID) -> [MotionAlert] {
        return recentMotionAlerts.filter { $0.deviceId == id }
    }
}

// MARK: - Supporting Models
struct EnergyStats {
    let totalDevices: Int
    let onlineDevices: Int
    let offlineDevices: Int
    let activeDevices: Int
    let totalEnergyUsage: Double
    let averageEnergyUsage: Double
}

struct SystemHealth {
    let overallHealth: Double
    let onlineDevices: Int
    let totalDevices: Int
    let issues: Int
    let criticalIssues: Int
}

struct DeviceComparison {
    let deviceCount: Int
    let averageEnergyUsage: Double
    let averageBatteryLevel: Double
    let averageSignalStrength: Double
    let onlineCount: Int
    let offlineCount: Int
}

struct SmartInsight {
    let type: InsightType
    let title: String
    let description: String
    let priority: InsightPriority
}

enum InsightType {
    case energyUsage, connectivity, battery, security, automation
}

enum InsightPriority {
    case low, medium, high, critical
}

struct PerformanceMetrics {
    let responseTime: Double
    let uptime: Double
    let errorRate: Double
    let activeConnections: Int
    let totalRequests: Int
}

struct Automation {
    let id: UUID
    let name: String
    let trigger: AutomationTrigger
    let actions: [AutomationAction]
    let isActive: Bool
}

struct AutomationTrigger {
    let type: TriggerType
    let conditions: [String: Any]
}

struct AutomationAction {
    let type: ActionType
    let parameters: [String: Any]
}

enum TriggerType {
    case time, motion, temperature, manual
}

enum ActionType {
    case turnOn, turnOff, setBrightness, setTemperature
}

struct MaintenanceTask {
    let device: RingDevice
    let date: Date
    let type: MaintenanceType
    let description: String
}

enum MaintenanceType {
    case firmware, battery, cleaning, inspection
}

enum DevicePermission {
    case view, control, configure, share
}

// MARK: - Supporting Types

struct SystemAlert {
    enum AlertType {
        case info, warning, error, critical
    }
    
    let type: AlertType
    let title: String
    let message: String
    let timestamp: Date
}

struct SystemReport {
    let totalDevices: Int
    let onlineDevices: Int
    let offlineDevices: Int
    let lowBatteryDevices: Int
    let systemHealth: SmartHomeManager.SystemHealth
    let performanceMetrics: SmartHomeManager.PerformanceMetrics
    let lastUpdated: Date
}

struct BackupData: Codable {
    let devices: [SmartDevice]
    let notificationPreferences: SmartHomeManager.NotificationPreferences
    let userAnalytics: SmartHomeManager.UserAnalytics
    let systemHealth: SmartHomeManager.SystemHealth
    let performanceMetrics: SmartHomeManager.PerformanceMetrics
    let timestamp: Date
    let version: String
}

enum BackupError: Error, LocalizedError {
    case incompatibleVersion
    case corruptedData
    case restoreFailed
    
    var errorDescription: String? {
        switch self {
        case .incompatibleVersion:
            return "Backup version is not compatible with current app version"
        case .corruptedData:
            return "Backup data is corrupted or invalid"
        case .restoreFailed:
            return "Failed to restore backup data"
        }
    }
}

class DeviceSetupWizard: ObservableObject {
    @Published var currentStep: SetupStep = .welcome
    @Published var setupData: SetupData = SetupData()
    private let smartHomeManager: SmartHomeManager
    
    enum SetupStep: Int, CaseIterable {
        case welcome = 0
        case deviceType
        case deviceLocation
        case deviceName
        case connectivity
        case confirmation
        case complete
    }
    
    struct SetupData {
        var deviceType: DeviceType?
        var location: String = ""
        var name: String = ""
        var isConnected: Bool = false
    }
    
    init(smartHomeManager: SmartHomeManager) {
        self.smartHomeManager = smartHomeManager
    }
    
    func nextStep() {
        guard currentStep.rawValue < SetupStep.allCases.count - 1 else { return }
        currentStep = SetupStep.allCases[currentStep.rawValue + 1]
    }
    
    func previousStep() {
        guard currentStep.rawValue > 0 else { return }
        currentStep = SetupStep.allCases[currentStep.rawValue - 1]
    }
    
    func completeSetup() {
        guard let deviceType = setupData.deviceType else { return }
        
        let newDevice = SmartDevice(
            id: UUID(),
            name: setupData.name.isEmpty ? "New \(deviceType.rawValue)" : setupData.name,
            status: .off,
            deviceType: deviceType,
            location: setupData.location.isEmpty ? nil : setupData.location
        )
        
        smartHomeManager.addDevice(newDevice)
        currentStep = .complete
    }
} 