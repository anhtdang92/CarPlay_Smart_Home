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

// MARK: - Modern Theme System
struct RingThemeSystem: View {
    @StateObject private var themeManager = ThemeManager()
    @Environment(\.colorScheme) var colorScheme
    @State private var showThemeMenu = false
    @State private var animateTheme = false
    
    var body: some View {
        ZStack {
            // Liquid glass background
            LiquidGlassBackground()
            
            VStack(spacing: RingDesignSystem.Spacing.xl) {
                // Theme header
                ThemeHeader()
                    .offset(y: animateTheme ? 0 : -30)
                    .opacity(animateTheme ? 1 : 0)
                
                // Theme switcher
                ModernThemeSwitcher(themeManager: themeManager)
                    .offset(y: animateTheme ? 0 : 30)
                    .opacity(animateTheme ? 1 : 0)
                
                // Theme options
                ThemeOptionsGrid(themeManager: themeManager)
                    .offset(y: animateTheme ? 0 : 50)
                    .opacity(animateTheme ? 1 : 0)
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                animateTheme = true
            }
        }
    }
}

// MARK: - Theme Header
struct ThemeHeader: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var animateIcon = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.md) {
            // Animated theme icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: colorScheme == .dark ? 
                                [.blue, .purple, .pink] :
                                [.blue, .cyan, .green],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(
                        color: .blue.opacity(0.4),
                        radius: 20,
                        x: 0,
                        y: 10
                    )
                
                Image(systemName: "paintbrush.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(animateIcon ? 360 : 0))
            }
            
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                AnimatedGradientText(
                    text: "Theme Settings",
                    colors: colorScheme == .dark ? 
                        [.white, .blue, .purple] :
                        [.black, .blue, .cyan]
                )
                .font(RingDesignSystem.Typography.title1)
                
                Text("Customize your smart home experience")
                    .font(RingDesignSystem.Typography.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
                animateIcon = true
            }
        }
    }
}

// MARK: - Modern Theme Switcher
struct ModernThemeSwitcher: View {
    @ObservedObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme
    @State private var animateSwitch = false
    
    var body: some View {
        LiquidGlassCard(intensity: 0.15) {
            VStack(spacing: RingDesignSystem.Spacing.lg) {
                HStack {
                    VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.sm) {
                        Text("App Theme")
                            .font(RingDesignSystem.Typography.headline)
                            .fontWeight(.semibold)
                        
                        Text("Switch between light and dark modes")
                            .font(RingDesignSystem.Typography.footnote)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Modern toggle switch
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    colors: colorScheme == .dark ? 
                                        [.gray.opacity(0.3), .gray.opacity(0.1)] :
                                        [.gray.opacity(0.2), .gray.opacity(0.1)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 60, height: 32)
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 28, height: 28)
                            .shadow(
                                color: .black.opacity(0.2),
                                radius: 4,
                                x: 0,
                                y: 2
                            )
                            .offset(x: colorScheme == .dark ? 14 : -14)
                            .scaleEffect(animateSwitch ? 1.1 : 1.0)
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            themeManager.toggleTheme()
                        }
                        HapticFeedback.impact(style: .light)
                    }
                }
                
                // Theme preview
                HStack(spacing: RingDesignSystem.Spacing.md) {
                    ThemePreviewCard(
                        title: "Light",
                        icon: "sun.max.fill",
                        color: .orange,
                        isActive: colorScheme == .light
                    )
                    
                    ThemePreviewCard(
                        title: "Dark",
                        icon: "moon.fill",
                        color: .purple,
                        isActive: colorScheme == .dark
                    )
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                animateSwitch = true
            }
        }
    }
}

struct ThemePreviewCard: View {
    let title: String
    let icon: String
    let color: Color
    let isActive: Bool
    
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.sm) {
            ZStack {
                Circle()
                    .fill(color.opacity(isActive ? 0.3 : 0.1))
                    .frame(width: 50, height: 50)
                    .scaleEffect(animate ? 1.1 : 1.0)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(color)
                    .rotationEffect(.degrees(animate ? 360 : 0))
            }
            
            Text(title)
                .font(RingDesignSystem.Typography.caption1)
                .fontWeight(.medium)
                .foregroundColor(isActive ? color : .secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, RingDesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                        .stroke(
                            isActive ? color.opacity(0.5) : Color.clear,
                            lineWidth: 2
                        )
                )
        )
        .onAppear {
            if isActive {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    animate = true
                }
            }
        }
    }
}

// MARK: - Theme Options Grid
struct ThemeOptionsGrid: View {
    @ObservedObject var themeManager: ThemeManager
    @State private var animateGrid = false
    
