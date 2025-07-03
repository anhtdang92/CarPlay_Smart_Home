import Foundation
import Combine

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
    
    init(id: UUID, name: String, status: DeviceStatus, deviceType: DeviceType = .camera, batteryLevel: Int? = nil, lastSeen: Date? = nil) {
        self.id = id
        self.name = name
        self.status = status
        self.deviceType = deviceType
        self.batteryLevel = batteryLevel
        self.lastSeen = lastSeen
    }
}

class SmartHomeManager: ObservableObject {

    static let shared = SmartHomeManager()

    @Published private(set) var devices: [SmartDevice] = []
    @Published private(set) var recentMotionAlerts: [MotionAlert] = []
    @Published private(set) var isLoading = false
    @Published private(set) var lastError: RingAPIError?
    @Published private(set) var deviceStatuses: [UUID: RingDeviceStatus] = [:]

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

    // MARK: - Utility Methods
    
    func getDevicesWithLowBattery(threshold: Int = 20) -> [SmartDevice] {
        return devices.filter { device in
            guard let batteryLevel = device.batteryLevel else { return false }
            return batteryLevel <= threshold
        }
    }
    
    func getOfflineDevices() -> [SmartDevice] {
        return devices.filter { device in
            guard let status = deviceStatuses[device.id] else { return false }
            return !status.isOnline
        }
    }
    
    func getDevicesWithMotionDetectionDisabled() -> [SmartDevice] {
        return devices.filter { device in
            guard let status = deviceStatuses[device.id] else { return false }
            return !status.motionDetectionEnabled
        }
    }
    
    func getTotalActiveAlerts() -> Int {
        let oneHourAgo = Date().addingTimeInterval(-3600)
        return recentMotionAlerts.filter { $0.timestamp > oneHourAgo }.count
    }
    
    func getAlertsForDevice(_ deviceId: UUID) -> [MotionAlert] {
        return recentMotionAlerts.filter { $0.deviceId == deviceId }
    }
    
    func clearOldAlerts(olderThan days: Int = 7) {
        let cutoffDate = Date().addingTimeInterval(-Double(days * 86400))
        recentMotionAlerts = recentMotionAlerts.filter { $0.timestamp > cutoffDate }
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
} 