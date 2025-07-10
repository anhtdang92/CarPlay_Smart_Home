import SwiftUI
import MapKit
import AVKit

// MARK: - Ring Premium Components

/// Premium Ring device card with advanced Ring-specific features
struct RingPremiumDeviceCard: View {
    let device: SmartDevice
    @State private var isExpanded = false
    @State private var showingLiveView = false
    @State private var motionEvents: [MotionEvent] = []
    @State private var isRecording = false
    
    var body: some View {
        LiquidGlassCard(tint: ringColorForDevice, cornerRadius: 20) {
            VStack(spacing: AppleSpacing.m) {
                // Header with device status
                HStack {
                    RingDeviceIcon(device: device)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(device.name)
                            .font(AppleTypography.title3)
                            .foregroundColor(.primary)
                        
                        RingStatusBadge(device: device)
                    }
                    
                    Spacer()
                    
                    if device.deviceType == .camera || device.deviceType == .doorbell {
                        RingLiveIndicator(isLive: device.status == .on)
                    }
                }
                
                // Ring-specific quick stats
                RingDeviceQuickStats(device: device)
                
                // Expandable Ring controls
                if isExpanded {
                    RingAdvancedControls(device: device)
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .opacity
                        ))
                }
                
                // Action buttons
                HStack(spacing: AppleSpacing.m) {
                    if device.deviceType == .camera || device.deviceType == .doorbell {
                        Button(action: { showingLiveView = true }) {
                            Label("Live View", systemImage: "video.fill")
                        }
                        .buttonStyle(RingActionButtonStyle())
                    }
                    
                    Button(action: { withAnimation(AppleAnimations.smooth) { isExpanded.toggle() } }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.title2)
                    }
                    .buttonStyle(RingSecondaryButtonStyle())
                    
                    Button(action: toggleDevice) {
                        Image(systemName: device.status == .on ? "power" : "power.circle")
                            .font(.title2)
                    }
                    .buttonStyle(RingPrimaryButtonStyle())
                }
            }
            .padding(AppleSpacing.l)
        }
        .onTapGesture {
            withAnimation(AppleAnimations.smooth) {
                isExpanded.toggle()
            }
        }
        .sheet(isPresented: $showingLiveView) {
            RingLiveViewSheet(device: device)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Ring \(device.deviceType.displayName), \(device.name)")
        .accessibilityValue("\(device.status == .on ? "Online" : "Offline"), Battery \(device.batteryLevel ?? 100)%")
        .accessibilityHint("Double tap to expand controls")
    }
    
    private var ringColorForDevice: Color {
        switch device.deviceType {
        case .camera: return AppleDesignSystem.Colors.accentBlue
        case .doorbell: return AppleDesignSystem.Colors.accentPurple
        case .motionSensor: return .green
        case .floodlight: return .orange
        case .chime: return .cyan
        }
    }
    
    private func toggleDevice() {
        HapticFeedback.deviceOperation(success: true)
        // Implement Ring device toggle
        Logger.shared.logUserAction("ring_device_toggled", context: device.deviceType.rawValue)
    }
}

/// Ring-specific device icon with animated status indicator
struct RingDeviceIcon: View {
    let device: SmartDevice
    @State private var isPulsing = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        ringColorForDevice.opacity(0.2),
                        ringColorForDevice.opacity(0.1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 60, height: 60)
            
            Image(systemName: iconForDevice)
                .font(.title2)
                .foregroundColor(ringColorForDevice)
            
            // Status indicator
            if device.status == .on {
                Circle()
                    .fill(Color.green)
                    .frame(width: 12, height: 12)
                    .offset(x: 20, y: -20)
                    .scaleEffect(isPulsing ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                        value: isPulsing
                    )
                    .onAppear { isPulsing = true }
            }
        }
    }
    
    private var iconForDevice: String {
        switch device.deviceType {
        case .camera: return "video.fill"
        case .doorbell: return "bell.fill"
        case .motionSensor: return "sensor.tag.radiowaves.forward.fill"
        case .floodlight: return "lightbulb.fill"
        case .chime: return "speaker.wave.3.fill"
        }
    }
    
    private var ringColorForDevice: Color {
        switch device.deviceType {
        case .camera: return AppleDesignSystem.Colors.accentBlue
        case .doorbell: return AppleDesignSystem.Colors.accentPurple
        case .motionSensor: return .green
        case .floodlight: return .orange
        case .chime: return .cyan
        }
    }
}

