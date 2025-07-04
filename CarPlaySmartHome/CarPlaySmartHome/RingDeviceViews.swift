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
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
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
                    
                    // Favorite Button
                    Button {
                        onFavoriteToggle()
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(isFavorite ? RingDesignSystem.Colors.ringRed : RingDesignSystem.Colors.Foreground.tertiary)
                    }
                    .frame(minWidth: RingDesignSystem.TouchTarget.minimumSize, minHeight: RingDesignSystem.TouchTarget.minimumSize)
                    
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
        .animation(RingDesignSystem.Animations.current, value: showingActions)
        .frame(minHeight: RingDesignSystem.TouchTarget.minimumSize)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(device.name), \(device.deviceType.rawValue)")
        .accessibilityValue("Status: \(device.status.description)")
        .accessibilityHint("Double tap to view device actions")
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
    
    // MARK: - Loading Skeleton
    
    private var loadingSkeleton: some View {
        HStack(spacing: RingDesignSystem.Spacing.md) {
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                .fill(RingDesignSystem.Colors.Fill.secondary)
                .frame(width: 60, height: 60)
                .shimmer(active: true)
            
            VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.xs) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(RingDesignSystem.Colors.Fill.secondary)
                    .frame(height: 16)
                    .shimmer(active: true)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(RingDesignSystem.Colors.Fill.tertiary)
                    .frame(height: 12)
                    .shimmer(active: true)
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .frame(minHeight: RingDesignSystem.TouchTarget.minimumSize)
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

// MARK: - Ring Device Home View

struct RingDeviceHomeView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var searchText = ""
    @State private var selectedDeviceType: DeviceType?
    @State private var showingAddDevice = false
    @State private var isLoading = false
    @State private var showingAdvancedFilters = false
    @State private var selectedGrouping: DeviceGrouping = .none
    @State private var showingFavoritesOnly = false
    @AppStorage("favoriteDevices") private var favoriteDevices: Set<String> = []
    
    enum DeviceGrouping: String, CaseIterable {
        case none = "None"
        case type = "By Type"
        case location = "By Location"
        case status = "By Status"
        
        var icon: String {
            switch self {
            case .none: return "list.bullet"
            case .type: return "folder"
            case .location: return "mappin.and.ellipse"
            case .status: return "circle.fill"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                RingDesignSystem.Colors.Background.primary.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search and Filter Section
                    searchAndFilterSection
                    
                    // Device List
                    if smartHomeManager.isLoading {
                        loadingView
                    } else if filteredDevices.isEmpty {
                        emptyStateView
                    } else {
                        deviceList
                    }
                }
            }
            .navigationTitle("Devices")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search devices...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Add Device") {
                            showingAddDevice = true
                        }
                        
                        Divider()
                        
                        Button("Advanced Filters") {
                            showingAdvancedFilters = true
                        }
                        
                        Button("Group by \(selectedGrouping.rawValue)") {
                            // Cycle through grouping options
                            let currentIndex = DeviceGrouping.allCases.firstIndex(of: selectedGrouping) ?? 0
                            let nextIndex = (currentIndex + 1) % DeviceGrouping.allCases.count
                            selectedGrouping = DeviceGrouping.allCases[nextIndex]
                            RingDesignSystem.Haptics.selection()
                        }
                        
                        Button(showingFavoritesOnly ? "Show All" : "Favorites Only") {
                            showingFavoritesOnly.toggle()
                            RingDesignSystem.Haptics.selection()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(RingDesignSystem.Colors.ringBlue)
                    }
                    .frame(minWidth: RingDesignSystem.TouchTarget.minimumSize, minHeight: RingDesignSystem.TouchTarget.minimumSize)
                }
            }
            .refreshable {
                await refreshDevices()
            }
            .sheet(isPresented: $showingAdvancedFilters) {
                AdvancedFiltersSheet(
                    selectedDeviceType: $selectedDeviceType,
                    selectedGrouping: $selectedGrouping,
                    showingFavoritesOnly: $showingFavoritesOnly
                )
            }
        }
    }
    
    private var searchAndFilterSection: some View {
        VStack(spacing: RingDesignSystem.Spacing.sm) {
            // Quick Actions Row
            quickActionsRow
            
            // Active Filters Row
            if hasActiveFilters {
                activeFiltersRow
            }
            
            // Device Type Filter
            if !searchText.isEmpty || selectedDeviceType != nil {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: RingDesignSystem.Spacing.sm) {
                        FilterChip(
                            title: "All Types",
                            isSelected: selectedDeviceType == nil
                        ) {
                            selectedDeviceType = nil
                            RingDesignSystem.Haptics.light()
                        }
                        
                        ForEach(DeviceType.allCases, id: \.self) { type in
                            FilterChip(
                                title: type.rawValue.capitalized,
                                isSelected: selectedDeviceType == type
                            ) {
                                selectedDeviceType = type
                                RingDesignSystem.Haptics.light()
                            }
                        }
                    }
                    .padding(.horizontal, RingDesignSystem.Spacing.md)
                }
            }
            
            // Device Stats
            deviceStatsRow
        }
        .padding(.vertical, RingDesignSystem.Spacing.sm)
        .background(
            RingDesignSystem.Colors.Background.secondary
                .ignoresSafeArea(edges: .horizontal)
        )
    }
    
    private var quickActionsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: RingDesignSystem.Spacing.md) {
                QuickActionButton(
                    title: "All Cameras",
                    icon: "video.fill",
                    color: RingDesignSystem.Colors.ringBlue
                ) {
                    selectedDeviceType = .camera
                    RingDesignSystem.Haptics.navigation()
                }
                
                QuickActionButton(
                    title: "Live View",
                    icon: "eye.fill",
                    color: RingDesignSystem.Colors.ringGreen
                ) {
                    // Open live view
                    RingDesignSystem.Haptics.navigation()
                }
                
                QuickActionButton(
                    title: "Favorites",
                    icon: "heart.fill",
                    color: RingDesignSystem.Colors.ringRed
                ) {
                    showingFavoritesOnly.toggle()
                    RingDesignSystem.Haptics.selection()
                }
                
                QuickActionButton(
                    title: "Group",
                    icon: selectedGrouping.icon,
                    color: RingDesignSystem.Colors.ringPurple
                ) {
                    // Cycle through grouping
                    let currentIndex = DeviceGrouping.allCases.firstIndex(of: selectedGrouping) ?? 0
                    let nextIndex = (currentIndex + 1) % DeviceGrouping.allCases.count
                    selectedGrouping = DeviceGrouping.allCases[nextIndex]
                    RingDesignSystem.Haptics.selection()
                }
            }
            .padding(.horizontal, RingDesignSystem.Spacing.md)
        }
    }
    
    private var activeFiltersRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: RingDesignSystem.Spacing.sm) {
                if selectedDeviceType != nil {
                    ActiveFilterChip(
                        title: selectedDeviceType!.rawValue,
                        onRemove: {
                            selectedDeviceType = nil
                            RingDesignSystem.Haptics.light()
                        }
                    )
                }
                
                if selectedGrouping != .none {
                    ActiveFilterChip(
                        title: "Grouped by \(selectedGrouping.rawValue)",
                        onRemove: {
                            selectedGrouping = .none
                            RingDesignSystem.Haptics.light()
                        }
                    )
                }
                
                if showingFavoritesOnly {
                    ActiveFilterChip(
                        title: "Favorites Only",
                        onRemove: {
                            showingFavoritesOnly = false
                            RingDesignSystem.Haptics.light()
                        }
                    )
                }
                
                if hasActiveFilters {
                    Button("Clear All") {
                        selectedDeviceType = nil
                        selectedGrouping = .none
                        showingFavoritesOnly = false
                        RingDesignSystem.Haptics.medium()
                    }
                    .font(RingDesignSystem.Typography.caption1)
                    .foregroundColor(RingDesignSystem.Colors.ringBlue)
                    .frame(minHeight: RingDesignSystem.TouchTarget.minimumSize)
                }
            }
            .padding(.horizontal, RingDesignSystem.Spacing.md)
        }
    }
    
    private var deviceList: some View {
        ScrollView {
            LazyVStack(spacing: RingDesignSystem.Spacing.sm) {
                if selectedGrouping == .none {
                    // Simple list
                    ForEach(filteredDevices, id: \.id) { device in
                        EnhancedRingDeviceRow(
                            device: device,
                            smartHomeManager: smartHomeManager,
                            isFavorite: favoriteDevices.contains(device.id.uuidString),
                            onFavoriteToggle: {
                                toggleFavorite(for: device)
                            }
                        )
                        .id(device.id)
                    }
                } else {
                    // Grouped list
                    ForEach(groupedDevices.keys.sorted(), id: \.self) { groupKey in
                        if let devices = groupedDevices[groupKey] {
                            DeviceGroupSection(
                                title: groupKey,
                                devices: devices,
                                smartHomeManager: smartHomeManager,
                                favoriteDevices: favoriteDevices,
                                onFavoriteToggle: { device in
                                    toggleFavorite(for: device)
                                }
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, RingDesignSystem.Spacing.md)
            .padding(.bottom, RingDesignSystem.Spacing.xxxl)
        }
    }
    
    private var hasActiveFilters: Bool {
        selectedDeviceType != nil || selectedGrouping != .none || showingFavoritesOnly
    }
    
    private var filteredDevices: [SmartDevice] {
        var devices = smartHomeManager.getDevices()
        
        if showingFavoritesOnly {
            devices = devices.filter { favoriteDevices.contains($0.id.uuidString) }
        }
        
        if let selectedType = selectedDeviceType {
            devices = devices.filter { $0.deviceType == selectedType }
        }
        
        if !searchText.isEmpty {
            devices = devices.filter { device in
                device.name.localizedCaseInsensitiveContains(searchText) ||
                device.deviceType.rawValue.localizedCaseInsensitiveContains(searchText) ||
                (device.location?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        return devices.sorted { $0.name < $1.name }
    }
    
    private var groupedDevices: [String: [SmartDevice]] {
        let devices = filteredDevices
        
        switch selectedGrouping {
        case .none:
            return [:]
        case .type:
            return Dictionary(grouping: devices) { $0.deviceType.rawValue }
        case .location:
            return Dictionary(grouping: devices) { $0.location ?? "Unknown Location" }
        case .status:
            return Dictionary(grouping: devices) { $0.status.description }
        }
    }
    
    private func toggleFavorite(for device: SmartDevice) {
        let deviceId = device.id.uuidString
        if favoriteDevices.contains(deviceId) {
            favoriteDevices.remove(deviceId)
            RingDesignSystem.Haptics.light()
        } else {
            favoriteDevices.insert(deviceId)
            RingDesignSystem.Haptics.success()
        }
    }
    
    private func refreshDevices() async {
        isLoading = true
        smartHomeManager.refreshDevices()
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isLoading = false
    }
    
    private var deviceStatsRow: some View {
        HStack(spacing: RingDesignSystem.Spacing.lg) {
            DeviceStat(
                title: "Total",
                count: smartHomeManager.getDevices().count,
                color: RingDesignSystem.Colors.ringBlue
            )
            
            DeviceStat(
                title: "Online",
                count: smartHomeManager.getOnlineDevices().count,
                color: RingDesignSystem.Colors.ringGreen
            )
            
            DeviceStat(
                title: "Offline",
                count: smartHomeManager.getOfflineDevices().count,
                color: RingDesignSystem.Colors.ringRed
            )
            
            Spacer()
        }
        .padding(.horizontal, RingDesignSystem.Spacing.md)
    }
    
    private var loadingView: some View {
        VStack(spacing: RingDesignSystem.Spacing.lg) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: RingDesignSystem.Colors.ringBlue))
                .scaleEffect(1.2)
            
            Text("Loading devices...")
                .font(RingDesignSystem.Typography.subheadline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: RingDesignSystem.Spacing.lg) {
            Image(systemName: "video.slash")
                .font(.system(size: 64))
                .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
            
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                Text("No Devices Found")
                    .font(RingDesignSystem.Typography.title2)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Text(searchText.isEmpty ? 
                     "Add your first Ring device to get started" :
                     "No devices match your search")
                    .font(RingDesignSystem.Typography.body)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Add Device") {
                showingAddDevice = true
            }
            .frame(minWidth: RingDesignSystem.TouchTarget.minimumSize, minHeight: RingDesignSystem.TouchTarget.minimumSize)
            .padding(.horizontal, RingDesignSystem.Spacing.md)
            .padding(.vertical, RingDesignSystem.Spacing.sm)
            .background(RingDesignSystem.Colors.ringBlue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(RingDesignSystem.Spacing.xl)
    }
}

// MARK: - Supporting Components

struct DeviceStat: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xxs) {
            Text("\(count)")
                .font(RingDesignSystem.Typography.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(RingDesignSystem.Typography.caption2)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(RingDesignSystem.Typography.caption1)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : RingDesignSystem.Colors.Foreground.primary)
                .padding(.horizontal, RingDesignSystem.Spacing.md)
                .padding(.vertical, RingDesignSystem.Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                        .fill(isSelected ? RingDesignSystem.Colors.ringBlue : RingDesignSystem.Colors.Fill.secondary)
                )
        }
        .frame(minWidth: RingDesignSystem.TouchTarget.minimumSize, minHeight: RingDesignSystem.TouchTarget.minimumSize)
        .accessibilityLabel(title)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
                
                Text(title)
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
                    .fill(color.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .onTapWithFeedback(haptic: .medium) {
            // Action handled in closure
        }
    }
}

struct ActiveFilterChip: View {
    let title: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: RingDesignSystem.Spacing.sm) {
            Text(title)
                .font(RingDesignSystem.Typography.caption1)
                .fontWeight(.medium)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            Button(action: onRemove) {
                Text("Remove")
                    .font(RingDesignSystem.Typography.caption1)
                    .foregroundColor(RingDesignSystem.Colors.ringBlue)
            }
        }
        .padding(RingDesignSystem.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                .fill(RingDesignSystem.Colors.Fill.secondary)
        )
    }
}

struct DeviceGroupSection: View {
    let title: String
    let devices: [SmartDevice]
    let smartHomeManager: SmartHomeManager
    let favoriteDevices: Set<String>
    let onFavoriteToggle: (SmartDevice) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text(title)
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            ScrollView {
                LazyVStack(spacing: RingDesignSystem.Spacing.sm) {
                    ForEach(devices, id: \.id) { device in
                        EnhancedRingDeviceRow(
                            device: device,
                            smartHomeManager: smartHomeManager,
                            isFavorite: favoriteDevices.contains(device.id.uuidString),
                            onFavoriteToggle: {
                                onFavoriteToggle(device)
                            }
                        )
                        .id(device.id)
                    }
                }
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
}

struct AdvancedFiltersSheet: View {
    @Binding var selectedDeviceType: DeviceType?
    @Binding var selectedGrouping: DeviceGrouping
    @Binding var showingFavoritesOnly: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: RingDesignSystem.Spacing.lg) {
                    // Device Type Filter
                    deviceTypeFilter
                    
                    // Grouping Filter
                    groupingFilter
                    
                    // Favorites Filter
                    favoritesFilter
                }
                .padding(RingDesignSystem.Spacing.md)
            }
            .background(RingDesignSystem.Colors.Background.primary.ignoresSafeArea())
            .navigationTitle("Advanced Filters")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Handle done action
                    }
                    .foregroundColor(RingDesignSystem.Colors.ringBlue)
                }
            }
        }
    }
    
    private var deviceTypeFilter: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Device Type")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: RingDesignSystem.Spacing.sm) {
                    ForEach(DeviceType.allCases, id: \.self) { type in
                        FilterChip(
                            title: type.rawValue.capitalized,
                            isSelected: selectedDeviceType == type
                        ) {
                            selectedDeviceType = type
                            RingDesignSystem.Haptics.light()
                        }
                    }
                }
                .padding(.horizontal, RingDesignSystem.Spacing.md)
            }
        }
    }
    
    private var groupingFilter: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Grouping")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: RingDesignSystem.Spacing.sm) {
                    ForEach(DeviceGrouping.allCases, id: \.rawValue) { grouping in
                        FilterChip(
                            title: grouping.rawValue,
                            isSelected: selectedGrouping == grouping
                        ) {
                            selectedGrouping = grouping
                            RingDesignSystem.Haptics.light()
                        }
                    }
                }
                .padding(.horizontal, RingDesignSystem.Spacing.md)
            }
        }
    }
    
    private var favoritesFilter: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Favorites")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            Toggle("Show only favorites", isOn: $showingFavoritesOnly)
        }
    }
}

