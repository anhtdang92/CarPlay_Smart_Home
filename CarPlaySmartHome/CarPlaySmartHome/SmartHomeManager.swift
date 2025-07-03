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
    
    init(id: UUID, name: String, status: DeviceStatus, deviceType: DeviceType = .camera) {
        self.id = id
        self.name = name
        self.status = status
        self.deviceType = deviceType
    }
}

class SmartHomeManager: ObservableObject {

    static let shared = SmartHomeManager()

    @Published private(set) var devices: [SmartDevice] = []
    @Published private(set) var recentMotionAlerts: [MotionAlert] = []

    private init() {
        // We can listen for authentication changes to load devices
        AuthenticationManager.shared.$isAuthenticated.sink { [weak self] isSignedIn in
            if isSignedIn {
                self?.loadDevicesFromRing()
            } else {
                self?.devices = []
                self?.recentMotionAlerts = []
            }
        }.store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()

    func loadDevicesFromRing() {
        RingAPIManager.shared.getRingDevices { [weak self] ringDevices in
            DispatchQueue.main.async {
                self?.devices = ringDevices
            }
        }
    }

    func getDevices() -> [SmartDevice] {
        return devices
    }
    
    func getDevices(ofType type: DeviceType) -> [SmartDevice] {
        return devices.filter { $0.deviceType == type }
    }

    func toggleDevice(withId id: UUID) {
        // For Ring, a "toggle" doesn't make much sense for a camera.
        // We would likely trigger a snapshot or view the stream.
        // For now, let's just print a message.
        if let device = devices.first(where: { $0.id == id }) {
            print("Interacting with Ring device: \(device.name)")
            // In a real app, you might do this:
            // RingAPIManager.shared.getCameraStreamURL(for: id) { url in ... }
        }
    }
    
    // MARK: - Ring Intervention Methods
    
    func captureSnapshot(for deviceId: UUID, completion: @escaping (Bool, URL?) -> Void) {
        RingAPIManager.shared.captureSnapshot(for: deviceId) { success, url in
            DispatchQueue.main.async {
                completion(success, url)
            }
        }
    }
    
    func getRecentMotionAlerts(for deviceId: UUID, completion: @escaping ([MotionAlert]) -> Void) {
        RingAPIManager.shared.getRecentMotionAlerts(for: deviceId) { [weak self] alerts in
            DispatchQueue.main.async {
                self?.recentMotionAlerts = alerts
                completion(alerts)
            }
        }
    }
    
    func toggleMotionDetection(for deviceId: UUID, completion: @escaping (Bool) -> Void) {
        RingAPIManager.shared.getDeviceStatus(for: deviceId) { [weak self] status in
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
        RingAPIManager.shared.enableMotionDetection(for: deviceId) { success in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    func disableMotionDetection(for deviceId: UUID, completion: @escaping (Bool) -> Void) {
        RingAPIManager.shared.disableMotionDetection(for: deviceId) { success in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    func activateSiren(for deviceId: UUID, completion: @escaping (Bool) -> Void) {
        RingAPIManager.shared.setSirenState(for: deviceId, enabled: true) { success in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    func deactivateSiren(for deviceId: UUID, completion: @escaping (Bool) -> Void) {
        RingAPIManager.shared.setSirenState(for: deviceId, enabled: false) { success in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    func getLiveStream(for deviceId: UUID, completion: @escaping (URL?) -> Void) {
        RingAPIManager.shared.getCameraStreamURL(for: deviceId) { url in
            DispatchQueue.main.async {
                completion(url)
            }
        }
    }
    
    func getDeviceStatus(for deviceId: UUID, completion: @escaping (RingDeviceStatus?) -> Void) {
        RingAPIManager.shared.getDeviceStatus(for: deviceId) { status in
            DispatchQueue.main.async {
                completion(status)
            }
        }
    }
} 