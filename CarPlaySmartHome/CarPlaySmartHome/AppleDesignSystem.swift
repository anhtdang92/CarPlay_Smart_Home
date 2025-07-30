import SwiftUI

// MARK: - Apple Design System for CarPlay

struct AppleDesignSystem {
    
    // MARK: - Color System
    
    struct Colors {
        // Apple's Dynamic Colors with Glass Effects
        static let primaryGlass = Color(red: 0.98, green: 0.98, blue: 1.0, opacity: 0.85)
        static let secondaryGlass = Color(red: 0.95, green: 0.95, blue: 0.97, opacity: 0.75)
        static let tertiaryGlass = Color(red: 0.92, green: 0.92, blue: 0.94, opacity: 0.65)
        
        // Accent Colors with Glass Variations
        static let accentBlue = Color(red: 0.0, green: 0.478, blue: 1.0)
        static let accentBlueGlass = Color(red: 0.0, green: 0.478, blue: 1.0, opacity: 0.8)
        static let accentPurple = Color(red: 0.686, green: 0.322, blue: 0.871)
        static let accentPurpleGlass = Color(red: 0.686, green: 0.322, blue: 0.871, opacity: 0.8)
        
        // Status Colors
        static let successGlass = Color(red: 0.298, green: 0.851, blue: 0.392, opacity: 0.8)
        static let warningGlass = Color(red: 1.0, green: 0.584, blue: 0.0, opacity: 0.8)
        static let errorGlass = Color(red: 1.0, green: 0.231, blue: 0.188, opacity: 0.8)
        
        // Adaptive Background System
        static func adaptiveBackground(for colorScheme: ColorScheme) -> Color {
            switch colorScheme {
            case .light:
                return Color(red: 0.98, green: 0.98, blue: 1.0)
            case .dark:
                return Color(red: 0.05, green: 0.05, blue: 0.08)
            @unknown default:
                return Color(red: 0.98, green: 0.98, blue: 1.0)
            }
        }
        
        static func glassOverlay(for colorScheme: ColorScheme) -> Color {
            switch colorScheme {
            case .light:
                return Color.white.opacity(0.7)
            case .dark:
                return Color.white.opacity(0.1)
            @unknown default:
                return Color.white.opacity(0.7)
            }
        }
    }
    
    // MARK: - Typography System
    
    struct Typography {
        // CarPlay-Optimized Typography
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        static let title1 = Font.system(size: 28, weight: .bold, design: .rounded)
        static let title2 = Font.system(size: 22, weight: .bold, design: .rounded)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
        static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let callout = Font.system(size: 16, weight: .regular, design: .default)
        static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
        static let footnote = Font.system(size: 13, weight: .regular, design: .default)
        static let caption1 = Font.system(size: 12, weight: .regular, design: .default)
        static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
        
        // CarPlay-Specific Sizes
        static let carPlayLarge = Font.system(size: 32, weight: .bold, design: .rounded)
        static let carPlayMedium = Font.system(size: 20, weight: .semibold, design: .rounded)
        static let carPlaySmall = Font.system(size: 16, weight: .medium, design: .default)
    }
    
    // MARK: - Spacing System
    
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
        
