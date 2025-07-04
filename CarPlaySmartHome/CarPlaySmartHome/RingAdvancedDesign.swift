import SwiftUI

struct RingAdvancedDesign: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedDevice: RingDevice?
    @State private var showingDeviceDetail = false
    @State private var isAnimating = false
    @State private var showWelcomeAnimation = false
    @State private var selectedTab = 0
    
    // Advanced UI states
    @State private var show3DEffects = true
    @State private var showParticleEffects = false
    @State private var showAdvancedControls = false
    @State private var showDeviceComparison = false
    @State private var showAutomationWizard = false
    
    var body: some View {
        ZStack {
            // Animated background with particles
            if showParticleEffects {
                ParticleBackground()
            }
            
            VStack(spacing: 0) {
                // Enhanced header with 3D effects
                if showWelcomeAnimation {
                    AdvancedHeaderView(smartHomeManager: smartHomeManager)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                // Advanced tab navigation
                AdvancedTabNavigation(selectedTab: $selectedTab)
                    .padding(.vertical, 8)
                
                // Main content with advanced animations
                TabView(selection: $selectedTab) {
                    // Device Control Center
                    AdvancedDeviceControlCenter(smartHomeManager: smartHomeManager)
                        .tag(0)
                    
                    // Automation Studio
                    AutomationStudioView(smartHomeManager: smartHomeManager)
                        .tag(1)
                    
                    // Analytics Dashboard
                    AdvancedAnalyticsDashboard(smartHomeManager: smartHomeManager)
                        .tag(2)
                    
                    // System Monitor
                    SystemMonitorView(smartHomeManager: smartHomeManager)
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: selectedTab)
            }
            
            // Floating action menu
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    AdvancedFloatingActionMenu(
                        showAdvancedControls: $showAdvancedControls,
                        showDeviceComparison: $showDeviceComparison,
                        showAutomationWizard: $showAutomationWizard
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            startAdvancedAnimations()
        }
        .sheet(isPresented: $showDeviceComparison) {
            DeviceComparisonView(smartHomeManager: smartHomeManager)
        }
        .sheet(isPresented: $showAutomationWizard) {
            AutomationWizardView(smartHomeManager: smartHomeManager)
        }
    }
    
    private func startAdvancedAnimations() {
        withAnimation(.easeInOut(duration: 1.0).delay(0.2)) {
            showWelcomeAnimation = true
        }
        
        withAnimation(.easeInOut(duration: 0.8).delay(0.5)) {
            isAnimating = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showParticleEffects = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showAdvancedControls = true
        }
    }
}
    
}

