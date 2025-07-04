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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            for i in devices.indices {
                devices[i].lastUpdated = Date()
                devices[i].status = Bool.random() ? .online : .offline
            }
        }
    }
    
    func turnOnAllDevices() {
        for i in devices.indices {
            devices[i].isOn = true
            devices[i].lastUpdated = Date()
        }
        HapticFeedback.notification(type: .success)
    }
    
    func turnOffAllDevices() {
        for i in devices.indices {
            devices[i].isOn = false
            devices[i].lastUpdated = Date()
        }
        HapticFeedback.notification(type: .success)
    }
    
    func setAwayMode() {
        // Turn off lights, enable security
        for i in devices.indices {
            if devices[i].type == .light {
                devices[i].isOn = false
            } else if devices[i].type == .camera || devices[i].type == .sensor {
                devices[i].isOn = true
            }
            devices[i].lastUpdated = Date()
        }
        HapticFeedback.notification(type: .success)
    }
    
    func setHomeMode() {
        // Turn on essential lights, disable some security
        for i in devices.indices {
            if devices[i].type == .light && devices[i].location.contains("Living") {
                devices[i].isOn = true
            } else if devices[i].type == .camera {
                devices[i].isOn = false
            }
            devices[i].lastUpdated = Date()
        }
        HapticFeedback.notification(type: .success)
    }
    
    func setNightMode() {
        // Dim lights, enable security
        for i in devices.indices {
            if devices[i].type == .light {
                devices[i].isOn = true
                devices[i].brightness = 0.3
            } else if devices[i].type == .camera || devices[i].type == .sensor {
                devices[i].isOn = true
            }
            devices[i].lastUpdated = Date()
        }
        HapticFeedback.notification(type: .success)
    }
    
    func getDeviceGroups() -> [String: [RingDevice]] {
        var groups: [String: [RingDevice]] = [:]
        
        for device in devices {
            let group = device.location
            if groups[group] == nil {
                groups[group] = []
            }
            groups[group]?.append(device)
        }
        
        return groups
    }
    
    func getFavoriteDevices() -> [RingDevice] {
        return devices.filter { $0.isFavorite }
    }
    
    func toggleFavorite(_ device: RingDevice) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index].isFavorite.toggle()
            HapticFeedback.impact(style: .light)
        }
    }
    
    func getDevicesByCategory(_ category: DeviceCategory) -> [RingDevice] {
        switch category {
        case .all:
            return devices
        case .lights:
            return devices.filter { $0.type == .light }
        case .cameras:
            return devices.filter { $0.type == .camera }
        case .sensors:
            return devices.filter { $0.type == .sensor }
        case .thermostats:
            return devices.filter { $0.type == .thermostat }
        case .locks:
            return devices.filter { $0.type == .lock }
        }
    }
    
    func getDevicesByStatus(_ status: DeviceStatus) -> [RingDevice] {
        switch status {
        case .all:
            return devices
        case .online:
            return devices.filter { $0.status == .online }
        case .offline:
            return devices.filter { $0.status == .offline }
        case .active:
            return devices.filter { $0.isOn }
        case .inactive:
            return devices.filter { !$0.isOn }
        }
    }
    
    func searchDevices(query: String) -> [RingDevice] {
        if query.isEmpty {
            return devices
        }
        
        return devices.filter { device in
            device.name.localizedCaseInsensitiveContains(query) ||
            device.location.localizedCaseInsensitiveContains(query) ||
            device.type.rawValue.localizedCaseInsensitiveContains(query)
        }
    }
    
    func getEnergyUsageStats() -> EnergyUsageStats {
        let totalUsage = devices.reduce(0) { $0 + $1.energyUsage }
        let averageUsage = devices.isEmpty ? 0 : totalUsage / Double(devices.count)
        let maxUsage = devices.map { $0.energyUsage }.max() ?? 0
        let minUsage = devices.map { $0.energyUsage }.min() ?? 0
        
        return EnergyUsageStats(
            totalUsage: totalUsage,
            averageUsage: averageUsage,
            maxUsage: maxUsage,
            minUsage: minUsage,
            deviceCount: devices.count
        )
    }
    
    func getSystemHealth() -> SystemHealth {
        let onlineDevices = devices.filter { $0.status == .online }.count
        let totalDevices = devices.count
        let healthPercentage = totalDevices > 0 ? Double(onlineDevices) / Double(totalDevices) : 0
        
        let issues = devices.compactMap { device -> SystemIssue? in
            if device.status == .offline {
                return SystemIssue(
                    type: .offline,
                    deviceName: device.name,
                    description: "Device is offline",
                    severity: .medium
                )
            }
            if device.energyUsage > 5.0 {
                return SystemIssue(
                    type: .highEnergyUsage,
                    deviceName: device.name,
                    description: "High energy consumption detected",
                    severity: .low
                )
            }
            return nil
        }
        
        return SystemHealth(
            overallHealth: healthPercentage,
            onlineDevices: onlineDevices,
            totalDevices: totalDevices,
            issues: issues
        )
    }
    
    func getAutomationRules() -> [AutomationRule] {
        return [
            AutomationRule(
                id: UUID(),
                name: "Night Mode",
                description: "Dim lights and enable security at 10 PM",
                trigger: .time(hour: 22, minute: 0),
                actions: [
                    AutomationAction(type: .dimLights, value: 0.3),
                    AutomationAction(type: .enableSecurity, value: 1.0)
                ],
                isEnabled: true
            ),
            AutomationRule(
                id: UUID(),
                name: "Away Mode",
                description: "Turn off lights and enable cameras when away",
                trigger: .location(entering: false),
                actions: [
                    AutomationAction(type: .turnOffLights, value: 0.0),
                    AutomationAction(type: .enableCameras, value: 1.0)
                ],
                isEnabled: true
            ),
            AutomationRule(
                id: UUID(),
                name: "Motion Detection",
                description: "Turn on lights when motion is detected",
                trigger: .motion,
                actions: [
                    AutomationAction(type: .turnOnLights, value: 1.0)
                ],
                isEnabled: false
            )
        ]
    }
    
    func addAutomationRule(_ rule: AutomationRule) {
        // In a real app, this would save to persistent storage
        HapticFeedback.notification(type: .success)
    }
    
    func deleteAutomationRule(_ rule: AutomationRule) {
        // In a real app, this would remove from persistent storage
        HapticFeedback.notification(type: .success)
    }
    
    func toggleAutomationRule(_ rule: AutomationRule) {
        // In a real app, this would update the rule's enabled state
        HapticFeedback.impact(style: .light)
    }
    
    func getDeviceComparison() -> DeviceComparison {
        let categories = DeviceCategory.allCases.filter { $0 != .all }
        var comparisons: [CategoryComparison] = []
        
        for category in categories {
            let categoryDevices = getDevicesByCategory(category)
            if !categoryDevices.isEmpty {
                let avgEnergy = categoryDevices.reduce(0) { $0 + $1.energyUsage } / Double(categoryDevices.count)
                let onlineCount = categoryDevices.filter { $0.status == .online }.count
                
                comparisons.append(CategoryComparison(
                    category: category,
                    deviceCount: categoryDevices.count,
                    averageEnergyUsage: avgEnergy,
                    onlinePercentage: Double(onlineCount) / Double(categoryDevices.count)
                ))
            }
        }
        
        return DeviceComparison(categories: comparisons)
    }
    
    func shareDevice(_ device: RingDevice, with email: String) {
        // In a real app, this would send an invitation
        HapticFeedback.notification(type: .success)
    }
    
    func getDeviceSharingInfo() -> [DeviceSharing] {
        return [
            DeviceSharing(
                device: devices.first ?? RingDevice.sampleDevices[0],
                sharedWith: ["john@example.com", "jane@example.com"],
                permissions: [.view, .control],
                sharedDate: Date().addingTimeInterval(-86400)
            )
        ]
    }
    
    func getMaintenanceSchedule() -> [MaintenanceTask] {
        return [
            MaintenanceTask(
                id: UUID(),
                deviceName: "Living Room Light",
                task: "Replace bulb",
                dueDate: Date().addingTimeInterval(7 * 86400),
                priority: .medium,
                isCompleted: false
            ),
            MaintenanceTask(
                id: UUID(),
                deviceName: "Front Door Camera",
                task: "Clean lens",
                dueDate: Date().addingTimeInterval(30 * 86400),
                priority: .low,
                isCompleted: false
            )
        ]
    }
    
    func addMaintenanceTask(_ task: MaintenanceTask) {
        // In a real app, this would save to persistent storage
        HapticFeedback.notification(type: .success)
    }
    
    func completeMaintenanceTask(_ task: MaintenanceTask) {
        // In a real app, this would mark the task as completed
        HapticFeedback.notification(type: .success)
    }
    
    func getInsights() -> [SmartHomeInsight] {
        return [
            SmartHomeInsight(
                id: UUID(),
                type: .energySaving,
                title: "Energy Usage Optimized",
                description: "Your devices are using 15% less energy this week",
                value: "15%",
                trend: .positive,
                date: Date()
            ),
            SmartHomeInsight(
                id: UUID(),
                type: .security,
                title: "Security Alert",
                description: "Motion detected at front door at 2:30 AM",
                value: "1",
                trend: .neutral,
                date: Date().addingTimeInterval(-3600)
            ),
            SmartHomeInsight(
                id: UUID(),
                type: .automation,
                title: "Automation Active",
                description: "Night mode automation triggered 5 times this week",
                value: "5",
                trend: .positive,
                date: Date()
            )
        ]
    }
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

