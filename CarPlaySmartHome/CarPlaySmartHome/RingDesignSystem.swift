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

// MARK: - Advanced Visual Effects
struct LiquidBlobView: View {
    @State private var animate = false
    let color: Color
    let size: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                Circle()
                    .fill(color.opacity(0.3))
                    .frame(width: size, height: size)
                    .scaleEffect(animate ? 1.2 + Double(index) * 0.1 : 1.0)
                    .opacity(animate ? 0.0 : 0.6)
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: false)
                        .delay(Double(index) * 0.3),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct MagneticButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var dragOffset = CGSize.zero
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [color, color.opacity(0.8)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 30
                            )
                        )
                        .shadow(
                            color: color.opacity(0.4),
                            radius: isPressed ? 8 : 12,
                            x: 0,
                            y: isPressed ? 4 : 8
                        )
                )
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .offset(dragOffset)
        }
        .buttonStyle(PlainButtonStyle())
        .gesture(
            DragGesture()
                .onChanged { value in
                    let distance = sqrt(pow(value.translation.x, 2) + pow(value.translation.y, 2))
                    let maxDistance: CGFloat = 30
                    let scale = max(0.5, 1 - distance / maxDistance)
                    
                    dragOffset = CGSize(
                        width: value.translation.x * scale,
                        height: value.translation.y * scale
                    )
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        dragOffset = .zero
                    }
                }
        )
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct GlowingCard<Content: View>: View {
    let content: Content
    let glowColor: Color
    let intensity: Double
    
    @State private var glowAnimation = false
    
    init(glowColor: Color = .blue, intensity: Double = 0.3, @ViewBuilder content: () -> Content) {
        self.glowColor = glowColor
        self.intensity = intensity
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                glowColor.opacity(glowAnimation ? intensity : intensity * 0.5),
                                lineWidth: 2
                            )
                    )
                    .shadow(
                        color: glowColor.opacity(glowAnimation ? intensity : intensity * 0.3),
                        radius: glowAnimation ? 15 : 8,
                        x: 0,
                        y: 0
                    )
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    glowAnimation = true
                }
            }
    }
}

struct MorphingButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var morphing = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .rotationEffect(.degrees(morphing ? 360 : 0))
                    .animation(.easeInOut(duration: 0.6), value: morphing)
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: morphing ? 25 : 12)
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple, .pink],
                            startPoint: morphing ? .topLeading : .leading,
                            endPoint: morphing ? .bottomTrailing : .trailing
                        )
                    )
                    .shadow(
                        color: .blue.opacity(0.3),
                        radius: isPressed ? 4 : 8,
                        x: 0,
                        y: isPressed ? 2 : 4
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = pressing
                morphing = pressing
            }
        }, perform: {})
    }
}

struct FloatingLabelCard<Content: View>: View {
    let title: String
    let content: Content
    let color: Color
    
    @State private var isExpanded = false
    
    init(title: String, color: Color = .blue, @ViewBuilder content: () -> Content) {
        self.title = title
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Floating label
            HStack {
                Text(title)
                    .font(.ringCaption)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Capsule()
                                    .stroke(color.opacity(0.3), lineWidth: 1)
                            )
                    )
                
                Spacer()
            }
            .offset(y: isExpanded ? 0 : -10)
            .opacity(isExpanded ? 1 : 0)
            
            // Content
            content
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(color.opacity(0.2), lineWidth: 1)
                        )
                )
                .scaleEffect(isExpanded ? 1.0 : 0.95)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                isExpanded = true
            }
        }
    }
}

struct AnimatedGradientText: View {
    let text: String
    let colors: [Color]
    
    @State private var animateGradient = false
    
    init(_ text: String, colors: [Color] = [.blue, .purple, .pink]) {
        self.text = text
        self.colors = colors
    }
    
    var body: some View {
        Text(text)
            .font(.ringTitle)
            .fontWeight(.bold)
            .foregroundStyle(
                LinearGradient(
                    colors: colors,
                    startPoint: animateGradient ? .topLeading : .bottomTrailing,
                    endPoint: animateGradient ? .bottomTrailing : .topLeading
                )
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    animateGradient = true
                }
            }
    }
}

