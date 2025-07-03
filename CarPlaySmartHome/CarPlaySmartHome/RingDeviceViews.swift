import SwiftUI

// MARK: - Enhanced Ring Device Row

struct EnhancedRingDeviceRow: View {
    let device: SmartDevice
    let smartHomeManager: SmartHomeManager
    @State private var showingActions = false
    @State private var isLoading = false
    @State private var deviceStatus: RingDeviceStatus?
    @State private var showingSnapshot = false
    @State private var capturedSnapshot: RingSnapshot?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button {
            showingActions = true
            RingDesignSystem.Haptics.light()
        } label: {
            deviceContent
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingActions) {
            DeviceActionsSheet(
                device: device,
                smartHomeManager: smartHomeManager,
                deviceStatus: deviceStatus
            )
        }
        .sheet(isPresented: $showingSnapshot) {
            if let snapshot = capturedSnapshot {
                SnapshotDetailView(snapshot: snapshot)
            }
        }
        .onAppear {
            loadDeviceStatus()
        }
    }
    
    private var deviceContent: some View {
        HStack(spacing: RingDesignSystem.Spacing.md) {
            // Device Icon with Status
            deviceIcon
            
            // Device Information
            VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.xs) {
                HStack {
                    Text(device.name)
                        .font(RingDesignSystem.Typography.headline)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .progressViewStyle(CircularProgressViewStyle(tint: device.deviceType.accentColor))
                    } else {
                        quickActionButton
                    }
                }
                
                // Device Details Row
                deviceDetailsRow
                
                // Status Indicators Row
                statusIndicatorsRow
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
        .overlay(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                .stroke(
                    LinearGradient(
                        colors: [
                            device.deviceType.accentColor.opacity(0.3),
                            device.deviceType.accentColor.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(
            color: RingDesignSystem.Colors.LiquidGlass.darkThin,
            radius: 8,
            x: 0,
            y: 2
        )
        .scaleEffect(showingActions ? 0.98 : 1.0)
        .animation(RingDesignSystem.Animations.quick, value: showingActions)
    }
    
    private var deviceIcon: some View {
        ZStack {
            // Background gradient
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                .fill(
                    LinearGradient(
                        colors: device.deviceType.gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .shadow(
                    color: device.deviceType.accentColor.opacity(0.3),
                    radius: 8,
                    x: 0,
                    y: 4
                )
            
            // Device icon
            Image(systemName: device.deviceType.iconName)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            
            // Status indicator
            statusDot
        }
        .pulse(active: device.status == .on && !isLoading)
    }
    
    private var statusDot: some View {
        Circle()
            .fill(device.status.color)
            .frame(width: 12, height: 12)
            .overlay(
                Circle()
                    .stroke(RingDesignSystem.Colors.Background.primary, lineWidth: 2)
            )
            .offset(x: 20, y: -20)
            .shadow(color: device.status.color.opacity(0.5), radius: 4, x: 0, y: 2)
    }
    
    private var deviceDetailsRow: some View {
        HStack(spacing: RingDesignSystem.Spacing.sm) {
            // Device Type
            Text(device.deviceType.rawValue)
                .font(RingDesignSystem.Typography.caption1)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
            
            // Separator
            if device.location != nil || device.batteryLevel != nil {
                Circle()
                    .fill(RingDesignSystem.Colors.Foreground.tertiary)
                    .frame(width: 2, height: 2)
            }
            
            // Location
            if let location = device.location {
                Text(location)
                    .font(RingDesignSystem.Typography.caption1)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Last seen
            if let lastSeen = device.lastSeen {
                Text(timeAgoString(from: lastSeen))
                    .font(RingDesignSystem.Typography.caption2)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
            }
        }
    }
    
    private var statusIndicatorsRow: some View {
        HStack(spacing: RingDesignSystem.Spacing.sm) {
            // Battery indicator
            if let batteryLevel = device.batteryLevel {
                batteryIndicator(level: batteryLevel)
            }
            
            // Signal strength
            if let status = deviceStatus {
                signalIndicator(strength: status.signalStrength)
            }
            
            // Motion detection status
            if let status = deviceStatus {
                motionDetectionIndicator(enabled: status.motionDetectionEnabled)
            }
            
            Spacer()
            
            // Temperature
            if let status = deviceStatus, device.deviceType == .camera || device.deviceType == .floodlight {
                temperatureIndicator(temperature: status.temperature)
            }
        }
    }
    
    private func batteryIndicator(level: Int) -> some View {
        HStack(spacing: RingDesignSystem.Spacing.xxs) {
            Image(systemName: batteryIconName(for: level))
                .font(RingDesignSystem.Typography.caption1)
                .foregroundColor(batteryColor(for: level))
            
            Text("\(level)%")
                .font(RingDesignSystem.Typography.caption2)
                .foregroundColor(batteryColor(for: level))
        }
        .padding(.horizontal, RingDesignSystem.Spacing.xs)
        .padding(.vertical, RingDesignSystem.Spacing.xxs)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xs)
                .fill(batteryColor(for: level).opacity(0.1))
        )
    }
    
    private func signalIndicator(strength: Int) -> some View {
        HStack(spacing: 1) {
            ForEach(1...4, id: \.self) { bar in
                RoundedRectangle(cornerRadius: 1)
                    .fill(
                        bar <= strength ?
                        RingDesignSystem.Colors.Foreground.primary :
                        RingDesignSystem.Colors.Foreground.quaternary
                    )
                    .frame(width: 3, height: CGFloat(bar * 2 + 4))
                    .animation(RingDesignSystem.Animations.quick.delay(Double(bar) * 0.1), value: strength)
            }
        }
        .padding(.horizontal, RingDesignSystem.Spacing.xs)
        .padding(.vertical, RingDesignSystem.Spacing.xxs)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xs)
                .fill(RingDesignSystem.Colors.Fill.tertiary)
        )
    }
    
    private func motionDetectionIndicator(enabled: Bool) -> some View {
        Image(systemName: enabled ? "sensor.tag.radiowaves.forward.fill" : "sensor.tag.radiowaves.forward")
            .font(RingDesignSystem.Typography.caption1)
            .foregroundColor(enabled ? RingDesignSystem.Colors.ringGreen : RingDesignSystem.Colors.Foreground.tertiary)
            .padding(RingDesignSystem.Spacing.xs)
            .background(
                Circle()
                    .fill(enabled ? RingDesignSystem.Colors.ringGreen.opacity(0.1) : RingDesignSystem.Colors.Fill.tertiary)
            )
    }
    
    private func temperatureIndicator(temperature: Int) -> some View {
        HStack(spacing: RingDesignSystem.Spacing.xxs) {
            Image(systemName: "thermometer")
                .font(RingDesignSystem.Typography.caption2)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
            
            Text("\(temperature)°C")
                .font(RingDesignSystem.Typography.caption2)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
        }
    }
    
    private var quickActionButton: some View {
        Button {
            performQuickAction()
        } label: {
            Image(systemName: quickActionIcon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(device.deviceType.accentColor)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(device.deviceType.accentColor.opacity(0.1))
                )
                .overlay(
                    Circle()
                        .stroke(device.deviceType.accentColor.opacity(0.3), lineWidth: 1)
                )
        }
        .onTapWithFeedback(haptic: .medium) {
            // Action handled in closure
        }
        .scaleEffect(isLoading ? 0.8 : 1.0)
        .animation(RingDesignSystem.Animations.bouncy, value: isLoading)
    }
    
    private var quickActionIcon: String {
        switch device.deviceType {
        case .camera, .doorbell: return "camera.circle.fill"
        case .motionSensor: return "sensor.tag.radiowaves.forward.fill"
        case .floodlight: return "lightbulb.circle.fill"
        case .chime: return "speaker.wave.3.circle.fill"
        }
    }
    
    // MARK: - Helper Functions
    
    private func batteryIconName(for level: Int) -> String {
        switch level {
        case 0...25: return "battery.25"
        case 26...50: return "battery.50"
        case 51...75: return "battery.75"
        default: return "battery.100"
        }
    }
    
    private func batteryColor(for level: Int) -> Color {
        switch level {
        case 0...20: return RingDesignSystem.Colors.Alert.critical
        case 21...40: return RingDesignSystem.Colors.Alert.warning
        default: return RingDesignSystem.Colors.Alert.success
        }
    }
    
    private func timeAgoString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    private func loadDeviceStatus() {
        smartHomeManager.getDeviceStatus(for: device.id) { status in
            DispatchQueue.main.async {
                self.deviceStatus = status
            }
        }
    }
    
    private func performQuickAction() {
        isLoading = true
        RingDesignSystem.Haptics.medium()
        
        switch device.deviceType {
        case .camera, .doorbell:
            smartHomeManager.captureSnapshot(for: device.id) { result in
                DispatchQueue.main.async {
                    isLoading = false
                    if case .success(let snapshot) = result {
                        capturedSnapshot = snapshot
                        showingSnapshot = true
                        RingDesignSystem.Haptics.success()
                    } else {
                        RingDesignSystem.Haptics.error()
                    }
                }
            }
        case .motionSensor:
            smartHomeManager.toggleMotionDetection(for: device.id) { _ in
                DispatchQueue.main.async {
                    isLoading = false
                    loadDeviceStatus() // Refresh status
                    RingDesignSystem.Haptics.success()
                }
            }
        case .floodlight:
            // Toggle floodlight
            smartHomeManager.toggleDevice(device.id) { _ in
                DispatchQueue.main.async {
                    isLoading = false
                    RingDesignSystem.Haptics.success()
                }
            }
        case .chime:
            // Test chime
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                isLoading = false
                RingDesignSystem.Haptics.success()
            }
        }
    }
}

// MARK: - Device Actions Sheet

struct DeviceActionsSheet: View {
    let device: SmartDevice
    let smartHomeManager: SmartHomeManager
    let deviceStatus: RingDeviceStatus?
    @Environment(\.dismiss) var dismiss
    @State private var isPerformingAction = false
    @State private var selectedAction: DeviceAction?
    
    enum DeviceAction: String, CaseIterable {
        case liveStream = "View Live Stream"
        case snapshot = "Capture Snapshot"
        case motionToggle = "Toggle Motion Detection"
        case siren = "Activate Siren"
        case privacy = "Toggle Privacy Mode"
        case lights = "Toggle Lights"
        case testChime = "Test Chime"
        case reboot = "Reboot Device"
        case settings = "Device Settings"
        
        var icon: String {
            switch self {
            case .liveStream: return "video.circle.fill"
            case .snapshot: return "camera.circle.fill"
            case .motionToggle: return "sensor.tag.radiowaves.forward.circle.fill"
            case .siren: return "speaker.wave.3.circle.fill"
            case .privacy: return "eye.slash.circle.fill"
            case .lights: return "lightbulb.circle.fill"
            case .testChime: return "bell.circle.fill"
            case .reboot: return "arrow.clockwise.circle.fill"
            case .settings: return "gear.circle.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .liveStream: return RingDesignSystem.Colors.ringBlue
            case .snapshot: return RingDesignSystem.Colors.ringGreen
            case .motionToggle: return RingDesignSystem.Colors.ringOrange
            case .siren: return RingDesignSystem.Colors.ringRed
            case .privacy: return RingDesignSystem.Colors.ringPurple
            case .lights: return RingDesignSystem.Colors.ringYellow
            case .testChime: return RingDesignSystem.Colors.ringBlue
            case .reboot: return RingDesignSystem.Colors.DeviceStatus.unknown
            case .settings: return RingDesignSystem.Colors.Foreground.secondary
            }
        }
        
        var isDestructive: Bool {
            switch self {
            case .siren, .reboot: return true
            default: return false
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: RingDesignSystem.Spacing.lg) {
                    // Device Header
                    deviceHeader
                    
                    // Device Status Card
                    deviceStatusCard
                    
                    // Actions Grid
                    actionsGrid
                    
                    // Recent Activity (if available)
                    recentActivityCard
                }
                .padding(RingDesignSystem.Spacing.md)
            }
            .background(RingDesignSystem.Colors.Background.primary.ignoresSafeArea())
            .navigationTitle(device.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(RingDesignSystem.Colors.ringBlue)
                }
            }
        }
    }
    
    private var deviceHeader: some View {
        HStack(spacing: RingDesignSystem.Spacing.md) {
            // Device Icon
            ZStack {
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                    .fill(
                        LinearGradient(
                            colors: device.deviceType.gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: device.deviceType.iconName)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
            }
            .shadow(color: device.deviceType.accentColor.opacity(0.3), radius: 12, x: 0, y: 6)
            
            VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.xs) {
                Text(device.name)
                    .font(RingDesignSystem.Typography.title2)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Text(device.deviceType.rawValue)
                    .font(RingDesignSystem.Typography.subheadline)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                
                if let location = device.location {
                    Text(location)
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
                }
                
                // Status Badge
                HStack(spacing: RingDesignSystem.Spacing.xs) {
                    Circle()
                        .fill(device.status.color)
                        .frame(width: 8, height: 8)
                    
                    Text(device.status.description)
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(device.status.color)
                }
            }
            
            Spacer()
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private var deviceStatusCard: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Device Status")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            if let status = deviceStatus {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: RingDesignSystem.Spacing.sm) {
                    StatusMetric(
                        title: "Battery",
                        value: device.batteryLevel.map { "\($0)%" } ?? "N/A",
                        icon: "battery.100",
                        color: device.batteryLevel.map { batteryColor(for: $0) } ?? RingDesignSystem.Colors.Foreground.tertiary
                    )
                    
                    StatusMetric(
                        title: "Signal",
                        value: "\(status.signalStrength)/4",
                        icon: "wifi",
                        color: status.signalStrength >= 3 ? RingDesignSystem.Colors.Alert.success : RingDesignSystem.Colors.Alert.warning
                    )
                    
                    StatusMetric(
                        title: "Motion",
                        value: status.motionDetectionEnabled ? "On" : "Off",
                        icon: "sensor.tag.radiowaves.forward",
                        color: status.motionDetectionEnabled ? RingDesignSystem.Colors.Alert.success : RingDesignSystem.Colors.Foreground.tertiary
                    )
                    
                    StatusMetric(
                        title: "Temperature",
                        value: "\(status.temperature)°C",
                        icon: "thermometer",
                        color: RingDesignSystem.Colors.ringBlue
                    )
                }
            } else {
                Text("Loading status...")
                    .font(RingDesignSystem.Typography.body)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    .shimmer(active: true)
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private var actionsGrid: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Quick Actions")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: RingDesignSystem.Spacing.sm) {
                ForEach(availableActions, id: \.rawValue) { action in
                    ActionButton(action: action) {
                        performAction(action)
                    }
                }
            }
        }
    }
    
    private var recentActivityCard: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Recent Activity")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            VStack(spacing: RingDesignSystem.Spacing.xs) {
                ActivityRow(
                    title: "Last Motion",
                    subtitle: deviceStatus?.lastMotionTime.map(timeAgoString) ?? "No recent motion",
                    icon: "sensor.tag.radiowaves.forward.fill",
                    color: RingDesignSystem.Colors.ringOrange
                )
                
                if let lastSeen = device.lastSeen {
                    ActivityRow(
                        title: "Last Seen",
                        subtitle: timeAgoString(from: lastSeen),
                        icon: "clock.fill",
                        color: RingDesignSystem.Colors.ringBlue
                    )
                }
                
                ActivityRow(
                    title: "Firmware",
                    subtitle: deviceStatus?.firmwareVersion ?? "Unknown",
                    icon: "gear.circle.fill",
                    color: RingDesignSystem.Colors.Foreground.secondary
                )
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private var availableActions: [DeviceAction] {
        var actions: [DeviceAction] = []
        
        switch device.deviceType {
        case .camera, .doorbell:
            actions.append(contentsOf: [.liveStream, .snapshot, .motionToggle, .privacy])
            if device.deviceType == .doorbell {
                actions.append(.siren)
            }
        case .motionSensor:
            actions.append(contentsOf: [.motionToggle, .settings])
        case .floodlight:
            actions.append(contentsOf: [.lights, .motionToggle, .settings])
        case .chime:
            actions.append(contentsOf: [.testChime, .settings])
        }
        
        actions.append(contentsOf: [.reboot, .settings])
        return actions
    }
    
    private func batteryColor(for level: Int) -> Color {
        switch level {
        case 0...20: return RingDesignSystem.Colors.Alert.critical
        case 21...40: return RingDesignSystem.Colors.Alert.warning
        default: return RingDesignSystem.Colors.Alert.success
        }
    }
    
    private func timeAgoString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    private func performAction(_ action: DeviceAction) {
        selectedAction = action
        isPerformingAction = true
        RingDesignSystem.Haptics.medium()
        
        // Simulate action
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isPerformingAction = false
            selectedAction = nil
            RingDesignSystem.Haptics.success()
        }
    }
}

