import SwiftUI
import UIKit

// MARK: - Ring Design System

@available(iOS 15.0, *)
struct RingDesignSystem {
    
    // MARK: - Color Palette
    
    struct Colors {
        
        // MARK: - Brand Colors
        static let ringBlue = Color(red: 0.0, green: 0.48, blue: 1.0)
        static let ringOrange = Color(red: 1.0, green: 0.38, blue: 0.0)
        static let ringGreen = Color(red: 0.20, green: 0.78, blue: 0.35)
        static let ringRed = Color(red: 1.0, green: 0.23, blue: 0.19)
        static let ringPurple = Color(red: 0.69, green: 0.32, blue: 0.87)
        static let ringYellow = Color(red: 1.0, green: 0.80, blue: 0.0)
        
        // MARK: - Adaptive Colors
        
        struct Background {
            static let primary = Color(UIColor.systemBackground)
            static let secondary = Color(UIColor.secondarySystemBackground)
            static let tertiary = Color(UIColor.tertiarySystemBackground)
            static let grouped = Color(UIColor.systemGroupedBackground)
            static let secondaryGrouped = Color(UIColor.secondarySystemGroupedBackground)
            static let tertiaryGrouped = Color(UIColor.tertiarySystemGroupedBackground)
        }
        
        struct Foreground {
            static let primary = Color(UIColor.label)
            static let secondary = Color(UIColor.secondaryLabel)
            static let tertiary = Color(UIColor.tertiaryLabel)
            static let quaternary = Color(UIColor.quaternaryLabel)
            static let placeholder = Color(UIColor.placeholderText)
        }
        
        struct Separator {
            static let primary = Color(UIColor.separator)
            static let secondary = Color(UIColor.opaqueSeparator)
        }
        
        struct Fill {
            static let primary = Color(UIColor.systemFill)
            static let secondary = Color(UIColor.secondarySystemFill)
            static let tertiary = Color(UIColor.tertiarySystemFill)
            static let quaternary = Color(UIColor.quaternarySystemFill)
        }
        
        // MARK: - Device Status Colors
        
        struct DeviceStatus {
            static let online = ringGreen
            static let offline = Color(UIColor.systemRed)
            static let unknown = Color(UIColor.systemOrange)
            static let maintenance = ringYellow
        }
        
        // MARK: - Alert Colors
        
        struct Alert {
            static let critical = Color(UIColor.systemRed)
            static let warning = Color(UIColor.systemOrange)
            static let info = ringBlue
            static let success = ringGreen
        }
        
        // MARK: - Liquid Glass Colors
        
        struct LiquidGlass {
            static let ultraThin = Color.white.opacity(0.1)
            static let thin = Color.white.opacity(0.2)
            static let regular = Color.white.opacity(0.3)
            static let thick = Color.white.opacity(0.4)
            static let ultraThick = Color.white.opacity(0.6)
            
            static let darkUltraThin = Color.black.opacity(0.1)
            static let darkThin = Color.black.opacity(0.2)
            static let darkRegular = Color.black.opacity(0.3)
            static let darkThick = Color.black.opacity(0.4)
            static let darkUltraThick = Color.black.opacity(0.6)
        }
    }
    
    // MARK: - Typography
    
    struct Typography {
        
        // MARK: - Font Weights
        enum Weight {
            case ultraLight, thin, light, regular, medium, semibold, bold, heavy, black
            
            var uiFont: UIFont.Weight {
                switch self {
                case .ultraLight: return .ultraLight
                case .thin: return .thin
                case .light: return .light
                case .regular: return .regular
                case .medium: return .medium
                case .semibold: return .semibold
                case .bold: return .bold
                case .heavy: return .heavy
                case .black: return .black
                }
            }
            
            var swiftUIFont: Font.Weight {
                switch self {
                case .ultraLight: return .ultraLight
                case .thin: return .thin
                case .light: return .light
                case .regular: return .regular
                case .medium: return .medium
                case .semibold: return .semibold
                case .bold: return .bold
                case .heavy: return .heavy
                case .black: return .black
                }
            }
        }
        
