class RingDevice: ObservableObject, Identifiable {
    let id = UUID()
    @Published var name: String
    @Published var type: DeviceType
    @Published var category: DeviceCategory
    @Published var location: String
    @Published var isOn: Bool
    @Published var status: DeviceStatus
    @Published var brightness: Double
    @Published var temperature: Double
    @Published var batteryLevel: Double
    @Published var energyUsage: Double
    @Published var isFavorite: Bool
    @Published var lastUpdated: Date
    @Published var firmwareVersion: String
    @Published var signalStrength: Double
    @Published var automationRules: [String]
    @Published var maintenanceInfo: MaintenanceInfo
    @Published var sharingInfo: SharingInfo
    
    init(name: String, type: DeviceType, category: DeviceCategory, location: String) {
        self.name = name
        self.type = type
        self.category = category
        self.location = location
        self.isOn = false
        self.status = .online
        self.brightness = 1.0
        self.temperature = 22.0
        self.batteryLevel = Double.random(in: 0.3...1.0)
        self.energyUsage = Double.random(in: 0.1...5.0)
        self.isFavorite = false
        self.lastUpdated = Date()
        self.firmwareVersion = "v\(Int.random(in: 1...5)).\(Int.random(in: 0...9)).\(Int.random(in: 0...9))"
        self.signalStrength = Double.random(in: 0.5...1.0)
        self.automationRules = []
        self.maintenanceInfo = MaintenanceInfo()
        self.sharingInfo = SharingInfo()
    }
    
    // MARK: - Enhanced Device Control
    func toggle() {
        if status == .online {
            isOn.toggle()
            lastUpdated = Date()
            HapticFeedback.impact(style: .light)
        }
    }
    
    func setBrightness(_ value: Double) {
        if status == .online && category == .lighting {
            brightness = max(0.0, min(1.0, value))
            lastUpdated = Date()
            HapticFeedback.impact(style: .light)
        }
    }
    
    func setTemperature(_ value: Double) {
        if status == .online && category == .climate {
            temperature = max(10.0, min(35.0, value))
            lastUpdated = Date()
            HapticFeedback.impact(style: .light)
        }
    }
    
    func refreshStatus() {
        // Simulate status refresh
        status = Bool.random() ? .online : .offline
        batteryLevel = max(0.0, batteryLevel + Double.random(in: -0.1...0.1))
        signalStrength = max(0.0, signalStrength + Double.random(in: -0.1...0.1))
        lastUpdated = Date()
    }
    
    // MARK: - Device Information
    var displayName: String {
        return name
    }
    
    var statusDescription: String {
        switch status {
        case .online:
            return isOn ? "Active" : "Standby"
        case .offline:
            return "Offline"
        }
    }
    
    var batteryStatus: BatteryStatus {
        if batteryLevel > 0.5 {
            return .good
        } else if batteryLevel > 0.2 {
            return .low
        } else {
            return .critical
        }
    }
    
    var signalStatus: SignalStatus {
        if signalStrength > 0.8 {
            return .excellent
        } else if signalStrength > 0.6 {
            return .good
        } else if signalStrength > 0.4 {
            return .fair
        } else {
            return .poor
        }
    }
    
    var energyEfficiency: EnergyEfficiency {
        if energyUsage < 1.0 {
            return .excellent
        } else if energyUsage < 2.5 {
            return .good
        } else if energyUsage < 4.0 {
            return .fair
        } else {
            return .poor
        }
    }
    
    // MARK: - Device Capabilities
    var capabilities: [DeviceCapability] {
        var caps: [DeviceCapability] = []
        
        switch category {
        case .lighting:
            caps.append(.brightness)
            caps.append(.color)
            caps.append(.scheduling)
        case .climate:
            caps.append(.temperature)
            caps.append(.humidity)
            caps.append(.scheduling)
        case .security:
            caps.append(.motion)
            caps.append(.recording)
            caps.append(.alerts)
        case .entertainment:
            caps.append(.volume)
            caps.append(.playback)
            caps.append(.scheduling)
        case .appliances:
            caps.append(.power)
            caps.append(.scheduling)
        case .sensors:
            caps.append(.monitoring)
            caps.append(.alerts)
        }
        
        return caps
    }
    
    // MARK: - Device Health
    var healthScore: Double {
        var score = 1.0
        
        // Status impact
        if status == .offline {
            score -= 0.5
        }
        
        // Battery impact
        if batteryLevel < 0.2 {
            score -= 0.3
        } else if batteryLevel < 0.5 {
            score -= 0.1
        }
        
        // Signal impact
        if signalStrength < 0.4 {
            score -= 0.2
        } else if signalStrength < 0.6 {
            score -= 0.1
        }
        
        // Energy efficiency impact
        if energyUsage > 4.0 {
            score -= 0.1
        }
        
        return max(0.0, score)
    }
    
