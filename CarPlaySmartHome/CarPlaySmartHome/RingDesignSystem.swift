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
        static let title1 = Font.system(.title, design: .rounded, weight: .semibold)
        static let title2 = Font.system(.title2, design: .rounded, weight: .semibold)
        static let title3 = Font.system(.title3, design: .rounded, weight: .medium)
        static let headline = Font.system(.headline, design: .rounded, weight: .semibold)
        static let subheadline = Font.system(.subheadline, design: .rounded, weight: .medium)
        static let body = Font.system(.body, design: .default, weight: .regular)
        static let callout = Font.system(.callout, design: .default, weight: .regular)
        static let footnote = Font.system(.footnote, design: .default, weight: .regular)
        static let caption1 = Font.system(.caption, design: .default, weight: .regular)
        static let caption2 = Font.system(.caption2, design: .default, weight: .regular)
        
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
        
        struct ShadowStyle {
            let color: Color
            let radius: CGFloat
            let x: CGFloat
            let y: CGFloat
        }
    }
    
    // MARK: - Animations
    
    struct Animations {
        static let quick = Animation.easeInOut(duration: 0.2)
        static let smooth = Animation.easeInOut(duration: 0.3)
        static let gentle = Animation.easeInOut(duration: 0.5)
        static let dramatic = Animation.easeInOut(duration: 0.8)
        
        static let spring = Animation.interpolatingSpring(
            mass: 1.0,
            stiffness: 100,
            damping: 10,
            initialVelocity: 0
        )
        
        static let bouncy = Animation.interpolatingSpring(
            mass: 0.8,
            stiffness: 120,
            damping: 8,
            initialVelocity: 0
        )
        
        static let snappy = Animation.interpolatingSpring(
            mass: 0.5,
            stiffness: 150,
            damping: 12,
            initialVelocity: 0
        )
    }
    
    // MARK: - Haptic Feedback
    
    struct Haptics {
        
        static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        }
        
        static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(type)
        }
        
        static func selection() {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
        
        // Convenience methods
        static func light() { impact(.light) }
        static func medium() { impact(.medium) }
        static func heavy() { impact(.heavy) }
        static func success() { notification(.success) }
        static func warning() { notification(.warning) }
        static func error() { notification(.error) }
    }
}

// MARK: - View Modifiers

@available(iOS 15.0, *)
extension View {
    
    // MARK: - Liquid Glass Effect
    
    func liquidGlass(
        style: RingDesignSystem.LiquidGlass.Style = .regular,
        cornerRadius: CGFloat = RingDesignSystem.CornerRadius.md
    ) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
    }
    
    // MARK: - Ring Card Style
    
    func ringCard(
        cornerRadius: CGFloat = RingDesignSystem.CornerRadius.lg,
        shadow: RingDesignSystem.Shadow.ShadowStyle = RingDesignSystem.Shadow.soft,
        padding: CGFloat = RingDesignSystem.Spacing.md
    ) -> some View {
        self
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(RingDesignSystem.Colors.Background.secondary)
                    .shadow(
                        color: shadow.color,
                        radius: shadow.radius,
                        x: shadow.x,
                        y: shadow.y
                    )
            )
    }
    
    // MARK: - Ring Button Style
    
    func ringButton(
        style: RingButtonStyle = .primary,
        size: RingButtonSize = .medium
    ) -> some View {
        self
            .font(size.font)
            .foregroundColor(style.foregroundColor)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background(
                RoundedRectangle(cornerRadius: size.cornerRadius)
                    .fill(style.backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: size.cornerRadius)
                            .stroke(style.borderColor, lineWidth: style.borderWidth)
                    )
            )
    }
    
    // MARK: - Status Indicator
    
    func ringStatusIndicator(
        status: DeviceStatus,
        size: CGFloat = 8
    ) -> some View {
        self
            .overlay(
                Circle()
                    .fill(status.color)
                    .frame(width: size, height: size)
                    .overlay(
                        Circle()
                            .stroke(RingDesignSystem.Colors.Background.primary, lineWidth: 2)
                    ),
                alignment: .topTrailing
            )
    }
    
    // MARK: - Shimmer Effect
    
    func shimmer(active: Bool = true) -> some View {
        self
            .overlay(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0),
                                Color.white.opacity(0.3),
                                Color.white.opacity(0)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(x: active ? 1 : 0, anchor: .leading)
                    .animation(
                        active ? 
                        Animation.linear(duration: 1.5).repeatForever(autoreverses: false) :
                        .default,
                        value: active
                    )
                    .clipped()
            )
            .clipped()
    }
    
    // MARK: - Pulsing Animation
    
    func pulse(active: Bool = true, scale: CGFloat = 1.05) -> some View {
        self
            .scaleEffect(active ? scale : 1.0)
            .animation(
                active ?
                Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true) :
                .default,
                value: active
            )
    }
    
    // MARK: - Breathing Animation
    
    func breathe(active: Bool = true) -> some View {
        self
            .opacity(active ? 0.6 : 1.0)
            .animation(
                active ?
                Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true) :
                .default,
                value: active
            )
    }
    
    // MARK: - Tap Feedback
    
    func onTapWithFeedback(
        haptic: UIImpactFeedbackGenerator.FeedbackStyle = .light,
        perform action: @escaping () -> Void
    ) -> some View {
        self
            .onTapGesture {
                RingDesignSystem.Haptics.impact(haptic)
                action()
            }
    }
}