        // MARK: - Text Styles
        static let largeTitle = Font.system(.largeTitle, design: .rounded, weight: .bold)
            .scaledFont(for: .largeTitle)
        static let title1 = Font.system(.title, design: .rounded, weight: .semibold)
            .scaledFont(for: .title)
        static let title2 = Font.system(.title2, design: .rounded, weight: .semibold)
            .scaledFont(for: .title2)
        static let title3 = Font.system(.title3, design: .rounded, weight: .medium)
            .scaledFont(for: .title3)
        static let headline = Font.system(.headline, design: .rounded, weight: .semibold)
            .scaledFont(for: .headline)
        static let subheadline = Font.system(.subheadline, design: .rounded, weight: .medium)
            .scaledFont(for: .subheadline)
        static let body = Font.system(.body, design: .default, weight: .regular)
            .scaledFont(for: .body)
        static let callout = Font.system(.callout, design: .default, weight: .regular)
            .scaledFont(for: .callout)
        static let footnote = Font.system(.footnote, design: .default, weight: .regular)
            .scaledFont(for: .footnote)
        static let caption1 = Font.system(.caption, design: .default, weight: .regular)
            .scaledFont(for: .caption)
        static let caption2 = Font.system(.caption2, design: .default, weight: .regular)
            .scaledFont(for: .caption2)
        
        // MARK: - Custom Fonts
        static func customFont(size: CGFloat, weight: Weight = .regular, design: Font.Design = .default) -> Font {
            return Font.system(size: size, weight: weight.swiftUIFont, design: design)
        }
    }
    
    // MARK: - Spacing
    
    struct Spacing {
        static let xxxs: CGFloat = 2
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
    }
    
    // MARK: - Corner Radius
    
    struct CornerRadius {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
        static let circular: CGFloat = 1000
    }
    
    // MARK: - Shadow Styles
    
    struct Shadow {
        
        static let soft = ShadowStyle(
            color: .black.opacity(0.1),
            radius: 8,
            x: 0,
            y: 2
        )
        
        static let medium = ShadowStyle(
            color: .black.opacity(0.15),
            radius: 12,
            x: 0,
            y: 4
        )
        
        static let strong = ShadowStyle(
            color: .black.opacity(0.2),
            radius: 20,
            x: 0,
            y: 8
        )
        
        static let dramatic = ShadowStyle(
            color: .black.opacity(0.3),
            radius: 32,
            x: 0,
            y: 12
        )
    }
    
    // MARK: - Animation Styles
    
    struct Animations {
        static let quick = Animation.easeInOut(duration: 0.2)
        static let gentle = Animation.easeInOut(duration: 0.3)
        static let slow = Animation.easeInOut(duration: 0.5)
        static let reducedMotion = Animation.easeInOut(duration: 0.1)
        
        static var current: Animation {
            return UIAccessibility.isReduceMotionEnabled ? reducedMotion : gentle
        }
    }
    
    // MARK: - Touch Target Guidelines
    
    struct TouchTarget {
        static let minimumSize: CGFloat = 44
        static let recommendedSize: CGFloat = 48
    }
    
    // MARK: - Accessibility
    
    struct Accessibility {
        static let minimumContrastRatio: CGFloat = 4.5
        
        static func scaledFont(for textStyle: UIFont.TextStyle) -> Font {
            return Font(textStyle).scaledFont(for: textStyle)
        }
    }
    
    // MARK: - Haptic Feedback
    
    struct Haptics {
        static func light() {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
        
        static func medium() {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
        
        static func heavy() {
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
        }
        
        static func selection() {
            let selectionFeedback = UISelectionFeedbackGenerator()
            selectionFeedback.selectionChanged()
        }
        
        static func success() {
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.success)
        }
        
        static func warning() {
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.warning)
        }
        
        static func error() {
            let notificationFeedback = UINotificationFeedbackGenerator()
            notificationFeedback.notificationOccurred(.error)
        }
        
        // Contextual haptics for different interactions
        static func deviceToggle() {
            medium()
        }
        
        static func alertReceived() {
            heavy()
        }
        
        static func navigation() {
            light()
        }
        
        static func criticalAction() {
            heavy()
        }
    }
    
    // MARK: - Dark Mode Optimizations
    
    struct DarkMode {
        static let enhancedBackground = Color(UIColor.systemBackground)
        static let enhancedSecondaryBackground = Color(UIColor.secondarySystemBackground)
        static let enhancedTertiaryBackground = Color(UIColor.tertiarySystemBackground)
        