// MARK: - Advanced Header View
struct AdvancedHeaderView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var animateGradient = false
    @State private var pulseAnimation = false
    
    var body: some View {
        GlassmorphismCard {
            VStack(spacing: 20) {
                // 3D animated title
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Smart Home")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple, .pink],
                                    startPoint: animateGradient ? .topLeading : .bottomTrailing,
                                    endPoint: animateGradient ? .bottomTrailing : .topLeading
                                )
                            )
                            .scaleEffect(pulseAnimation ? 1.05 : 1.0)
                            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulseAnimation)
                        
                        Text("Advanced Control Center")
                            .font(.ringBody)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // 3D rotating device icon
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [.blue.opacity(0.3), .clear],
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 40
                                )
                            )
                            .frame(width: 80, height: 80)
                            .rotation3DEffect(.degrees(animateGradient ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                            .animation(.linear(duration: 8.0).repeatForever(autoreverses: false), value: animateGradient)
                        
                        Image(systemName: "house.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.blue)
                            .rotation3DEffect(.degrees(animateGradient ? -360 : 0), axis: (x: 0, y: 1, z: 0))
                            .animation(.linear(duration: 8.0).repeatForever(autoreverses: false), value: animateGradient)
                    }
                }
                
                // Advanced status indicators
                HStack(spacing: 20) {
                    AdvancedStatusCard(
                        title: "Online",
                        count: smartHomeManager.devices.filter { $0.status == .online }.count,
                        total: smartHomeManager.devices.count,
                        color: .successGreen,
                        icon: "checkmark.circle.fill"
                    )
                    
                    AdvancedStatusCard(
                        title: "Active",
                        count: smartHomeManager.devices.filter { $0.isOn }.count,
                        total: smartHomeManager.devices.count,
                        color: .warningOrange,
                        icon: "bolt.fill"
                    )
                    
                    AdvancedStatusCard(
                        title: "Automation",
                        count: smartHomeManager.getAutomationRules().filter { $0.isEnabled }.count,
                        total: smartHomeManager.getAutomationRules().count,
                        color: .purple,
                        icon: "clock.fill"
                    )
                }
            }
            .padding()
        }
        .padding(.horizontal)
        .padding(.top)
        .onAppear {
            animateGradient = true
            pulseAnimation = true
        }
    }
}
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(intensity.material)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(RingAdvancedDesign.Gradients.glassGradient)
                    )
                    .overlay(
                        showBorder ?
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.4),
                                        Color.white.opacity(0.1),
                                        Color.clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            ) : nil
                    )
            )
    }
    
    // MARK: - Floating Card Effect
    
    func floatingCard(
        elevation: RingAdvancedDesign.Elevation = .medium,
        cornerRadius: CGFloat = RingDesignSystem.CornerRadius.lg
    ) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(RingDesignSystem.Colors.Background.secondary)
                    .modifier(MultiShadowModifier(shadows: elevation.shadows))
            )
    }
    
    // MARK: - Glow Effect
    
    func glowEffect(
        color: Color = RingDesignSystem.Colors.ringBlue,
        intensity: CGFloat = 0.6
    ) -> some View {
        self
            .shadow(color: color.opacity(intensity * 0.4), radius: 4, x: 0, y: 0)
            .shadow(color: color.opacity(intensity * 0.3), radius: 8, x: 0, y: 0)
            .shadow(color: color.opacity(intensity * 0.2), radius: 16, x: 0, y: 0)
    }
    
    // MARK: - Shimmer Loading Effect
    
    func advancedShimmer(
        active: Bool = true,
        speed: Double = 1.5,
        angle: Double = 70
    ) -> some View {
        self
            .overlay(
                Rectangle()
                    .fill(
                        AngularGradient(
                            colors: [
                                Color.clear,
                                Color.white.opacity(0.6),
                                Color.clear
                            ],
                            center: .center,
                            angle: .degrees(angle)
                        )
                    )
                    .rotationEffect(.degrees(active ? 360 : 0))
                    .animation(
                        active ?
                        Animation.linear(duration: speed).repeatForever(autoreverses: false) :
                        .default,
                        value: active
                    )
                    .mask(
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.clear,
                                        Color.black,
                                        Color.clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .scaleEffect(x: active ? 3 : 0, anchor: .leading)
                            .animation(
                                active ?
                                Animation.linear(duration: speed).repeatForever(autoreverses: false) :
                                .default,
                                value: active
                            )
                    )
            )
            .clipped()
    }
    
    // MARK: - Floating Animation
    
    func floatingAnimation(active: Bool = true, distance: CGFloat = 4) -> some View {
        self
            .offset(y: active ? -distance : distance)
            .animation(RingAdvancedDesign.Animations.floatAnimation, value: active)
    }
    
    // MARK: - Interactive Scale Effect
    
    func interactiveScale(pressed: Bool) -> some View {
        self
            .scaleEffect(pressed ? 0.95 : 1.0)
            .animation(RingAdvancedDesign.Animations.bouncySpring, value: pressed)
    }
    
    // MARK: - Gradient Border
    
    func gradientBorder(
        gradient: LinearGradient,
        width: CGFloat = 2,
        cornerRadius: CGFloat = RingDesignSystem.CornerRadius.md
    ) -> some View {
        self
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(gradient, lineWidth: width)
            )
    }
    
    // MARK: - Status Glow
    
    func statusGlow(status: DeviceStatus, intensity: CGFloat = 0.8) -> some View {
        self
            .shadow(
                color: status.color.opacity(intensity * 0.3),
                radius: 8,
                x: 0,
                y: 0
            )
            .shadow(
                color: status.color.opacity(intensity * 0.2),
                radius: 16,
                x: 0,
                y: 0
            )
    }
}

// MARK: - Supporting Enums and Structs

@available(iOS 15.0, *)
extension RingAdvancedDesign {
    
    enum GlassIntensity {
        case ultraThin, thin, medium, thick, ultraThick
        
        var material: Material {
            switch self {
            case .ultraThin: return .ultraThinMaterial
            case .thin: return .thinMaterial
            case .medium: return .regularMaterial
            case .thick: return .thickMaterial
            case .ultraThick: return .ultraThickMaterial
            }
        }
    }
    
    enum Elevation {
        case low, medium, high, floating
        
        var shadows: [Shadows.Shadow] {
            switch self {
            case .low:
                return [
                    Shadows.Shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                ]
            case .medium:
                return [
                    Shadows.Shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2),
                    Shadows.Shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                ]
            case .high:
                return [
                    Shadows.Shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4),
                    Shadows.Shadow(color: .black.opacity(0.1), radius: 16, x: 0, y: 8)
                ]
            case .floating:
                return Shadows.floatingShadow
            }
        }
    }
}

// MARK: - Multi-Shadow Modifier

struct MultiShadowModifier: ViewModifier {
    let shadows: [RingAdvancedDesign.Shadows.Shadow]
    
    func body(content: Content) -> some View {
        shadows.reduce(content) { view, shadow in
            view.shadow(
                color: shadow.color,
                radius: shadow.radius,
                x: shadow.x,
                y: shadow.y
            )
        }
    }
}

// MARK: - Enhanced Premium Components

@available(iOS 15.0, *)
struct PremiumDeviceCard: View {
    let device: SmartDevice
    let smartHomeManager: SmartHomeManager
    @State private var isPressed = false
    @State private var isHovered = false
    @State private var showingActions = false
    @State private var deviceStatus: RingDeviceStatus?
    
