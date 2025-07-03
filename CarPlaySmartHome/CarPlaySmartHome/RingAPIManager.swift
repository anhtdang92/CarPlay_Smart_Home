import Foundation
import UserNotifications
import CoreLocation

// MARK: - Ring API Manager
class RingAPIManager: NSObject, ObservableObject {

    static let shared = RingAPIManager()
    
    // MARK: - Properties
    private var accessToken: String?
    private var refreshToken: String?
    private var deviceStatuses: [UUID: RingDeviceStatus] = [:]
    private var deviceLocations: [UUID: RingDeviceLocation] = [:]
    private var deviceSchedules: [UUID: MotionSchedule] = [:]
    private var notificationCenter = UNUserNotificationCenter.current()
    private var locationManager = CLLocationManager()
    private var geofences: [RingGeofence] = []
    
    // Debugging and Analytics
    private var debugMode = true
    private var analyticsCollector = RingAnalyticsCollector()
    private var errorLogger = RingErrorLogger()
    
    @Published var isOnline = true
    @Published var apiResponseTime: TimeInterval = 0
    @Published var deviceConnections: [UUID: Bool] = [:]

    private override init() {
        super.init()
        setupNotifications()
        setupLocationManager()
        startNetworkMonitoring()
        loadPersistedData()
    }

    // MARK: - Authentication
    
    func signInWithRing(completion: @escaping (RingAuthResult) -> Void) {
        let startTime = Date()
        debugLog("🔐 Starting Ring OAuth flow...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Simulate successful authentication
            self.accessToken = "mock_access_token_\(UUID().uuidString)"
            self.refreshToken = "mock_refresh_token_\(UUID().uuidString)"
            self.apiResponseTime = Date().timeIntervalSince(startTime)
            
            self.debugLog("✅ Successfully received mock Ring access token in \(self.apiResponseTime)s")
            self.analyticsCollector.recordAuthenticationEvent(success: true, duration: self.apiResponseTime)
            
            AuthenticationManager.shared.signIn { success in
                if success {
                    completion(.success(accessToken: self.accessToken ?? ""))
                    self.startPeriodicUpdates()
                    self.loadGeofences()
                } else {
                    self.errorLogger.logError(.authenticationFailed, context: "Local auth manager failed")
                    completion(.failure(.authenticationFailed))
                }
            }
        }
    }
    
    func signOut() {
        debugLog("🚪 Signing out from Ring...")
        accessToken = nil
        refreshToken = nil
        deviceStatuses.removeAll()
        deviceLocations.removeAll()
        deviceSchedules.removeAll()
        geofences.removeAll()
        stopPeriodicUpdates()
        analyticsCollector.reset()
        persistData()
    }
    
    func refreshAuthToken(completion: @escaping (Bool) -> Void) {
        guard refreshToken != nil else {
            errorLogger.logError(.notAuthenticated, context: "No refresh token available")
            completion(false)
            return
        }
        
        debugLog("🔄 Refreshing Ring access token...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.accessToken = "refreshed_token_\(UUID().uuidString)"
            self.debugLog("✅ Token refreshed successfully")
            completion(true)
        }
    }

    // MARK: - Device Management
    