struct RippleButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var rippleScale: CGFloat = 0
    @State private var rippleOpacity: Double = 0
    
    var body: some View {
        Button(action: {
            // Create ripple effect
            rippleScale = 0
            rippleOpacity = 1
            
            withAnimation(.easeOut(duration: 0.6)) {
                rippleScale = 2
                rippleOpacity = 0
            }
            
            action()
        }) {
            ZStack {
                // Ripple effect
                Circle()
                    .fill(.white.opacity(0.3))
                    .scaleEffect(rippleScale)
                    .opacity(rippleOpacity)
                
                // Button content
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct AnimatedIcon: View {
    let icon: String
    let color: Color
    let animationType: AnimationType
    
    @State private var animate = false
    
    enum AnimationType {
        case bounce, rotate, pulse, shake, wave
    }
    
    var body: some View {
        Image(systemName: icon)
            .font(.title2)
            .foregroundColor(color)
            .modifier(AnimationModifier(type: animationType, animate: animate))
            .onAppear {
                animate = true
            }
    }
}

struct AnimationModifier: ViewModifier {
    let type: AnimatedIcon.AnimationType
    let animate: Bool
    
    func body(content: Content) -> some View {
        switch type {
        case .bounce:
            content
                .scaleEffect(animate ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: animate)
        case .rotate:
            content
                .rotationEffect(.degrees(animate ? 360 : 0))
                .animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: animate)
        case .pulse:
            content
                .scaleEffect(animate ? 1.1 : 1.0)
                .opacity(animate ? 0.7 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: animate)
        case .shake:
            content
                .offset(x: animate ? 5 : -5)
                .animation(.easeInOut(duration: 0.1).repeatForever(autoreverses: true), value: animate)
        case .wave:
            content
                .rotationEffect(.degrees(animate ? 10 : -10))
                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: animate)
        }
    }
}

struct NeumorphicView<Content: View>: View {
    let content: Content
    let isPressed: Bool
    
    init(isPressed: Bool = false, @ViewBuilder content: () -> Content) {
        self.isPressed = isPressed
        self.content = content()
    }
    
    var body: some View {
        content
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
}

struct AnimatedBorder: View {
    let color: Color
    let lineWidth: CGFloat
    
    @State private var animate = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(
                LinearGradient(
                    colors: [color, color.opacity(0.5), color],
                    startPoint: animate ? .topLeading : .bottomTrailing,
                    endPoint: animate ? .bottomTrailing : .topLeading
                ),
                lineWidth: lineWidth
            )
            .onAppear {
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    animate = true
                }
            }
    }
}

struct FloatingBubble: View {
    let color: Color
    let size: CGFloat
    
    @State private var animate = false
    @State private var offset = CGSize.zero
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [color, color.opacity(0.3)],
                    center: .center,
                    startRadius: 0,
                    endRadius: size / 2
                )
            )
            .frame(width: size, height: size)
            .scaleEffect(animate ? 1.2 : 0.8)
            .opacity(animate ? 0.6 : 1.0)
            .offset(offset)
            .onAppear {
                // Random initial position
                offset = CGSize(
                    width: CGFloat.random(in: -50...50),
                    height: CGFloat.random(in: -50...50)
                )
                
                // Animate floating
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    animate = true
                    offset = CGSize(
                        width: CGFloat.random(in: -30...30),
                        height: CGFloat.random(in: -30...30)
                    )
                }
            }
    }
}

struct AnimatedProgressBar: View {
    let progress: Double
    let color: Color
    let height: CGFloat
    
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(color.opacity(0.2))
                    .frame(height: height)
                
                // Progress
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * animatedProgress, height: height)
                    .overlay(
                        // Shimmer effect
                        RoundedRectangle(cornerRadius: height / 2)
                            .fill(
                                LinearGradient(
                                    colors: [.clear, .white.opacity(0.3), .clear],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: -geometry.size.width)
                            .animation(
                                .linear(duration: 2.0)
                                .repeatForever(autoreverses: false),
                                value: animatedProgress
                            )
                    )
            }
        }
        .frame(height: height)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newValue in
            withAnimation(.easeInOut(duration: 0.5)) {
                animatedProgress = newValue
            }
        }
    }
}