    var body: some View {
        Button {
            showingActions = true
            RingDesignSystem.Haptics.medium()
        } label: {
            cardContent
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : (isHovered ? 1.02 : 1.0))
        .animation(RingAdvancedDesign.Animations.gentleSpring, value: isPressed)
        .animation(RingAdvancedDesign.Animations.smoothSpring, value: isHovered)
        .onTapGesture {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
        .onHover { hovering in
            isHovered = hovering
        }
        .sheet(isPresented: $showingActions) {
            DeviceActionsSheet(
                device: device,
                smartHomeManager: smartHomeManager,
                deviceStatus: deviceStatus
            )
        }
        .onAppear {
            loadDeviceStatus()
        }
    }
    
    private var cardContent: some View {
        VStack(spacing: RingDesignSystem.Spacing.md) {
            // Header with device icon and status
            HStack {
                premiumDeviceIcon
                
                Spacer()
                
                statusIndicator
            }
            
            // Device information
            VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.xs) {
                HStack {
                    Text(device.name)
                        .font(RingDesignSystem.Typography.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                        .lineLimit(1)
                    
                    Spacer()
                }
                
                HStack {
                    Text(device.deviceType.rawValue)
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    
                    if let location = device.location {
                        Text("• \(location)")
                            .font(RingDesignSystem.Typography.caption1)
                            .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
                    }
                    
                    Spacer()
                }
            }
            
            // Status indicators row
            premiumStatusRow
        }
        .padding(RingDesignSystem.Spacing.lg)
        .advancedLiquidGlass(cornerRadius: RingDesignSystem.CornerRadius.xl)
        .gradientBorder(
            gradient: LinearGradient(
                colors: [
                    device.deviceType.accentColor.opacity(0.6),
                    device.deviceType.accentColor.opacity(0.2),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            width: 1.5,
            cornerRadius: RingDesignSystem.CornerRadius.xl
        )
        .statusGlow(status: device.status, intensity: device.status == .on ? 1.0 : 0.3)
    }
    
    private var premiumDeviceIcon: some View {
        ZStack {
            // Animated background
            Circle()
                .fill(RingAdvancedDesign.Gradients.deviceGradient(for: device.deviceType))
                .frame(width: 56, height: 56)
                .overlay(
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.clear
                                ],
                                center: .topLeading,
                                startRadius: 0,
                                endRadius: 28
                            )
                        )
                )
            
            // Device icon
            Image(systemName: device.deviceType.iconName)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            
            // Activity indicator
            if device.status == .on {
                Circle()
                    .stroke(Color.white.opacity(0.8), lineWidth: 2)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .trim(from: 0, to: 0.3)
                            .stroke(
                                Color.white,
                                style: StrokeStyle(lineWidth: 2, lineCap: .round)
                            )
                            .frame(width: 60, height: 60)
                            .rotationEffect(.degrees(-90))
                            .animation(
                                Animation.linear(duration: 2.0).repeatForever(autoreverses: false),
                                value: device.status == .on
                            )
                    )
            }
        }
        .glowEffect(color: device.deviceType.accentColor, intensity: device.status == .on ? 0.8 : 0.3)
    }
    
    private var statusIndicator: some View {
        HStack(spacing: RingDesignSystem.Spacing.xs) {
            Circle()
                .fill(device.status.color)
                .frame(width: 10, height: 10)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.8), lineWidth: 1)
                )
                .scaleEffect(device.status == .on ? 1.2 : 1.0)
                .animation(RingAdvancedDesign.Animations.pulseAnimation, value: device.status == .on)
            
            Text(device.status.description)
                .font(RingDesignSystem.Typography.caption2)
                .fontWeight(.medium)
                .foregroundColor(device.status.color)
        }
        .padding(.horizontal, RingDesignSystem.Spacing.sm)
        .padding(.vertical, RingDesignSystem.Spacing.xs)
        .background(
            Capsule()
                .fill(device.status.color.opacity(0.15))
                .overlay(
                    Capsule()
                        .stroke(device.status.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var premiumStatusRow: some View {
        HStack(spacing: RingDesignSystem.Spacing.md) {
            if let batteryLevel = device.batteryLevel {
                PremiumStatusPill(
                    icon: batteryIconName(for: batteryLevel),
                    text: "\(batteryLevel)%",
                    color: batteryColor(for: batteryLevel)
                )
            }
            
            if let status = deviceStatus {
                PremiumStatusPill(
                    icon: "wifi",
                    text: "\(status.signalStrength)/4",
                    color: signalColor(for: status.signalStrength)
                )
            }
            
            Spacer()
            
            if let lastSeen = device.lastSeen {
                Text(timeAgoString(from: lastSeen))
                    .font(RingDesignSystem.Typography.caption2)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
            }
        }
    }
    
    // Helper functions
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
    
    private func signalColor(for strength: Int) -> Color {
        switch strength {
        case 1...2: return RingDesignSystem.Colors.Alert.critical
        case 3: return RingDesignSystem.Colors.Alert.warning
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
}

// MARK: - Premium Status Pill

@available(iOS 15.0, *)
struct PremiumStatusPill: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: RingDesignSystem.Spacing.xs) {
            Image(systemName: icon)
                .font(RingDesignSystem.Typography.caption2)
                .foregroundColor(color)
            
            Text(text)
                .font(RingDesignSystem.Typography.caption2)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
        .padding(.horizontal, RingDesignSystem.Spacing.sm)
        .padding(.vertical, RingDesignSystem.Spacing.xs)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .fill(color.opacity(0.1))
                )
                .overlay(
                    Capsule()
                        .stroke(color.opacity(0.3), lineWidth: 0.5)
                )
        )
    }
}

// MARK: - Enhanced Loading View

