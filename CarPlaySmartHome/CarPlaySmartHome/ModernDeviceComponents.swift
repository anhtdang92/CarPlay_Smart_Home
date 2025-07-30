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
            // Enhanced status ring with multiple layers
            Circle()
                .stroke(statusColor.opacity(0.2), lineWidth: 2)
                .frame(width: 80, height: 80)
                .scaleEffect(isGlowing ? 1.15 : 1.0)
                .opacity(isGlowing ? 0.6 : 0.3)
            
            // Animated status ring with gradient
            Circle()
                .trim(from: 0, to: statusProgress)
                .stroke(
                    AngularGradient(
                        colors: [
                            statusColor,
                            statusColor.opacity(0.7),
                            statusColor.opacity(0.3)
                        ],
                        center: .center
                    ),
                    style: StrokeStyle(lineCap: .round, lineWidth: 4)
                )
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(-90))
                .animation(AppleDesignSystem.Animations.smooth, value: statusProgress)
            
            // Pulsing ring for active devices
            if device.isActive {
                Circle()
                    .stroke(statusColor.opacity(0.4), lineWidth: 1)
                    .frame(width: 80, height: 80)
                    .scaleEffect(isGlowing ? 1.3 : 1.0)
                    .opacity(isGlowing ? 0.8 : 0.0)
                    .animation(
                        .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                        value: isGlowing
                    )
            }
            
            // Device icon with enhanced styling
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                statusColor.opacity(0.9),
                                statusColor.opacity(0.6),
                                statusColor.opacity(0.3)
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
    @State private var isGlowing = false
    @State private var rotationAngle: Double = 0
    @State private var showShimmer = false
    
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
            performAction()
        }) {
            HStack(spacing: AppleDesignSystem.Spacing.sm) {
                // Enhanced icon with rotation
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(rotationAngle))
                    .animation(AppleDesignSystem.Animations.smooth, value: rotationAngle)
                
                Text(label)
                    .font(AppleDesignSystem.Typography.carPlayMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .opacity(isPressed ? 0.9 : 1.0)
            }
            .padding(.horizontal, AppleDesignSystem.Spacing.lg)
            .padding(.vertical, AppleDesignSystem.Spacing.md)
            .background(
                ZStack {
                    // Enhanced background gradient
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                colors: [
                                    accentColor,
                                    accentColor.opacity(0.9),
                                    accentColor.opacity(0.7)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Shimmer effect
                    if showShimmer {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.clear,
                                        Color.white.opacity(0.3),
                                        Color.clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: -50)
                            .animation(
                                .linear(duration: 1.5).repeatForever(autoreverses: false),
                                value: showShimmer
                            )
                    }
                    
                    // Enhanced pulse effect
                    if isPulsing {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(accentColor)
                            .blur(radius: 15)
                            .opacity(0.4)
                            .scaleEffect(1.3)
                            .animation(
                                .easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                                value: isPulsing
                            )
                    }
                    
                    // Glowing border
                    if isGlowing {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(accentColor.opacity(0.6), lineWidth: 2)
                            .blur(radius: 3)
                            .scaleEffect(1.05)
                            .opacity(0.8)
                            .animation(
                                .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                                value: isGlowing
                            )
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.4),
                                Color.white.opacity(0.2),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(
                color: accentColor.opacity(isPressed ? 0.2 : 0.4),
                radius: isPressed ? 10 : 18,
                x: 0,
                y: isPressed ? 5 : 10
            )
            .scaleEffect(isPressed ? 0.94 : 1.0)
            .scaleEffect(isPulsing ? 1.08 : 1.0)
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
            startAnimations()
        }
    }
    
    private func performAction() {
        // Enhanced haptic feedback with device-specific patterns
        HapticFeedback.deviceFeedback(for: .system)
        
        // Advanced visual feedback with multiple effects
        withAnimation(AppleDesignSystem.Animations.snappy) {
            isPulsing = true
            rotationAngle += 25
        }
        
        // Perform the action
        action()
        
        // Enhanced reset animations with staggered timing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(AppleDesignSystem.Animations.smooth) {
                isPulsing = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(AppleDesignSystem.Animations.gentle) {
                rotationAngle -= 25
            }
        }
        
        // Restart shimmer effect after action
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(AppleDesignSystem.Animations.shimmer) {
                showShimmer = true
            }
        }
    }
    
    private func startAnimations() {
        // Start shimmer effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                showShimmer = true
            }
        }
        
        // Start glowing effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                isGlowing = true
            }
        }
    }
}

