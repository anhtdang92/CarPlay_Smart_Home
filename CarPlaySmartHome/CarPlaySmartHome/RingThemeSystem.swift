import SwiftUI

// MARK: - Advanced Theme System

class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme = .system
    @Published var isDarkMode: Bool = false
    
    static let shared = ThemeManager()
    
    private init() {
        updateTheme()
    }
    
    func updateTheme() {
        switch currentTheme {
        case .light:
            isDarkMode = false
        case .dark:
            isDarkMode = true
        case .system:
            isDarkMode = UIScreen.main.traitCollection.userInterfaceStyle == .dark
        }
    }
    
    func toggleTheme() {
        withAnimation(RingDesignSystem.Animations.smooth) {
            switch currentTheme {
            case .light:
                currentTheme = .dark
            case .dark:
                currentTheme = .system
            case .system:
                currentTheme = .light
            }
            updateTheme()
        }
    }
}

enum AppTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
    
    var icon: String {
        switch self {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        case .system: return "gear"
        }
    }
    
    var description: String {
        switch self {
        case .light: return "Always light appearance"
        case .dark: return "Always dark appearance"
        case .system: return "Follows system setting"
        }
    }
}

// MARK: - Apple-Inspired Color System

struct AppleColors {
    // MARK: - Primary Colors
    static let blue = Color(red: 0.0, green: 0.478, blue: 1.0)
    static let indigo = Color(red: 0.345, green: 0.337, blue: 0.839)
    static let purple = Color(red: 0.686, green: 0.322, blue: 0.871)
    static let pink = Color(red: 1.0, green: 0.176, blue: 0.333)
    static let red = Color(red: 1.0, green: 0.231, blue: 0.188)
    static let orange = Color(red: 1.0, green: 0.584, blue: 0.0)
    static let yellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let green = Color(red: 0.298, green: 0.851, blue: 0.392)
    static let mint = Color(red: 0.0, green: 0.78, blue: 0.745)
    static let teal = Color(red: 0.0, green: 0.478, blue: 0.537)
    static let cyan = Color(red: 0.0, green: 0.478, blue: 1.0)
    
    // MARK: - Semantic Colors
    static let success = green
    static let warning = orange
    static let error = red
    static let info = blue
    
    // MARK: - Adaptive Colors
    static func adaptiveBackground(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 0.98, green: 0.98, blue: 0.98)
        case .dark:
            return Color(red: 0.11, green: 0.11, blue: 0.12)
        @unknown default:
            return Color(red: 0.98, green: 0.98, blue: 0.98)
        }
    }
    
    static func adaptiveSecondaryBackground(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 0.95, green: 0.95, blue: 0.97)
        case .dark:
            return Color(red: 0.15, green: 0.15, blue: 0.16)
        @unknown default:
            return Color(red: 0.95, green: 0.95, blue: 0.97)
        }
    }
    
    static func adaptiveTertiaryBackground(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 0.92, green: 0.92, blue: 0.94)
        case .dark:
            return Color(red: 0.19, green: 0.19, blue: 0.20)
        @unknown default:
            return Color(red: 0.92, green: 0.92, blue: 0.94)
        }
    }
    
    static func adaptiveLabel(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 0.0, green: 0.0, blue: 0.0)
        case .dark:
            return Color(red: 1.0, green: 1.0, blue: 1.0)
        @unknown default:
            return Color(red: 0.0, green: 0.0, blue: 0.0)
        }
    }
    
    static func adaptiveSecondaryLabel(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 0.235, green: 0.235, blue: 0.263)
        case .dark:
            return Color(red: 0.922, green: 0.922, blue: 0.961)
        @unknown default:
            return Color(red: 0.235, green: 0.235, blue: 0.263)
        }
    }
    
    static func adaptiveTertiaryLabel(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 0.235, green: 0.235, blue: 0.263, opacity: 0.6)
        case .dark:
            return Color(red: 0.922, green: 0.922, blue: 0.961, opacity: 0.6)
        @unknown default:
            return Color(red: 0.235, green: 0.235, blue: 0.263, opacity: 0.6)
        }
    }
    
    static func adaptiveSeparator(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 0.235, green: 0.235, blue: 0.263, opacity: 0.2)
        case .dark:
            return Color(red: 0.922, green: 0.922, blue: 0.961, opacity: 0.2)
        @unknown default:
            return Color(red: 0.235, green: 0.235, blue: 0.263, opacity: 0.2)
        }
    }
}

// MARK: - Enhanced Liquid Glass Effects