@available(iOS 15.0, *)
struct PremiumLoadingView: View {
    let title: String
    let subtitle: String?
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xl) {
            ZStack {
                // Outer ring
                Circle()
                    .stroke(
                        RingDesignSystem.Colors.ringBlue.opacity(0.2),
                        lineWidth: 4
                    )
                    .frame(width: 80, height: 80)
                
                // Animated ring
                Circle()
                    .trim(from: 0, to: 0.3)
                    .stroke(
                        RingAdvancedDesign.Gradients.heroGradient,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(rotationAngle))
                    .animation(
                        Animation.linear(duration: 1.0).repeatForever(autoreverses: false),
                        value: rotationAngle
                    )
                
                // Center icon
                Image(systemName: "house.fill")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(RingDesignSystem.Colors.ringBlue)
                    .scaleEffect(pulseScale)
                    .animation(
                        Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                        value: pulseScale
                    )
            }
            
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                Text(title)
                    .font(RingDesignSystem.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(RingDesignSystem.Typography.body)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(RingDesignSystem.Spacing.xxl)
        .advancedLiquidGlass(cornerRadius: RingDesignSystem.CornerRadius.xxl)
        .onAppear {
            rotationAngle = 360
            pulseScale = 1.2
        }
    }
}

// MARK: - Advanced Analytics Dashboard

struct AdvancedAnalyticsView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedTimeRange: TimeRange = .week
    @State private var showingDetailedChart = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: RingDesignSystem.Spacing.lg) {
                    // Time Range Selector
                    timeRangeSelector
                    
                    // Key Metrics Cards
                    keyMetricsSection
                    
                    // Activity Chart
                    activityChartSection
                    
                    // Device Performance
                    devicePerformanceSection
                    
                    // Security Insights
                    securityInsightsSection
                    
                    // Network Health
                    networkHealthSection
                }
                .padding(RingDesignSystem.Spacing.md)
            }
            .background(backgroundGradient.ignoresSafeArea())
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingDetailedChart) {
                DetailedChartView(timeRange: selectedTimeRange)
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: colorScheme == .dark ? 
            [Color.black, Color(red: 0.05, green: 0.05, blue: 0.1)] :
            [Color(red: 0.95, green: 0.97, blue: 1.0), Color.white],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var timeRangeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: RingDesignSystem.Spacing.sm) {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    AdvancedFilterChip(
                        title: range.displayName,
                        subtitle: range.description,
                        icon: range.icon,
                        isSelected: selectedTimeRange == range
                    ) {
                        withAnimation(RingDesignSystem.Animations.gentle) {
                            selectedTimeRange = range
                        }
                        RingDesignSystem.Haptics.light()
                    }
                }
            }
            .padding(.horizontal, RingDesignSystem.Spacing.md)
        }
    }
    
    private var keyMetricsSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: RingDesignSystem.Spacing.md) {
            AdvancedMetricCard(
                title: "Motion Events",
                value: "\(generateMotionEvents())",
                trend: "+12%",
                trendDirection: .up,
                icon: "sensor.tag.radiowaves.forward.fill",
                color: RingDesignSystem.Colors.ringOrange
            )
            
            AdvancedMetricCard(
                title: "Battery Health",
                value: "\(generateBatteryHealth())%",
                trend: "+5%",
                trendDirection: .up,
                icon: "battery.100",
                color: RingDesignSystem.Colors.ringGreen
            )
            
            AdvancedMetricCard(
                title: "Network Uptime",
                value: "99.8%",
                trend: "+0.2%",
                trendDirection: .up,
                icon: "wifi",
                color: RingDesignSystem.Colors.ringBlue
            )
            
            AdvancedMetricCard(
                title: "Response Time",
                value: "1.2s",
                trend: "-0.3s",
                trendDirection: .down,
                icon: "speedometer",
                color: RingDesignSystem.Colors.ringPurple
            )
        }
    }
    
    private var activityChartSection: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            HStack {
                Text("Activity Overview")
                    .font(RingDesignSystem.Typography.headline)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Spacer()
                
                Button("View Details") {
                    showingDetailedChart = true
                }
                .font(RingDesignSystem.Typography.subheadline)
                .foregroundColor(RingDesignSystem.Colors.ringBlue)
            }
            
            ActivityChartView(data: generateChartData())
                .frame(height: 200)
                .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
        }
    }
    
    private var devicePerformanceSection: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Device Performance")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                ForEach(generateDevicePerformance(), id: \.name) { device in
                    DevicePerformanceRow(device: device)
                }
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private var securityInsightsSection: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Security Insights")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            VStack(spacing: RingDesignSystem.Spacing.md) {
                SecurityInsightCard(
                    title: "Peak Activity Times",
                    description: "Most motion detected between 6-8 PM",
                    icon: "clock.fill",
                    color: RingDesignSystem.Colors.ringOrange
                )
                
                SecurityInsightCard(
                    title: "Quiet Zones",
                    description: "Backyard camera shows minimal activity",
                    icon: "leaf.fill",
                    color: RingDesignSystem.Colors.ringGreen
                )
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private var networkHealthSection: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Network Health")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            NetworkHealthCard()
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    // MARK: - Helper Functions
    
    private func generateMotionEvents() -> Int {
        return Int.random(in: 45...120)
    }
    
    private func generateBatteryHealth() -> Int {
        return Int.random(in: 85...98)
    }
    
    private func generateChartData() -> [ChartDataPoint] {
        return (0..<7).map { day in
            ChartDataPoint(
                label: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][day],
                value: Double.random(in: 5...25),
                secondaryValue: Double.random(in: 2...8)
            )
        }
    }
    
    private func generateDevicePerformance() -> [DevicePerformance] {
        return [
            DevicePerformance(name: "Front Door Camera", uptime: 99.9, responseTime: 1.1, status: .excellent),
            DevicePerformance(name: "Backyard Camera", uptime: 98.5, responseTime: 1.8, status: .good),
            DevicePerformance(name: "Garage Floodlight", uptime: 99.2, responseTime: 1.3, status: .excellent),
            DevicePerformance(name: "Kitchen Sensor", uptime: 97.8, responseTime: 2.1, status: .fair)
        ]
    }
}