struct AnimatedCheckmark: View {
    let isCompleted: Bool
    let color: Color
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isCompleted ? color : .gray.opacity(0.3))
                .frame(width: 30, height: 30)
                .scaleEffect(animate ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: animate)
            
            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(animate ? 1.0 : 0.5)
                    .opacity(animate ? 1.0 : 0.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: animate)
            }
        }
        .onAppear {
            if isCompleted {
                withAnimation(.easeInOut(duration: 0.3).delay(0.1)) {
                    animate = true
                }
            }
        }
        .onChange(of: isCompleted) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.3)) {
                    animate = true
                }
            } else {
                animate = false
            }
        }
    }
}

struct AnimatedBadge: View {
    let count: Int
    let color: Color
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: 24, height: 24)
                .scaleEffect(animate ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.3).repeatForever(autoreverses: true), value: animate)
            
            Text("\(count)")
                .font(.ringSmall)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .onAppear {
            animate = true
        }
    }
}

struct AnimatedToggle: View {
    @Binding var isOn: Bool
    let color: Color
    
    @State private var animate = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isOn.toggle()
            }
            HapticFeedback.impact(style: .light)
        }) {
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 20)
                    .fill(isOn ? color : .gray.opacity(0.3))
                    .frame(width: 50, height: 30)
                
                // Thumb
                Circle()
                    .fill(.white)
                    .frame(width: 26, height: 26)
                    .offset(x: isOn ? 10 : -10)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                    .scaleEffect(animate ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: animate)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                animate = pressing
            }
        }, perform: {})
    }
}

// MARK: - Advanced Animation Extensions
extension Animation {
    static let elastic = Animation.interpolatingSpring(
        mass: 0.5,
        stiffness: 100,
        damping: 10,
        initialVelocity: 0
    )
    
    static let bouncy = Animation.interpolatingSpring(
        mass: 0.3,
        stiffness: 150,
        damping: 6,
        initialVelocity: 0
    )
    
    static let smooth = Animation.interpolatingSpring(
        mass: 1.0,
        stiffness: 120,
        damping: 15,
        initialVelocity: 0
    )
    
    static let quick = Animation.easeInOut(duration: 0.2)
    static let medium = Animation.easeInOut(duration: 0.4)
    static let slow = Animation.easeInOut(duration: 0.8)
}

// MARK: - Advanced Color Extensions
extension Color {
    static let primaryGradient = LinearGradient(
        colors: [.blue, .purple, .pink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [.orange, .red, .pink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let successGradient = LinearGradient(
        colors: [.green, .mint, .teal],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let warningGradient = LinearGradient(
        colors: [.orange, .yellow, .red],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Advanced Shadow System
struct AdvancedShadow {
    static let soft = [
        Shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1),
        Shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2),
        Shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
    ]
    
    static let medium = [
        Shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2),
        Shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4),
        Shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 8)
    ]
    
    static let strong = [
        Shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 4),
        Shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 8),
        Shadow(color: .black.opacity(0.15), radius: 24, x: 0, y: 16)
    ]
    
    struct Shadow {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }
}

// MARK: - Advanced View Modifiers
extension View {
    func advancedShadow(_ shadows: [AdvancedShadow.Shadow]) -> some View {
        self.modifier(AdvancedShadowModifier(shadows: shadows))
    }
    
    func liquidEffect() -> some View {
        self.modifier(LiquidEffectModifier())
    }
    
    func morphingEffect() -> some View {
        self.modifier(MorphingEffectModifier())
    }
}

struct AdvancedShadowModifier: ViewModifier {
    let shadows: [AdvancedShadow.Shadow]
    
    func body(content: Content) -> some View {
        content.background(
            ForEach(Array(shadows.enumerated()), id: \.offset) { _, shadow in
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.clear)
                    .shadow(
                        color: shadow.color,
                        radius: shadow.radius,
                        x: shadow.x,
                        y: shadow.y
                    )
            }
        )
    }
}