struct LiquidGlassStyle {
    let blurRadius: CGFloat
    let opacity: Double
    let cornerRadius: CGFloat
    let borderWidth: CGFloat
    let borderColor: Color
    let shadowRadius: CGFloat
    let shadowColor: Color
    let shadowOpacity: Double
    
    static let subtle = LiquidGlassStyle(
        blurRadius: 10,
        opacity: 0.3,
        cornerRadius: 16,
        borderWidth: 0.5,
        borderColor: Color.white.opacity(0.2),
        shadowRadius: 8,
        shadowColor: Color.black,
        shadowOpacity: 0.1
    )
    
    static let medium = LiquidGlassStyle(
        blurRadius: 20,
        opacity: 0.4,
        cornerRadius: 20,
        borderWidth: 1,
        borderColor: Color.white.opacity(0.3),
        shadowRadius: 12,
        shadowColor: Color.black,
        shadowOpacity: 0.15
    )
    
    static let strong = LiquidGlassStyle(
        blurRadius: 30,
        opacity: 0.5,
        cornerRadius: 24,
        borderWidth: 1.5,
        borderColor: Color.white.opacity(0.4),
        shadowRadius: 16,
        shadowColor: Color.black,
        shadowOpacity: 0.2
    )
    
    static let premium = LiquidGlassStyle(
        blurRadius: 40,
        opacity: 0.6,
        cornerRadius: 28,
        borderWidth: 2,
        borderColor: Color.white.opacity(0.5),
        shadowRadius: 20,
        shadowColor: Color.black,
        shadowOpacity: 0.25
    )
}

struct EnhancedLiquidGlassModifier: ViewModifier {
    let style: LiquidGlassStyle
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Blur background
                    BlurView(style: colorScheme == .dark ? .systemUltraThinMaterialDark : .systemUltraThinMaterialLight)
                        .opacity(style.opacity)
                    
                    // Gradient overlay
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.1),
                            Color.white.opacity(0.05),
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .stroke(style.borderColor, lineWidth: style.borderWidth)
            )
            .shadow(
                color: style.shadowColor.opacity(style.shadowOpacity),
                radius: style.shadowRadius,
                x: 0,
                y: style.shadowRadius / 2
            )
    }
}

// MARK: - Apple-Style Blur View

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        // No updates needed
    }
}

// MARK: - Theme-Aware Components

struct ThemeAwareCard<Content: View>: View {
    let content: Content
    let style: CardStyle
    @Environment(\.colorScheme) var colorScheme
    @State private var isPressed = false
    @State private var isHovered = false
    
    enum CardStyle {
        case elevated, glass, gradient, minimal, premium
        
        var liquidGlassStyle: LiquidGlassStyle {
            switch self {
            case .elevated: return .medium
            case .glass: return .strong
            case .gradient: return .premium
            case .minimal: return .subtle
            case .premium: return .premium
            }
        }
    }
    