// MARK: - Button Styles

@available(iOS 15.0, *)
enum RingButtonStyle {
    case primary, secondary, tertiary, destructive, success, warning
    
    var backgroundColor: Color {
        switch self {
        case .primary: return RingDesignSystem.Colors.ringBlue
        case .secondary: return RingDesignSystem.Colors.Background.secondary
        case .tertiary: return Color.clear
        case .destructive: return RingDesignSystem.Colors.ringRed
        case .success: return RingDesignSystem.Colors.ringGreen
        case .warning: return RingDesignSystem.Colors.ringOrange
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .primary, .destructive, .success, .warning: return .white
        case .secondary, .tertiary: return RingDesignSystem.Colors.Foreground.primary
        }
    }
    
    var borderColor: Color {
        switch self {
        case .primary, .destructive, .success, .warning: return Color.clear
        case .secondary: return RingDesignSystem.Colors.Separator.primary
        case .tertiary: return RingDesignSystem.Colors.ringBlue
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .tertiary: return 1
        default: return 0
        }
    }
}

@available(iOS 15.0, *)
enum RingButtonSize {
    case small, medium, large
    
    var font: Font {
        switch self {
        case .small: return RingDesignSystem.Typography.caption1
        case .medium: return RingDesignSystem.Typography.callout
        case .large: return RingDesignSystem.Typography.headline
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .small: return RingDesignSystem.Spacing.sm
        case .medium: return RingDesignSystem.Spacing.md
        case .large: return RingDesignSystem.Spacing.lg
        }
    }
    
    var verticalPadding: CGFloat {
        switch self {
        case .small: return RingDesignSystem.Spacing.xs
        case .medium: return RingDesignSystem.Spacing.sm
        case .large: return RingDesignSystem.Spacing.md
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .small: return RingDesignSystem.CornerRadius.xs
        case .medium: return RingDesignSystem.CornerRadius.sm
        case .large: return RingDesignSystem.CornerRadius.md
        }
    }
}

// MARK: - Liquid Glass Style Extensions

@available(iOS 15.0, *)
extension RingDesignSystem.LiquidGlass {
    enum Style {
        case ultraThin, thin, regular, thick, ultraThick
        
        var material: Material {
            switch self {
            case .ultraThin: return .ultraThinMaterial
            case .thin: return .thinMaterial
            case .regular: return .regularMaterial
            case .thick: return .thickMaterial
            case .ultraThick: return .ultraThickMaterial
            }
        }
        
        var opacity: Double {
            switch self {
            case .ultraThin: return 0.1
            case .thin: return 0.2
            case .regular: return 0.3
            case .thick: return 0.4
            case .ultraThick: return 0.6
            }
        }
    }
}

// MARK: - Device Status Extensions

extension DeviceStatus {
    var color: Color {
        switch self {
        case .on, .open: return RingDesignSystem.Colors.DeviceStatus.online
        case .off, .closed: return RingDesignSystem.Colors.DeviceStatus.offline
        case .unknown: return RingDesignSystem.Colors.DeviceStatus.unknown
        }
    }
    
    var iconName: String {
        switch self {
        case .on: return "power"
        case .off: return "power"
        case .open: return "lock.open"
        case .closed: return "lock"
        case .unknown: return "questionmark"
        }
    }
}

// MARK: - Alert Type Extensions

extension MotionAlert.AlertType {
    var color: Color {
        switch self {
        case .motion: return RingDesignSystem.Colors.ringOrange
        case .person: return RingDesignSystem.Colors.ringBlue
        case .vehicle: return RingDesignSystem.Colors.ringPurple
        case .package: return RingDesignSystem.Colors.ringGreen
        case .doorbell: return RingDesignSystem.Colors.ringYellow
        }
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
}