// MARK: - Supporting Components

struct StatusMetric: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xs) {
            HStack {
                Image(systemName: icon)
                    .font(RingDesignSystem.Typography.caption1)
                    .foregroundColor(color)
                
                Spacer()
                
                Text(value)
                    .font(RingDesignSystem.Typography.caption1)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            }
            
            HStack {
                Text(title)
                    .font(RingDesignSystem.Typography.caption2)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                
                Spacer()
            }
        }
        .padding(RingDesignSystem.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.sm)
                .fill(color.opacity(0.1))
        )
    }
}

struct ActionButton: View {
    let action: DeviceActionsSheet.DeviceAction
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                Image(systemName: action.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(action.color)
                
                Text(action.rawValue)
                    .font(RingDesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, minHeight: 80)
            .padding(RingDesignSystem.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                    .fill(action.color.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                            .stroke(action.color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .onTapWithFeedback(haptic: action.isDestructive ? .heavy : .medium) {
            // Action handled in closure
        }
    }
}

struct ActivityRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: RingDesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(RingDesignSystem.Typography.caption1)
                .foregroundColor(color)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(RingDesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Text(subtitle)
                    .font(RingDesignSystem.Typography.caption2)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, RingDesignSystem.Spacing.xs)
    }
}

// MARK: - Snapshot Detail View

struct SnapshotDetailView: View {
    let snapshot: RingSnapshot
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                RingDesignSystem.Colors.Background.primary.ignoresSafeArea()
                