// MARK: - Advanced UI Components

struct AdvancedFilterChip: View {
    let title: String
    let subtitle: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: RingDesignSystem.Spacing.xs) {
                HStack(spacing: RingDesignSystem.Spacing.sm) {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(isSelected ? .white : RingDesignSystem.Colors.Foreground.primary)
                    
                    Text(title)
                        .font(RingDesignSystem.Typography.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(isSelected ? .white : RingDesignSystem.Colors.Foreground.primary)
                }
                
                Text(subtitle)
                    .font(RingDesignSystem.Typography.caption2)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : RingDesignSystem.Colors.Foreground.secondary)
            }
            .padding(RingDesignSystem.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                    .fill(
                        isSelected ? 
                        LinearGradient(
                            colors: [RingDesignSystem.Colors.ringBlue, RingDesignSystem.Colors.ringBlue.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        RingDesignSystem.Colors.Fill.secondary
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                    .stroke(
                        isSelected ? 
                        RingDesignSystem.Colors.ringBlue :
                        RingDesignSystem.Colors.Separator.primary,
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(RingDesignSystem.Animations.quick, value: isSelected)
    }
}

struct AdvancedMetricCard: View {
    let title: String
    let value: String
    let trend: String
    let trendDirection: TrendDirection
    let icon: String
    let color: Color
    
    enum TrendDirection {
        case up, down
        
        var color: Color {
            switch self {
            case .up: return RingDesignSystem.Colors.ringGreen
            case .down: return RingDesignSystem.Colors.ringRed
            }
        }
        
        var icon: String {
            switch self {
            case .up: return "arrow.up.right"
            case .down: return "arrow.down.right"
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                HStack(spacing: 2) {
                    Image(systemName: trendDirection.icon)
                        .font(.caption)
                        .foregroundColor(trendDirection.color)
                    
                    Text(trend)
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(trendDirection.color)
                }
                .padding(.horizontal, RingDesignSystem.Spacing.xs)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xs)
                        .fill(trendDirection.color.opacity(0.1))
                )
            }
            
            Text(value)
                .font(RingDesignSystem.Typography.title1)
                .fontWeight(.bold)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            Text(title)
                .font(RingDesignSystem.Typography.subheadline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
}

struct ActivityChartView: View {
    let data: [ChartDataPoint]
    
    var body: some View {
        Chart {
            ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                LineMark(
                    x: .value("Day", point.label),
                    y: .value("Events", point.value)
                )
                .foregroundStyle(RingDesignSystem.Colors.ringBlue)
                .lineStyle(StrokeStyle(lineWidth: 3))
                
                AreaMark(
                    x: .value("Day", point.label),
                    y: .value("Events", point.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            RingDesignSystem.Colors.ringBlue.opacity(0.3),
                            RingDesignSystem.Colors.ringBlue.opacity(0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                PointMark(
                    x: .value("Day", point.label),
                    y: .value("Events", point.value)
                )
                .foregroundStyle(RingDesignSystem.Colors.ringBlue)
                .symbolSize(20)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisGridLine()
                AxisValueLabel()
            }
        }
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel()
            }
        }
    }
}

struct DevicePerformanceRow: View {
    let device: DevicePerformance
    
    var body: some View {
        HStack(spacing: RingDesignSystem.Spacing.sm) {
            // Status indicator
            Circle()
                .fill(device.status.color)
                .frame(width: 8, height: 8)
            
            // Device info
            VStack(alignment: .leading, spacing: 2) {
                Text(device.name)
                    .font(RingDesignSystem.Typography.subheadline)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Text("\(device.uptime, specifier: "%.1f")% uptime • \(device.responseTime, specifier: "%.1f")s response")
                    .font(RingDesignSystem.Typography.caption2)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
            }
            
            Spacer()
            
            // Performance indicator
            VStack(alignment: .trailing, spacing: 2) {
                Text(device.status.rawValue)
                    .font(RingDesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(device.status.color)
                
                Text("\(device.status.score)/100")
                    .font(RingDesignSystem.Typography.caption2)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
            }
        }
        .padding(RingDesignSystem.Spacing.sm)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.sm)
    }
}

struct SecurityInsightCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: RingDesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(RingDesignSystem.Typography.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Text(description)
                    .font(RingDesignSystem.Typography.caption1)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
            }
            
            Spacer()
        }
        .padding(RingDesignSystem.Spacing.sm)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.sm)
    }
}