        static let enhancedPrimaryText = Color(UIColor.label)
        static let enhancedSecondaryText = Color(UIColor.secondaryLabel)
        static let enhancedTertiaryText = Color(UIColor.tertiaryLabel)
        
        static let enhancedSeparator = Color(UIColor.separator)
        static let enhancedFill = Color(UIColor.systemFill)
        
        // Enhanced liquid glass for dark mode
        static let enhancedLiquidGlass = Color.white.opacity(0.15)
        static let enhancedLiquidGlassThick = Color.white.opacity(0.25)
        
        // Enhanced shadows for dark mode
        static let enhancedShadow = Color.black.opacity(0.4)
        static let enhancedShadowStrong = Color.black.opacity(0.6)
    }
}

// MARK: - Supporting Structures

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Modifiers

struct LiquidGlassModifier: ViewModifier {
    let style: LiquidGlassStyle
    let cornerRadius: CGFloat
    
    enum LiquidGlassStyle {
        case ultraThin, thin, regular, thick, ultraThick
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        RingDesignSystem.Colors.LiquidGlass.ultraThin,
                                        RingDesignSystem.Colors.LiquidGlass.thin
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
    }
}

struct PulseModifier: ViewModifier {
    let active: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(active ? 1.05 : 1.0)
            .animation(
                active ? 
                Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true) : 
                .default,
                value: active
            )
    }
}

struct ShimmerModifier: ViewModifier {
    let active: Bool
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if active {
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.white.opacity(0.3),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .offset(x: -200 + phase * 400)
                        .animation(
                            Animation.linear(duration: 1.5).repeatForever(autoreverses: false),
                            value: phase
                        )
                        .onAppear {
                            phase = 1
                        }
                    }
                }
            )
    }
}

struct TapFeedbackModifier: ViewModifier {
    let haptic: RingDesignSystem.Haptics
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                switch haptic {
                case .light: RingDesignSystem.Haptics.light()
                case .medium: RingDesignSystem.Haptics.medium()
                case .heavy: RingDesignSystem.Haptics.heavy()
                case .success: RingDesignSystem.Haptics.success()
                case .warning: RingDesignSystem.Haptics.warning()
                case .error: RingDesignSystem.Haptics.error()
                }
                action()
            }
    }
}

// MARK: - View Extensions

extension View {
    func liquidGlass(_ style: LiquidGlassModifier.LiquidGlassStyle = .regular, cornerRadius: CGFloat) -> some View {
        modifier(LiquidGlassModifier(style: style, cornerRadius: cornerRadius))
    }
    
    func pulse(active: Bool) -> some View {
        modifier(PulseModifier(active: active))
    }
    
    func shimmer(active: Bool) -> some View {
        modifier(ShimmerModifier(active: active))
    }
    
    func onTapWithFeedback(haptic: RingDesignSystem.Haptics, action: @escaping () -> Void) -> some View {
        modifier(TapFeedbackModifier(haptic: haptic, action: action))
    }
}

// MARK: - UI Components

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(RingDesignSystem.Typography.subheadline)
                .fontWeight(isSelected ? .semibold : .medium)
                .foregroundColor(isSelected ? .white : RingDesignSystem.Colors.Foreground.primary)
                .padding(.horizontal, RingDesignSystem.Spacing.md)
                .padding(.vertical, RingDesignSystem.Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.circular)
                        .fill(
                            isSelected ? 
                            RingDesignSystem.Colors.ringBlue :
                            RingDesignSystem.Colors.Fill.secondary
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.circular)
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

struct StatusMetric: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: RingDesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(RingDesignSystem.Typography.headline)
                    .fontWeight(.bold)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Text(title)
                    .font(RingDesignSystem.Typography.caption1)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
            }
            
            Spacer()
        }
        .padding(RingDesignSystem.Spacing.sm)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.sm)
    }
}

struct HealthRow: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: RingDesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(title)
                .font(RingDesignSystem.Typography.subheadline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            Spacer()
            
            Text("\(count)")
                .font(RingDesignSystem.Typography.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .padding(RingDesignSystem.Spacing.sm)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.sm)
    }
}

