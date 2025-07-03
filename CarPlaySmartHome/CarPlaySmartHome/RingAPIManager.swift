import Foundation
import UserNotifications

// MARK: - Ring API Manager
class RingAPIManager {

    static let shared = RingAPIManager()
    
    // MARK: - Properties
    private var accessToken: String?
    private var refreshToken: String?
    private var deviceStatuses: [UUID: RingDeviceStatus] = [:]
    private var notificationCenter = UNUserNotificationCenter.current()

    private init() {
        setupNotifications()
    }

    // MARK: - Authentication
    
    func signInWithRing(completion: @escaping (RingAuthResult) -> Void) {
        print("Simulating Ring OAuth flow...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Simulate successful authentication
            self.accessToken = "mock_access_token_\(UUID().uuidString)"
            self.refreshToken = "mock_refresh_token_\(UUID().uuidString)"
            print("Successfully received mock Ring access token.")
            
            AuthenticationManager.shared.signIn { success in
                if success {
                    completion(.success(accessToken: self.accessToken ?? ""))
                    self.startPeriodicUpdates()
                } else {
                    completion(.failure(.authenticationFailed))
                }
            }
        }
    }
    
    func signOut() {
        accessToken = nil
        refreshToken = nil
        deviceStatuses.removeAll()
        stopPeriodicUpdates()
    }
    
    func refreshAuthToken(completion: @escaping (Bool) -> Void) {
        guard refreshToken != nil else {
            completion(false)
            return
        }
        
        print("Refreshing Ring access token...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.accessToken = "refreshed_token_\(UUID().uuidString)"
            completion(true)
        }
    }

    // MARK: - Device Management
    
    func getRingDevices(completion: @escaping (Result<[SmartDevice], RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        print("Fetching devices from Ring API...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let ringDevices: [SmartDevice] = [
                SmartDevice(id: UUID(), name: "Front Door Camera", status: .on, deviceType: .camera, batteryLevel: 85, lastSeen: Date()),
                SmartDevice(id: UUID(), name: "Backyard Camera", status: .on, deviceType: .camera, batteryLevel: 72, lastSeen: Date().addingTimeInterval(-120)),
                SmartDevice(id: UUID(), name: "Video Doorbell Pro", status: .on, deviceType: .doorbell, batteryLevel: 91, lastSeen: Date()),
                SmartDevice(id: UUID(), name: "Kitchen Motion Sensor", status: .on, deviceType: .motionSensor, batteryLevel: 68, lastSeen: Date().addingTimeInterval(-60)),
                SmartDevice(id: UUID(), name: "Garage Floodlight Cam", status: .off, deviceType: .floodlight, batteryLevel: 94, lastSeen: Date().addingTimeInterval(-300))
            ]
            
            // Update device statuses
            for device in ringDevices {
                self.deviceStatuses[device.id] = RingDeviceStatus(
                    isOnline: device.status != .off,
                    batteryLevel: device.batteryLevel ?? 0,
                    motionDetectionEnabled: true,
                    lastMotionTime: Date().addingTimeInterval(-Double.random(in: 300...3600)),
                    signalStrength: Int.random(in: 1...4),
                    firmwareVersion: "2.1.\(Int.random(in: 10...99))"
                )
            }
            
            completion(.success(ringDevices))
        }
    }

    // MARK: - Camera Operations
    
    func getCameraStreamURL(for deviceId: UUID, quality: StreamQuality = .high, completion: @escaping (Result<URL, RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        print("Requesting \(quality.rawValue) quality livestream URL for device \(deviceId)...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if Bool.random() { // Simulate occasional failures
                let streamURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
                completion(.success(streamURL))
            } else {
                completion(.failure(.streamUnavailable))
            }
        }
    }
    
    func captureSnapshot(for deviceId: UUID, completion: @escaping (Result<RingSnapshot, RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        print("Capturing snapshot for device \(deviceId)...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if Bool.random() { // Simulate occasional failures
                let snapshot = RingSnapshot(
                    id: UUID(),
                    deviceId: deviceId,
                    imageURL: URL(string: "https://via.placeholder.com/640x480/000000/FFFFFF/?text=Ring+Snapshot")!,
                    timestamp: Date(),
                    width: 640,
                    height: 480
                )
                completion(.success(snapshot))
                
                // Trigger notification
                self.sendLocalNotification(title: "Snapshot Captured", body: "Successfully captured snapshot from \(deviceId)")
            } else {
                completion(.failure(.operationFailed))
            }
        }
    }