// MARK: - Supporting Models
struct EnergyUsageStats {
    let totalUsage: Double
    let averageUsage: Double
    let maxUsage: Double
    let minUsage: Double
    let deviceCount: Int
}

struct SystemHealth {
    let overallHealth: Double
    let onlineDevices: Int
    let totalDevices: Int
    let issues: [SystemIssue]
}

struct SystemIssue {
    let type: IssueType
    let deviceName: String
    let description: String
    let severity: IssueSeverity
    
    enum IssueType {
        case offline
        case highEnergyUsage
        case connectivity
        case battery
    }
    
    enum IssueSeverity {
        case low
        case medium
        case high
        case critical
    }
}

struct AutomationRule {
    let id: UUID
    let name: String
    let description: String
    let trigger: AutomationTrigger
    let actions: [AutomationAction]
    var isEnabled: Bool
}

enum AutomationTrigger {
    case time(hour: Int, minute: Int)
    case location(entering: Bool)
    case motion
    case deviceState(deviceId: UUID, state: Bool)
}

struct AutomationAction {
    let type: ActionType
    let value: Double
    
    enum ActionType {
        case turnOnLights
        case turnOffLights
        case dimLights
        case enableSecurity
        case enableCameras
        case setTemperature
    }
}

struct DeviceComparison {
    let categories: [CategoryComparison]
}

struct CategoryComparison {
    let category: DeviceCategory
    let deviceCount: Int
    let averageEnergyUsage: Double
    let onlinePercentage: Double
}

struct DeviceSharing {
    let device: RingDevice
    let sharedWith: [String]
    let permissions: [SharingPermission]
    let sharedDate: Date
    
    enum SharingPermission {
        case view
        case control
        case admin
    }
}

struct MaintenanceTask {
    let id: UUID
    let deviceName: String
    let task: String
    let dueDate: Date
    let priority: TaskPriority
    var isCompleted: Bool
    
    enum TaskPriority {
        case low
        case medium
        case high
        case critical
    }
}

struct SmartHomeInsight {
    let id: UUID
    let type: InsightType
    let title: String
    let description: String
    let value: String
    let trend: InsightTrend
    let date: Date
    
    enum InsightType {
        case energySaving
        case security
        case automation
        case performance
        case maintenance
    }
    
    enum InsightTrend {
        case positive
        case negative
        case neutral
    }
} 