struct NetworkHealthCard: View {
    @State private var networkLatency = 24.0
    @State private var packetLoss = 0.1
    @State private var bandwidth = 95.8
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.md) {
            // Overall health indicator
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Excellent")
                        .font(RingDesignSystem.Typography.headline)
                        .foregroundColor(RingDesignSystem.Colors.ringGreen)
                    
                    Text("Network performance is optimal")
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(RingDesignSystem.Colors.ringGreen.opacity(0.2), lineWidth: 8)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: 0.95)
                        .stroke(RingDesignSystem.Colors.ringGreen, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                        .animation(RingDesignSystem.Animations.smooth, value: bandwidth)
                    
                    Text("95%")
                        .font(RingDesignSystem.Typography.caption1)
                        .fontWeight(.bold)
                        .foregroundColor(RingDesignSystem.Colors.ringGreen)
                }
            }
            
            // Metrics grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: RingDesignSystem.Spacing.sm) {
                NetworkMetric(label: "Latency", value: "\(Int(networkLatency))ms", color: .green)
                NetworkMetric(label: "Packet Loss", value: "\(packetLoss, specifier: "%.1f")%", color: .green)
                NetworkMetric(label: "Bandwidth", value: "\(bandwidth, specifier: "%.1f")%", color: .green)
            }
        }
    }
}

struct NetworkMetric: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(RingDesignSystem.Typography.subheadline)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(label)
                .font(RingDesignSystem.Typography.caption2)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(RingDesignSystem.Spacing.xs)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.xs)
    }
}

// MARK: - Supporting Structures

enum TimeRange: CaseIterable {
    case day, week, month, quarter
    
    var displayName: String {
        switch self {
        case .day: return "24 Hours"
        case .week: return "7 Days"
        case .month: return "30 Days"
        case .quarter: return "90 Days"
        }
    }
    
    var description: String {
        switch self {
        case .day: return "Today's activity"
        case .week: return "Weekly trends"
        case .month: return "Monthly patterns"
        case .quarter: return "Quarterly view"
        }
    }
    
    var icon: String {
        switch self {
        case .day: return "clock.fill"
        case .week: return "calendar"
        case .month: return "calendar.badge.clock"
        case .quarter: return "chart.line.uptrend.xyaxis"
        }
    }
}

struct ChartDataPoint {
    let label: String
    let value: Double
    let secondaryValue: Double
}

struct DevicePerformance {
    let name: String
    let uptime: Double
    let responseTime: Double
    let status: PerformanceStatus
    
    enum PerformanceStatus {
        case excellent, good, fair, poor
        
        var color: Color {
            switch self {
            case .excellent: return RingDesignSystem.Colors.ringGreen
            case .good: return RingDesignSystem.Colors.ringBlue
            case .fair: return RingDesignSystem.Colors.ringOrange
            case .poor: return RingDesignSystem.Colors.ringRed
            }
        }
        
        var rawValue: String {
            switch self {
            case .excellent: return "Excellent"
            case .good: return "Good"
            case .fair: return "Fair"
            case .poor: return "Poor"
            }
        }
        
        var score: Int {
            switch self {
            case .excellent: return 95
            case .good: return 85
            case .fair: return 70
            case .poor: return 50
            }
        }
    }
}

// MARK: - Advanced Status Card
struct AdvancedStatusCard: View {
    let title: String
    let count: Int
    let total: Int
    let color: Color
    let icon: String
    
    @State private var animateProgress = false
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Animated icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .scaleEffect(animateProgress ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: animateProgress)
            }
            
            VStack(spacing: 4) {
                Text("\(count)")
                    .font(.ringHeadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.ringSmall)
                    .foregroundColor(.secondary)
            }
            
            // Animated progress ring
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 4)
                    .frame(width: 40, height: 40)
                
                Circle()
                    .trim(from: 0, to: animateProgress ? percentage : 0)
                    .stroke(
                        color,
                        style: StrokeStyle(
                            lineWidth: 4,
                            lineCap: .round
                        )
                    )
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: animateProgress)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(0.5)) {
                animateProgress = true
            }
        }
    }
}

// MARK: - Advanced Tab Navigation
struct AdvancedTabNavigation: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        ("Control", "slider.horizontal.3"),
        ("Automation", "clock.fill"),
        ("Analytics", "chart.bar.fill"),
        ("Monitor", "gauge")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                AdvancedTabButton(
                    title: tab.0,
                    icon: tab.1,
                    isSelected: selectedTab == index,
                    color: getTabColor(index)
                ) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedTab = index
                    }
                    HapticFeedback.impact(style: .medium)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
    
    private func getTabColor(_ index: Int) -> Color {
        switch index {
        case 0: return .blue
        case 1: return .purple
        case 2: return .green
        case 3: return .orange
        default: return .gray
        }
    }
}

// MARK: - Advanced Tab Button
struct AdvancedTabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(isSelected ? color : .clear)
                        .frame(width: 40, height: 40)
                        .scaleEffect(isSelected ? 1.0 : 0.8)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: isSelected ? .semibold : .medium))
                        .foregroundColor(isSelected ? .white : .secondary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                }
                
                Text(title)
                    .font(.ringSmall)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .foregroundColor(isSelected ? color : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Advanced Device Control Center
struct AdvancedDeviceControlCenter: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedCategory: DeviceCategory = .all
    @State private var showGridLayout = true
    @State private var animateCards = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Category selector with 3D effects
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(DeviceCategory.allCases, id: \.self) { category in
                        Category3DButton(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedCategory = category
                            }
                            HapticFeedback.impact(style: .light)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Layout toggle with animation
            HStack {
                Text("Device Control")
                    .font(.ringHeadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        showGridLayout.toggle()
                    }
                    HapticFeedback.impact(style: .light)
                }) {
                    Image(systemName: showGridLayout ? "list.bullet" : "square.grid.2x2")
                        .font(.title3)
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                        )
                        .rotation3DEffect(.degrees(showGridLayout ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                }
            }
            .padding(.horizontal)
            
            // Device grid/list with advanced animations
            if showGridLayout {
                AdvancedDeviceGridView(
                    smartHomeManager: smartHomeManager,
                    selectedCategory: selectedCategory,
                    animateCards: $animateCards
                )
            } else {
                AdvancedDeviceListView(
                    smartHomeManager: smartHomeManager,
                    selectedCategory: selectedCategory
                )
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                animateCards = true
            }
        }
    }
}