    var healthStatus: HealthStatus {
        let score = healthScore
        if score > 0.8 {
            return .excellent
        } else if score > 0.6 {
            return .good
        } else if score > 0.4 {
            return .fair
        } else {
            return .poor
        }
    }
    
    // MARK: - Device Recommendations
    func getRecommendations() -> [DeviceRecommendation] {
        var recommendations: [DeviceRecommendation] = []
        
        // Battery recommendations
        if batteryLevel < 0.2 {
            recommendations.append(DeviceRecommendation(
                type: .battery,
                title: "Low Battery",
                description: "Consider charging or replacing the battery",
                priority: .high
            ))
        }
        
        // Signal recommendations
        if signalStrength < 0.4 {
            recommendations.append(DeviceRecommendation(
                type: .connectivity,
                title: "Poor Signal",
                description: "Move device closer to router or check interference",
                priority: .medium
            ))
        }
        
        // Energy recommendations
        if energyUsage > 4.0 {
            recommendations.append(DeviceRecommendation(
                type: .energy,
                title: "High Energy Usage",
                description: "Consider optimizing settings or upgrading to energy-efficient model",
                priority: .low
            ))
        }
        
        // Firmware recommendations
        if firmwareVersion < "v2.0" {
            recommendations.append(DeviceRecommendation(
                type: .firmware,
                title: "Firmware Update Available",
                description: "Update firmware for improved performance and security",
                priority: .medium
            ))
        }
        
        return recommendations
    }
}

// MARK: - Supporting Models
struct MaintenanceInfo {
    var lastMaintenance: Date?
    var nextMaintenance: Date?
    var maintenanceType: MaintenanceType?
    var notes: String = ""
}

struct SharingInfo {
    var sharedWith: [String] = []
    var permissions: [DevicePermission] = []
    var sharedDate: Date?
}

enum BatteryStatus {
    case good, low, critical
    
    var color: Color {
        switch self {
        case .good: return .green
        case .low: return .orange
        case .critical: return .red
        }
    }
    
    var description: String {
        switch self {
        case .good: return "Good"
        case .low: return "Low"
        case .critical: return "Critical"
        }
    }
}

enum SignalStatus {
    case excellent, good, fair, poor
    
    var color: Color {
        switch self {
        case .excellent: return .green
        case .good: return .blue
        case .fair: return .orange
        case .poor: return .red
        }
    }
    
    var description: String {
        switch self {
        case .excellent: return "Excellent"
        case .good: return "Good"
        case .fair: return "Fair"
        case .poor: return "Poor"
        }
    }
}

enum EnergyEfficiency {
    case excellent, good, fair, poor
    
    var color: Color {
        switch self {
        case .excellent: return .green
        case .good: return .blue
        case .fair: return .orange
        case .poor: return .red
        }
    }
    
    var description: String {
        switch self {
        case .excellent: return "Excellent"
        case .good: return "Good"
        case .fair: return "Fair"
        case .poor: return "Poor"
        }
    }
}

enum DeviceCapability {
    case brightness, color, temperature, humidity, motion, recording, alerts, volume, playback, power, monitoring, scheduling
    
    var icon: String {
        switch self {
        case .brightness: return "lightbulb"
        case .color: return "paintbrush"
        case .temperature: return "thermometer"
        case .humidity: return "drop"
        case .motion: return "figure.walk"
        case .recording: return "video"
        case .alerts: return "bell"
        case .volume: return "speaker.wave.3"
        case .playback: return "play"
        case .power: return "power"
        case .monitoring: return "eye"
        case .scheduling: return "clock"
        }
    }
    
    var description: String {
        switch self {
        case .brightness: return "Brightness Control"
        case .color: return "Color Control"
        case .temperature: return "Temperature Control"
        case .humidity: return "Humidity Control"
        case .motion: return "Motion Detection"
        case .recording: return "Video Recording"
        case .alerts: return "Alerts & Notifications"
        case .volume: return "Volume Control"
        case .playback: return "Media Playback"
        case .power: return "Power Control"
        case .monitoring: return "Environmental Monitoring"
        case .scheduling: return "Scheduling"
        }
    }
}

enum HealthStatus {
    case excellent, good, fair, poor
    
    var color: Color {
        switch self {
        case .excellent: return .green
        case .good: return .blue
        case .fair: return .orange
        case .poor: return .red
        }
    }
    
    var description: String {
        switch self {
        case .excellent: return "Excellent"
        case .good: return "Good"
        case .fair: return "Fair"
        case .poor: return "Poor"
        }
    }
}

struct DeviceRecommendation {
    let type: RecommendationType
    let title: String
    let description: String
    let priority: RecommendationPriority
}

enum RecommendationType {
    case battery, connectivity, energy, firmware, security, automation
}

enum RecommendationPriority {
    case low, medium, high, critical
} 