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