    func getRingDevices(completion: @escaping (Result<[SmartDevice], RingAPIError>) -> Void) {
        guard isAuthenticated else {
            let error = RingAPIError.notAuthenticated
            errorLogger.logError(error, context: "Attempted device fetch without authentication")
            completion(.failure(error))
            return
        }
        
        let startTime = Date()
        debugLog("📱 Fetching devices from Ring API...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let ringDevices: [SmartDevice] = [
                SmartDevice(id: UUID(), name: "Front Door Camera", status: .on, deviceType: .camera, batteryLevel: 85, lastSeen: Date(), location: "Front Entrance"),
                SmartDevice(id: UUID(), name: "Backyard Camera", status: .on, deviceType: .camera, batteryLevel: 72, lastSeen: Date().addingTimeInterval(-120), location: "Back Garden"),
                SmartDevice(id: UUID(), name: "Video Doorbell Pro", status: .on, deviceType: .doorbell, batteryLevel: 91, lastSeen: Date(), location: "Main Door"),
                SmartDevice(id: UUID(), name: "Kitchen Motion Sensor", status: .on, deviceType: .motionSensor, batteryLevel: 68, lastSeen: Date().addingTimeInterval(-60), location: "Kitchen"),
                SmartDevice(id: UUID(), name: "Garage Floodlight Cam", status: .off, deviceType: .floodlight, batteryLevel: 94, lastSeen: Date().addingTimeInterval(-300), location: "Garage"),
                SmartDevice(id: UUID(), name: "Living Room Chime", status: .on, deviceType: .chime, batteryLevel: nil, lastSeen: Date(), location: "Living Room")
            ]
            
            self.apiResponseTime = Date().timeIntervalSince(startTime)
            self.debugLog("✅ Fetched \(ringDevices.count) devices in \(self.apiResponseTime)s")
            
            // Update device statuses and locations
            for device in ringDevices {
                self.deviceStatuses[device.id] = RingDeviceStatus(
                    isOnline: device.status != .off,
                    batteryLevel: device.batteryLevel ?? 100,
                    motionDetectionEnabled: true,
                    lastMotionTime: Date().addingTimeInterval(-Double.random(in: 300...3600)),
                    signalStrength: Int.random(in: 1...4),
                    firmwareVersion: "2.1.\(Int.random(in: 10...99))",
                    temperature: Int.random(in: 18...25),
                    recordingMode: .auto
                )
                
                if let location = device.location {
                    self.deviceLocations[device.id] = RingDeviceLocation(
                        name: location,
                        coordinate: self.generateRandomCoordinate(),
                        zone: self.determineZone(for: location)
                    )
                }
                
                self.deviceConnections[device.id] = device.status != .off
            }
            
            self.analyticsCollector.recordDeviceCount(ringDevices.count)
            completion(.success(ringDevices))
        }
    }

    // MARK: - Camera Operations
    
    func getCameraStreamURL(for deviceId: UUID, quality: StreamQuality = .high, completion: @escaping (Result<RingLiveStream, RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        debugLog("📹 Requesting \(quality.rawValue) quality livestream for device \(deviceId)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if Bool.random() { // Simulate occasional failures
                let stream = RingLiveStream(
                    streamURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
                    quality: quality,
                    duration: 300,
                    startTime: Date(),
                    isRecording: true
                )
                self.analyticsCollector.recordStreamAccess(deviceId: deviceId, quality: quality)
                completion(.success(stream))
            } else {
                self.errorLogger.logError(.streamUnavailable, context: "Device \(deviceId) stream unavailable")
                completion(.failure(.streamUnavailable))
            }
        }
    }
    
    func captureSnapshot(for deviceId: UUID, highResolution: Bool = false, completion: @escaping (Result<RingSnapshot, RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        debugLog("📸 Capturing \(highResolution ? "high-res" : "standard") snapshot for device \(deviceId)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if Bool.random() { // Simulate occasional failures
                let snapshot = RingSnapshot(
                    id: UUID(),
                    deviceId: deviceId,
                    imageURL: URL(string: "https://via.placeholder.com/\(highResolution ? "1920x1080" : "640x480")/000000/FFFFFF/?text=Ring+Snapshot")!,
                    timestamp: Date(),
                    width: highResolution ? 1920 : 640,
                    height: highResolution ? 1080 : 480,
                    fileSize: highResolution ? 2.5 : 0.8,
                    location: self.deviceLocations[deviceId]
                )
                
                self.analyticsCollector.recordSnapshotCapture(deviceId: deviceId, highRes: highResolution)
                completion(.success(snapshot))
                
                // Trigger notification
                self.sendLocalNotification(title: "Snapshot Captured", body: "Successfully captured snapshot from \(deviceId)")
            } else {
                self.errorLogger.logError(.operationFailed, context: "Snapshot capture failed for device \(deviceId)")
                completion(.failure(.operationFailed))
            }
        }
    }

    // MARK: - Advanced Device Control
    
    func setRecordingMode(for deviceId: UUID, mode: RecordingMode, completion: @escaping (Result<Void, RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        debugLog("📹 Setting recording mode to \(mode) for device \(deviceId)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.deviceStatuses[deviceId]?.recordingMode = mode
            completion(.success(()))
            self.sendLocalNotification(title: "Recording Mode Updated", body: "Device recording mode set to \(mode.rawValue)")
        }
    }
    
    func setDeviceNickname(for deviceId: UUID, nickname: String, completion: @escaping (Result<Void, RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        debugLog("🏷️ Setting nickname '\(nickname)' for device \(deviceId)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Store nickname in device metadata
            completion(.success(()))
        }
    }
    
    func getDeviceHealth(for deviceId: UUID, completion: @escaping (Result<RingDeviceHealth, RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        debugLog("🏥 Getting health report for device \(deviceId)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let health = RingDeviceHealth(
                batteryHealth: Int.random(in: 85...100),
                wifiSignalStrength: Int.random(in: 1...4),
                lastMaintenanceDate: Date().addingTimeInterval(-Double.random(in: 86400...2592000)),
                recommendedActions: self.generateMaintenanceRecommendations(),
                uptimePercentage: Double.random(in: 95...99.9),
                averageResponseTime: TimeInterval.random(in: 0.1...0.5)
            )
            completion(.success(health))
        }
    }

    // MARK: - Geofencing
    
    func createGeofence(_ geofence: RingGeofence, completion: @escaping (Result<Void, RingAPIError>) -> Void) {
        debugLog("📍 Creating geofence: \(geofence.name)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.geofences.append(geofence)
            self.startMonitoringGeofence(geofence)
            completion(.success(()))
        }
    }
    
    func removeGeofence(withId id: UUID, completion: @escaping (Result<Void, RingAPIError>) -> Void) {
        debugLog("🗑️ Removing geofence with ID: \(id)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.geofences.removeAll { $0.id == id }
            completion(.success(()))
        }
    }
    
    func getGeofences(completion: @escaping (Result<[RingGeofence], RingAPIError>) -> Void) {
        debugLog("📍 Fetching geofences")
        completion(.success(geofences))
    }

    // MARK: - Device Scheduling
    
    func setMotionSchedule(for deviceId: UUID, schedule: MotionSchedule, completion: @escaping (Result<Void, RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        debugLog("📅 Setting motion schedule for device \(deviceId)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.deviceSchedules[deviceId] = schedule
            completion(.success(()))
            self.sendLocalNotification(title: "Motion Schedule Updated", body: "Custom motion detection schedule applied")
        }
    }
    
    func getMotionSchedule(for deviceId: UUID, completion: @escaping (Result<MotionSchedule?, RingAPIError>) -> Void) {
        completion(.success(deviceSchedules[deviceId]))
    }

    // MARK: - Analytics and Reporting
    
    func getDeviceAnalytics(for deviceId: UUID, period: AnalyticsPeriod, completion: @escaping (Result<RingDeviceAnalytics, RingAPIError>) -> Void) {
        debugLog("📊 Generating analytics for device \(deviceId) - period: \(period)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let analytics = RingDeviceAnalytics(
                deviceId: deviceId,
                period: period,
                totalMotionEvents: Int.random(in: 50...200),
                averageEventsPerDay: Double.random(in: 5...25),
                peakActivityHour: Int.random(in: 8...20),
                batteryUsagePattern: self.generateBatteryUsagePattern(),
                recordingDuration: TimeInterval.random(in: 3600...86400),
                storageUsed: Double.random(in: 1...10) // GB
            )
            completion(.success(analytics))
        }
    }
    
    func getSystemReport(completion: @escaping (Result<RingSystemReport, RingAPIError>) -> Void) {
        debugLog("📋 Generating system report")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let report = RingSystemReport(
                totalDevices: self.deviceStatuses.count,
                onlineDevices: self.deviceConnections.values.filter { $0 }.count,
                totalAlerts24h: Int.random(in: 10...50),
                systemUptime: TimeInterval.random(in: 86400...604800),
                storageUsed: Double.random(in: 50...200), // GB
                averageResponseTime: self.apiResponseTime,
                errorRate: Double.random(in: 0...5), // %
                lastBackupDate: Date().addingTimeInterval(-Double.random(in: 86400...259200))
            )
            completion(.success(report))
        }
    }

    // MARK: - Backup and Restore
    
    func createBackup(completion: @escaping (Result<RingBackup, RingAPIError>) -> Void) {
        debugLog("💾 Creating system backup")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let backup = RingBackup(
                id: UUID(),
                timestamp: Date(),
                deviceConfigurations: self.deviceStatuses,
                schedules: self.deviceSchedules,
                geofences: self.geofences,
                version: "1.0"
            )
            
            // Simulate saving to cloud
            completion(.success(backup))
            self.sendLocalNotification(title: "Backup Complete", body: "System configuration backed up successfully")
        }
    }
    
    func restoreFromBackup(_ backup: RingBackup, completion: @escaping (Result<Void, RingAPIError>) -> Void) {
        debugLog("🔄 Restoring from backup: \(backup.id)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.deviceStatuses = backup.deviceConfigurations
            self.deviceSchedules = backup.schedules
            self.geofences = backup.geofences
            
            completion(.success(()))
            self.sendLocalNotification(title: "Restore Complete", body: "System restored from backup")
        }
    }

    // MARK: - Network Monitoring
    
    private func startNetworkMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            self.checkNetworkStatus()
        }
    }
    
    private func checkNetworkStatus() {
        // Simulate network status check
        let wasOnline = isOnline
        isOnline = Bool.random() ? true : Double.random(in: 0...1) > 0.1 // 90% uptime
        
        if wasOnline != isOnline {
            debugLog(isOnline ? "🌐 Network connection restored" : "❌ Network connection lost")
            
            if !isOnline {
                errorLogger.logError(.networkError, context: "Network connectivity lost")
            }
        }
    }

    // MARK: - Real-time Updates and Notifications
    
    private var updateTimer: Timer?
    
    private func startPeriodicUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            self.performPeriodicTasks()
        }
    }
    
    private func performPeriodicTasks() {
        checkForNewAlerts()
        updateDeviceStatuses()
        checkGeofenceStatus()
        performMaintenanceChecks()
    }
    
    private func updateDeviceStatuses() {
        for deviceId in deviceStatuses.keys {
            // Simulate device status changes
            if Double.random(in: 0...1) > 0.95 { // 5% chance of status change
                deviceStatuses[deviceId]?.lastMotionTime = Date()
                simulateMotionAlert(for: deviceId)
            }
        }
    }
    
    private func checkGeofenceStatus() {
        // Simulate geofence events
        for geofence in geofences {
            if geofence.isEnabled && Double.random(in: 0...1) > 0.98 { // 2% chance
                handleGeofenceEvent(geofence, entered: Bool.random())
            }
        }
    }
    
    private func performMaintenanceChecks() {
        // Check for devices needing maintenance
        for (deviceId, status) in deviceStatuses {
            if status.batteryLevel < 20 {
                sendMaintenanceAlert(for: deviceId, type: .lowBattery)
            }
            
            if !status.isOnline {
                sendMaintenanceAlert(for: deviceId, type: .offline)
            }
        }
    }

    // MARK: - Helper Methods
    
    private var isAuthenticated: Bool {
        return accessToken != nil
    }
    
    private func setupNotifications() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                self.debugLog("✅ Notification permission granted")
            } else {
                self.errorLogger.logError(.operationFailed, context: "Notification permission denied")
            }
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func loadGeofences() {
        // Load predefined geofences
        let homeGeofence = RingGeofence(
            id: UUID(),
            name: "Home",
            coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            radius: 100,
            isEnabled: true,
            actions: [.enableMotionDetection, .sendNotification]
        )
        geofences.append(homeGeofence)
    }
    
    private func generateRandomCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: 37.7749 + Double.random(in: -0.01...0.01),
            longitude: -122.4194 + Double.random(in: -0.01...0.01)
        )
    }
    
    private func determineZone(for location: String) -> String {
        let zones = ["Front Yard", "Back Yard", "Interior", "Garage", "Side Entrance"]
        return zones.randomElement() ?? "Unknown"
    }
    
    private func generateMaintenanceRecommendations() -> [String] {
        let recommendations = [
            "Clean camera lens",
            "Check mounting stability",
            "Update firmware",
            "Optimize motion zones",
            "Battery replacement recommended"
        ]
        return Array(recommendations.shuffled().prefix(Int.random(in: 1...3)))
    }
    
    private func generateBatteryUsagePattern() -> [Double] {
        return (0..<24).map { _ in Double.random(in: 0.5...2.0) }
    }
    
    private func startMonitoringGeofence(_ geofence: RingGeofence) {
        let region = CLCircularRegion(
            center: geofence.coordinate,
            radius: geofence.radius,
            identifier: geofence.id.uuidString
        )
        locationManager.startMonitoring(for: region)
        debugLog("📍 Started monitoring geofence: \(geofence.name)")
    }
    
    private func handleGeofenceEvent(_ geofence: RingGeofence, entered: Bool) {
        let action = entered ? "entered" : "exited"
        debugLog("📍 Geofence event: \(action) \(geofence.name)")
        
        sendLocalNotification(
            title: "Geofence Alert",
            body: "You have \(action) \(geofence.name)"
        )
        
        // Execute geofence actions
        if entered {
            executeGeofenceActions(geofence.actions)
        }
    }
    
    private func executeGeofenceActions(_ actions: [GeofenceAction]) {
        for action in actions {
            switch action {
            case .enableMotionDetection:
                debugLog("🔔 Enabling motion detection for all devices")
            case .disableMotionDetection:
                debugLog("🔕 Disabling motion detection for all devices")
            case .sendNotification:
                debugLog("📱 Sending geofence notification")
            case .captureSnapshot:
                debugLog("📸 Capturing snapshots from all cameras")
            }
        }
    }
    
    private func sendMaintenanceAlert(for deviceId: UUID, type: MaintenanceAlertType) {
        let message = type == .lowBattery ? "Low battery detected" : "Device offline"
        sendLocalNotification(title: "Maintenance Alert", body: message)
    }
    
    private func debugLog(_ message: String) {
        if debugMode {
            print("🔧 RingAPI: \(message)")
        }
    }
    
    private func persistData() {
        // Simulate data persistence
        debugLog("💾 Persisting data to storage")
    }
    
    private func loadPersistedData() {
        // Simulate loading persisted data
        debugLog("📂 Loading persisted data")
    }
    
    private func stopPeriodicUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    private func sendLocalNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        notificationCenter.add(request)
    }
    
    private func simulateMotionAlert(for deviceId: UUID) {
        let alertTypes = ["Motion detected at front door", "Person approaching", "Vehicle in driveway", "Package delivery detected"]
        let alertText = alertTypes.randomElement()!
        
        sendLocalNotification(title: "Motion Alert", body: alertText)
        
        // Notify SmartHomeManager of new alert
        NotificationCenter.default.post(name: .ringMotionAlert, object: nil, userInfo: [
            "deviceId": deviceId,
            "alertText": alertText,
            "timestamp": Date()
        ])
    }
    
    private func checkForNewAlerts() {
        // Simulate random motion alerts
        if Bool.random() && deviceStatuses.count > 0 {
            let deviceId = deviceStatuses.keys.randomElement()!
            simulateMotionAlert(for: deviceId)
        }
    }
}