// MARK: - Enhanced RingDevice Model
struct RingDevice: Identifiable, Codable {
    let id = UUID()
    var name: String
    var type: DeviceType
    var location: String
    var status: DeviceStatus
    var isOn: Bool
    var energyUsage: Double
    var lastUpdated: Date
    var icon: String
    var brightness: Double
    var temperature: Double?
    var batteryLevel: Double?
    var isFavorite: Bool
    var isShared: Bool
    var sharedWith: [String]
    var automationRules: [String]
    var maintenanceDue: Date?
    var lastMaintenance: Date?
    var firmwareVersion: String
    var signalStrength: Double
    var isOnline: Bool {
        return status == .online
    }
    
    enum DeviceType: String, CaseIterable, Codable {
        case light = "Light"
        case camera = "Camera"
        case sensor = "Sensor"
        case thermostat = "Thermostat"
        case lock = "Lock"
        case doorbell = "Doorbell"
        case speaker = "Speaker"
        case switch = "Switch"
        case outlet = "Outlet"
        case fan = "Fan"
        case blind = "Blind"
        case garage = "Garage"
        
        var icon: String {
            switch self {
            case .light: return "lightbulb.fill"
            case .camera: return "video.fill"
            case .sensor: return "sensor.tag.radiowaves.forward.fill"
            case .thermostat: return "thermometer"
            case .lock: return "lock.fill"
            case .doorbell: return "bell.fill"
            case .speaker: return "speaker.wave.2.fill"
            case .switch: return "switch.2"
            case .outlet: return "poweroutlet.type.b.fill"
            case .fan: return "fan.fill"
            case .blind: return "blind.horizontal.closed"
            case .garage: return "garage.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .light: return .orange
            case .camera: return .blue
            case .sensor: return .green
            case .thermostat: return .red
            case .lock: return .purple
            case .doorbell: return .pink
            case .speaker: return .indigo
            case .switch: return .gray
            case .outlet: return .brown
            case .fan: return .cyan
            case .blind: return .mint
            case .garage: return .teal
            }
        }
    }
    