        // CarPlay-Specific Spacing
        static let carPlayTight: CGFloat = 8
        static let carPlayStandard: CGFloat = 16
        static let carPlayLoose: CGFloat = 24
        static let carPlaySection: CGFloat = 32
    }
    
    // MARK: - Elevation System
    
    enum ElevationLevel {
        case surface
        case low
        case medium
        case high
        case overlay
        
        var shadowRadius: CGFloat {
            switch self {
            case .surface: return 0
            case .low: return 4
            case .medium: return 8
            case .high: return 16
            case .overlay: return 24
            }
        }
        
        var shadowOpacity: Double {
            switch self {
            case .surface: return 0
            case .low: return 0.05
            case .medium: return 0.1
            case .high: return 0.2
            case .overlay: return 0.3
            }
        }
        
        var shadowOffset: CGSize {
            switch self {
            case .surface: return .zero
            case .low: return CGSize(width: 0, height: 2)
            case .medium: return CGSize(width: 0, height: 4)
            case .high: return CGSize(width: 0, height: 8)
            case .overlay: return CGSize(width: 0, height: 12)
            }
        }
    }
    
    // MARK: - Animation System
    
    struct Animations {
        // Apple-like Animation Curves
        static let spring = Animation.interpolatingSpring(stiffness: 300, damping: 30)
        static let snappy = Animation.interpolatingSpring(stiffness: 400, damping: 25)
        static let smooth = Animation.interpolatingSpring(stiffness: 250, damping: 35)
        static let gentle = Animation.interpolatingSpring(stiffness: 200, damping: 40)
        
        // Timing-based Animations
        static let quick = Animation.easeOut(duration: 0.2)
        static let standard = Animation.easeInOut(duration: 0.3)
        static let slow = Animation.easeInOut(duration: 0.5)
        
        // CarPlay-Optimized Animations
        static let carPlayFast = Animation.easeOut(duration: 0.15)
        static let carPlayStandard = Animation.easeInOut(duration: 0.25)
        static let carPlaySlow = Animation.easeInOut(duration: 0.4)
    }
    
    // MARK: - Liquid Glass Material System
    
    struct LiquidGlassMaterial {
        static func primaryGlass(
            cornerRadius: CGFloat = 16,
            elevation: ElevationLevel = .medium
        ) -> some View {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(
                    color: Color.black.opacity(elevation.shadowOpacity),
                    radius: elevation.shadowRadius,
                    x: 0,
                    y: elevation.shadowOffset
                )
        }
        
        static func secondaryGlass(
            cornerRadius: CGFloat = 12,
            elevation: ElevationLevel = .low
        ) -> some View {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.thinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.2),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                )
                .shadow(
                    color: Color.black.opacity(elevation.shadowOpacity * 0.7),
                    radius: elevation.shadowRadius * 0.8,
                    x: 0,
                    y: elevation.shadowOffset * 0.8
                )
        }
        
        static func accentGlass(
            color: Color,
            cornerRadius: CGFloat = 16,
            elevation: ElevationLevel = .medium
        ) -> some View {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    color.opacity(0.3),
                                    color.opacity(0.1),
                                    color.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    color.opacity(0.4),
                                    color.opacity(0.2),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(
                    color: color.opacity(elevation.shadowOpacity * 0.3),
                    radius: elevation.shadowRadius,
                    x: 0,
                    y: elevation.shadowOffset
                )
        }
        
        static func animatedGlass(
            color: Color,
            cornerRadius: CGFloat = 16,
            elevation: ElevationLevel = .medium,
            isAnimating: Bool = false
        ) -> some View {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    color.opacity(isAnimating ? 0.4 : 0.2),
                                    color.opacity(isAnimating ? 0.2 : 0.1),
                                    color.opacity(isAnimating ? 0.1 : 0.05)
                                ],
                                startPoint: isAnimating ? .bottomTrailing : .topLeading,
                                endPoint: isAnimating ? .topLeading : .bottomTrailing
                            )
                        )
                        .animation(
                            .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    color.opacity(isAnimating ? 0.6 : 0.3),
                                    color.opacity(isAnimating ? 0.3 : 0.15),
                                    Color.clear
                                ],
                                startPoint: isAnimating ? .bottomTrailing : .topLeading,
                                endPoint: isAnimating ? .topLeading : .bottomTrailing
                            ),
                            lineWidth: isAnimating ? 2 : 1
                        )
                        .animation(
                            .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                )
                .shadow(
                    color: color.opacity(elevation.shadowOpacity * (isAnimating ? 0.5 : 0.3)),
                    radius: elevation.shadowRadius * (isAnimating ? 1.2 : 1.0),
                    x: 0,
                    y: elevation.shadowOffset
                )
                .animation(
                    .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                    value: isAnimating
                )
        }
    }
    
    // MARK: - Glass Card System
    
    struct GlassCard {
        static func primary(
            cornerRadius: CGFloat = 16,
            elevation: ElevationLevel = .medium
        ) -> some View {
            LiquidGlassMaterial.primaryGlass(
                cornerRadius: cornerRadius,
                elevation: elevation
            )
        }
        
        static func secondary(
            cornerRadius: CGFloat = 12,
            elevation: ElevationLevel = .low
        ) -> some View {
            LiquidGlassMaterial.secondaryGlass(
                cornerRadius: cornerRadius,
                elevation: elevation
            )
        }
        
        static func accent(
            color: Color,
            cornerRadius: CGFloat = 16,
            elevation: ElevationLevel = .medium
        ) -> some View {
            LiquidGlassMaterial.accentGlass(
                color: color,
                cornerRadius: cornerRadius,
                elevation: elevation
            )
        }
        
        static func animated(
            color: Color,
            cornerRadius: CGFloat = 16,
            elevation: ElevationLevel = .medium,
            isAnimating: Bool = false
        ) -> some View {
            LiquidGlassMaterial.animatedGlass(
                color: color,
                cornerRadius: cornerRadius,
                elevation: elevation,
                isAnimating: isAnimating
            )
        }
    }
    
    // MARK: - Glass Overlay System
    
    struct GlassOverlay {
        static func primary(
            cornerRadius: CGFloat = 16
        ) -> some View {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            Color.white.opacity(0.2),
                            lineWidth: 1
                        )
                )
        }
        
        static func secondary(
            cornerRadius: CGFloat = 12
        ) -> some View {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.thinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            Color.white.opacity(0.15),
                            lineWidth: 0.5
                        )
                )
        }
        
        static func accent(
            color: Color,
            cornerRadius: CGFloat = 16
        ) -> some View {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            color.opacity(0.1)
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            color.opacity(0.3),
                            lineWidth: 1
                        )
                )
        }
    }
    
    // MARK: - Glass Background System
    
    struct GlassBackground {
        static func primary() -> some View {
            ZStack {
                Colors.adaptiveBackground(for: .light)
                    .ignoresSafeArea()
                
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.1),
                        Color.clear,
                        Color.white.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
        }
        
        static func accent(color: Color) -> some View {
            ZStack {
                Colors.adaptiveBackground(for: .light)
                    .ignoresSafeArea()
                
                LinearGradient(
                    colors: [
                        color.opacity(0.1),
                        Color.clear,
                        color.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
        }
        
        static func animated(color: Color, isAnimating: Bool = false) -> some View {
            ZStack {
                Colors.adaptiveBackground(for: .light)
                    .ignoresSafeArea()
                
                LinearGradient(
                    colors: [
                        color.opacity(isAnimating ? 0.15 : 0.1),
                        Color.clear,
                        color.opacity(isAnimating ? 0.08 : 0.05)
                    ],
                    startPoint: isAnimating ? .bottomTrailing : .topLeading,
                    endPoint: isAnimating ? .topLeading : .bottomTrailing
                )
                .ignoresSafeArea()
                .animation(
                    .easeInOut(duration: 3.0).repeatForever(autoreverses: true),
                    value: isAnimating
                )
            }
        }
    }
    
    // MARK: - Typography System
    
    struct Typography {
        // CarPlay-Optimized Typography
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        static let title1 = Font.system(size: 28, weight: .bold, design: .rounded)
        static let title2 = Font.system(size: 22, weight: .bold, design: .rounded)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
        static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let callout = Font.system(size: 16, weight: .regular, design: .default)
        static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
        static let footnote = Font.system(size: 13, weight: .regular, design: .default)
        static let caption1 = Font.system(size: 12, weight: .regular, design: .default)
        static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
        
        // CarPlay-Specific Sizes
        static let carPlayLarge = Font.system(size: 32, weight: .bold, design: .rounded)
        static let carPlayMedium = Font.system(size: 20, weight: .semibold, design: .rounded)
        static let carPlaySmall = Font.system(size: 16, weight: .medium, design: .default)
    }
    
    // MARK: - Spacing System
    
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
        
        // CarPlay-Specific Spacing
        static let carPlayTight: CGFloat = 8
        static let carPlayStandard: CGFloat = 16
        static let carPlayLoose: CGFloat = 24
        static let carPlaySection: CGFloat = 32
    }
    
    // MARK: - Elevation System
    
    enum ElevationLevel {
        case surface
        case low
        case medium
        case high
        case overlay
        
        var shadowRadius: CGFloat {
            switch self {
            case .surface: return 0
            case .low: return 4
            case .medium: return 8
            case .high: return 16
            case .overlay: return 24
            }
        }
        
        var shadowOpacity: Double {
            switch self {
            case .surface: return 0
            case .low: return 0.05
            case .medium: return 0.1
            case .high: return 0.2
            case .overlay: return 0.3
            }
        }
        
        var shadowOffset: CGSize {
            switch self {
            case .surface: return .zero
            case .low: return CGSize(width: 0, height: 2)
            case .medium: return CGSize(width: 0, height: 4)
            case .high: return CGSize(width: 0, height: 8)
            case .overlay: return CGSize(width: 0, height: 12)
            }
        }
    }
    
    // MARK: - Animation System
    
    struct Animations {
        // Apple-like Animation Curves
        static let spring = Animation.interpolatingSpring(stiffness: 300, damping: 30)
        static let snappy = Animation.interpolatingSpring(stiffness: 400, damping: 25)
        static let smooth = Animation.interpolatingSpring(stiffness: 250, damping: 35)
        static let gentle = Animation.interpolatingSpring(stiffness: 200, damping: 40)
        
        // Timing-based Animations
        static let quick = Animation.easeOut(duration: 0.2)
        static let standard = Animation.easeInOut(duration: 0.3)
        static let slow = Animation.easeInOut(duration: 0.5)
        
        // CarPlay-Optimized Animations
        static let carPlayFast = Animation.easeOut(duration: 0.15)
        static let carPlayStandard = Animation.easeInOut(duration: 0.25)
        static let carPlaySlow = Animation.easeInOut(duration: 0.4)
    }
}

// MARK: - Liquid Glass Material

struct LiquidGlassMaterial: View {
    let intensity: Double
    let tint: Color
    let cornerRadius: CGFloat
    
    @Environment(\.colorScheme) var colorScheme
    
    init(intensity: Double = 0.8, tint: Color = .clear, cornerRadius: CGFloat = 16) {
        self.intensity = intensity
        self.tint = tint
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        ZStack {
            // Base glass layer
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.ultraThinMaterial)
                .opacity(intensity)
            
            // Gradient overlay for depth
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            AppleDesignSystem.Colors.glassOverlay(for: colorScheme),
                            AppleDesignSystem.Colors.glassOverlay(for: colorScheme).opacity(0.3),
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Tint overlay
            if tint != .clear {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(tint.opacity(0.1))
            }
            
            // Border highlight
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(colorScheme == .dark ? 0.2 : 0.4),
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.5
                )
        }
    }
}