// MARK: - Status Dashboard

struct StatusDashboard: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var animateStats = false
    @State private var refreshData = false
    @State private var showDetailedMetrics = false
    @State private var pulseAnimation = false
    
    var body: some View {
        VStack(spacing: AppleDesignSystem.Spacing.lg) {
            // Enhanced Header with Refresh
            enhancedHeaderCard
            
            // System Status with Enhanced Indicators
            enhancedSystemStatusCard
            
            // Quick Stats with Animations
            animatedQuickStatsGrid
            
            // Recent Activity with Enhanced Display
            enhancedRecentActivityCard
            
            // Quick Actions
            quickActionsSection
        }
        .onAppear {
            startEnhancedAnimations()
        }
    }
    
    private var enhancedHeaderCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppleDesignSystem.Spacing.xs) {
                Text("System Dashboard")
                    .font(AppleDesignSystem.Typography.carPlayLarge)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Last updated: \(smartHomeManager.lastUpdateTime)")
                    .font(AppleDesignSystem.Typography.caption1)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                refreshDashboard()
            }) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppleDesignSystem.Colors.accentBlue)
                    .rotationEffect(.degrees(refreshData ? 360 : 0))
                    .animation(
                        .linear(duration: 1.0).repeatForever(autoreverses: false),
                        value: refreshData
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .hapticFeedback({
                HapticFeedback.impact(style: .light)
            })
        }
        .padding(AppleDesignSystem.Spacing.lg)
        .liquidGlassCard(elevation: .medium, cornerRadius: 24)
        .offset(y: animateStats ? 0 : 30)
        .opacity(animateStats ? 1 : 0)
    }
    
    private var enhancedSystemStatusCard: some View {
        VStack(spacing: AppleDesignSystem.Spacing.md) {
            HStack {
                Text("System Status")
                    .font(AppleDesignSystem.Typography.carPlayLarge)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                enhancedSystemStatusIndicator
            }
            
            HStack(spacing: AppleDesignSystem.Spacing.lg) {
                enhancedStatusMetric(
                    title: "Online",
                    value: "\(onlineDeviceCount)",
                    color: .green,
                    delay: 0.1
                )
                
                enhancedStatusMetric(
                    title: "Offline",
                    value: "\(offlineDeviceCount)",
                    color: .red,
                    delay: 0.2
                )
                
                enhancedStatusMetric(
                    title: "Total",
                    value: "\(smartHomeManager.devices.count)",
                    color: .blue,
                    delay: 0.3
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
    
    // MARK: - Enhanced Helper Methods
    
    private func startEnhancedAnimations() {
        // Staggered entrance animations with enhanced timing
        withAnimation(AppleDesignSystem.Animations.smooth.delay(0.2)) {
            animateStats = true
        }
        
        // Enhanced pulse animation with multiple layers
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(AppleDesignSystem.Animations.pulse) {
                pulseAnimation = true
            }
        }
        
        // Breathing effect for system health indicators
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(AppleDesignSystem.Animations.breathing) {
                // Breathing effect will be handled by the breathing modifier
            }
        }
        
        // Floating effect for quick action buttons
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(AppleDesignSystem.Animations.floating) {
                // Floating effect will be handled by the floating modifier
            }
        }
        
        // Morphing effect for performance metrics
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(AppleDesignSystem.Animations.morphing) {
                // Morphing effect will be handled by the morphing modifier
            }
        }
    }
    
    private func refreshDashboard() {
        withAnimation(AppleDesignSystem.Animations.smooth) {
            refreshData = true
        }
        
        // Simulate refresh
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(AppleDesignSystem.Animations.smooth) {
                refreshData = false
            }
        }
        
        HapticFeedback.impact(style: .light)
    }
    
    private var enhancedSystemStatusIndicator: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(systemHealthColor)
                .frame(width: 12, height: 12)
                .scaleEffect(pulseAnimation ? 1.3 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    value: pulseAnimation
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
    
    private func enhancedStatusMetric(title: String, value: String, color: Color, delay: Double) -> some View {
        VStack(spacing: AppleDesignSystem.Spacing.xs) {
            Text(value)
                .font(AppleDesignSystem.Typography.carPlayLarge)
                .fontWeight(.bold)
                .foregroundColor(color)
                .scaleEffect(animateStats ? 1.0 : 0.8)
                .opacity(animateStats ? 1.0 : 0.0)
                .animation(
                    AppleDesignSystem.Animations.smooth.delay(delay),
                    value: animateStats
                )
            
            Text(title)
                .font(AppleDesignSystem.Typography.caption1)
                .foregroundColor(.secondary)
                .opacity(animateStats ? 1.0 : 0.0)
                .animation(
                    AppleDesignSystem.Animations.smooth.delay(delay + 0.1),
                    value: animateStats
                )
        }
        .frame(maxWidth: .infinity)
    }
    
    private var animatedQuickStatsGrid: some View {
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
                enhancedQuickStatCard(
                    title: stat.0,
                    count: stat.1,
                    icon: stat.2,
                    color: stat.3,
                    delay: Double(index) * 0.1
                )
            }
        }
        .offset(y: animateStats ? 0 : 20)
        .opacity(animateStats ? 1 : 0)
        .animation(
            AppleDesignSystem.Animations.smooth.delay(0.4),
            value: animateStats
        )
    }
    
    private func enhancedQuickStatCard(title: String, count: Int, icon: String, color: Color, delay: Double) -> some View {
        VStack(spacing: AppleDesignSystem.Spacing.sm) {
            // Enhanced icon with multiple animation layers
            ZStack {
                // Background glow
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .scaleEffect(animateStats ? 1.0 : 0.8)
                    .opacity(animateStats ? 1.0 : 0.0)
                    .animation(
                        AppleDesignSystem.Animations.smooth.delay(delay),
                        value: animateStats
                    )
                
                // Icon with enhanced effects
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
                    .scaleEffect(animateStats ? 1.0 : 0.5)
                    .opacity(animateStats ? 1.0 : 0.0)
                    .rotationEffect(.degrees(animateStats ? 0 : -10))
                    .animation(
                        AppleDesignSystem.Animations.bouncy.delay(delay),
                        value: animateStats
                    )
                    .breathing()
            }
            
            // Enhanced count with number animation
            Text("\(count)")
                .font(AppleDesignSystem.Typography.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .scaleEffect(animateStats ? 1.0 : 0.8)
                .opacity(animateStats ? 1.0 : 0.0)
                .animation(
                    AppleDesignSystem.Animations.elastic.delay(delay + 0.1),
                    value: animateStats
                )
                .pulse()
            
            // Enhanced title with fade animation
            Text(title)
                .font(AppleDesignSystem.Typography.caption1)
                .foregroundColor(.secondary)
                .opacity(animateStats ? 1.0 : 0.0)
                .offset(y: animateStats ? 0 : 5)
                .animation(
                    AppleDesignSystem.Animations.smooth.delay(delay + 0.2),
                    value: animateStats
                )
        }
        .frame(maxWidth: .infinity)
        .padding(AppleDesignSystem.Spacing.md)
        .liquidGlassCard(elevation: .low, cornerRadius: 16)
        .scaleEffect(animateStats ? 1.0 : 0.9)
        .animation(
            AppleDesignSystem.Animations.smooth.delay(delay + 0.3),
            value: animateStats
        )
        .morphing()
    }
    
    private var enhancedRecentActivityCard: some View {
        VStack(alignment: .leading, spacing: AppleDesignSystem.Spacing.md) {
            HStack {
                Text("Recent Activity")
                    .font(AppleDesignSystem.Typography.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("View All") {
                    // Navigate to activity view
                }
                .font(AppleDesignSystem.Typography.caption1)
                .foregroundColor(AppleDesignSystem.Colors.accentBlue)
            }
            
            if smartHomeManager.recentActivity.isEmpty {
                emptyActivityView
            } else {
                activityListView
            }
        }
        .padding(AppleDesignSystem.Spacing.lg)
        .liquidGlassCard(elevation: .medium, cornerRadius: 24)
        .offset(y: animateStats ? 0 : 20)
        .opacity(animateStats ? 1 : 0)
        .animation(
            AppleDesignSystem.Animations.smooth.delay(0.6),
            value: animateStats
        )
    }
    
    private var emptyActivityView: some View {
        VStack(spacing: AppleDesignSystem.Spacing.md) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 32))
                .foregroundColor(.green)
                .opacity(0.6)
            
            Text("No Recent Activity")
                .font(AppleDesignSystem.Typography.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppleDesignSystem.Spacing.xl)
    }
    
    private var activityListView: some View {
        VStack(spacing: AppleDesignSystem.Spacing.sm) {
            ForEach(smartHomeManager.recentActivity.prefix(3), id: \.id) { activity in
                activityRow(activity)
            }
        }
    }
    
    private func activityRow(_ activity: RingActivity) -> some View {
        HStack(spacing: AppleDesignSystem.Spacing.sm) {
            Circle()
                .fill(activity.color)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.title)
                    .font(AppleDesignSystem.Typography.caption1)
                    .foregroundColor(.primary)
                
                Text(activity.timestamp)
                    .font(AppleDesignSystem.Typography.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: activity.icon)
                .font(.system(size: 12))
                .foregroundColor(activity.color)
        }
        .padding(.vertical, 4)
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: AppleDesignSystem.Spacing.md) {
            Text("Quick Actions")
                .font(AppleDesignSystem.Typography.title3)
                .fontWeight(.semibold)
            
            HStack(spacing: AppleDesignSystem.Spacing.md) {
                QuickActionButton(
                    title: "Refresh All",
                    icon: "arrow.clockwise",
                    action: { refreshAllDevices() }
                )
                
                QuickActionButton(
                    title: "System Check",
                    icon: "checkmark.shield",
                    action: { performSystemCheck() }
                )
                
                QuickActionButton(
                    title: "Emergency",
                    icon: "exclamationmark.triangle",
                    action: { triggerEmergency() }
                )
            }
        }
        .offset(y: animateStats ? 0 : 20)
        .opacity(animateStats ? 1 : 0)
        .animation(
            AppleDesignSystem.Animations.smooth.delay(0.8),
            value: animateStats
        )
    }
    
    private func refreshAllDevices() {
        HapticFeedback.impact(style: .medium)
        // Implementation for refreshing all devices
    }
    
    private func performSystemCheck() {
        HapticFeedback.impact(style: .medium)
        // Implementation for system check
    }
    
    private func triggerEmergency() {
        HapticFeedback.emergency()
        // Implementation for emergency trigger
    }
    
    // MARK: - Quick Action Button Component
    
    struct QuickActionButton: View {
        let title: String
        let icon: String
        let action: () -> Void
        
        @State private var isPressed = false
        @State private var isAnimating = false
        @State private var isGlowing = false
        
        var body: some View {
            Button(action: {
                performEnhancedAction()
            }) {
                VStack(spacing: AppleDesignSystem.Spacing.xs) {
                    // Enhanced icon with multiple effects
                    ZStack {
                        // Background glow
                        Circle()
                            .fill(AppleDesignSystem.Colors.accentBlue.opacity(0.1))
                            .frame(width: 32, height: 32)
                            .scaleEffect(isGlowing ? 1.2 : 1.0)
                            .opacity(isGlowing ? 0.8 : 0.0)
                            .animation(AppleDesignSystem.Animations.pulse, value: isGlowing)
                        
                        // Icon with enhanced styling
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppleDesignSystem.Colors.accentBlue)
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .rotationEffect(.degrees(isAnimating ? 5 : 0))
                            .animation(AppleDesignSystem.Animations.morphing, value: isAnimating)
                    }
                    
                    // Enhanced title with improved typography
                    Text(title)
                        .font(AppleDesignSystem.Typography.caption2)
                        .foregroundColor(AppleDesignSystem.Colors.accentBlue)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .opacity(isPressed ? 0.8 : 1.0)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                        .animation(AppleDesignSystem.Animations.quick, value: isPressed)
                }
                .frame(maxWidth: .infinity)
                .padding(AppleDesignSystem.Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppleDesignSystem.Colors.accentBlue.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(AppleDesignSystem.Colors.accentBlue.opacity(0.3), lineWidth: 1)
                        )
                        .scaleEffect(isGlowing ? 1.05 : 1.0)
                        .animation(AppleDesignSystem.Animations.breathing, value: isGlowing)
                )
                .scaleEffect(isPressed ? 0.92 : 1.0)
                .animation(AppleDesignSystem.Animations.quick, value: isPressed)
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
                startEnhancedAnimations()
            }
        }
        
        private func performEnhancedAction() {
            // Enhanced haptic feedback
            HapticFeedback.impact(style: .medium)
            
            // Visual feedback with multiple effects
            withAnimation(AppleDesignSystem.Animations.snappy) {
                isAnimating = true
                isGlowing = true
            }
            
            // Perform the action
            action()
            
            // Reset animations with staggered timing
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(AppleDesignSystem.Animations.smooth) {
                    isAnimating = false
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(AppleDesignSystem.Animations.gentle) {
                    isGlowing = false
                }
            }
        }
        
        private func startEnhancedAnimations() {
            // Start breathing animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(AppleDesignSystem.Animations.breathing) {
                    isGlowing = true
                }
            }
            
            // Start morphing animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(AppleDesignSystem.Animations.morphing) {
                    isAnimating = true
                }
            }
        }
    }
}