struct LiquidEffectModifier: ViewModifier {
    @State private var animate = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(animate ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animate)
            .onAppear {
                animate = true
            }
    }
}

struct MorphingEffectModifier: ViewModifier {
    @State private var morphing = false
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(.degrees(morphing ? 5 : 0), axis: (x: 1, y: 0, z: 0))
            .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: morphing)
            .onAppear {
                morphing = true
            }
    }
}

// MARK: - Enhanced Design System with Apple's Liquid Glass
struct RingDesignSystem {
    // MARK: - Color Schemes
    struct Colors {
        // Primary Colors
        static let primary = Color("PrimaryColor")
        static let secondary = Color("SecondaryColor")
        static let accent = Color("AccentColor")
        
        // Background Colors
        static let background = Color("BackgroundColor")
        static let secondaryBackground = Color("SecondaryBackgroundColor")
        static let tertiaryBackground = Color("TertiaryBackgroundColor")
        
        // Text Colors
        static let primaryText = Color("PrimaryTextColor")
        static let secondaryText = Color("SecondaryTextColor")
        static let tertiaryText = Color("TertiaryTextColor")
        
        // Status Colors
        static let success = Color("SuccessColor")
        static let warning = Color("WarningColor")
        static let error = Color("ErrorColor")
        static let info = Color("InfoColor")
        
        // Gradient Colors
        static let gradientStart = Color("GradientStartColor")
        static let gradientEnd = Color("GradientEndColor")
        static let gradientAccent = Color("GradientAccentColor")
        
        // Glass Colors
        static let glassPrimary = Color("GlassPrimaryColor")
        static let glassSecondary = Color("GlassSecondaryColor")
        static let glassAccent = Color("GlassAccentColor")
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        static let title1 = Font.system(size: 28, weight: .bold, design: .rounded)
        static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
        static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 17, weight: .regular, design: .rounded)
        static let callout = Font.system(size: 16, weight: .regular, design: .rounded)
        static let subheadline = Font.system(size: 15, weight: .regular, design: .rounded)
        static let footnote = Font.system(size: 13, weight: .regular, design: .rounded)
        static let caption1 = Font.system(size: 12, weight: .regular, design: .rounded)
        static let caption2 = Font.system(size: 11, weight: .regular, design: .rounded)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let full: CGFloat = 999
    }
    
    // MARK: - Shadows
    struct Shadows {
        static let small = Shadow(
            color: .black.opacity(0.1),
            radius: 4,
            x: 0,
            y: 2
        )
        
        static let medium = Shadow(
            color: .black.opacity(0.15),
            radius: 8,
            x: 0,
            y: 4
        )
        
        static let large = Shadow(
            color: .black.opacity(0.2),
            radius: 16,
            x: 0,
            y: 8
        )
        
        static let extraLarge = Shadow(
            color: .black.opacity(0.25),
            radius: 24,
            x: 0,
            y: 12
        )
    }
}

// MARK: - Shadow Structure
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Liquid Glass Effects
struct LiquidGlassBackground: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: colorScheme == .dark ? 
                    [Color.black, Color.gray.opacity(0.3)] :
                    [Color.white, Color.gray.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Liquid glass orbs
            ForEach(0..<6) { index in
                LiquidGlassOrb(
                    color: liquidGlassColors[index % liquidGlassColors.count],
                    size: CGFloat.random(in: 60...120),
                    delay: Double(index) * 0.5
                )
            }
            
            // Subtle mesh overlay
            MeshOverlay()
                .opacity(0.1)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
    
    private var liquidGlassColors: [Color] {
        colorScheme == .dark ? 
            [.blue.opacity(0.3), .purple.opacity(0.3), .cyan.opacity(0.3)] :
            [.blue.opacity(0.1), .purple.opacity(0.1), .cyan.opacity(0.1)]
    }
}

struct LiquidGlassOrb: View {
    let color: Color
    let size: CGFloat
    let delay: Double
    