// MARK: - Core Location Delegate
extension RingAPIManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let geofence = geofences.first(where: { $0.id.uuidString == region.identifier }) {
            handleGeofenceEvent(geofence, entered: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let geofence = geofences.first(where: { $0.id.uuidString == region.identifier }) {
            handleGeofenceEvent(geofence, entered: false)
        }
    }
}

// MARK: - Enhanced Data Models

struct RingLiveStream {
    let streamURL: URL
    let quality: StreamQuality
    let duration: TimeInterval
    let startTime: Date
    let isRecording: Bool
}

struct RingSnapshot {
    let id: UUID
    let deviceId: UUID
    let imageURL: URL
    let timestamp: Date
    let width: Int
    let height: Int
    let fileSize: Double // MB
    let location: RingDeviceLocation?
}

struct RingDeviceLocation {
    let name: String
    let coordinate: CLLocationCoordinate2D
    let zone: String
}

struct RingDeviceHealth {
    let batteryHealth: Int
    let wifiSignalStrength: Int
    let lastMaintenanceDate: Date
    let recommendedActions: [String]
    let uptimePercentage: Double
    let averageResponseTime: TimeInterval
}

struct RingGeofence {
    let id: UUID
    let name: String
    let coordinate: CLLocationCoordinate2D
    let radius: Double
    let isEnabled: Bool
    let actions: [GeofenceAction]
}