// MARK: - Category 3D Button
struct Category3DButton: View {
    let category: DeviceCategory
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: isSelected ? [.blue, .purple] : [.gray.opacity(0.1), .gray.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isSelected ? .blue.opacity(0.5) : .clear, lineWidth: 2)
                        )
                        .shadow(
                            color: isSelected ? .blue.opacity(0.3) : .black.opacity(0.1),
                            radius: isSelected ? 8 : 4,
                            x: 0,
                            y: isSelected ? 4 : 2
                        )
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                        .rotation3DEffect(.degrees(isSelected ? 5 : 0), axis: (x: 1, y: 0, z: 0))
                    
                    Image(systemName: getCategoryIcon(category))
                        .font(.title2)
                        .foregroundColor(isSelected ? .white : .primary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                Text(category.rawValue)
                    .font(.ringSmall)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .blue : .primary)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    private func getCategoryIcon(_ category: DeviceCategory) -> String {
        switch category {
        case .all: return "house.fill"
        case .lights: return "lightbulb.fill"
        case .cameras: return "video.fill"
        case .sensors: return "sensor.tag.radiowaves.forward.fill"
        case .thermostats: return "thermometer"
        case .locks: return "lock.fill"
        }
    }
}

// MARK: - Advanced Device Grid View
struct AdvancedDeviceGridView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    let selectedCategory: DeviceCategory
    @Binding var animateCards: Bool
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private var filteredDevices: [RingDevice] {
        if selectedCategory == .all {
            return smartHomeManager.devices
        } else {
            return smartHomeManager.getDevicesByCategory(selectedCategory)
        }
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(Array(filteredDevices.enumerated()), id: \.element.id) { index, device in
                AdvancedDeviceCard(
                    device: device,
                    smartHomeManager: smartHomeManager
                )
                .offset(y: animateCards ? 0 : 100)
                .opacity(animateCards ? 1 : 0)
                .rotation3DEffect(.degrees(animateCards ? 0 : 15), axis: (x: 1, y: 0, z: 0))
                .animation(
                    .spring(response: 0.6, dampingFraction: 0.8)
                    .delay(Double(index) * 0.1),
                    value: animateCards
                )
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Advanced Device List View
struct AdvancedDeviceListView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    let selectedCategory: DeviceCategory
    
    private var filteredDevices: [RingDevice] {
        if selectedCategory == .all {
            return smartHomeManager.devices
        } else {
            return smartHomeManager.getDevicesByCategory(selectedCategory)
        }
    }
    
    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(filteredDevices) { device in
                AdvancedDeviceListItem(
                    device: device,
                    smartHomeManager: smartHomeManager
                )
                .transition(.slide.combined(with: .opacity))
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Advanced Device Card
struct AdvancedDeviceCard: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var isPressed = false
    @State private var showDetails = false
    @State private var animateGlow = false
    
    var body: some View {
        Button(action: {
            HapticFeedback.impact(style: .medium)
            showDetails = true
        }) {
            VStack(spacing: 16) {
                // Device icon with 3D effects
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [device.type.color.opacity(0.3), .clear],
                                center: .center,
                                startRadius: 20,
                                endRadius: 40
                            )
                        )
                        .frame(width: 70, height: 70)
                        .scaleEffect(animateGlow ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateGlow)
                    
                    Image(systemName: device.icon)
                        .font(.title)
                        .foregroundColor(device.type.color)
                        .rotation3DEffect(.degrees(isPressed ? 15 : 0), axis: (x: 1, y: 0, z: 0))
                }
                
                VStack(spacing: 4) {
                    Text(device.name)
                        .font(.ringBody)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(device.location)
                        .font(.ringSmall)
                        .foregroundColor(.secondary)
                }
                
                // Advanced toggle with 3D effect
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(device.isOn ? device.type.color : .gray.opacity(0.3))
                        .frame(width: 50, height: 30)
                        .overlay(
                            Circle()
                                .fill(.white)
                                .frame(width: 26, height: 26)
                                .offset(x: device.isOn ? 10 : -10)
                                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                        )
                        .rotation3DEffect(.degrees(isPressed ? 5 : 0), axis: (x: 1, y: 0, z: 0))
                }
                .onTapGesture {
                    HapticFeedback.impact(style: .medium)
                    smartHomeManager.toggleDevice(device)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(device.type.color.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(
                        color: device.type.color.opacity(0.2),
                        radius: isPressed ? 8 : 4,
                        x: 0,
                        y: isPressed ? 4 : 2
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .rotation3DEffect(.degrees(isPressed ? 2 : 0), axis: (x: 1, y: 0, z: 0))
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .onAppear {
            animateGlow = true
        }
        .sheet(isPresented: $showDetails) {
            AdvancedDeviceDetailView(device: device, smartHomeManager: smartHomeManager)
        }
    }
}

// MARK: - Advanced Device List Item
struct AdvancedDeviceListItem: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Device icon with 3D effect
            ZStack {
                Circle()
                    .fill(device.type.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: device.icon)
                    .font(.title3)
                    .foregroundColor(device.type.color)
                    .rotation3DEffect(.degrees(isPressed ? 15 : 0), axis: (x: 1, y: 0, z: 0))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(device.name)
                    .font(.ringBody)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                HStack {
                    Text(device.location)
                        .font(.ringSmall)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(device.energyUsage, specifier: "%.1f") kWh")
                        .font(.ringSmall)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Advanced toggle
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(device.isOn ? device.type.color : .gray.opacity(0.3))
                    .frame(width: 44, height: 28)
                    .overlay(
                        Circle()
                            .fill(.white)
                            .frame(width: 24, height: 24)
                            .offset(x: device.isOn ? 8 : -8)
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                    )
                    .rotation3DEffect(.degrees(isPressed ? 5 : 0), axis: (x: 1, y: 0, z: 0))
            }
            .onTapGesture {
                HapticFeedback.impact(style: .medium)
                smartHomeManager.toggleDevice(device)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - Advanced Floating Action Menu
struct AdvancedFloatingActionMenu: View {
    @Binding var showAdvancedControls: Bool
    @Binding var showDeviceComparison: Bool
    @Binding var showAutomationWizard: Bool
    @State private var isExpanded = false
    @State private var animateButtons = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Secondary action buttons
            if isExpanded {
                VStack(spacing: 12) {
                    FloatingActionButton(
                        icon: "chart.bar.xaxis",
                        action: {
                            HapticFeedback.impact(style: .medium)
                            showDeviceComparison = true
                        },
                        color: .green
                    )
                    .scaleEffect(animateButtons ? 1.0 : 0.5)
                    .opacity(animateButtons ? 1.0 : 0.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.1), value: animateButtons)
                    
                    FloatingActionButton(
                        icon: "wand.and.stars",
                        action: {
                            HapticFeedback.impact(style: .medium)
                            showAutomationWizard = true
                        },
                        color: .purple
                    )
                    .scaleEffect(animateButtons ? 1.0 : 0.5)
                    .opacity(animateButtons ? 1.0 : 0.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.2), value: animateButtons)
                }
            }
            
            // Main action button
            Button(action: {
                HapticFeedback.impact(style: .medium)
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
                
                if isExpanded {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.1)) {
                        animateButtons = true
                    }
                } else {
                    animateButtons = false
                }
            }) {
                Image(systemName: isExpanded ? "xmark" : "plus")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                    .rotationEffect(.degrees(isExpanded ? 45 : 0))
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isExpanded)
            }
        }
    }
}