struct AlertSummaryRow: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: RingDesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(title)
                .font(RingDesignSystem.Typography.subheadline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            Spacer()
            
            Text("\(count)")
                .font(RingDesignSystem.Typography.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .padding(RingDesignSystem.Spacing.sm)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.sm)
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: RingDesignSystem.Spacing.sm) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Text(title)
                    .font(RingDesignSystem.Typography.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Spacer()
            }
            .padding(RingDesignSystem.Spacing.md)
            .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.md)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Device Type Extensions

extension DeviceType {
    var accentColor: Color {
        switch self {
        case .camera: return RingDesignSystem.Colors.ringBlue
        case .doorbell: return RingDesignSystem.Colors.ringOrange
        case .motionSensor: return RingDesignSystem.Colors.ringGreen
        case .floodlight: return RingDesignSystem.Colors.ringYellow
        case .chime: return RingDesignSystem.Colors.ringPurple
        }
    }
    
    var gradientColors: [Color] {
        switch self {
        case .camera: return [RingDesignSystem.Colors.ringBlue, RingDesignSystem.Colors.ringBlue.opacity(0.7)]
        case .doorbell: return [RingDesignSystem.Colors.ringOrange, RingDesignSystem.Colors.ringOrange.opacity(0.7)]
        case .motionSensor: return [RingDesignSystem.Colors.ringGreen, RingDesignSystem.Colors.ringGreen.opacity(0.7)]
        case .floodlight: return [RingDesignSystem.Colors.ringYellow, RingDesignSystem.Colors.ringYellow.opacity(0.7)]
        case .chime: return [RingDesignSystem.Colors.ringPurple, RingDesignSystem.Colors.ringPurple.opacity(0.7)]
        }
    }
    
    var iconName: String {
        switch self {
        case .camera: return "video.fill"
        case .doorbell: return "bell.fill"
        case .motionSensor: return "sensor.tag.radiowaves.forward.fill"
        case .floodlight: return "lightbulb.fill"
        case .chime: return "speaker.wave.2.fill"
        }
    }
}

extension DeviceStatus {
    var color: Color {
        switch self {
        case .on: return RingDesignSystem.Colors.ringGreen
        case .off: return RingDesignSystem.Colors.ringRed
        case .open: return RingDesignSystem.Colors.ringGreen
        case .closed: return RingDesignSystem.Colors.ringRed
        case .unknown: return RingDesignSystem.Colors.ringOrange
        }
    }
}

// MARK: - Utility Functions

func timeAgoString(from date: Date) -> String {
    let interval = Date().timeIntervalSince(date)
    
    if interval < 60 {
        return "Just now"
    } else if interval < 3600 {
        let minutes = Int(interval / 60)
        return "\(minutes)m ago"
    } else if interval < 86400 {
        let hours = Int(interval / 3600)
        return "\(hours)h ago"
    } else {
        let days = Int(interval / 86400)
        return "\(days)d ago"
    }
}

// MARK: - Enhanced Animation Presets

extension RingDesignSystem {
    struct EnhancedAnimations {
        static let springBounce = Animation.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)
        static let elasticOut = Animation.interpolatingSpring(stiffness: 100, damping: 10)
        static let smoothEase = Animation.easeInOut(duration: 0.4)
        static let quickSnap = Animation.easeOut(duration: 0.2)
        static let gentleFloat = Animation.easeInOut(duration: 0.8)
        static let pulseBounce = Animation.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)
        static let slideIn = Animation.easeOut(duration: 0.5)
        static let fadeIn = Animation.easeIn(duration: 0.3)
        static let scaleIn = Animation.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0)
        static let rotateIn = Animation.easeOut(duration: 0.6)
    }
}

// MARK: - Micro-Interaction Modifiers

struct MicroInteractionModifier: ViewModifier {
    let isActive: Bool
    let scale: CGFloat
    let rotation: Double
    let animation: Animation
    
    init(isActive: Bool, scale: CGFloat = 1.05, rotation: Double = 0, animation: Animation = RingDesignSystem.Animations.quick) {
        self.isActive = isActive
        self.scale = scale
        self.rotation = rotation
        self.animation = animation
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isActive ? scale : 1.0)
            .rotationEffect(.degrees(isActive ? rotation : 0))
            .animation(animation, value: isActive)
    }
}