struct RingDeviceAnalytics {
    let deviceId: UUID
    let period: AnalyticsPeriod
    let totalMotionEvents: Int
    let averageEventsPerDay: Double
    let peakActivityHour: Int
    let batteryUsagePattern: [Double]
    let recordingDuration: TimeInterval
    let storageUsed: Double
}

struct RingSystemReport {
    let totalDevices: Int
    let onlineDevices: Int
    let totalAlerts24h: Int
    let systemUptime: TimeInterval
    let storageUsed: Double
    let averageResponseTime: TimeInterval
    let errorRate: Double
    let lastBackupDate: Date
}

struct RingBackup {
    let id: UUID
    let timestamp: Date
    let deviceConfigurations: [UUID: RingDeviceStatus]
    let schedules: [UUID: MotionSchedule]
    let geofences: [RingGeofence]
    let version: String
}

// MARK: - Enhanced Enums

enum RecordingMode: String, CaseIterable {
    case auto = "Auto"
    case manual = "Manual"
    case disabled = "Disabled"
    case scheduled = "Scheduled"
}

enum AnalyticsPeriod: String, CaseIterable {
    case day = "24 Hours"
    case week = "7 Days"
    case month = "30 Days"
    case year = "1 Year"
}

enum GeofenceAction: String, CaseIterable {
    case enableMotionDetection = "Enable Motion Detection"
    case disableMotionDetection = "Disable Motion Detection"
    case sendNotification = "Send Notification"
    case captureSnapshot = "Capture Snapshot"
}

