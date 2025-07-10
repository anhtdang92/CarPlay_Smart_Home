import Foundation
import SwiftUI

// MARK: - RingDevice Extensions for Modern Interface

extension RingDevice {
    /// Device status for modern interface
    var status: DeviceConnectionStatus {
        // Convert from your existing status system to the new one
        return isOnline ? .online : .offline
    }
    
    /// Battery level for devices that support it
    var batteryLevel: Int? {
        // Return battery level if available, otherwise nil
        // This should be connected to your actual battery level data
        if category == .motionSensor || category == .doorbell {
            return Int.random(in: 15...100) // Mock data - replace with actual battery level
        }
        return nil
    }
    
    /// Device category with proper icon support
    var category: DeviceCategory {
        // Convert from your existing device type to the new category system
        switch deviceType {
        case .camera:
            return .camera
        case .doorbell:
            return .doorbell
        case .motionSensor:
            return .motionSensor
        case .floodlight:
            return .floodlight
        case .chime:
            return .chime
        }
    }
    
    /// Check if device is currently on/active
    var isOn: Bool {
        // This should be connected to your actual device state
        return status == .online && deviceStatus == .on
    }
    
    /// Last seen timestamp for device
    var lastSeenDate: Date? {
        // Return the last time the device was seen online
        return lastSeen
    }
}

// MARK: - Device Connection Status

enum DeviceConnectionStatus: String, CaseIterable {
    case online = "online"
    case offline = "offline"
    case unknown = "unknown"
    
    var displayName: String {
        switch self {
        case .online: return "Online"
        case .offline: return "Offline"
        case .unknown: return "Unknown"
        }
    }
    
    var color: Color {
        switch self {
        case .online: return .green
        case .offline: return .red
        case .unknown: return .orange
        }
    }
}

// MARK: - Enhanced Device Category

enum DeviceCategory: String, CaseIterable {
    case camera = "Camera"
    case doorbell = "Doorbell"
    case motionSensor = "Motion Sensor"
    case floodlight = "Floodlight"
    case chime = "Chime"
    case all = "All Devices"
    
    var icon: String {
        switch self {
        case .camera: return "video.fill"
        case .doorbell: return "bell.fill"
        case .motionSensor: return "sensor.tag.radiowaves.forward.fill"
        case .floodlight: return "lightbulb.fill"
        case .chime: return "speaker.wave.3.fill"
        case .all: return "square.grid.3x3.fill"
        }
    }
    
    var displayName: String {
        return rawValue
    }
    
    var description: String {
        switch self {
        case .camera: return "Security cameras with video recording"
        case .doorbell: return "Smart doorbells with two-way audio"
        case .motionSensor: return "Motion detection sensors"
        case .floodlight: return "Smart floodlights with motion activation"
        case .chime: return "Audio chimes and notifications"
        case .all: return "All device types"
        }
    }
    
    var primaryColor: Color {
        switch self {
        case .camera: return AppleDesignSystem.Colors.accentBlue
        case .doorbell: return AppleDesignSystem.Colors.accentPurple
        case .motionSensor: return .green
        case .floodlight: return .orange
        case .chime: return .cyan
        case .all: return .gray
        }
    }
}

// MARK: - SmartHomeManager Extensions for Modern Interface

extension SmartHomeManager {
    
    /// Total energy usage for all devices
    var totalEnergyUsage: Double {
        // Calculate total energy usage across all devices
        // This should be connected to your actual energy monitoring
        return Double(devices.count) * 0.5 // Mock calculation
    }
    
    /// Number of active automations
    var activeAutomations: Int {
        // Return count of active automation rules
        // This should be connected to your actual automation system
        return 5 // Mock data
    }
    
    /// Turn on a specific device
    func turnDeviceOn(_ device: RingDevice) {
        guard device.status == .online else {
            logWarning("Cannot turn on offline device: \(device.name)", category: .device)
            return
        }
        
        // Implement device turn on logic
        logInfo("Turning on device: \(device.name)", category: .device)
        
        // Update device state and trigger haptic feedback
        HapticFeedback.deviceOperation(success: true)
        
        // Track user action
        trackUserAction("device_turned_on", context: device.category.rawValue)
    }
    
    /// Turn off a specific device
    func turnDeviceOff(_ device: RingDevice) {
        guard device.status == .online else {
            logWarning("Cannot turn off offline device: \(device.name)", category: .device)
            return
        }
        
        // Implement device turn off logic
        logInfo("Turning off device: \(device.name)", category: .device)
        
        // Update device state and trigger haptic feedback
        HapticFeedback.deviceOperation(success: true)
        
        // Track user action
        trackUserAction("device_turned_off", context: device.category.rawValue)
    }
    
    /// Turn on all devices
    func turnAllDevicesOn() {
        let onlineDevices = devices.filter { $0.status == .online }
        
        for device in onlineDevices {
            turnDeviceOn(device)
        }
        
        logInfo("Turned on \(onlineDevices.count) devices", category: .device)
        HapticFeedback.success()
        trackUserAction("all_devices_on", context: "bulk_operation")
    }
    