    enum DeviceStatus: String, CaseIterable, Codable {
        case online = "Online"
        case offline = "Offline"
        case connecting = "Connecting"
        case updating = "Updating"
        case error = "Error"
        
        var color: Color {
            switch self {
            case .online: return .successGreen
            case .offline: return .errorRed
            case .connecting: return .warningOrange
            case .updating: return .infoBlue
            case .error: return .errorRed
            }
        }
        
        var icon: String {
            switch self {
            case .online: return "checkmark.circle.fill"
            case .offline: return "xmark.circle.fill"
            case .connecting: return "arrow.clockwise.circle.fill"
            case .updating: return "arrow.triangle.2.circlepath.circle.fill"
            case .error: return "exclamationmark.triangle.fill"
            }
        }
    }
    
    init(name: String, type: DeviceType, location: String, status: DeviceStatus = .online, isOn: Bool = false) {
        self.name = name
        self.type = type
        self.location = location
        self.status = status
        self.isOn = isOn
        self.energyUsage = Double.random(in: 0.1...5.0)
        self.lastUpdated = Date()
        self.icon = type.icon
        self.brightness = 1.0
        self.temperature = type == .thermostat ? Double.random(in: 18...25) : nil
        self.batteryLevel = type == .sensor || type == .camera ? Double.random(in: 0.2...1.0) : nil
        self.isFavorite = false
        self.isShared = false
        self.sharedWith = []
        self.automationRules = []
        self.maintenanceDue = nil
        self.lastMaintenance = nil
        self.firmwareVersion = "1.2.3"
        self.signalStrength = Double.random(in: 0.5...1.0)
    }
    