// MARK: - Apple Button Style

struct AppleButtonStyle: ButtonStyle {
    let variant: Variant
    let size: Size
    
    enum Variant {
        case primary, secondary, tertiary, destructive
        
        var backgroundColor: Color {
            switch self {
            case .primary: return AppleDesignSystem.Colors.accentBlue
            case .secondary: return AppleDesignSystem.Colors.secondaryGlass
            case .tertiary: return Color.clear
            case .destructive: return AppleDesignSystem.Colors.errorGlass
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary: return .white
            case .secondary: return .primary
            case .tertiary: return AppleDesignSystem.Colors.accentBlue
            case .destructive: return .white
            }
        }
    }
    
    enum Size {
        case small, medium, large, carPlay
        
        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            case .medium: return EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
            case .large: return EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
            case .carPlay: return EdgeInsets(top: 20, leading: 32, bottom: 20, trailing: 32)
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 12
            case .large: return 16
            case .carPlay: return 20
            }
        }
        
        var font: Font {
            switch self {
            case .small: return AppleDesignSystem.Typography.footnote
            case .medium: return AppleDesignSystem.Typography.body
            case .large: return AppleDesignSystem.Typography.headline
            case .carPlay: return AppleDesignSystem.Typography.carPlayMedium
            }
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .foregroundColor(variant.foregroundColor)
            .padding(size.padding)
            .background(
                Group {
                    if variant == .tertiary {
                        LiquidGlassMaterial(
                            intensity: 0.6,
                            tint: AppleDesignSystem.Colors.accentBlue,
                            cornerRadius: size.cornerRadius
                        )
                    } else {
                        RoundedRectangle(cornerRadius: size.cornerRadius)
                            .fill(variant.backgroundColor)
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: size.cornerRadius)
                    .stroke(Color.white.opacity(0.2), lineWidth: variant == .tertiary ? 1 : 0)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(AppleDesignSystem.Animations.snappy, value: configuration.isPressed)
            .shadow(
                color: Color.black.opacity(configuration.isPressed ? 0.1 : 0.2),
                radius: configuration.isPressed ? 4 : 8,
                x: 0,
                y: configuration.isPressed ? 2 : 4
            )
    }
}

// MARK: - Liquid Glass Card

struct LiquidGlassCard<Content: View>: View {
    let content: Content
    let elevation: AppleDesignSystem.ElevationLevel
    let cornerRadius: CGFloat
    let tint: Color
    
    @State private var isHovered = false
    @Environment(\.colorScheme) var colorScheme
    
    init(
        elevation: AppleDesignSystem.ElevationLevel = .medium,
        cornerRadius: CGFloat = 20,
        tint: Color = .clear,
        @ViewBuilder content: () -> Content
    ) {
        self.elevation = elevation
        self.cornerRadius = cornerRadius
        self.tint = tint
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                LiquidGlassMaterial(
                    intensity: 0.8,
                    tint: tint,
                    cornerRadius: cornerRadius
                )
            )
            .shadow(
                color: Color.black.opacity(elevation.shadowOpacity),
                radius: elevation.shadowRadius,
                x: elevation.shadowOffset.width,
                y: elevation.shadowOffset.height
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(AppleDesignSystem.Animations.smooth, value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

// MARK: - CarPlay Navigation Component

struct CarPlayNavigation: View {
    let title: String
    let subtitle: String?
    let leadingAction: (() -> Void)?
    let trailingAction: (() -> Void)?
    let leadingIcon: String?
    let trailingIcon: String?
    
    @Environment(\.colorScheme) var colorScheme
    
    init(
        title: String,
        subtitle: String? = nil,
        leadingIcon: String? = nil,
        leadingAction: (() -> Void)? = nil,
        trailingIcon: String? = nil,
        trailingAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leadingIcon = leadingIcon
        self.leadingAction = leadingAction
        self.trailingIcon = trailingIcon
        self.trailingAction = trailingAction
    }
    
    var body: some View {
        HStack(spacing: AppleDesignSystem.Spacing.md) {
            // Leading action
            if let leadingIcon = leadingIcon, let leadingAction = leadingAction {
                Button(action: leadingAction) {
                    Image(systemName: leadingIcon)
                        .font(.title2)
                        .foregroundColor(AppleDesignSystem.Colors.accentBlue)
                        .frame(width: 44, height: 44)
                        .background(
                            LiquidGlassMaterial(
                                intensity: 0.6,
                                cornerRadius: 12
                            )
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Title and subtitle
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppleDesignSystem.Typography.carPlayLarge)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(AppleDesignSystem.Typography.carPlaySmall)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Trailing action
            if let trailingIcon = trailingIcon, let trailingAction = trailingAction {
                Button(action: trailingAction) {
                    Image(systemName: trailingIcon)
                        .font(.title2)
                        .foregroundColor(AppleDesignSystem.Colors.accentBlue)
                        .frame(width: 44, height: 44)
                        .background(
                            LiquidGlassMaterial(
                                intensity: 0.6,
                                cornerRadius: 12
                            )
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, AppleDesignSystem.Spacing.carPlayStandard)
        .padding(.vertical, AppleDesignSystem.Spacing.carPlayTight)
        .background(
            LiquidGlassMaterial(
                intensity: 0.9,
                cornerRadius: 0
            )
        )
    }
}

// MARK: - Futuristic Toggle

struct FuturisticToggle: View {
    @Binding var isOn: Bool
    let label: String
    let description: String?
    let accentColor: Color
    
    @State private var isAnimating = false
    
    init(
        _ label: String,
        isOn: Binding<Bool>,
        description: String? = nil,
        accentColor: Color = AppleDesignSystem.Colors.accentBlue
    ) {
        self.label = label
        self._isOn = isOn
        self.description = description
        self.accentColor = accentColor
    }
    
    var body: some View {
        HStack(spacing: AppleDesignSystem.Spacing.md) {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(AppleDesignSystem.Typography.carPlayMedium)
                    .foregroundColor(.primary)
                
                if let description = description {
                    Text(description)
                        .font(AppleDesignSystem.Typography.carPlaySmall)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Futuristic toggle
            Button(action: {
                withAnimation(AppleDesignSystem.Animations.snappy) {
                    isOn.toggle()
                    isAnimating = true
                }
                
                HapticFeedback.toggle(isOn: isOn)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isAnimating = false
                }
            }) {
                ZStack {
                    // Background track
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isOn ? accentColor : Color.secondary.opacity(0.3))
                        .frame(width: 60, height: 32)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
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
                    
                    // Animated glow
                    if isOn {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(accentColor)
                            .frame(width: 60, height: 32)
                            .blur(radius: isAnimating ? 8 : 4)
                            .opacity(isAnimating ? 0.8 : 0.3)
                            .animation(
                                Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                    }
                    
                    // Toggle thumb
                    Circle()
                        .fill(.white)
                        .frame(width: 28, height: 28)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                        .offset(x: isOn ? 14 : -14)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(AppleDesignSystem.Spacing.md)
        .background(
            LiquidGlassMaterial(
                intensity: 0.6,
                tint: isOn ? accentColor : .clear,
                cornerRadius: 16
            )
        )
    }
}

// MARK: - Convenience Extensions

extension View {
    func appleButton(
        variant: AppleButtonStyle.Variant = .primary,
        size: AppleButtonStyle.Size = .medium
    ) -> some View {
        self.buttonStyle(AppleButtonStyle(variant: variant, size: size))
    }
    
    func liquidGlassCard(
        elevation: AppleDesignSystem.ElevationLevel = .medium,
        cornerRadius: CGFloat = 20,
        tint: Color = .clear
    ) -> some View {
        LiquidGlassCard(
            elevation: elevation,
            cornerRadius: cornerRadius,
            tint: tint
        ) {
            self
        }
    }
    
    func carPlayOptimized() -> some View {
        self
            .background(AppleDesignSystem.Colors.adaptiveBackground(for: .light))
            .environment(\.font, AppleDesignSystem.Typography.carPlayMedium)
    }
}