    @State private var animate = false
    @State private var position = CGSize.zero
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [color, color.opacity(0.5), .clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: size / 2
                )
            )
            .frame(width: size, height: size)
            .blur(radius: 20)
            .scaleEffect(animate ? 1.2 : 0.8)
            .opacity(animate ? 0.6 : 0.3)
            .offset(position)
            .onAppear {
                position = CGSize(
                    width: CGFloat.random(in: -150...150),
                    height: CGFloat.random(in: -300...300)
                )
                
                withAnimation(
                    .easeInOut(duration: 6.0)
                    .repeatForever(autoreverses: true)
                    .delay(delay)
                ) {
                    animate = true
                    position = CGSize(
                        width: CGFloat.random(in: -150...150),
                        height: CGFloat.random(in: -300...300)
                    )
                }
            }
    }
}

struct MeshOverlay: View {
    @State private var animate = false
    
    var body: some View {
        Canvas { context, size in
            for i in 0..<8 {
                for j in 0..<8 {
                    let x = size.width * Double(i) / 7
                    let y = size.height * Double(j) / 7
                    let radius = 30.0
                    
                    let color = Color(
                        hue: (Double(i + j) / 16 + animate ? 0.5 : 0.0).truncatingRemainder(dividingBy: 1.0),
                        saturation: 0.3,
                        brightness: 0.8
                    )
                    
                    context.fill(
                        Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)),
                        with: .color(color.opacity(0.1))
                    )
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 10.0).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

// MARK: - Liquid Glass Card
struct LiquidGlassCard<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    let content: Content
    let intensity: CGFloat
    
    init(intensity: CGFloat = 0.1, @ViewBuilder content: () -> Content) {
        self.intensity = intensity
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                            .stroke(
                                colorScheme == .dark ? 
                                    Color.white.opacity(intensity) : 
                                    Color.black.opacity(intensity),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(
                color: colorScheme == .dark ? 
                    Color.black.opacity(0.3) : 
                    Color.black.opacity(0.1),
                radius: 10,
                x: 0,
                y: 5
            )
    }
}

// MARK: - Modern Button Styles
struct ModernButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    let variant: ButtonVariant
    
    enum ButtonVariant {
        case primary, secondary, ghost, danger
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, RingDesignSystem.Spacing.lg)
            .padding(.vertical, RingDesignSystem.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                            .stroke(borderColor, lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .shadow(
                color: shadowColor,
                radius: configuration.isPressed ? 2 : 4,
                x: 0,
                y: configuration.isPressed ? 1 : 2
            )
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
    private var backgroundColor: Color {
        switch variant {
        case .primary:
            return colorScheme == .dark ? .blue : .blue
        case .secondary:
            return colorScheme == .dark ? .gray.opacity(0.3) : .gray.opacity(0.1)
        case .ghost:
            return .clear
        case .danger:
            return colorScheme == .dark ? .red.opacity(0.3) : .red.opacity(0.1)
        }
    }
    
    private var borderColor: Color {
        switch variant {
        case .primary:
            return .blue.opacity(0.3)
        case .secondary:
            return colorScheme == .dark ? .white.opacity(0.2) : .black.opacity(0.1)
        case .ghost:
            return .clear
        case .danger:
            return .red.opacity(0.3)
        }
    }
    
    private var shadowColor: Color {
        colorScheme == .dark ? .black.opacity(0.3) : .black.opacity(0.1)
    }
}

// MARK: - Animated Gradient Text
struct AnimatedGradientText: View {
    let text: String
    let colors: [Color]
    @State private var animate = false
    
    var body: some View {
        Text(text)
            .foregroundStyle(
                LinearGradient(
                    colors: colors,
                    startPoint: animate ? .topLeading : .bottomTrailing,
                    endPoint: animate ? .bottomTrailing : .topLeading
                )
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    animate = true
                }
            }
    }
}

// MARK: - Floating Action Button
struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .fontWeight(.semibold)
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
                        .shadow(
                            color: .blue.opacity(0.4),
                            radius: isPressed ? 8 : 12,
                            x: 0,
                            y: isPressed ? 4 : 6
                        )
                )
                .scaleEffect(isPressed ? 0.9 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - Modern Toggle
struct ModernToggle: View {
    @Binding var isOn: Bool
    let color: Color
    @State private var animate = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isOn.toggle()
            }
            HapticFeedback.impact(style: .light)
        }) {
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 25)
                    .fill(isOn ? color : .gray.opacity(0.3))
                    .frame(width: 51, height: 31)
                
                // Thumb
                Circle()
                    .fill(.white)
                    .frame(width: 27, height: 27)
                    .offset(x: isOn ? 10 : -10)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                    .scaleEffect(animate ? 1.1 : 1.0)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                animate = pressing
            }
        }, perform: {})
    }
}