// MARK: - Enhanced Device Card Animations

struct EnhancedDeviceCard: View {
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
            HapticFeedback.deviceActivation(for: device.type)
        }) {
            VStack(spacing: AppleDesignSystem.Spacing.md) {
                // Enhanced Device Icon with Advanced Status Ring
                enhancedDeviceIconWithStatus
                
                // Enhanced Device Information
                enhancedDeviceInfo
                
                // Enhanced Quick Actions (expandable)
                if showActions {
                    enhancedQuickActions
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
            .staggeredEntrance(delay: Double(device.hashValue % 10) * 0.1)
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
            startEnhancedAnimations()
        }
    }
    
    // MARK: - Enhanced Device Icon with Advanced Status Ring
    
    private var enhancedDeviceIconWithStatus: some View {
        ZStack {
            // Multi-layer status ring system
            ForEach(0..<3) { layer in
                Circle()
                    .stroke(
                        statusColor.opacity(0.3 - Double(layer) * 0.1),
                        lineWidth: 3 - CGFloat(layer)
                    )
                    .frame(width: 80 + CGFloat(layer * 10), height: 80 + CGFloat(layer * 10))
                    .scaleEffect(isGlowing ? 1.1 + Double(layer) * 0.05 : 1.0)
                    .opacity(isGlowing ? 0.8 - Double(layer) * 0.2 : 0.5 - Double(layer) * 0.1)
                    .animation(
                        AppleDesignSystem.Animations.smooth.delay(Double(layer) * 0.1),
                        value: isGlowing
                    )
            }
            
            // Animated status ring with gradient
            Circle()
                .trim(from: 0, to: statusProgress)
                .stroke(
                    AngularGradient(
                        colors: [
                            statusColor,
                            statusColor.opacity(0.7),
                            statusColor.opacity(0.3),
                            statusColor.opacity(0.1)
                        ],
                        center: .center
                    ),
                    style: StrokeStyle(lineCap: .round, lineWidth: 4)
                )
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(-90))
                .animation(AppleDesignSystem.Animations.smooth, value: statusProgress)
            
            // Pulsing ring for active devices
            if device.isActive {
                Circle()
                    .stroke(statusColor.opacity(0.4), lineWidth: 1)
                    .frame(width: 80, height: 80)
                    .scaleEffect(isGlowing ? 1.3 : 1.0)
                    .opacity(isGlowing ? 0.8 : 0.0)
                    .animation(
                        AppleDesignSystem.Animations.pulse,
                        value: isGlowing
                    )
            }
            
            // Enhanced device icon with 3D effects
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                statusColor.opacity(0.9),
                                statusColor.opacity(0.6),
                                statusColor.opacity(0.3),
                                statusColor.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(
                        color: statusColor.opacity(0.3),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                
                Image(systemName: device.iconName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .scaleEffect(isGlowing ? 1.1 : 1.0)
                    .animation(AppleDesignSystem.Animations.smooth, value: isGlowing)
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(AppleDesignSystem.Animations.quick, value: isPressed)
        }
    }
    
    // MARK: - Enhanced Device Information
    
    private var enhancedDeviceInfo: some View {
        VStack(spacing: AppleDesignSystem.Spacing.sm) {
            // Device name with enhanced typography
            Text(device.name)
                .font(AppleDesignSystem.Typography.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(AppleDesignSystem.Animations.quick, value: isPressed)
            
            // Enhanced status indicators
            enhancedStatusIndicators
                .opacity(isPressed ? 0.8 : 1.0)
                .animation(AppleDesignSystem.Animations.quick, value: isPressed)
            
            // Device location with icon
            if !device.location.isEmpty {
                HStack(spacing: AppleDesignSystem.Spacing.xs) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                    
                    Text(device.location)
                        .font(AppleDesignSystem.Typography.caption1)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .opacity(isPressed ? 0.7 : 1.0)
                .animation(AppleDesignSystem.Animations.quick, value: isPressed)
            }
        }
    }
    
    // MARK: - Enhanced Status Indicators
    
    private var enhancedStatusIndicators: some View {
        HStack(spacing: AppleDesignSystem.Spacing.xs) {
            // Online status with pulse
            Circle()
                .fill(device.isOnline ? Colors.successGlass : Colors.errorGlass)
                .frame(width: 8, height: 8)
                .scaleEffect(isGlowing ? 1.2 : 1.0)
                .animation(AppleDesignSystem.Animations.pulse, value: isGlowing)
            
            // Battery indicator with enhanced styling
            if device.hasBattery {
                enhancedBatteryIndicator
            }
            
            // Signal strength with animated bars
            if device.hasSignalStrength {
                enhancedSignalStrengthIndicator
            }
            
            // Motion detection with alert animation
            if device.hasMotionDetection {
                enhancedMotionDetectionIndicator
            }
        }
    }
    
    // MARK: - Enhanced Battery Indicator
    
    private var enhancedBatteryIndicator: some View {
        HStack(spacing: 2) {
            Image(systemName: batteryIcon)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(batteryColor)
                .scaleEffect(isGlowing ? 1.1 : 1.0)
                .animation(AppleDesignSystem.Animations.smooth, value: isGlowing)
            
            if device.batteryLevel < 20 {
                Text("\(Int(device.batteryLevel))%")
                    .font(AppleDesignSystem.Typography.caption2)
                    .foregroundColor(batteryColor)
                    .scaleEffect(isGlowing ? 1.05 : 1.0)
                    .animation(AppleDesignSystem.Animations.pulse, value: isGlowing)
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(batteryColor.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(batteryColor.opacity(0.3), lineWidth: 0.5)
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(AppleDesignSystem.Animations.quick, value: isPressed)
    }
    
    // MARK: - Enhanced Signal Strength Indicator
    
    private var enhancedSignalStrengthIndicator: some View {
        HStack(spacing: 1) {
            ForEach(0..<4) { index in
                Rectangle()
                    .fill(signalColor)
                    .frame(width: 2, height: CGFloat(index + 1) * 3)
                    .opacity(index < device.signalStrength ? 1.0 : 0.3)
                    .scaleEffect(isGlowing ? 1.05 : 1.0)
                    .animation(
                        AppleDesignSystem.Animations.smooth.delay(Double(index) * 0.05),
                        value: isGlowing
                    )
            }
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(AppleDesignSystem.Animations.quick, value: isPressed)
    }
    
    // MARK: - Enhanced Motion Detection Indicator
    
    private var enhancedMotionDetectionIndicator: some View {
        Circle()
            .fill(device.motionDetected ? Colors.warningGlass : Color.clear)
            .frame(width: 6, height: 6)
            .scaleEffect(device.motionDetected ? 1.5 : 1.0)
            .opacity(device.motionDetected ? 1.0 : 0.0)
            .animation(AppleDesignSystem.Animations.smooth, value: device.motionDetected)
            .overlay(
                Circle()
                    .stroke(Colors.warningGlass.opacity(0.5), lineWidth: 1)
                    .scaleEffect(device.motionDetected ? 2.0 : 1.0)
                    .opacity(device.motionDetected ? 0.0 : 0.0)
                    .animation(
                        AppleDesignSystem.Animations.pulse,
                        value: device.motionDetected
                    )
            )
    }
    
    // MARK: - Enhanced Quick Actions
    
    private var enhancedQuickActions: some View {
        VStack(spacing: AppleDesignSystem.Spacing.sm) {
            // Action buttons with staggered entrance
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppleDesignSystem.Spacing.sm) {
                ForEach(Array(device.availableActions.enumerated()), id: \.offset) { index, action in
                    EnhancedActionButton(
                        action: action,
                        device: device,
                        smartHomeManager: smartHomeManager,
                        delay: Double(index) * 0.1
                    )
                }
            }
            
            // Device-specific controls with enhanced styling
            if device.hasAdvancedControls {
                enhancedAdvancedControls
            }
        }
        .padding(AppleDesignSystem.Spacing.md)
        .background(
            AppleDesignSystem.GlassCard.secondary(
                cornerRadius: 12,
                elevation: .low
            )
        )
        .staggeredEntrance(delay: 0.2)
    }
    
    // MARK: - Enhanced Action Button Component
    
    struct EnhancedActionButton: View {
        let action: RingDevice.Action
        let device: RingDevice
        @ObservedObject var smartHomeManager: SmartHomeManager
        let delay: Double
        
        @State private var isPressed = false
        @State private var isLoading = false
        @State private var isAnimating = false
        
        var body: some View {
            Button(action: {
                performEnhancedAction()
            }) {
                VStack(spacing: AppleDesignSystem.Spacing.xs) {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                            .progressViewStyle(CircularProgressViewStyle(tint: action.color))
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(AppleDesignSystem.Animations.pulse, value: isAnimating)
                    } else {
                        Image(systemName: action.icon)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(action.color)
                            .scaleEffect(isAnimating ? 1.05 : 1.0)
                            .rotationEffect(.degrees(isAnimating ? 5 : 0))
                            .animation(AppleDesignSystem.Animations.morphing, value: isAnimating)
                    }
                    
                    Text(action.title)
                        .font(AppleDesignSystem.Typography.caption2)
                        .foregroundColor(action.color)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .opacity(isPressed ? 0.8 : 1.0)
                        .animation(AppleDesignSystem.Animations.quick, value: isPressed)
                }
                .frame(width: 60, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(action.color.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(action.color.opacity(0.3), lineWidth: 1)
                        )
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(AppleDesignSystem.Animations.quick, value: isPressed)
            }
            .buttonStyle(PlainButtonStyle())
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
                withAnimation(AppleDesignSystem.Animations.quick) {
                    isPressed = pressing
                }
            } perform: {
                HapticFeedback.longPress()
            }
            .staggeredEntrance(delay: delay)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.5) {
                    isAnimating = true
                }
            }
        }
        
        private func performEnhancedAction() {
            isLoading = true
            isAnimating = false
            HapticFeedback.deviceActivation(for: device.type)
            
            Task {
                do {
                    try await smartHomeManager.performAction(action, on: device)
                    await MainActor.run {
                        isLoading = false
                        HapticFeedback.success()
                        
                        // Restart animation after completion
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isAnimating = true
                        }
                    }
                } catch {
                    await MainActor.run {
                        isLoading = false
                        HapticFeedback.error()
                        
                        // Restart animation after error
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isAnimating = true
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Enhanced Animation Methods
    
    private func startEnhancedAnimations() {
        // Start glow animation with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(AppleDesignSystem.Animations.smooth) {
                isGlowing = true
            }
        }
        
        // Start breathing animation for active devices
        if device.isActive {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(AppleDesignSystem.Animations.breathing) {
                    // Breathing effect will be handled by the breathing modifier
                }
            }
        }
    }
}