                VStack(spacing: RingDesignSystem.Spacing.lg) {
                    // Placeholder for snapshot image
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                        .fill(
                            LinearGradient(
                                colors: [
                                    RingDesignSystem.Colors.ringBlue.opacity(0.3),
                                    RingDesignSystem.Colors.ringBlue.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 300)
                        .overlay(
                            VStack(spacing: RingDesignSystem.Spacing.md) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 48))
                                    .foregroundColor(RingDesignSystem.Colors.ringBlue)
                                
                                Text("Snapshot Preview")
                                    .font(RingDesignSystem.Typography.headline)
                                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                                
                                Text("Quality: \(snapshot.quality)")
                                    .font(RingDesignSystem.Typography.caption1)
                                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                            }
                        )
                    
                    // Snapshot details
                    VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.sm) {
                        Text("Snapshot Details")
                            .font(RingDesignSystem.Typography.headline)
                            .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                        
                        VStack(spacing: RingDesignSystem.Spacing.xs) {
                            DetailRow(label: "Captured", value: formatDate(snapshot.timestamp))
                            DetailRow(label: "Resolution", value: snapshot.quality)
                            DetailRow(label: "File Size", value: "2.4 MB")
                            if let location = snapshot.location {
                                DetailRow(label: "Location", value: location)
                            }
                        }
                    }
                    .padding(RingDesignSystem.Spacing.md)
                    .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
                    
                    Spacer()
                }
                .padding(RingDesignSystem.Spacing.md)
            }
            .navigationTitle("Snapshot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(RingDesignSystem.Colors.ringBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Save snapshot
                        RingDesignSystem.Haptics.success()
                    }
                    .foregroundColor(RingDesignSystem.Colors.ringBlue)
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(RingDesignSystem.Typography.caption1)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
            
            Spacer()
            
            Text(value)
                .font(RingDesignSystem.Typography.caption1)
                .fontWeight(.medium)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
        }
    }
}