    /// Turn off all devices
    func turnAllDevicesOff() {
        let onlineDevices = devices.filter { $0.status == .online }
        
        for device in onlineDevices {
            turnDeviceOff(device)
        }
        
        logInfo("Turned off \(onlineDevices.count) devices", category: .device)
        HapticFeedback.success()
        trackUserAction("all_devices_off", context: "bulk_operation")
    }
    
    /// Set away mode - optimized security settings
    func setAwayMode() {
        logInfo("Activating away mode", category: .device)
        
        // Turn on all security devices
        let securityDevices = devices.filter { 
            $0.category == .camera || $0.category == .doorbell || $0.category == .motionSensor 
        }
        
        for device in securityDevices {
            if device.status == .online {
                turnDeviceOn(device)
            }
        }
        
        HapticFeedback.success()
        trackUserAction("away_mode_activated", context: "security")
    }
    
    /// Set night mode - optimized evening settings
    func setNightMode() {
        logInfo("Activating night mode", category: .device)
        
        // Turn on floodlights and security cameras
        let nightModeDevices = devices.filter { 
            $0.category == .floodlight || $0.category == .camera 
        }
        
        for device in nightModeDevices {
            if device.status == .online {
                turnDeviceOn(device)
            }
        }
        
        HapticFeedback.success()
        trackUserAction("night_mode_activated", context: "automation")
    }
}

// MARK: - MotionAlert Extensions

extension MotionAlert {
    /// Formatted timestamp for display
    var formattedTimestamp: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
    
    /// Device name associated with the alert
    var deviceName: String {
        // This should be connected to your device lookup system
        return "Security Camera" // Placeholder
    }
    
    /// Alert type icon
    var icon: String {
        return "motion.sensor"
    }
    
    /// Alert priority level
    var priority: AlertPriority {
        // Determine priority based on alert characteristics
        return .medium // Default priority
    }
}

// MARK: - Alert Priority

enum AlertPriority: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case critical = "Critical"
    
    var color: Color {
        switch self {
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        case .critical: return .purple
        }
    }
    
    var icon: String {
        switch self {
        case .low: return "info.circle"
        case .medium: return "exclamationmark.triangle"
        case .high: return "exclamationmark.triangle.fill"
        case .critical: return "exclamationmark.octagon.fill"
        }
    }
}

// MARK: - Device Status Extensions

extension DeviceStatus {
    var connectionStatus: DeviceConnectionStatus {
        switch self {
        case .on, .open:
            return .online
        case .off, .closed:
            return .offline
        case .unknown:
            return .unknown
        }
    }
}

// MARK: - CarPlay Optimizations

extension View {
    /// Apply CarPlay-specific optimizations
    func carPlayOptimized() -> some View {
        self
            .font(AppleDesignSystem.Typography.carPlayMedium)
            .environment(\.colorScheme, .dark) // CarPlay typically uses dark mode
            .preferredColorScheme(.dark)
    }
    
    /// Apply liquid glass effect with CarPlay optimizations
    func liquidGlass(
        intensity: Double = 0.8,
        cornerRadius: CGFloat = 16,
        tint: Color = .clear
    ) -> some View {
        self.background(
            LiquidGlassMaterial(
                intensity: intensity,
                tint: tint,
                cornerRadius: cornerRadius
            )
        )
    }
}

// MARK: - Mock Data Helpers (for development)

extension SmartHomeManager {
    /// Add sample devices for testing
    func addSampleDevices() {
        let sampleDevices = [
            SmartDevice(
                id: UUID(),
                name: "Front Door Camera",
                status: .on,
                deviceType: .camera,
                batteryLevel: 85,
                lastSeen: Date(),
                location: "Front Door"
            ),
            SmartDevice(
                id: UUID(),
                name: "Video Doorbell",
                status: .on,
                deviceType: .doorbell,
                batteryLevel: 92,
                lastSeen: Date().addingTimeInterval(-300),
                location: "Main Entrance"
            ),
            SmartDevice(
                id: UUID(),
                name: "Backyard Motion Sensor",
                status: .on,
                deviceType: .motionSensor,
                batteryLevel: 67,
                lastSeen: Date().addingTimeInterval(-150),
                location: "Backyard"
            ),
            SmartDevice(
                id: UUID(),
                name: "Garage Floodlight",
                status: .off,
                deviceType: .floodlight,
                lastSeen: Date().addingTimeInterval(-600),
                location: "Garage"
            ),
            SmartDevice(
                id: UUID(),
                name: "Indoor Chime",
                status: .on,
                deviceType: .chime,
                lastSeen: Date().addingTimeInterval(-60),
                location: "Living Room"
            )
        ]
        
        // Convert to RingDevice format if needed
        // devices.append(contentsOf: sampleDevices)
        
        logInfo("Added \(sampleDevices.count) sample devices", category: .device)
    }
}