struct HoverEffectModifier: ViewModifier {
    @State private var isHovered = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .shadow(
                color: isHovered ? RingDesignSystem.Colors.ringBlue.opacity(0.2) : Color.clear,
                radius: isHovered ? 8 : 0,
                x: 0,
                y: isHovered ? 4 : 0
            )
            .animation(RingDesignSystem.Animations.gentle, value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

struct PressEffectModifier: ViewModifier {
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(RingDesignSystem.Animations.quick, value: isPressed)
            .onTapGesture {
                withAnimation(RingDesignSystem.Animations.quick) {
                    isPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(RingDesignSystem.Animations.quick) {
                        isPressed = false
                    }
                }
            }
    }
}

// MARK: - Advanced Loading Animations

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.white.opacity(0.3),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: -200 + phase * 400)
                .animation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false),
                    value: phase
                )
            )
            .onAppear {
                phase = 1
            }
    }
}

struct BreathingEffect: ViewModifier {
    @State private var breathing = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(breathing ? 1.05 : 1.0)
            .opacity(breathing ? 0.8 : 1.0)
            .animation(
                Animation.easeInOut(duration: 2)
                    .repeatForever(autoreverses: true),
                value: breathing
            )
            .onAppear {
                breathing = true
            }
    }
}

struct FloatingEffect: ViewModifier {
    @State private var floating = false
    
    func body(content: Content) -> some View {
        content
            .offset(y: floating ? -5 : 5)
            .animation(
                Animation.easeInOut(duration: 3)
                    .repeatForever(autoreverses: true),
                value: floating
            )
            .onAppear {
                floating = true
            }
    }
}

// MARK: - Advanced View Modifiers

extension View {
    func microInteraction(isActive: Bool, scale: CGFloat = 1.05, rotation: Double = 0, animation: Animation = RingDesignSystem.Animations.quick) -> some View {
        modifier(MicroInteractionModifier(isActive: isActive, scale: scale, rotation: rotation, animation: animation))
    }
    
    func hoverEffect() -> some View {
        modifier(HoverEffectModifier())
    }
    
    func pressEffect() -> some View {
        modifier(PressEffectModifier())
    }
    
    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
    
    func breathing() -> some View {
        modifier(BreathingEffect())
    }
    
    func floating() -> some View {
        modifier(FloatingEffect())
    }
    
    func bounceIn(delay: Double = 0) -> some View {
        self
            .scaleEffect(0.3)
            .opacity(0)
            .animation(
                RingDesignSystem.EnhancedAnimations.springBounce.delay(delay),
                value: true
            )
            .onAppear {
                withAnimation(RingDesignSystem.EnhancedAnimations.springBounce.delay(delay)) {
                    // Trigger animation
                }
            }
    }
    
    func slideInFromBottom(delay: Double = 0) -> some View {
        self
            .offset(y: 50)
            .opacity(0)
            .animation(
                RingDesignSystem.EnhancedAnimations.slideIn.delay(delay),
                value: true
            )
            .onAppear {
                withAnimation(RingDesignSystem.EnhancedAnimations.slideIn.delay(delay)) {
                    // Trigger animation
                }
            }
    }
    
    func fadeInUp(delay: Double = 0) -> some View {
        self
            .offset(y: 20)
            .opacity(0)
            .animation(
                RingDesignSystem.EnhancedAnimations.fadeIn.delay(delay),
                value: true
            )
            .onAppear {
                withAnimation(RingDesignSystem.EnhancedAnimations.fadeIn.delay(delay)) {
                    // Trigger animation
                }
            }
    }
    
    func rotateIn(delay: Double = 0) -> some View {
        self
            .rotationEffect(.degrees(-180))
            .opacity(0)
            .animation(
                RingDesignSystem.EnhancedAnimations.rotateIn.delay(delay),
                value: true
            )
            .onAppear {
                withAnimation(RingDesignSystem.EnhancedAnimations.rotateIn.delay(delay)) {
                    // Trigger animation
                }
            }
    }
}

// MARK: - Advanced Color Extensions

extension Color {
    func adaptive() -> Color {
        return self
    }
    
    func withAlpha(_ alpha: Double) -> Color {
        return self.opacity(alpha)
    }
    
    var isLight: Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let brightness = ((red * 299) + (green * 587) + (blue * 114)) / 1000
        return brightness > 0.5
    }
    
    var contrastingText: Color {
        return isLight ? .black : .white
    }
}