// MARK: - Progress Ring
struct ProgressRing: View {
    let progress: Double
    let color: Color
    let size: CGFloat
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 8)
                .frame(width: size, height: size)
            
            // Progress ring
            Circle()
                .trim(from: 0, to: animate ? progress : 0)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: animate)
        }
        .onAppear {
            animate = true
        }
    }
}

// MARK: - Shimmer Effect
struct ShimmerEffect: View {
    @State private var animate = false
    
    var body: some View {
        LinearGradient(
            colors: [
                Color.gray.opacity(0.3),
                Color.gray.opacity(0.1),
                Color.gray.opacity(0.3)
            ],
            startPoint: animate ? .leading : .trailing,
            endPoint: animate ? .trailing : .leading
        )
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                animate = true
            }
        }
    }
}

// MARK: - Confetti Effect
struct ConfettiEffect: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<20) { index in
                ConfettiPiece(
                    color: [.blue, .purple, .pink, .orange, .green].randomElement()!,
                    delay: Double(index) * 0.1
                )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct ConfettiPiece: View {
    let color: Color
    let delay: Double
    
    @State private var animate = false
    @State private var position = CGSize.zero
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: 4, height: 8)
            .rotationEffect(.degrees(animate ? 360 : 0))
            .offset(position)
            .onAppear {
                position = CGSize(
                    width: CGFloat.random(in: -100...100),
                    height: -200
                )
                
                withAnimation(
                    .easeOut(duration: 2.0)
                    .delay(delay)
                ) {
                    animate = true
                    position = CGSize(
                        width: CGFloat.random(in: -100...100),
                        height: 400
                    )
                }
            }
    }
}

// MARK: - Morphing Button
struct MorphingButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: RingDesignSystem.Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(RingDesignSystem.Typography.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, RingDesignSystem.Spacing.md)
            .padding(.vertical, RingDesignSystem.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                            .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - Theme Manager
class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool = true
    
    func toggleTheme() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isDarkMode.toggle()
        }
    }
}

// MARK: - Haptic Feedback
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

// MARK: - Extensions
extension View {
    func liquidGlassCard(intensity: CGFloat = 0.1) -> some View {
        self.modifier(LiquidGlassCardModifier(intensity: intensity))
    }
    
    func modernButton(_ variant: ModernButtonStyle.ButtonVariant) -> some View {
        self.buttonStyle(ModernButtonStyle(variant: variant))
    }
    
    func advancedShadow(_ shadow: Shadow) -> some View {
        self.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
}

struct LiquidGlassCardModifier: ViewModifier {
    let intensity: CGFloat
    
    func body(content: Content) -> some View {
        LiquidGlassCard(intensity: intensity) {
            content
        }
    }
}

// MARK: - Color Assets (for reference)
extension Color {
    static let ringPrimary = Color("RingPrimary")
    static let ringSecondary = Color("RingSecondary")
    static let ringAccent = Color("RingAccent")
    static let ringBackground = Color("RingBackground")
    static let ringSurface = Color("RingSurface")
    static let ringText = Color("RingText")
    static let ringTextSecondary = Color("RingTextSecondary")
}

#Preview {
    VStack(spacing: 20) {
        LiquidGlassCard {
            Text("Liquid Glass Card")
                .font(RingDesignSystem.Typography.headline)
        }
        
        Button("Modern Button") {}
            .modernButton(.primary)
        
        ModernToggle(isOn: .constant(true), color: .blue)
        
        ProgressRing(progress: 0.75, color: .blue, size: 60)
    }
    .padding()
    .background(LiquidGlassBackground())
    .preferredColorScheme(.dark)
}