// MARK: - Particle Background
struct ParticleBackground: View {
    @State private var particles: [Particle] = []
    
    struct Particle: Identifiable {
        let id = UUID()
        var x: Double
        var y: Double
        var size: Double
        var opacity: Double
        var speed: Double
    }
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(.blue.opacity(particle.opacity))
                    .frame(width: particle.size, height: particle.size)
                    .position(x: particle.x, y: particle.y)
                    .animation(
                        .linear(duration: particle.speed)
                        .repeatForever(autoreverses: false),
                        value: particle.x
                    )
            }
        }
        .onAppear {
            createParticles()
        }
    }
    
    private func createParticles() {
        for _ in 0..<20 {
            let particle = Particle(
                x: Double.random(in: 0...UIScreen.main.bounds.width),
                y: Double.random(in: 0...UIScreen.main.bounds.height),
                size: Double.random(in: 2...6),
                opacity: Double.random(in: 0.1...0.3),
                speed: Double.random(in: 3...8)
            )
            particles.append(particle)
        }
        
        // Animate particles
        withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: false)) {
            for i in particles.indices {
                particles[i].y -= 200
                particles[i].x += Double.random(in: -50...50)
            }
        }
    }
}

// MARK: - Placeholder Views
struct AutomationStudioView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    
    var body: some View {
        VStack {
            Text("Automation Studio")
                .font(.ringTitle)
                .foregroundColor(.primary)
            
            Text("Advanced automation controls coming soon...")
                .font(.ringBody)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct AdvancedAnalyticsDashboard: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    
    var body: some View {
        VStack {
            Text("Analytics Dashboard")
                .font(.ringTitle)
                .foregroundColor(.primary)
            
            Text("Advanced analytics coming soon...")
                .font(.ringBody)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SystemMonitorView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    
    var body: some View {
        VStack {
            Text("System Monitor")
                .font(.ringTitle)
                .foregroundColor(.primary)
            
            Text("System monitoring coming soon...")
                .font(.ringBody)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct AdvancedDeviceDetailView: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Advanced Device Details")
                    .font(.ringTitle)
                    .foregroundColor(.primary)
                
                Text("Coming soon...")
                    .font(.ringBody)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Device Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct DeviceComparisonView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Device Comparison")
                    .font(.ringTitle)
                    .foregroundColor(.primary)
                
                Text("Coming soon...")
                    .font(.ringBody)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Device Comparison")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AutomationWizardView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Automation Wizard")
                .font(.ringTitle)
                .foregroundColor(.primary)
                
                Text("Coming soon...")
                .font(.ringBody)
                .foregroundColor(.secondary)
            }
            .navigationTitle("Automation Wizard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct RingAdvancedDesign_Previews: PreviewProvider {
    static var previews: some View {
        RingAdvancedDesign(smartHomeManager: SmartHomeManager())
    }
}