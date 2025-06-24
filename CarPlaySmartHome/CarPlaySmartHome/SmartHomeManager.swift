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

struct SmartDevice: Identifiable {
    let id: UUID
    let name: String
    var status: DeviceStatus
}

class SmartHomeManager: ObservableObject {

    static let shared = SmartHomeManager()

    @Published private(set) var devices: [SmartDevice] = []

    private init() {
        // We can listen for authentication changes to load devices
        AuthenticationManager.shared.$isAuthenticated.sink { [weak self] isSignedIn in
            if isSignedIn {
                self?.loadDevicesFromRing()
            } else {
                self?.devices = []
            }
        }.store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()

    func loadDevicesFromRing() {
        RingAPIManager.shared.getRingDevices { [weak self] ringDevices in
            self?.devices = ringDevices
        }
    }

    func getDevices() -> [SmartDevice] {
        return devices
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
} 