enum MaintenanceAlertType {
    case lowBattery, offline, firmwareUpdate, cleaningRequired
}

// MARK: - Analytics and Debugging Classes

class RingAnalyticsCollector {
    private var events: [RingAnalyticsEvent] = []
    
    func recordAuthenticationEvent(success: Bool, duration: TimeInterval) {
        let event = RingAnalyticsEvent(
            type: .authentication,
            timestamp: Date(),
            metadata: ["success": success, "duration": duration]
        )
        events.append(event)
    }
    
    func recordDeviceCount(_ count: Int) {
        let event = RingAnalyticsEvent(
            type: .deviceCount,
            timestamp: Date(),
            metadata: ["count": count]
        )
        events.append(event)
    }
    
    func recordStreamAccess(deviceId: UUID, quality: StreamQuality) {
        let event = RingAnalyticsEvent(
            type: .streamAccess,
            timestamp: Date(),
            metadata: ["deviceId": deviceId.uuidString, "quality": quality.rawValue]
        )
        events.append(event)
    }
    
    func recordSnapshotCapture(deviceId: UUID, highRes: Bool) {
        let event = RingAnalyticsEvent(
            type: .snapshotCapture,
            timestamp: Date(),
            metadata: ["deviceId": deviceId.uuidString, "highRes": highRes]
        )
        events.append(event)
    }
    