    private let themeOptions = [
        ThemeOption(
            title: "Classic",
            description: "Traditional iOS design",
            icon: "iphone",
            colors: [.blue, .gray]
        ),
        ThemeOption(
            title: "Vibrant",
            description: "Bold and colorful",
            icon: "paintpalette.fill",
            colors: [.purple, .pink, .orange]
        ),
        ThemeOption(
            title: "Minimal",
            description: "Clean and simple",
            icon: "circle.grid.2x2",
            colors: [.gray, .black]
        ),
        ThemeOption(
            title: "Nature",
            description: "Earth-inspired tones",
            icon: "leaf.fill",
            colors: [.green, .brown]
        ),
        ThemeOption(
            title: "Ocean",
            description: "Deep blue themes",
            icon: "drop.fill",
            colors: [.blue, .cyan]
        ),
        ThemeOption(
            title: "Sunset",
            description: "Warm gradients",
            icon: "sunset.fill",
            colors: [.orange, .red, .pink]
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Theme Presets")
                .font(RingDesignSystem.Typography.title3)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: RingDesignSystem.Spacing.md), count: 2), spacing: RingDesignSystem.Spacing.md) {
                ForEach(Array(themeOptions.enumerated()), id: \.offset) { index, option in
                    ThemeOptionCard(option: option)
                        .offset(y: animateGrid ? 0 : 50)
                        .opacity(animateGrid ? 1 : 0)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.8)
                            .delay(Double(index) * 0.1),
                            value: animateGrid
                        )
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3)) {
                animateGrid = true
            }
        }
    }
}

struct ThemeOption: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let colors: [Color]
}

struct ThemeOptionCard: View {
    let option: ThemeOption
    @State private var isPressed = false
    @State private var animate = false
    
    var body: some View {
        Button(action: {
            // Apply theme
            HapticFeedback.impact(style: .light)
        }) {
            VStack(spacing: RingDesignSystem.Spacing.md) {
                // Gradient icon background
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: option.colors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .scaleEffect(animate ? 1.1 : 1.0)
                    
                    Image(systemName: option.icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(animate ? 360 : 0))
                }
                
                VStack(spacing: RingDesignSystem.Spacing.xs) {
                    Text(option.title)
                        .font(RingDesignSystem.Typography.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(option.description)
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, RingDesignSystem.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                            .stroke(
                                LinearGradient(
                                    colors: option.colors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ).opacity(0.3),
                                lineWidth: 1
                            )
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
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

// MARK: - Advanced Theme Components
struct AdvancedThemeSwitcher: View {
    @ObservedObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme
    @State private var dragOffset = CGSize.zero
    @State private var isDragging = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.lg) {
            // Theme indicator
            HStack {
                ThemeIndicator(
                    icon: "sun.max.fill",
                    color: .orange,
                    isActive: colorScheme == .light
                )
                
                Spacer()
                
                // Draggable theme switch
                ZStack {
                    // Background track
                    RoundedRectangle(cornerRadius: 30)
                        .fill(
                            LinearGradient(
                                colors: colorScheme == .dark ? 
                                    [.gray.opacity(0.4), .gray.opacity(0.2)] :
                                    [.gray.opacity(0.3), .gray.opacity(0.1)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 80, height: 40)
                    
                    // Draggable thumb
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.white, .gray.opacity(0.1)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 36, height: 36)
                        .shadow(
                            color: .black.opacity(0.2),
                            radius: 6,
                            x: 0,
                            y: 3
                        )
                        .offset(x: colorScheme == .dark ? 22 : -22)
                        .offset(dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDragging = true
                                    dragOffset = value.translation
                                }
                                .onEnded { value in
                                    isDragging = false
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                        dragOffset = .zero
                                        themeManager.toggleTheme()
                                    }
                                    HapticFeedback.impact(style: .medium)
                                }
                        )
                        .scaleEffect(isDragging ? 1.1 : 1.0)
                }
                
                Spacer()
                
                ThemeIndicator(
                    icon: "moon.fill",
                    color: .purple,
                    isActive: colorScheme == .dark
                )
            }
            
            // Theme description
            Text(colorScheme == .dark ? "Dark mode active" : "Light mode active")
                .font(RingDesignSystem.Typography.caption1)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct ThemeIndicator: View {
    let icon: String
    let color: Color
    let isActive: Bool
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(isActive ? 0.3 : 0.1))
                .frame(width: 40, height: 40)
                .scaleEffect(animate ? 1.2 : 1.0)
            
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .rotationEffect(.degrees(animate ? 360 : 0))
        }
        .onAppear {
            if isActive {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    animate = true
                }
            }
        }
    }
}

// MARK: - Theme Preview
struct ThemePreview: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.md) {
            // Preview header
            HStack {
                Text("Preview")
                    .font(RingDesignSystem.Typography.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(colorScheme == .dark ? "Dark" : "Light")
                    .font(RingDesignSystem.Typography.caption1)
                    .padding(.horizontal, RingDesignSystem.Spacing.sm)
                    .padding(.vertical, RingDesignSystem.Spacing.xs)
                    .background(
                        Capsule()
                            .fill(colorScheme == .dark ? .purple.opacity(0.3) : .orange.opacity(0.3))
                    )
            }
            
            // Preview content
            HStack(spacing: RingDesignSystem.Spacing.md) {
                // Sample card
                VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.sm) {
                    Circle()
                        .fill(.blue)
                        .frame(width: 40, height: 40)
                    
                    Text("Sample Card")
                        .font(RingDesignSystem.Typography.subheadline)
                        .fontWeight(.medium)
                    
                    Text("This is how content will look")
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                        .fill(.ultraThinMaterial)
                )
                
                // Sample button
                Button("Sample") {}
                    .modernButton(.primary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                .fill(.ultraThinMaterial)
        )
    }
}

#Preview {
    RingThemeSystem()
        .preferredColorScheme(.dark)
} 