/// Ring status badge with subscription tier
struct RingStatusBadge: View {
    let device: SmartDevice
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            Text(statusText)
                .font(AppleTypography.caption)
                .foregroundColor(.secondary)
            
            if hasRingProtect {
                RingProtectBadge()
            }
        }
    }
    
    private var statusColor: Color {
        switch device.status {
        case .on: return .green
        case .off: return .red
        case .unknown: return .orange
        }
    }
    
    private var statusText: String {
        switch device.status {
        case .on: return "Online"
        case .off: return "Offline"
        case .unknown: return "Unknown"
        }
    }
    
    private var hasRingProtect: Bool {
        // Simulate Ring Protect subscription
        return device.deviceType == .camera || device.deviceType == .doorbell
    }
}

/// Ring Protect subscription badge
struct RingProtectBadge: View {
    var body: some View {
        Text("PROTECT")
            .font(.system(size: 10, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
    }
}

/// Ring live view indicator
struct RingLiveIndicator: View {
    let isLive: Bool
    @State private var isBlinking = false
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(isLive ? Color.red : Color.gray)
                .frame(width: 8, height: 8)
                .opacity(isLive && isBlinking ? 0.5 : 1.0)
                .animation(
                    isLive ? Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true) : .none,
                    value: isBlinking
                )
                .onAppear {
                    if isLive { isBlinking = true }
                }
            
            Text(isLive ? "LIVE" : "OFFLINE")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(isLive ? .red : .gray)
        }
    }
}

/// Ring device quick statistics
struct RingDeviceQuickStats: View {
    let device: SmartDevice
    
    var body: some View {
        HStack(spacing: AppleSpacing.l) {
            if let battery = device.batteryLevel {
                RingStatItem(
                    icon: "battery.100",
                    value: "\(battery)%",
                    label: "Battery",
                    color: batteryColor(for: battery)
                )
            }
            
            RingStatItem(
                icon: "wifi",
                value: signalStrengthText,
                label: "Signal",
                color: signalColor
            )
            
            if device.deviceType == .camera || device.deviceType == .doorbell {
                RingStatItem(
                    icon: "figure.walk",
                    value: "\(Int.random(in: 5...25))",
                    label: "Events",
                    color: .blue
                )
            }
        }
    }
    
    private func batteryColor(for level: Int) -> Color {
        switch level {
        case 70...100: return .green
        case 30...69: return .orange
        default: return .red
        }
    }
    
    private var signalStrengthText: String {
        let strength = Int.random(in: 1...4)
        return String(repeating: "●", count: strength) + String(repeating: "○", count: 4 - strength)
    }
    
    private var signalColor: Color {
        return .blue
    }
}

/// Ring statistic item
struct RingStatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
            
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 50)
    }
}

/// Advanced Ring device controls
struct RingAdvancedControls: View {
    let device: SmartDevice
    @State private var motionDetectionEnabled = true
    @State private var nightVisionEnabled = true
    @State private var recordingQuality = "HD"
    
    var body: some View {
        VStack(spacing: AppleSpacing.m) {
            if device.deviceType == .camera || device.deviceType == .doorbell {
                // Camera-specific controls
                VStack(spacing: AppleSpacing.s) {
                    RingControlRow(
                        title: "Motion Detection",
                        isOn: $motionDetectionEnabled,
                        icon: "figure.walk"
                    )
                    
                    RingControlRow(
                        title: "Night Vision",
                        isOn: $nightVisionEnabled,
                        icon: "moon.fill"
                    )
                    
                    // Recording quality picker
                    HStack {
                        Image(systemName: "video.badge.checkmark")
                            .foregroundColor(.blue)
                        
                        Text("Quality")
                            .font(AppleTypography.body)
                        
                        Spacer()
                        
                        Picker("Quality", selection: $recordingQuality) {
                            Text("720p").tag("HD")
                            Text("1080p").tag("FHD")
                            Text("1440p").tag("2K")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 150)
                    }
                }
                
                Divider()
                    .padding(.vertical, AppleSpacing.xs)
                
                // Quick actions
                RingQuickActionsGrid(device: device)
            }
        }
    }
}

