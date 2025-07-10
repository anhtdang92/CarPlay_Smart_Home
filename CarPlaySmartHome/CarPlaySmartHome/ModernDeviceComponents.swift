import SwiftUI

// MARK: - Modern Device Components for CarPlay

// MARK: - Modern Device Card

struct ModernDeviceCard: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    
    @State private var isPressed = false
    @State private var isGlowing = false
    @State private var showActions = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: {
            withAnimation(AppleDesignSystem.Animations.snappy) {
                showActions.toggle()
            }
            HapticFeedback.selection()
        }) {
            VStack(spacing: AppleDesignSystem.Spacing.md) {
                // Device Icon with Status Ring
                deviceIconWithStatus
                
                // Device Information
                deviceInfo
                
                // Quick Actions (expandable)
                if showActions {
                    quickActions
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                }
            }
            .padding(AppleDesignSystem.Spacing.lg)
            .frame(maxWidth: .infinity)
            .liquidGlassCard(
                elevation: isPressed ? .low : .medium,
                cornerRadius: 24,
                tint: statusColor.opacity(0.1)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(AppleDesignSystem.Animations.snappy, value: isPressed)
            .animation(AppleDesignSystem.Animations.smooth, value: showActions)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            withAnimation(AppleDesignSystem.Animations.quick) {
                isPressed = pressing
            }
        } perform: {
            HapticFeedback.longPress()
        }
        .onAppear {
            startGlowAnimation()
        }
    }
    
    // MARK: - Device Icon with Status Ring
    
    private var deviceIconWithStatus: some View {
        ZStack {
            // Status ring
            Circle()
                .stroke(statusColor.opacity(0.3), lineWidth: 3)
                .frame(width: 80, height: 80)
                .scaleEffect(isGlowing ? 1.1 : 1.0)
                .opacity(isGlowing ? 0.8 : 0.5)
            
            // Animated status ring
            Circle()
                .trim(from: 0, to: statusProgress)
                .stroke(
                    AngularGradient(
                        colors: [statusColor, statusColor.opacity(0.3)],
                        center: .center
                    ),
                    style: StrokeStyle(lineCap: .round, lineWidth: 4)
                )
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(-90))
                .animation(AppleDesignSystem.Animations.smooth, value: statusProgress)
            
            // Device icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                statusColor.opacity(0.8),
                                statusColor.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                
                Image(systemName: device.category.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            }
            
            // Status indicator dot
            if device.status != .unknown {
                Circle()
                    .fill(statusColor)
                    .frame(width: 16, height: 16)
                    .offset(x: 24, y: -24)
                    .shadow(color: statusColor.opacity(0.5), radius: 4, x: 0, y: 0)
                    .scaleEffect(isGlowing ? 1.2 : 1.0)
            }
        }
    }
    
    // MARK: - Device Information
    
    private var deviceInfo: some View {
        VStack(spacing: 4) {
            Text(device.name)
                .font(AppleDesignSystem.Typography.carPlayMedium)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Text(device.category.displayName)
                .font(AppleDesignSystem.Typography.carPlaySmall)
                .foregroundColor(.secondary)
            
            // Battery indicator (if applicable)
            if let batteryLevel = device.batteryLevel {
                batteryIndicator(level: batteryLevel)
                    .padding(.top, 4)
            }
            
            // Connection status
            HStack(spacing: 4) {
                Circle()
                    .fill(statusColor)
                    .frame(width: 6, height: 6)
                    .scaleEffect(isGlowing ? 1.3 : 1.0)
                
                Text(device.status.rawValue.capitalized)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // MARK: - Quick Actions
    
    private var quickActions: some View {
        VStack(spacing: AppleDesignSystem.Spacing.sm) {
            // Primary toggle
            FuturisticToggle(
                "Device Power",
                isOn: Binding(
                    get: { device.isOn },
                    set: { newValue in
                        toggleDevice(newValue)
                    }
                ),
                description: device.isOn ? "Tap to turn off" : "Tap to turn on",
                accentColor: statusColor
            )
            
            // Secondary actions
            HStack(spacing: AppleDesignSystem.Spacing.sm) {
                actionButton(
                    icon: "camera.fill",
                    label: "Snapshot",
                    action: captureSnapshot
                )
                
                if device.category == .camera || device.category == .doorbell {
                    actionButton(
                        icon: "eye.slash.fill",
                        label: "Privacy",
                        action: togglePrivacy
                    )
                }
                
                actionButton(
                    icon: "gear",
                    label: "Settings",
                    action: openSettings
                )
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func batteryIndicator(level: Int) -> some View {
        HStack(spacing: 4) {
            Image(systemName: batteryIcon(for: level))
                .font(.caption)
                .foregroundColor(batteryColor(for: level))
            
            Text("\(level)%")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 2)
        .background(
            Capsule()
                .fill(batteryColor(for: level).opacity(0.1))
        )
    }
    
    private func actionButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppleDesignSystem.Colors.accentBlue)
                
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .appleButton(variant: .tertiary, size: .small)
    }
    
    // MARK: - Computed Properties
    
    private var statusColor: Color {
        switch device.status {
        case .online:
            return AppleDesignSystem.Colors.successGlass
        case .offline:
            return AppleDesignSystem.Colors.errorGlass
        case .unknown:
            return AppleDesignSystem.Colors.warningGlass
        }
    }
    
    private var statusProgress: Double {
        switch device.status {
        case .online: return 1.0
        case .offline: return 0.0
        case .unknown: return 0.5
        }
    }
    
    private func batteryIcon(for level: Int) -> String {
        switch level {
        case 75...100: return "battery.100"
        case 50..<75: return "battery.75"
        case 25..<50: return "battery.25"
        case 1..<25: return "battery.0"
        default: return "battery.0"
        }
    }
    
    private func batteryColor(for level: Int) -> Color {
        switch level {
        case 50...100: return .green
        case 20..<50: return .orange
        default: return .red
        }
    }
    
    // MARK: - Actions
    
    private func startGlowAnimation() {
        withAnimation(
            Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)
        ) {
            isGlowing = true
        }
    }
    
    private func toggleDevice(_ isOn: Bool) {
        HapticFeedback.toggle(isOn: isOn)
        
        if isOn {
            smartHomeManager.turnDeviceOn(device)
        } else {
            smartHomeManager.turnDeviceOff(device)
        }
    }
    
    private func captureSnapshot() {
        HapticFeedback.light()
        smartHomeManager.captureSnapshot(for: device.id) { result in
            switch result {
            case .success:
                HapticFeedback.success()
            case .failure:
                HapticFeedback.error()
            }
        }
    }
    
    private func togglePrivacy() {
        HapticFeedback.medium()
        // Implement privacy toggle
        logInfo("Privacy toggle for device \(device.name)", category: .device)
    }
    
    private func openSettings() {
        HapticFeedback.selection()
        // Implement settings navigation
        logInfo("Settings for device \(device.name)", category: .ui)
    }
}

// MARK: - Modern Device Grid

struct ModernDeviceGrid: View {
    let devices: [RingDevice]
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var animateCards = false
    
    private let columns = [
        GridItem(.flexible(), spacing: AppleDesignSystem.Spacing.md),
        GridItem(.flexible(), spacing: AppleDesignSystem.Spacing.md)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: AppleDesignSystem.Spacing.lg) {
            ForEach(Array(devices.enumerated()), id: \.element.id) { index, device in
                ModernDeviceCard(device: device, smartHomeManager: smartHomeManager)
                    .offset(y: animateCards ? 0 : 50)
                    .opacity(animateCards ? 1 : 0)
                    .animation(
                        AppleDesignSystem.Animations.smooth
                            .delay(Double(index) * 0.1),
                        value: animateCards
                    )
            }
        }
        .onAppear {
            withAnimation {
                animateCards = true
            }
        }
    }
}

// MARK: - Floating Action Button

struct FloatingActionButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    let accentColor: Color
    
    @State private var isPressed = false
    @State private var isPulsing = false
    
    init(
        icon: String,
        label: String,
        accentColor: Color = AppleDesignSystem.Colors.accentBlue,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.label = label
        self.accentColor = accentColor
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action()
            HapticFeedback.medium()
            
            withAnimation(AppleDesignSystem.Animations.snappy) {
                isPulsing = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isPulsing = false
            }
        }) {
            HStack(spacing: AppleDesignSystem.Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(label)
                    .font(AppleDesignSystem.Typography.carPlayMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, AppleDesignSystem.Spacing.lg)
            .padding(.vertical, AppleDesignSystem.Spacing.md)
            .background(
                ZStack {
                    // Background gradient
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                colors: [accentColor, accentColor.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Pulse effect
                    if isPulsing {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(accentColor)
                            .blur(radius: 10)
                            .opacity(0.6)
                            .scaleEffect(1.2)
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: accentColor.opacity(0.3),
                radius: isPressed ? 8 : 15,
                x: 0,
                y: isPressed ? 4 : 8
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .scaleEffect(isPulsing ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            withAnimation(AppleDesignSystem.Animations.quick) {
                isPressed = pressing
            }
        } perform: {}
    }
}

// MARK: - Status Dashboard

struct StatusDashboard: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var animateStats = false
    
    var body: some View {
        VStack(spacing: AppleDesignSystem.Spacing.lg) {
            // System Status
            systemStatusCard
            
            // Quick Stats
            quickStatsGrid
            
            // Recent Activity
            recentActivityCard
        }
        .onAppear {
            withAnimation(AppleDesignSystem.Animations.smooth.delay(0.2)) {
                animateStats = true
            }
        }
    }
    
    private var systemStatusCard: some View {
        VStack(spacing: AppleDesignSystem.Spacing.md) {
            HStack {
                Text("System Status")
                    .font(AppleDesignSystem.Typography.carPlayLarge)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                systemStatusIndicator
            }
            
            HStack(spacing: AppleDesignSystem.Spacing.lg) {
                statusMetric(
                    title: "Online",
                    value: "\(onlineDeviceCount)",
                    color: .green
                )
                
                statusMetric(
                    title: "Offline",
                    value: "\(offlineDeviceCount)",
                    color: .red
                )
                
                statusMetric(
                    title: "Total",
                    value: "\(smartHomeManager.devices.count)",
                    color: .blue
                )
            }
        }
        .padding(AppleDesignSystem.Spacing.lg)
        .liquidGlassCard(elevation: .medium, cornerRadius: 24)
        .offset(y: animateStats ? 0 : 30)
        .opacity(animateStats ? 1 : 0)
    }
    
    private var systemStatusIndicator: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(systemHealthColor)
                .frame(width: 12, height: 12)
                .scaleEffect(animateStats ? 1.2 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: animateStats
                )
            
            Text(systemHealthText)
                .font(AppleDesignSystem.Typography.carPlaySmall)
                .fontWeight(.semibold)
                .foregroundColor(systemHealthColor)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(systemHealthColor.opacity(0.1))
        )
    }
    
    private var quickStatsGrid: some View {
        let stats = [
            ("Cameras", cameraCount, "video.fill", AppleDesignSystem.Colors.accentBlue),
            ("Doorbells", doorbellCount, "bell.fill", AppleDesignSystem.Colors.accentPurple),
            ("Sensors", sensorCount, "sensor.tag.radiowaves.forward.fill", .green),
            ("Lights", lightCount, "lightbulb.fill", .orange)
        ]
        
        return LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: 2),
            spacing: AppleDesignSystem.Spacing.md
        ) {
            ForEach(Array(stats.enumerated()), id: \.offset) { index, stat in
                quickStatCard(
                    title: stat.0,
                    count: stat.1,
                    icon: stat.2,
                    color: stat.3
                )
                .offset(y: animateStats ? 0 : 20)
                .opacity(animateStats ? 1 : 0)
                .animation(
                    AppleDesignSystem.Animations.smooth.delay(Double(index) * 0.1),
                    value: animateStats
                )
            }
        }
    }
    
    private func quickStatCard(title: String, count: Int, icon: String, color: Color) -> some View {
        VStack(spacing: AppleDesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(color)
            
            Text("\(count)")
                .font(AppleDesignSystem.Typography.carPlayLarge)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(AppleDesignSystem.Typography.carPlaySmall)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppleDesignSystem.Spacing.lg)
        .liquidGlassCard(
            elevation: .low,
            cornerRadius: 20,
            tint: color.opacity(0.1)
        )
    }
    
    private var recentActivityCard: some View {
        VStack(alignment: .leading, spacing: AppleDesignSystem.Spacing.md) {
            Text("Recent Activity")
                .font(AppleDesignSystem.Typography.carPlayLarge)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            if smartHomeManager.recentMotionAlerts.isEmpty {
                Text("No recent activity")
                    .font(AppleDesignSystem.Typography.carPlaySmall)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, AppleDesignSystem.Spacing.lg)
            } else {
                LazyVStack(spacing: AppleDesignSystem.Spacing.sm) {
                    ForEach(smartHomeManager.recentMotionAlerts.prefix(3)) { alert in
                        activityRow(alert: alert)
                    }
                }
            }
        }
        .padding(AppleDesignSystem.Spacing.lg)
        .liquidGlassCard(elevation: .medium, cornerRadius: 24)
        .offset(y: animateStats ? 0 : 30)
        .opacity(animateStats ? 1 : 0)
        .animation(AppleDesignSystem.Animations.smooth.delay(0.4), value: animateStats)
    }
    
    private func activityRow(alert: MotionAlert) -> some View {
        HStack(spacing: AppleDesignSystem.Spacing.md) {
            Circle()
                .fill(.orange)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Motion detected")
                    .font(AppleDesignSystem.Typography.carPlaySmall)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(alert.timestamp.formatted(.relative(presentation: .named)))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private func statusMetric(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(AppleDesignSystem.Typography.carPlayLarge)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(AppleDesignSystem.Typography.carPlaySmall)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Computed Properties
    
    private var onlineDeviceCount: Int {
        smartHomeManager.devices.filter { $0.status == .online }.count
    }
    
    private var offlineDeviceCount: Int {
        smartHomeManager.devices.filter { $0.status == .offline }.count
    }
    
    private var cameraCount: Int {
        smartHomeManager.devices.filter { $0.category == .camera }.count
    }
    
    private var doorbellCount: Int {
        smartHomeManager.devices.filter { $0.category == .doorbell }.count
    }
    
    private var sensorCount: Int {
        smartHomeManager.devices.filter { $0.category == .motionSensor }.count
    }
    
    private var lightCount: Int {
        smartHomeManager.devices.filter { $0.category == .floodlight }.count
    }
    
    private var systemHealthColor: Color {
        let onlinePercentage = Double(onlineDeviceCount) / Double(max(smartHomeManager.devices.count, 1))
        
        switch onlinePercentage {
        case 0.8...1.0: return .green
        case 0.5..<0.8: return .orange
        default: return .red
        }
    }
    
    private var systemHealthText: String {
        let onlinePercentage = Double(onlineDeviceCount) / Double(max(smartHomeManager.devices.count, 1))
        
        switch onlinePercentage {
        case 0.8...1.0: return "Excellent"
        case 0.5..<0.8: return "Good"
        default: return "Needs Attention"
        }
    }
}