    func reset() {
        events.removeAll()
    }
}

class RingErrorLogger {
    private var errors: [RingErrorLog] = []
    
    func logError(_ error: RingAPIError, context: String) {
        let errorLog = RingErrorLog(
            error: error,
            timestamp: Date(),
            context: context,
            stackTrace: Thread.callStackSymbols
        )
        errors.append(errorLog)
        print("❌ RingError: \(error.localizedDescription) - Context: \(context)")
    }
    
    func getRecentErrors(limit: Int = 10) -> [RingErrorLog] {
        return Array(errors.suffix(limit))
    }
}

struct RingAnalyticsEvent {
    let type: AnalyticsEventType
    let timestamp: Date
    let metadata: [String: Any]
}

struct RingErrorLog {
    let error: RingAPIError
    let timestamp: Date
    let context: String
    let stackTrace: [String]
}

enum AnalyticsEventType {
    case authentication, deviceCount, streamAccess, snapshotCapture, motionAlert, geofenceEvent
}

// MARK: - Updated Device Status
struct RingDeviceStatus {
    let isOnline: Bool
    let batteryLevel: Int
    var motionDetectionEnabled: Bool
    let lastMotionTime: Date?
    let signalStrength: Int // 1-4 bars
    let firmwareVersion: String
    let temperature: Int // Celsius
    var recordingMode: RecordingMode
}

// Enhanced existing models
struct MotionAlert: Identifiable {
    let id: UUID
    let deviceId: UUID
    let timestamp: Date
    let description: String
    let alertType: AlertType
    let confidence: Double
    let hasVideo: Bool
    