    // MARK: - Motion Detection
    
    func getRecentMotionAlerts(for deviceId: UUID, limit: Int = 10, completion: @escaping (Result<[MotionAlert], RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        print("Fetching recent motion alerts for device \(deviceId)...")
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
        
        print("Enabling motion detection for device \(deviceId)...")
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
        
        print("Disabling motion detection for device \(deviceId)...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.deviceStatuses[deviceId]?.motionDetectionEnabled = false
            completion(.success(()))
            self.sendLocalNotification(title: "Motion Detection Disabled", body: "Motion alerts are now paused")
        }
    }

    // MARK: - Security Features
    
    func setSirenState(for deviceId: UUID, enabled: Bool, duration: TimeInterval = 30, completion: @escaping (Result<Void, RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        print("\(enabled ? "Activating" : "Deactivating") siren for device \(deviceId)...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if enabled {
                // Auto-deactivate after duration
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    print("Auto-deactivating siren after \(duration) seconds")
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
        
        print("\(enabled ? "Enabling" : "Disabling") privacy mode for device \(deviceId)...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(()))
            let message = enabled ? "Camera recording paused" : "Camera recording resumed"
            self.sendLocalNotification(title: "Privacy Mode", body: message)
        }
    }

    // MARK: - Device Status
    
    func getDeviceStatus(for deviceId: UUID, completion: @escaping (Result<RingDeviceStatus, RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        print("Getting device status for \(deviceId)...")
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
                    firmwareVersion: "2.1.\(Int.random(in: 10...99))"
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

    // MARK: - Advanced Features
    
    func setMotionSchedule(for deviceId: UUID, schedule: MotionSchedule, completion: @escaping (Result<Void, RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        print("Setting motion schedule for device \(deviceId)...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(()))
            self.sendLocalNotification(title: "Motion Schedule Updated", body: "Custom motion detection schedule applied")
        }
    }
    
    func getDeviceHistory(for deviceId: UUID, days: Int = 7, completion: @escaping (Result<[RingEvent], RingAPIError>) -> Void) {
        guard isAuthenticated else {
            completion(.failure(.notAuthenticated))
            return
        }
        
        print("Fetching device history for \(deviceId)...")
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
                        duration: TimeInterval.random(in: 10...120)
                    ))
                }
            }
            
            completion(.success(events.sorted { $0.timestamp > $1.timestamp }))
        }
    }

    // MARK: - Real-time Updates
    
    private var updateTimer: Timer?
    
    private func startPeriodicUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            self.checkForNewAlerts()
        }
    }
    
    private func stopPeriodicUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    private func checkForNewAlerts() {
        // Simulate random motion alerts
        if Bool.random() && deviceStatuses.count > 0 {
            let deviceId = deviceStatuses.keys.randomElement()!
            simulateMotionAlert(for: deviceId)
        }
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

    // MARK: - Helpers
    
    private var isAuthenticated: Bool {
        return accessToken != nil
    }
    
    private func setupNotifications() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            }
        }
    }
    
    private func sendLocalNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        notificationCenter.add(request)
    }
}

// MARK: - Enhanced Data Models

struct RingSnapshot {
    let id: UUID
    let deviceId: UUID
    let imageURL: URL
    let timestamp: Date
    let width: Int
    let height: Int
}

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

struct RingDeviceStatus {
    let isOnline: Bool
    let batteryLevel: Int
    var motionDetectionEnabled: Bool
    let lastMotionTime: Date?
    let signalStrength: Int // 1-4 bars
    let firmwareVersion: String
}

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
    }
}

struct RingEvent {
    let id: UUID
    let deviceId: UUID
    let timestamp: Date
    let type: RingEventType
    let duration: TimeInterval
}

enum RingEventType {
    case motion, doorbell, livestream, snapshot
}

enum StreamQuality: String {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case ultra = "ultra"
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
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let ringMotionAlert = Notification.Name("ringMotionAlert")
    static let ringDeviceStatusChanged = Notification.Name("ringDeviceStatusChanged")
} 