/// Ring control row with toggle
struct RingControlRow: View {
    let title: String
    @Binding var isOn: Bool
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .font(AppleTypography.body)
            
            Spacer()
            
            FuturisticToggle(
                isOn: $isOn,
                label: title,
                accentColor: .blue
            )
        }
    }
}

/// Ring quick actions grid
struct RingQuickActionsGrid: View {
    let device: SmartDevice
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: AppleSpacing.s) {
            RingQuickActionButton(
                icon: "camera.fill",
                title: "Snapshot",
                action: takeSnapshot
            )
            
            RingQuickActionButton(
                icon: "speaker.wave.2.fill",
                title: "Talk",
                action: startTwoWayTalk
            )
            
            RingQuickActionButton(
                icon: "bell.badge.fill",
                title: "Siren",
                action: activateSiren
            )
        }
    }
    
    private func takeSnapshot() {
        HapticFeedback.impact(style: .medium)
        Logger.shared.logUserAction("ring_snapshot_taken", context: device.name)
    }
    
    private func startTwoWayTalk() {
        HapticFeedback.impact(style: .medium)
        Logger.shared.logUserAction("ring_two_way_talk", context: device.name)
    }
    
    private func activateSiren() {
        HapticFeedback.criticalAlert()
        Logger.shared.logUserAction("ring_siren_activated", context: device.name)
    }
}

/// Ring quick action button
struct RingQuickActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title3)
                
                Text(title)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(.blue)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.1))
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

/// Ring live view sheet
struct RingLiveViewSheet: View {
    let device: SmartDevice
    @Environment(\.dismiss) private var dismiss
    @State private var isRecording = false
    @State private var isTalking = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Mock video player background
                Rectangle()
                    .fill(Color.black)
                    .overlay(
                        VStack {
                            Image(systemName: "video.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text("Live View")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(device.name)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.6))
                        }
                    )
                
                // Controls overlay
                VStack {
                    Spacer()
                    
                    HStack(spacing: AppleSpacing.xl) {
                        // Record button
                        Button(action: { isRecording.toggle() }) {
                            Image(systemName: isRecording ? "record.circle.fill" : "record.circle")
                                .font(.system(size: 40))
                                .foregroundColor(isRecording ? .red : .white)
                        }
                        
                        // Snapshot button
                        Button(action: takeSnapshot) {
                            Image(systemName: "camera.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                        
                        // Talk button
                        Button(action: { isTalking.toggle() }) {
                            Image(systemName: isTalking ? "mic.fill" : "mic.circle")
                                .font(.system(size: 40))
                                .foregroundColor(isTalking ? .blue : .white)
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
            .navigationTitle("Live View")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private func takeSnapshot() {
        HapticFeedback.impact(style: .medium)
        Logger.shared.logUserAction("ring_live_snapshot", context: device.name)
    }
}

// MARK: - Ring Button Styles

struct RingPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .frame(width: 44, height: 44)
            .background(
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct RingSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.blue)
            .frame(width: 44, height: 44)
            .background(
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .overlay(
                        Circle()
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct RingActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Supporting Models

struct MotionEvent {
    let id = UUID()
    let timestamp: Date
    let confidence: Double
    let thumbnailURL: URL?
    let duration: TimeInterval
}

extension DeviceType {
    var displayName: String {
        switch self {
        case .camera: return "Camera"
        case .doorbell: return "Doorbell"
        case .motionSensor: return "Motion Sensor"
        case .floodlight: return "Floodlight"
        case .chime: return "Chime"
        }
    }
} 