// MARK: - Advanced Typography

extension RingDesignSystem {
    struct AdvancedTypography {
        static let displayLarge = Font.system(size: 48, weight: .bold, design: .rounded)
        static let displayMedium = Font.system(size: 36, weight: .bold, design: .rounded)
        static let displaySmall = Font.system(size: 24, weight: .bold, design: .rounded)
        static let headlineLarge = Font.system(size: 22, weight: .semibold, design: .rounded)
        static let headlineMedium = Font.system(size: 20, weight: .semibold, design: .rounded)
        static let headlineSmall = Font.system(size: 18, weight: .semibold, design: .rounded)
        static let titleLarge = Font.system(size: 16, weight: .semibold, design: .rounded)
        static let titleMedium = Font.system(size: 14, weight: .semibold, design: .rounded)
        static let titleSmall = Font.system(size: 12, weight: .semibold, design: .rounded)
        static let bodyLarge = Font.system(size: 16, weight: .regular, design: .rounded)
        static let bodyMedium = Font.system(size: 14, weight: .regular, design: .rounded)
        static let bodySmall = Font.system(size: 12, weight: .regular, design: .rounded)
        static let labelLarge = Font.system(size: 14, weight: .medium, design: .rounded)
        static let labelMedium = Font.system(size: 12, weight: .medium, design: .rounded)
        static let labelSmall = Font.system(size: 10, weight: .medium, design: .rounded)
    }
}

// MARK: - Advanced Spacing

extension RingDesignSystem {
    struct AdvancedSpacing {
        static let xs = CGFloat(4)
        static let sm = CGFloat(8)
        static let md = CGFloat(16)
        static let lg = CGFloat(24)
        static let xl = CGFloat(32)
        static let xxl = CGFloat(48)
        static let xxxl = CGFloat(64)
    }
}

// MARK: - Advanced Corner Radius

extension RingDesignSystem {
    struct AdvancedCornerRadius {
        static let none = CGFloat(0)
        static let xs = CGFloat(4)
        static let sm = CGFloat(8)
        static let md = CGFloat(12)
        static let lg = CGFloat(16)
        static let xl = CGFloat(24)
        static let xxl = CGFloat(32)
        static let full = CGFloat(999)
    }
}

// MARK: - Advanced UI Components
struct GlassmorphismCard<Content: View>: View {
    let content: Content
    let blurRadius: CGFloat
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    
    init(
        blurRadius: CGFloat = 20,
        cornerRadius: CGFloat = 16,
        shadowRadius: CGFloat = 10,
        @ViewBuilder content: () -> Content
    ) {
        self.blurRadius = blurRadius
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.3), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(
                color: .black.opacity(0.1),
                radius: shadowRadius,
                x: 0,
                y: 5
            )
    }
}

struct GradientButton: View {
    let title: String
    let icon: String?
    let gradient: LinearGradient
    let action: () -> Void
    let isLoading: Bool
    
    init(
        title: String,
        icon: String? = nil,
        gradient: LinearGradient = LinearGradient(
            colors: [.blue, .purple],
            startPoint: .leading,
            endPoint: .trailing
        ),
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.gradient = gradient
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(gradient)
                    .shadow(
                        color: gradient.stops.first?.color.opacity(0.3) ?? .blue.opacity(0.3),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(isLoading)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void
    let color: Color
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(color)
                        .shadow(
                            color: color.opacity(0.3),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct AnimatedProgressRing: View {
    let progress: Double
    let lineWidth: CGFloat
    let size: CGFloat
    let color: Color
    
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: animatedProgress)
        }
        .frame(width: size, height: size)
        .onAppear {
            animatedProgress = progress
        }
        .onChange(of: progress) { newValue in
            animatedProgress = newValue
        }
    }
}

struct ShimmerView: View {
    @State private var isAnimating = false
    