    enum AlertType {
        case motion, person, vehicle, package, doorbell
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let ringMotionAlert = Notification.Name("ringMotionAlert")
    static let ringDeviceStatusChanged = Notification.Name("ringDeviceStatusChanged")
}

// MARK: - Missing Data Structures and Enums

struct MotionSchedule {
    let enabled: Bool
    let timeZone: TimeZone
    let weeklySchedule: [DayOfWeek: [TimeRange]]
    
    struct TimeRange {
        let start: Date
        let end: Date
    }
    
    enum DayOfWeek: Int, CaseIterable {
        case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
        
        var displayName: String {
            switch self {
            case .sunday: return "Sunday"
            case .monday: return "Monday"
            case .tuesday: return "Tuesday"
            case .wednesday: return "Wednesday"
            case .thursday: return "Thursday"
            case .friday: return "Friday"
            case .saturday: return "Saturday"
            }
        }
    }
}

struct RingEvent {
    let id: UUID
    let deviceId: UUID
    let timestamp: Date
    let type: RingEventType
    let duration: TimeInterval
    let metadata: [String: Any]
}

enum RingEventType: String, CaseIterable {
    case motion = "Motion"
    case doorbell = "Doorbell"
    case livestream = "Live Stream"
    case snapshot = "Snapshot"
    case maintenance = "Maintenance"
    case geofence = "Geofence"
    
    var iconName: String {
        switch self {
        case .motion: return "sensor.tag.radiowaves.forward.fill"
        case .doorbell: return "bell.fill"
        case .livestream: return "video.fill"
        case .snapshot: return "camera.fill"
        case .maintenance: return "wrench.and.screwdriver.fill"
        case .geofence: return "location.fill"
        }
    }
}

enum StreamQuality: String, CaseIterable {
    case low = "Low (480p)"
    case medium = "Medium (720p)"
    case high = "High (1080p)"
    case ultra = "Ultra (4K)"
    
    var bandwidth: String {
        switch self {
        case .low: return "1 Mbps"
        case .medium: return "3 Mbps"
        case .high: return "8 Mbps"
        case .ultra: return "25 Mbps"
        }
    }
}

enum RingAuthResult {
    case success(accessToken: String)
    case failure(RingAPIError)
}

enum RingAPIError: Error, LocalizedError {
    case notAuthenticated
    case networkError
    case invalidResponse
    case deviceNotFound
    case operationFailed
    case streamUnavailable
    case authenticationFailed
    case rateLimitExceeded
    case insufficientPermissions
    case deviceOffline
    case storageExceeded
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated: return "Please sign in to Ring"
        case .networkError: return "Network connection error"
        case .invalidResponse: return "Invalid response from Ring"
        case .deviceNotFound: return "Device not found"
        case .operationFailed: return "Operation failed"
        case .streamUnavailable: return "Live stream unavailable"
        case .authenticationFailed: return "Authentication failed"
        case .rateLimitExceeded: return "Too many requests, please wait"
        case .insufficientPermissions: return "Insufficient permissions"
        case .deviceOffline: return "Device is offline"
        case .storageExceeded: return "Storage limit exceeded"
        }
    }
    
    var recoveryAction: String? {
        switch self {
        case .notAuthenticated: return "Sign in to continue"
        case .networkError: return "Check your connection"
        case .deviceNotFound: return "Refresh devices"
        case .operationFailed: return "Try again"
        case .streamUnavailable: return "Check device status"
        case .authenticationFailed: return "Re-authenticate"
        case .rateLimitExceeded: return "Wait a moment"
        case .insufficientPermissions: return "Check permissions"
        case .deviceOffline: return "Check device power"
        case .storageExceeded: return "Free up space"
        default: return nil
        }
    }
}

// MARK: - Advanced Motion Detection Functions

extension RingAPIManager {
    