    static let sampleDevices = [
        RingDevice(name: "Living Room Light", type: .light, location: "Living Room"),
        RingDevice(name: "Kitchen Light", type: .light, location: "Kitchen"),
        RingDevice(name: "Front Door Camera", type: .camera, location: "Front Door"),
        RingDevice(name: "Motion Sensor", type: .sensor, location: "Hallway"),
        RingDevice(name: "Smart Thermostat", type: .thermostat, location: "Living Room"),
        RingDevice(name: "Front Door Lock", type: .lock, location: "Front Door"),
        RingDevice(name: "Doorbell", type: .doorbell, location: "Front Door"),
        RingDevice(name: "Kitchen Speaker", type: .speaker, location: "Kitchen"),
        RingDevice(name: "Bedroom Light", type: .light, location: "Bedroom"),
        RingDevice(name: "Bathroom Light", type: .light, location: "Bathroom"),
        RingDevice(name: "Garage Door", type: .garage, location: "Garage"),
        RingDevice(name: "Smart Outlet", type: .outlet, location: "Living Room")
    ]
}

// MARK: - Enhanced Device Views
struct EnhancedDeviceCard: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var isPressed = false
    @State private var showDetails = false
    
    var body: some View {
        GlassmorphismCard {
            VStack(spacing: 16) {
                // Device header
                HStack {
                    // Device icon with status
                    ZStack {
                        Circle()
                            .fill(device.type.color.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: device.icon)
                            .font(.title2)
                            .foregroundColor(device.type.color)
                        
                        // Status indicator
                        Circle()
                            .fill(device.status.color)
                            .frame(width: 12, height: 12)
                            .offset(x: 20, y: -20)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(device.name)
                            .font(.ringBody)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(device.location)
                            .font(.ringSmall)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 4) {
                            Image(systemName: device.status.icon)
                                .font(.caption)
                                .foregroundColor(device.status.color)
                            
                            Text(device.status.rawValue)
                                .font(.ringSmall)
                                .foregroundColor(device.status.color)
                        }
                    }
                    
                    Spacer()
                    
                    // Favorite button
                    Button(action: {
                        HapticFeedback.impact(style: .light)
                        smartHomeManager.toggleFavorite(device)
                    }) {
                        Image(systemName: device.isFavorite ? "heart.fill" : "heart")
                            .font(.title3)
                            .foregroundColor(device.isFavorite ? .red : .secondary)
                    }
                }
                
                // Device controls
                HStack(spacing: 16) {
                    // Power toggle
                    VStack(spacing: 4) {
                        Text("Power")
                            .font(.ringSmall)
                            .foregroundColor(.secondary)
                        
                        Toggle("", isOn: Binding(
                            get: { device.isOn },
                            set: { newValue in
                                HapticFeedback.impact(style: .medium)
                                smartHomeManager.toggleDevice(device)
                            }
                        ))
                        .toggleStyle(CustomToggleStyle())
                    }
                    
                    // Brightness slider (for lights)
                    if device.type == .light {
                        VStack(spacing: 4) {
                            Text("Brightness")
                                .font(.ringSmall)
                                .foregroundColor(.secondary)
                            
                            Slider(value: Binding(
                                get: { device.brightness },
                                set: { newValue in
                                    // In a real app, this would update the device
                                    HapticFeedback.impact(style: .light)
                                }
                            ), in: 0...1)
                            .accentColor(device.type.color)
                        }
                    }
                    
                    // Temperature control (for thermostats)
                    if device.type == .thermostat, let temperature = device.temperature {
                        VStack(spacing: 4) {
                            Text("Temperature")
                                .font(.ringSmall)
                                .foregroundColor(.secondary)
                            
                            Text("\(Int(temperature))°C")
                                .font(.ringBody)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                // Device metrics
                HStack(spacing: 20) {
                    MetricView(
                        title: "Energy",
                        value: "\(device.energyUsage, specifier: "%.1f") kWh",
                        icon: "bolt.fill",
                        color: .warningOrange
                    )
                    
                    if let batteryLevel = device.batteryLevel {
                        MetricView(
                            title: "Battery",
                            value: "\(Int(batteryLevel * 100))%",
                            icon: "battery.100",
                            color: batteryLevel > 0.2 ? .successGreen : .errorRed
                        )
                    }
                    
                    MetricView(
                        title: "Signal",
                        value: "\(Int(device.signalStrength * 100))%",
                        icon: "wifi",
                        color: device.signalStrength > 0.7 ? .successGreen : .warningOrange
                    )
                }
                
                // Action buttons
                HStack(spacing: 12) {
                    Button(action: {
                        HapticFeedback.impact(style: .light)
                        showDetails = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "info.circle")
                                .font(.caption)
                            Text("Details")
                                .font(.ringSmall)
                        }
                        .foregroundColor(.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.ultraThinMaterial)
                        )
                    }
                    
                    if device.isShared {
                        Button(action: {
                            HapticFeedback.impact(style: .light)
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "person.2")
                                    .font(.caption)
                                Text("Shared")
                                    .font(.ringSmall)
                            }
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.blue.opacity(0.1))
                            )
                        }
                    }
                    
                    Spacer()
                    
                    // Maintenance indicator
                    if let maintenanceDue = device.maintenanceDue, maintenanceDue < Date() {
                        HStack(spacing: 4) {
                            Image(systemName: "wrench.and.screwdriver")
                                .font(.caption)
                            Text("Maintenance")
                                .font(.ringSmall)
                        }
                        .foregroundColor(.errorRed)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.errorRed.opacity(0.1))
                        )
                    }
                }
            }
            .padding()
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .sheet(isPresented: $showDetails) {
            DeviceDetailView(device: device, smartHomeManager: smartHomeManager)
        }
    }
}