    var body: some View {
        LinearGradient(
            colors: [
                Color.gray.opacity(0.3),
                Color.gray.opacity(0.1),
                Color.gray.opacity(0.3)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .mask(
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.clear, .white, .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .offset(x: isAnimating ? 200 : -200)
        )
        .onAppear {
            withAnimation(
                .linear(duration: 1.5)
                .repeatForever(autoreverses: false)
            ) {
                isAnimating = true
            }
        }
    }
}

struct ParallaxScrollView<Content: View>: View {
    let content: Content
    let headerHeight: CGFloat
    
    init(headerHeight: CGFloat = 200, @ViewBuilder content: () -> Content) {
        self.headerHeight = headerHeight
        self.content = content()
    }
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                let offset = geometry.frame(in: .global).minY
                let height = headerHeight + (offset > 0 ? offset : 0)
                
                Color.clear
                    .frame(height: headerHeight)
                    .offset(y: offset > 0 ? -offset * 0.5 : 0)
            }
            .frame(height: headerHeight)
            
            content
        }
    }
}

struct ConfettiView: View {
    @State private var particles: [Particle] = []
    
    struct Particle: Identifiable {
        let id = UUID()
        var x: Double
        var y: Double
        var rotation: Double
        var scale: Double
        var color: Color
    }
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: 8, height: 8)
                    .scaleEffect(particle.scale)
                    .position(x: particle.x, y: particle.y)
                    .rotationEffect(.degrees(particle.rotation))
            }
        }
        .onAppear {
            createParticles()
        }
    }
    
    private func createParticles() {
        let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange]
        
        for _ in 0..<50 {
            let particle = Particle(
                x: Double.random(in: 0...UIScreen.main.bounds.width),
                y: Double.random(in: 0...UIScreen.main.bounds.height),
                rotation: Double.random(in: 0...360),
                scale: Double.random(in: 0.5...1.5),
                color: colors.randomElement() ?? .blue
            )
            particles.append(particle)
        }
        
        withAnimation(.easeInOut(duration: 3.0)) {
            for i in particles.indices {
                particles[i].y -= 200
                particles[i].rotation += 360
            }
        }
    }
}

struct MorphingShape: View {
    @State private var morphing = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.blue)
                .frame(width: 100, height: 100)
                .scaleEffect(morphing ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: morphing)
            
            RoundedRectangle(cornerRadius: morphing ? 50 : 0)
                .fill(.purple)
                .frame(width: 100, height: 100)
                .scaleEffect(morphing ? 0.8 : 1.0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: morphing)
        }
        .onAppear {
            morphing = true
        }
    }
}

struct NeumorphicButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    let isPressed: Bool
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isPressed ? .blue : .primary)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isPressed ? .blue : .primary)
            }
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: isPressed ? .clear : .black.opacity(0.1),
                        radius: isPressed ? 0 : 8,
                        x: isPressed ? 0 : 4,
                        y: isPressed ? 0 : 4
                    )
                    .shadow(
                        color: isPressed ? .clear : .white.opacity(0.8),
                        radius: isPressed ? 0 : 8,
                        x: isPressed ? 0 : -4,
                        y: isPressed ? 0 : -4
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}

struct AnimatedTabBar: View {
    @Binding var selectedTab: Int
    let tabs: [TabItem]
    
    struct TabItem {
        let title: String
        let icon: String
        let color: Color
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20, weight: selectedTab == index ? .semibold : .medium))
                            .foregroundColor(selectedTab == index ? tab.color : .secondary)
                            .scaleEffect(selectedTab == index ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
                        
                        Text(tab.title)
                            .font(.caption2)
                            .fontWeight(selectedTab == index ? .semibold : .medium)
                            .foregroundColor(selectedTab == index ? tab.color : .secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())
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
}

struct AnimatedCounter: View {
    let value: Int
    let prefix: String
    let suffix: String
    
    @State private var animatedValue: Int = 0
    
    var body: some View {
        HStack(spacing: 4) {
            if !prefix.isEmpty {
                Text(prefix)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            Text("\(animatedValue)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .animation(.easeOut(duration: 0.5), value: animatedValue)
            
            if !suffix.isEmpty {
                Text(suffix)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            animateToValue()
        }
        .onChange(of: value) { _ in
            animateToValue()
        }
    }
    
    private func animateToValue() {
        withAnimation(.easeOut(duration: 0.5)) {
            animatedValue = value
        }
    }
}

struct PulseAnimation: View {
    @State private var isPulsing = false
    
    var body: some View {
        Circle()
            .fill(.blue)
            .scaleEffect(isPulsing ? 1.5 : 1.0)
            .opacity(isPulsing ? 0.0 : 1.0)
            .animation(
                .easeInOut(duration: 1.0)
                .repeatForever(autoreverses: false),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}

struct WaveAnimation: View {
    @State private var waveOffset = 0.0
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                Circle()
                    .stroke(.blue.opacity(0.3), lineWidth: 2)
                    .scaleEffect(1.0 + Double(index) * 0.2)
                    .opacity(1.0 - Double(index) * 0.3)
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: false)
                        .delay(Double(index) * 0.3),
                        value: waveOffset
                    )
            }
        }
        .onAppear {
            waveOffset = 1.0
        }
    }
}