    init(style: CardStyle = .elevated, @ViewBuilder content: () -> Content) {
        self.style = style
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(RingDesignSystem.Spacing.lg)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: style.liquidGlassStyle.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: style.liquidGlassStyle.cornerRadius)
                    .stroke(borderColor, lineWidth: style.liquidGlassStyle.borderWidth)
            )
            .shadow(
                color: shadowColor,
                radius: style.liquidGlassStyle.shadowRadius + (isHovered ? 4 : 0),
                x: 0,
                y: (style.liquidGlassStyle.shadowRadius / 2) + (isHovered ? 2 : 0)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(RingDesignSystem.Animations.quick, value: isPressed)
            .animation(RingDesignSystem.Animations.gentle, value: isHovered)
            .onTapGesture {
                withAnimation(RingDesignSystem.Animations.quick) {
                    isPressed = true
                }
                RingDesignSystem.Haptics.light()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(RingDesignSystem.Animations.quick) {
                        isPressed = false
                    }
                }
            }
            .onHover { hovering in
                isHovered = hovering
            }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .elevated:
            AppleColors.adaptiveBackground(for: colorScheme)
        case .glass:
            BlurView(style: colorScheme == .dark ? .systemUltraThinMaterialDark : .systemUltraThinMaterialLight)
                .opacity(0.8)
        case .gradient:
            LinearGradient(
                colors: gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .minimal:
            AppleColors.adaptiveSecondaryBackground(for: colorScheme)
        case .premium:
            ZStack {
                BlurView(style: colorScheme == .dark ? .systemUltraThinMaterialDark : .systemUltraThinMaterialLight)
                LinearGradient(
                    colors: [
                        AppleColors.blue.opacity(0.1),
                        AppleColors.purple.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
    
    private var gradientColors: [Color] {
        switch colorScheme {
        case .light:
            return [
                AppleColors.blue.opacity(0.1),
                AppleColors.purple.opacity(0.05),
                AppleColors.adaptiveBackground(for: colorScheme)
            ]
        case .dark:
            return [
                AppleColors.blue.opacity(0.2),
                AppleColors.purple.opacity(0.1),
                AppleColors.adaptiveBackground(for: colorScheme)
            ]
        @unknown default:
            return [AppleColors.adaptiveBackground(for: colorScheme)]
        }
    }
    
    private var borderColor: Color {
        switch colorScheme {
        case .light:
            return AppleColors.adaptiveSeparator(for: colorScheme)
        case .dark:
            return Color.white.opacity(0.1)
        @unknown default:
            return AppleColors.adaptiveSeparator(for: colorScheme)
        }
    }
    
    private var shadowColor: Color {
        switch colorScheme {
        case .light:
            return Color.black.opacity(0.1)
        case .dark:
            return Color.black.opacity(0.3)
        @unknown default:
            return Color.black.opacity(0.1)
        }
    }
}

// MARK: - Theme Toggle Component

struct ThemeToggleView: View {
    @ObservedObject var themeManager = ThemeManager.shared
    @State private var isRotating = false
    
    var body: some View {
        ThemeAwareCard(style: .glass) {
            VStack(spacing: RingDesignSystem.Spacing.md) {
                HStack {
                    Text("Appearance")
                        .font(RingDesignSystem.Typography.headline)
                        .foregroundColor(AppleColors.adaptiveLabel(for: themeManager.isDarkMode ? .dark : .light))
                    
                    Spacer()
                    
                    Button {
                        themeManager.toggleTheme()
                        RingDesignSystem.Haptics.medium()
                    } label: {
                        Image(systemName: themeManager.currentTheme.icon)
                            .font(.title2)
                            .foregroundColor(AppleColors.blue)
                            .rotationEffect(.degrees(isRotating ? 360 : 0))
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatCount(1, autoreverses: false),
                                value: isRotating
                            )
                    }
                    .onTapGesture {
                        isRotating = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            isRotating = false
                        }
                    }
                }
                
                VStack(spacing: RingDesignSystem.Spacing.sm) {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        ThemeOptionRow(
                            theme: theme,
                            isSelected: themeManager.currentTheme == theme
                        ) {
                            withAnimation(RingDesignSystem.Animations.smooth) {
                                themeManager.currentTheme = theme
                                themeManager.updateTheme()
                            }
                            RingDesignSystem.Haptics.light()
                        }
                    }
                }
            }
        }
    }
}

struct ThemeOptionRow: View {
    let theme: AppTheme
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: RingDesignSystem.Spacing.md) {
                Image(systemName: theme.icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? AppleColors.blue : AppleColors.adaptiveSecondaryLabel(for: colorScheme))
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(theme.rawValue)
                        .font(RingDesignSystem.Typography.subheadline)
                        .fontWeight(isSelected ? .semibold : .regular)
                        .foregroundColor(AppleColors.adaptiveLabel(for: colorScheme))
                    
                    Text(theme.description)
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(AppleColors.adaptiveTertiaryLabel(for: colorScheme))
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(AppleColors.blue)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(RingDesignSystem.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                    .fill(isSelected ? AppleColors.blue.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Enhanced View Modifiers

extension View {
    func enhancedLiquidGlass(_ style: LiquidGlassStyle = .medium) -> some View {
        modifier(EnhancedLiquidGlassModifier(style: style))
    }
    
    func themeAwareBackground() -> some View {
        self.background(
            AppleColors.adaptiveBackground(for: ThemeManager.shared.isDarkMode ? .dark : .light)
                .ignoresSafeArea()
        )
    }
    
    func appleStyleCard(_ style: ThemeAwareCard<AnyView>.CardStyle = .elevated) -> some View {
        ThemeAwareCard(style: style) {
            AnyView(self)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: RingDesignSystem.Spacing.lg) {
        ThemeToggleView()
        
        ThemeAwareCard(style: .premium) {
            VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
                Text("Premium Card")
                    .font(RingDesignSystem.Typography.headline)
                
                Text("This card uses Apple-inspired design with liquid glass effects and adaptive theming.")
                    .font(RingDesignSystem.Typography.body)
            }
        }
        
        ThemeAwareCard(style: .glass) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(AppleColors.yellow)
                Text("Glass Effect Card")
                    .font(RingDesignSystem.Typography.subheadline)
            }
        }
    }
    .padding()
    .themeAwareBackground()
} 