    func getRecentMotionAlerts(for deviceId: UUID, limit: Int = 10, completion: @escaping (Result<[MotionAlert], RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        debugLog("📋 Fetching recent motion alerts for device \(deviceId)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            var alerts: [MotionAlert] = []
            
            for i in 0..<limit {
                let timestamp = Date().addingTimeInterval(-Double(i * 300 + Int.random(in: 0...299)))
                let alertTypes = ["Motion detected", "Person detected", "Vehicle detected", "Package detected"]
                let description = alertTypes.randomElement()!
                
                alerts.append(MotionAlert(
                    id: UUID(),
                    deviceId: deviceId,
                    timestamp: timestamp,
                    description: description,
                    alertType: .motion,
                    confidence: Double.random(in: 0.7...1.0),
                    hasVideo: Bool.random()
                ))
            }
            
            completion(.success(alerts.sorted { $0.timestamp > $1.timestamp }))
        }
    }
    
    func enableMotionDetection(for deviceId: UUID, completion: @escaping (Result<Void, RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        debugLog("🔔 Enabling motion detection for device \(deviceId)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.deviceStatuses[deviceId]?.motionDetectionEnabled = true
            completion(.success(()))
            self.sendLocalNotification(title: "Motion Detection Enabled", body: "Motion alerts are now active")
        }
    }
    
    func disableMotionDetection(for deviceId: UUID, completion: @escaping (Result<Void, RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        debugLog("🔕 Disabling motion detection for device \(deviceId)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.deviceStatuses[deviceId]?.motionDetectionEnabled = false
            completion(.success(()))
            self.sendLocalNotification(title: "Motion Detection Disabled", body: "Motion alerts are now paused")
        }
    }
    
    func setSirenState(for deviceId: UUID, enabled: Bool, duration: TimeInterval = 30, completion: @escaping (Result<Void, RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        debugLog("🚨 \(enabled ? "Activating" : "Deactivating") siren for device \(deviceId)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if enabled {
                // Auto-deactivate after duration
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    self.debugLog("⏰ Auto-deactivating siren after \(duration) seconds")
                    self.sendLocalNotification(title: "Siren Deactivated", body: "Emergency siren automatically stopped")
                }
                self.sendLocalNotification(title: "Emergency Siren Activated", body: "Siren will auto-stop in \(Int(duration)) seconds")
            }
            completion(.success(()))
        }
    }
    
    func setPrivacyMode(for deviceId: UUID, enabled: Bool, completion: @escaping (Result<Void, RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        debugLog("🔒 \(enabled ? "Enabling" : "Disabling") privacy mode for device \(deviceId)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(()))
            let message = enabled ? "Camera recording paused" : "Camera recording resumed"
            self.sendLocalNotification(title: "Privacy Mode", body: message)
        }
    }
    
    func getDeviceStatus(for deviceId: UUID, completion: @escaping (Result<RingDeviceStatus, RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        debugLog("📊 Getting device status for \(deviceId)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let status = self.deviceStatuses[deviceId] {
                completion(.success(status))
            } else {
                // Create default status
                let status = RingDeviceStatus(
                    isOnline: true,
                    batteryLevel: Int.random(in: 60...95),
                    motionDetectionEnabled: true,
                    lastMotionTime: Date().addingTimeInterval(-Double.random(in: 300...7200)),
                    signalStrength: Int.random(in: 1...4),
                    firmwareVersion: "2.1.\(Int.random(in: 10...99))",
                    temperature: Int.random(in: 18...25),
                    recordingMode: .auto
                )
                self.deviceStatuses[deviceId] = status
                completion(.success(status))
            }
        }
    }
    
    func getAllDevicesStatus(completion: @escaping (Result<[UUID: RingDeviceStatus], RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(self.deviceStatuses))
        }
    }
    
    func getDeviceHistory(for deviceId: UUID, days: Int = 7, completion: @escaping (Result<[RingEvent], RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        debugLog("📈 Fetching device history for \(deviceId) - \(days) days")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            var events: [RingEvent] = []
            
            for day in 0..<days {
                let eventsPerDay = Int.random(in: 5...15)
                for _ in 0..<eventsPerDay {
                    let timestamp = Date().addingTimeInterval(-Double(day * 86400 + Int.random(in: 0...86400)))
                    let eventTypes: [RingEventType] = [.motion, .doorbell, .livestream, .snapshot]
                    
                    events.append(RingEvent(
                        id: UUID(),
                        deviceId: deviceId,
                        timestamp: timestamp,
                        type: eventTypes.randomElement()!,
                        duration: TimeInterval.random(in: 10...120),
                        metadata: [:]
                    ))
                }
            }
            
            completion(.success(events.sorted { $0.timestamp > $1.timestamp }))
        }
    }
} 