struct FloatingLabelTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String?
    
    @State private var isFocused = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(placeholder)
                        .font(.caption)
                        .foregroundColor(isFocused || !text.isEmpty ? .blue : .secondary)
                        .scaleEffect(isFocused || !text.isEmpty ? 0.8 : 1.0)
                        .offset(y: isFocused || !text.isEmpty ? -8 : 0)
                        .animation(.easeInOut(duration: 0.2), value: isFocused || !text.isEmpty)
                    
                    TextField("", text: $text)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onTapGesture {
                            isFocused = true
                        }
                }
            }
            
            Rectangle()
                .fill(isFocused ? Color.blue : Color.gray.opacity(0.3))
                .frame(height: 1)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct AnimatedGradientBackground: View {
    @State private var gradientStart = UnitPoint(x: 0, y: 0)
    @State private var gradientEnd = UnitPoint(x: 1, y: 1)
    
    let colors: [Color]
    
    init(colors: [Color] = [.blue, .purple, .pink]) {
        self.colors = colors
    }
    
    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: gradientStart,
            endPoint: gradientEnd
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(
                .easeInOut(duration: 3.0)
                .repeatForever(autoreverses: true)
            ) {
                gradientStart = UnitPoint(x: 1, y: 1)
                gradientEnd = UnitPoint(x: 0, y: 0)
            }
        }
    }
}

struct HapticFeedback {
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.impactOccurred()
    }
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(type)
    }
    
    static func selection() {
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
}

// MARK: - Enhanced Color System
extension Color {
    static let ringPrimary = Color("RingPrimary")
    static let ringSecondary = Color("RingSecondary")
    static let ringAccent = Color("RingAccent")
    static let ringBackground = Color("RingBackground")
    static let ringSurface = Color("RingSurface")
    
    static let successGreen = Color(red: 0.2, green: 0.8, blue: 0.2)
    static let warningOrange = Color(red: 1.0, green: 0.6, blue: 0.0)
    static let errorRed = Color(red: 0.9, green: 0.2, blue: 0.2)
    static let infoBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    
    static let glassBackground = Color.white.opacity(0.1)
    static let glassBorder = Color.white.opacity(0.2)
}

// MARK: - Enhanced Animation System
extension Animation {
    static let ringSpring = Animation.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)
    static let ringEaseOut = Animation.easeOut(duration: 0.3)
    static let ringEaseIn = Animation.easeIn(duration: 0.3)
    static let ringEaseInOut = Animation.easeInOut(duration: 0.3)
    
    static let gentle = Animation.easeInOut(duration: 0.4)
    static let snappy = Animation.spring(response: 0.4, dampingFraction: 0.7)
    static let bouncy = Animation.spring(response: 0.5, dampingFraction: 0.6)
}

// MARK: - Enhanced Typography
extension Font {
    static let ringTitle = Font.system(size: 28, weight: .bold, design: .rounded)
    static let ringHeadline = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let ringBody = Font.system(size: 16, weight: .regular, design: .rounded)
    static let ringCaption = Font.system(size: 14, weight: .medium, design: .rounded)
    static let ringSmall = Font.system(size: 12, weight: .medium, design: .rounded)
}

// MARK: - Enhanced Spacing
extension CGFloat {
    static let ringSpacing: CGFloat = 16
    static let ringSpacingSmall: CGFloat = 8
    static let ringSpacingLarge: CGFloat = 24
    static let ringSpacingExtraLarge: CGFloat = 32
    
    static let ringCornerRadius: CGFloat = 12
    static let ringCornerRadiusSmall: CGFloat = 8
    static let ringCornerRadiusLarge: CGFloat = 16
}