// MARK: - Metric View
struct MetricView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.ringSmall)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.ringSmall)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Device Grid View
struct EnhancedDeviceGridView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedCategory: DeviceCategory = .all
    @State private var searchText = ""
    @State private var showFilters = false
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private var filteredDevices: [RingDevice] {
        var devices = smartHomeManager.devices
        
        // Filter by category
        if selectedCategory != .all {
            devices = smartHomeManager.getDevicesByCategory(selectedCategory)
        }
        
        // Filter by search
        if !searchText.isEmpty {
            devices = smartHomeManager.searchDevices(query: searchText)
        }
        
        return devices
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Search and filter bar
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search devices...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.ultraThinMaterial)
                )
                
                Button(action: {
                    HapticFeedback.impact(style: .light)
                    showFilters = true
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal)
            
            // Category filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(DeviceCategory.allCases, id: \.self) { category in
                        CategoryFilterButton(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            HapticFeedback.impact(style: .light)
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Device grid
            if filteredDevices.isEmpty {
                EmptyStateView(
                    title: "No devices found",
                    subtitle: "Try adjusting your search or filters",
                    icon: "magnifyingglass"
                )
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredDevices) { device in
                        EnhancedDeviceCard(
                            device: device,
                            smartHomeManager: smartHomeManager
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showFilters) {
            SearchFiltersView(
                selectedCategory: $selectedCategory,
                selectedStatus: .constant(.all)
            )
        }
    }
}

// MARK: - Category Filter Button
struct CategoryFilterButton: View {
    let category: DeviceCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category.rawValue)
                .font(.ringSmall)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? .blue : .ultraThinMaterial)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.ringHeadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.ringBody)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Device Category
enum DeviceCategory: String, CaseIterable {
    case all = "All"
    case lights = "Lights"
    case cameras = "Cameras"
    case sensors = "Sensors"
    case thermostats = "Thermostats"
    case locks = "Locks"
}

// MARK: - Device Status
enum DeviceStatus: String, CaseIterable {
    case all = "All"
    case online = "Online"
    case offline = "Offline"
    case active = "Active"
    case inactive = "Inactive"
}