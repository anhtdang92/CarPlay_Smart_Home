import SwiftUI
import UIKit

// MARK: - Advanced Design Components

@available(iOS 15.0, *)
struct RingAdvancedDesign {
    
    // MARK: - Advanced Gradients
    
    struct Gradients {
        
        static let heroGradient = LinearGradient(
            colors: [
                Color(red: 0.0, green: 0.48, blue: 1.0),
                Color(red: 0.2, green: 0.6, blue: 1.0),
                Color(red: 0.4, green: 0.8, blue: 1.0)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let successGradient = LinearGradient(
            colors: [
                Color(red: 0.2, green: 0.78, blue: 0.35),
                Color(red: 0.3, green: 0.85, blue: 0.4),
                Color(red: 0.1, green: 0.7, blue: 0.3)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let warningGradient = LinearGradient(
            colors: [
                Color(red: 1.0, green: 0.38, blue: 0.0),
                Color(red: 1.0, green: 0.5, blue: 0.1),
                Color(red: 0.9, green: 0.3, blue: 0.0)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let glassGradient = LinearGradient(
            colors: [
                Color.white.opacity(0.25),
                Color.white.opacity(0.1),
                Color.white.opacity(0.05)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let shimmerGradient = LinearGradient(
            colors: [
                Color.white.opacity(0),
                Color.white.opacity(0.8),
                Color.white.opacity(0),
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        static func deviceGradient(for type: DeviceType) -> LinearGradient {
            switch type {
            case .camera:
                return LinearGradient(
                    colors: [
                        RingDesignSystem.Colors.ringBlue,
                        RingDesignSystem.Colors.ringBlue.opacity(0.8),
                        Color(red: 0.1, green: 0.6, blue: 1.0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .doorbell:
                return LinearGradient(
                    colors: [
                        RingDesignSystem.Colors.ringOrange,
                        RingDesignSystem.Colors.ringOrange.opacity(0.8),
                        Color(red: 1.0, green: 0.5, blue: 0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .motionSensor:
                return LinearGradient(
                    colors: [
                        RingDesignSystem.Colors.ringGreen,
                        RingDesignSystem.Colors.ringGreen.opacity(0.8),
                        Color(red: 0.3, green: 0.9, blue: 0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .floodlight:
                return LinearGradient(
                    colors: [
                        RingDesignSystem.Colors.ringYellow,
                        RingDesignSystem.Colors.ringYellow.opacity(0.8),
                        Color(red: 1.0, green: 0.9, blue: 0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .chime:
                return LinearGradient(
                    colors: [
                        RingDesignSystem.Colors.ringPurple,
                        RingDesignSystem.Colors.ringPurple.opacity(0.8),
                        Color(red: 0.8, green: 0.4, blue: 0.9)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
    
    // MARK: - Enhanced Shadows
    
    struct Shadows {
        
        static let floatingShadow = [
            Shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1),
            Shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4),
            Shadow(color: .black.opacity(0.1), radius: 16, x: 0, y: 8)
        ]
        
        static let elevatedShadow = [
            Shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 2),
            Shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 6),
            Shadow(color: .black.opacity(0.1), radius: 24, x: 0, y: 12)
        ]
        
        static let glowShadow = [
            Shadow(color: RingDesignSystem.Colors.ringBlue.opacity(0.3), radius: 8, x: 0, y: 0),
            Shadow(color: RingDesignSystem.Colors.ringBlue.opacity(0.2), radius: 16, x: 0, y: 0),
            Shadow(color: RingDesignSystem.Colors.ringBlue.opacity(0.1), radius: 32, x: 0, y: 0)
        ]
        
        struct Shadow {
            let color: Color
            let radius: CGFloat
            let x: CGFloat
            let y: CGFloat
        }
    }
    
    // MARK: - Advanced Animations
    
    struct Animations {
        
        static let gentleSpring = Animation.interpolatingSpring(
            mass: 0.8,
            stiffness: 100,
            damping: 12,
            initialVelocity: 0
        )
        
        static let bouncySpring = Animation.interpolatingSpring(
            mass: 0.6,
            stiffness: 150,
            damping: 8,
            initialVelocity: 0
        )
        
        static let smoothSpring = Animation.interpolatingSpring(
            mass: 1.0,
            stiffness: 120,
            damping: 15,
            initialVelocity: 0
        )
        
        static let pulseAnimation = Animation.easeInOut(duration: 2.0)
            .repeatForever(autoreverses: true)
        
        static let shimmerAnimation = Animation.linear(duration: 1.5)
            .repeatForever(autoreverses: false)
        
        static let breatheAnimation = Animation.easeInOut(duration: 3.0)
            .repeatForever(autoreverses: true)
        
        static let floatAnimation = Animation.easeInOut(duration: 4.0)
            .repeatForever(autoreverses: true)
    }
}

// MARK: - Enhanced View Modifiers

@available(iOS 15.0, *)
extension View {
    
    // MARK: - Advanced Liquid Glass Effect
    
    func advancedLiquidGlass(
        intensity: RingAdvancedDesign.GlassIntensity = .medium,
        cornerRadius: CGFloat = RingDesignSystem.CornerRadius.lg,
        showBorder: Bool = true
    ) -> some View {
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