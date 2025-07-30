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
    
    // MARK: - Enhanced Advanced Animation System
    
    struct Animations {
        // Apple-like Animation Curves with Enhanced Physics
        static let spring = Animation.interpolatingSpring(stiffness: 300, damping: 30, mass: 1.0)
        static let snappy = Animation.interpolatingSpring(stiffness: 400, damping: 25, mass: 0.8)
        static let smooth = Animation.interpolatingSpring(stiffness: 250, damping: 35, mass: 1.2)
        static let gentle = Animation.interpolatingSpring(stiffness: 200, damping: 40, mass: 1.5)
        static let bouncy = Animation.interpolatingSpring(stiffness: 500, damping: 20, mass: 0.6)
        static let elastic = Animation.interpolatingSpring(stiffness: 600, damping: 15, mass: 0.4)
        
        // Enhanced Timing-based Animations
        static let quick = Animation.easeOut(duration: 0.2)
        static let standard = Animation.easeInOut(duration: 0.3)
        static let slow = Animation.easeInOut(duration: 0.5)
        static let verySlow = Animation.easeInOut(duration: 0.8)
        
        // CarPlay-Optimized Animations
        static let carPlayFast = Animation.easeOut(duration: 0.15)
        static let carPlayStandard = Animation.easeInOut(duration: 0.25)
        static let carPlaySlow = Animation.easeInOut(duration: 0.4)
        
        // Advanced Animation Curves
        static let easeInBack = Animation.easeIn(duration: 0.3)
        static let easeOutBack = Animation.easeOut(duration: 0.3)
        static let easeInOutBack = Animation.easeInOut(duration: 0.4)
        
        // Staggered Animation Delays
        static func staggered(delay: Double = 0.1) -> Animation {
            .easeInOut(duration: 0.3).delay(delay)
        }
        
        // Breathing Animation
        static let breathing = Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)
        
        // Pulse Animation
        static let pulse = Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
        
        // Shimmer Animation
        static let shimmer = Animation.linear(duration: 1.5).repeatForever(autoreverses: false)
        
        // Morphing Animation
        static let morphing = Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true)
        
        // Floating Animation
        static let floating = Animation.easeInOut(duration: 4.0).repeatForever(autoreverses: true)
        
        // Rotation Animation
        static let rotation = Animation.linear(duration: 20.0).repeatForever(autoreverses: false)
        
        // Scale Animation
        static let scale = Animation.interpolatingSpring(stiffness: 300, damping: 30).repeatForever(autoreverses: true)
        
        // Opacity Animation
        static let fade = Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)
        
        // Performance-Optimized Animations
        static let optimized = Animation.easeInOut(duration: 0.25)
        static let reducedMotion = Animation.easeInOut(duration: 0.1)
        
        // Accessibility-Aware Animations
        static func accessibilityAware() -> Animation {
            if UIAccessibility.isReduceMotionEnabled {
                return reducedMotion
            } else {
                return optimized
            }
        }
        
        // Battery-Aware Animations
        static func batteryAware() -> Animation {
            // Reduce animation complexity when battery is low
            return optimized
        }
        
        // Enhanced Performance-Aware Animations
        static func performanceAware() -> Animation {
            if AnimationPerformanceMonitor.currentComplexityLevel == .minimal {
                return reducedMotion
            } else {
                return optimized
            }
        }
        
        // Advanced Staggered Animations
        static func staggeredEntrance(delay: Double = 0.1, duration: Double = 0.3) -> Animation {
            .easeInOut(duration: duration).delay(delay)
        }
        
        // Elastic Bounce Animations
        static let elasticBounce = Animation.interpolatingSpring(
            mass: 0.3,
            stiffness: 200,
            damping: 8,
            initialVelocity: 0
        )
        
        // Smooth Morphing Animations
        static let smoothMorph = Animation.interpolatingSpring(
            mass: 1.2,
            stiffness: 150,
            damping: 25,
            initialVelocity: 0
        )
        
        // Quick Response Animations
        static let quickResponse = Animation.interpolatingSpring(
            mass: 0.8,
            stiffness: 400,
            damping: 20,
            initialVelocity: 0
        )
        
        // Gentle Float Animations
        static let gentleFloat = Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true)
        
        // Energy Field Animations
        static let energyField = Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: true)
        
        // Particle System Animations
        static let particleSystem = Animation.linear(duration: 4.0).repeatForever(autoreverses: false)
        
        // Liquid Morphing Animations
        static let liquidMorph = Animation.interpolatingSpring(
            mass: 1.5,
            stiffness: 100,
            damping: 30,
            initialVelocity: 0
        )
        
        // Magnetic Pull Animations
        static let magneticPull = Animation.interpolatingSpring(
            mass: 0.6,
            stiffness: 300,
            damping: 15,
            initialVelocity: 0
        )
        
        // Holographic Effect Animations
        static let holographic = Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)
        
        // Neural Network Animations
        static let neuralNetwork = Animation.easeInOut(duration: 1.8).repeatForever(autoreverses: true)
        
        // Quantum State Animations
        static let quantumState = Animation.interpolatingSpring(
            mass: 0.4,
            stiffness: 250,
            damping: 12,
            initialVelocity: 0
        )
    }
    
    // MARK: - Enhanced Advanced Animation Modifiers
    
    struct AnimationModifiers {
        // Staggered Entrance Animation
        static func staggeredEntrance(delay: Double = 0.1) -> some ViewModifier {
            StaggeredEntranceModifier(delay: delay)
        }
        
        // Breathing Effect
        static func breathing() -> some ViewModifier {
            BreathingModifier()
        }
        
        // Pulse Effect
        static func pulse() -> some ViewModifier {
            PulseModifier()
        }
        
        // Shimmer Effect
        static func shimmer() -> some ViewModifier {
            ShimmerModifier()
        }
        
        // Floating Effect
        static func floating() -> some ViewModifier {
            FloatingModifier()
        }
        
        // Morphing Effect
        static func morphing() -> some ViewModifier {
            MorphingModifier()
        }
        
        // Scale Effect
        static func scale() -> some ViewModifier {
            ScaleModifier()
        }
        
        // Fade Effect
        static func fade() -> some ViewModifier {
            FadeModifier()
        }
        
        // Enhanced Energy Field Effect
        static func energyField() -> some ViewModifier {
            EnergyFieldModifier()
        }
        
        // Particle System Effect
        static func particleSystem() -> some ViewModifier {
            ParticleSystemModifier()
        }
        
        // Liquid Morphing Effect
        static func liquidMorph() -> some ViewModifier {
            LiquidMorphModifier()
        }
        
        // Magnetic Pull Effect
        static func magneticPull() -> some ViewModifier {
            MagneticPullModifier()
        }
        
        // Holographic Effect
        static func holographic() -> some ViewModifier {
            HolographicModifier()
        }
        
        // Neural Network Effect
        static func neuralNetwork() -> some ViewModifier {
            NeuralNetworkModifier()
        }
        
        // Quantum State Effect
        static func quantumState() -> some ViewModifier {
            QuantumStateModifier()
        }
        
        // Elastic Bounce Effect
        static func elasticBounce() -> some ViewModifier {
            ElasticBounceModifier()
        }
        
        // Smooth Morph Effect
        static func smoothMorph() -> some ViewModifier {
            SmoothMorphModifier()
        }
        
        // Quick Response Effect
        static func quickResponse() -> some ViewModifier {
            QuickResponseModifier()
        }
        
        // Gentle Float Effect
        static func gentleFloat() -> some ViewModifier {
            GentleFloatModifier()
        }
        
        // Performance-Aware Effect
        static func performanceAware() -> some ViewModifier {
            PerformanceAwareModifier()
        }
        
        // Accessibility-Aware Effect
        static func accessibilityAware() -> some ViewModifier {
            AccessibilityAwareModifier()
        }
        
        // Battery-Aware Effect
        static func batteryAware() -> some ViewModifier {
            BatteryAwareModifier()
        }
        
        // Conditional Animation Effect
        static func conditionalAnimation(
            when condition: Bool,
            animation: Animation = .easeInOut(duration: 0.3)
        ) -> some ViewModifier {
            ConditionalAnimationModifier(condition: condition, animation: animation)
        }
    }
    
    // MARK: - Custom Animation Modifiers
    
    struct StaggeredEntranceModifier: ViewModifier {
        let delay: Double
        @State private var isVisible = false
        
        func body(content: Content) -> some View {
            content
                .opacity(isVisible ? 1.0 : 0.0)
                .scaleEffect(isVisible ? 1.0 : 0.8)
                .offset(y: isVisible ? 0 : 20)
                .animation(Animations.smooth.delay(delay), value: isVisible)
                .onAppear {
                    isVisible = true
                }
        }
    }
    
    struct BreathingModifier: ViewModifier {
        @State private var isBreathing = false
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(isBreathing ? 1.05 : 1.0)
                .opacity(isBreathing ? 0.9 : 1.0)
                .animation(Animations.breathing, value: isBreathing)
                .onAppear {
                    isBreathing = true
                }
        }
    }
    
    struct PulseModifier: ViewModifier {
        @State private var isPulsing = false
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(isPulsing ? 1.1 : 1.0)
                .animation(Animations.pulse, value: isPulsing)
                .onAppear {
                    isPulsing = true
                }
        }
    }
    
    struct ShimmerModifier: ViewModifier {
        @State private var shimmerOffset: CGFloat = -200
        
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
                    .offset(x: shimmerOffset)
                    .animation(Animations.shimmer, value: shimmerOffset)
                )
                .onAppear {
                    shimmerOffset = 200
                }
        }
    }
    
    struct FloatingModifier: ViewModifier {
        @State private var isFloating = false
        
        func body(content: Content) -> some View {
            content
                .offset(y: isFloating ? -5 : 5)
                .animation(Animations.floating, value: isFloating)
                .onAppear {
                    isFloating = true
                }
        }
    }
    
    struct MorphingModifier: ViewModifier {
        @State private var isMorphing = false
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(isMorphing ? 1.02 : 0.98)
                .rotationEffect(.degrees(isMorphing ? 1 : -1))
                .animation(Animations.morphing, value: isMorphing)
                .onAppear {
                    isMorphing = true
                }
        }
    }
    
    struct ScaleModifier: ViewModifier {
        @State private var isScaling = false
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(isScaling ? 1.05 : 1.0)
                .animation(Animations.scale, value: isScaling)
                .onAppear {
                    isScaling = true
                }
        }
    }
    
    struct FadeModifier: ViewModifier {
        @State private var isFading = false
        
        func body(content: Content) -> some View {
            content
                .opacity(isFading ? 0.7 : 1.0)
                .animation(Animations.fade, value: isFading)
                .onAppear {
                    isFading = true
                }
        }
    }
    
    // MARK: - Enhanced Animation Modifiers
    
    struct EnergyFieldModifier: ViewModifier {
        @State private var isEnergized = false
        
        func body(content: Content) -> some View {
            content
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.6),
                                    Color.purple.opacity(0.4),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .scaleEffect(isEnergized ? 1.3 : 1.0)
                        .opacity(isEnergized ? 0.8 : 0.0)
                        .animation(Animations.energyField, value: isEnergized)
                )
                .onAppear {
                    isEnergized = true
                }
        }
    }
    
    struct ParticleSystemModifier: ViewModifier {
        @State private var particleOffset: CGFloat = 0
        
        func body(content: Content) -> some View {
            content
                .overlay(
                    ZStack {
                        ForEach(0..<6) { index in
                            Circle()
                                .fill(Color.blue.opacity(0.3))
                                .frame(width: 4, height: 4)
                                .offset(
                                    x: cos(Double(index) * .pi / 3) * 20,
                                    y: sin(Double(index) * .pi / 3) * 20
                                )
                                .scaleEffect(particleOffset > 0 ? 1.5 : 0.5)
                                .opacity(particleOffset > 0 ? 0.0 : 1.0)
                                .animation(
                                    Animations.particleSystem.delay(Double(index) * 0.2),
                                    value: particleOffset
                                )
                        }
                    }
                )
                .onAppear {
                    particleOffset = 1.0
                }
        }
    }
    
    struct LiquidMorphModifier: ViewModifier {
        @State private var isMorphing = false
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(isMorphing ? 1.02 : 0.98)
                .rotationEffect(.degrees(isMorphing ? 2 : -2))
                .animation(Animations.liquidMorph, value: isMorphing)
                .onAppear {
                    isMorphing = true
                }
        }
    }
    
    struct MagneticPullModifier: ViewModifier {
        @State private var isPulled = false
        
        func body(content: Content) -> some View {
            content
                .offset(x: isPulled ? 5 : -5)
                .scaleEffect(isPulled ? 1.05 : 1.0)
                .animation(Animations.magneticPull, value: isPulled)
                .onAppear {
                    isPulled = true
                }
        }
    }
    
    struct HolographicModifier: ViewModifier {
        @State private var holographicOffset: CGFloat = -100
        
        func body(content: Content) -> some View {
            content
                .overlay(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.white.opacity(0.4),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .offset(x: holographicOffset)
                    .animation(Animations.holographic, value: holographicOffset)
                )
                .onAppear {
                    holographicOffset = 100
                }
        }
    }
    
    struct NeuralNetworkModifier: ViewModifier {
        @State private var isConnected = false
        
        func body(content: Content) -> some View {
            content
                .overlay(
                    ZStack {
                        ForEach(0..<4) { index in
                            Rectangle()
                                .fill(Color.green.opacity(0.3))
                                .frame(width: 1, height: 20)
                                .rotationEffect(.degrees(Double(index) * 45))
                                .scaleEffect(isConnected ? 1.2 : 0.8)
                                .opacity(isConnected ? 0.8 : 0.3)
                                .animation(
                                    Animations.neuralNetwork.delay(Double(index) * 0.1),
                                    value: isConnected
                                )
                        }
                    }
                )
                .onAppear {
                    isConnected = true
                }
        }
    }
    
    struct QuantumStateModifier: ViewModifier {
        @State private var quantumState = false
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(quantumState ? 1.03 : 0.97)
                .opacity(quantumState ? 0.9 : 1.0)
                .animation(Animations.quantumState, value: quantumState)
                .onAppear {
                    quantumState = true
                }
        }
    }
    
    struct ElasticBounceModifier: ViewModifier {
        @State private var isBouncing = false
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(isBouncing ? 1.1 : 1.0)
                .animation(Animations.elasticBounce, value: isBouncing)
                .onAppear {
                    isBouncing = true
                }
        }
    }
    
    struct SmoothMorphModifier: ViewModifier {
        @State private var isMorphing = false
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(isMorphing ? 1.02 : 0.98)
                .rotationEffect(.degrees(isMorphing ? 1 : -1))
                .animation(Animations.smoothMorph, value: isMorphing)
                .onAppear {
                    isMorphing = true
                }
        }
    }
    
    struct QuickResponseModifier: ViewModifier {
        @State private var isResponding = false
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(isResponding ? 1.05 : 1.0)
                .animation(Animations.quickResponse, value: isResponding)
                .onAppear {
                    isResponding = true
                }
        }
    }
    
    struct GentleFloatModifier: ViewModifier {
        @State private var isFloating = false
        
        func body(content: Content) -> some View {
            content
                .offset(y: isFloating ? -3 : 3)
                .animation(Animations.gentleFloat, value: isFloating)
                .onAppear {
                    isFloating = true
                }
        }
    }
    
    struct PerformanceAwareModifier: ViewModifier {
        @State private var isAnimated = false
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(isAnimated ? 1.02 : 1.0)
                .animation(Animations.performanceAware(), value: isAnimated)
                .onAppear {
                    isAnimated = true
                }
        }
    }
    
    struct AccessibilityAwareModifier: ViewModifier {
        @State private var isAnimated = false
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(isAnimated ? 1.01 : 1.0)
                .animation(Animations.accessibilityAware(), value: isAnimated)
                .onAppear {
                    isAnimated = true
                }
        }
    }
    
    struct BatteryAwareModifier: ViewModifier {
        @State private var isAnimated = false
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(isAnimated ? 1.01 : 1.0)
                .animation(Animations.batteryAware(), value: isAnimated)
                .onAppear {
                    isAnimated = true
                }
        }
    }
    
    struct ConditionalAnimationModifier: ViewModifier {
        let condition: Bool
        let animation: Animation
        @State private var isAnimated = false
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(isAnimated ? 1.02 : 1.0)
                .animation(condition ? animation : .none, value: isAnimated)
                .onAppear {
                    isAnimated = true
                }
        }
    }
    
    // MARK: - Enhanced Advanced Animation Performance Monitor
    
    struct AnimationPerformanceMonitor {
        private static var frameCount = 0
        private static var lastFrameTime: CFTimeInterval = 0
        private static var frameRate: Double = 60.0
        private static var isMonitoring = false
        
        // Performance thresholds
        private static let targetFrameRate: Double = 60.0
        private static let minimumFrameRate: Double = 30.0
        private static let frameTimeThreshold: CFTimeInterval = 1.0 / 60.0
        
        // Animation complexity levels
        enum ComplexityLevel {
            case minimal
            case reduced
            case standard
            case enhanced
            case premium
            
            var animationDuration: Double {
                switch self {
                case .minimal: return 0.1
                case .reduced: return 0.2
                case .standard: return 0.3
                case .enhanced: return 0.4
                case .premium: return 0.5
                }
            }
            
            var maxSimultaneousAnimations: Int {
                switch self {
                case .minimal: return 2
                case .reduced: return 4
                case .standard: return 8
                case .enhanced: return 12
                case .premium: return 20
                }
            }
        }
        
        // Current performance state
        static var currentComplexityLevel: ComplexityLevel = .standard
        static var currentFrameRate: Double { frameRate }
        static var isPerformanceOptimal: Bool { frameRate >= targetFrameRate }
        
        // Enhanced monitoring
        private static var activeAnimations = 0
        private static var performanceHistory: [Double] = []
        private static let maxHistorySize = 60 // 1 second at 60fps
        
        // Battery and accessibility awareness
        private static var batteryLevel: Float = 1.0
        private static var isReduceMotionEnabled = false
        
        // MARK: - Enhanced Performance Monitoring
        
        static func startMonitoring() {
            guard !isMonitoring else { return }
            isMonitoring = true
            frameCount = 0
            lastFrameTime = CACurrentMediaTime()
            
            // Start frame rate monitoring
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                updatePerformanceMetrics()
            }
        }
        
        static func stopMonitoring() {
            isMonitoring = false
        }
        
        static func recordFrame() {
            frameCount += 1
            let currentTime = CACurrentMediaTime()
            
            if currentTime - lastFrameTime >= 1.0 {
                frameRate = Double(frameCount) / (currentTime - lastFrameTime)
                frameCount = 0
                lastFrameTime = currentTime
                
                // Update performance history
                performanceHistory.append(frameRate)
                if performanceHistory.count > maxHistorySize {
                    performanceHistory.removeFirst()
                }
                
                // Adjust complexity based on performance
                adjustComplexityLevel()
            }
        }
        
        private static func updatePerformanceMetrics() {
            // Calculate average frame rate
            let averageFrameRate = performanceHistory.isEmpty ? 60.0 : performanceHistory.reduce(0, +) / Double(performanceHistory.count)
            
            // Update complexity level based on performance
            if averageFrameRate < minimumFrameRate {
                currentComplexityLevel = .minimal
            } else if averageFrameRate < 45.0 {
                currentComplexityLevel = .reduced
            } else if averageFrameRate < 55.0 {
                currentComplexityLevel = .standard
            } else if averageFrameRate >= 58.0 {
                currentComplexityLevel = .enhanced
            } else {
                currentComplexityLevel = .standard
            }
            
            // Consider battery level
            if batteryLevel < 0.2 {
                currentComplexityLevel = .minimal
            } else if batteryLevel < 0.5 {
                currentComplexityLevel = .reduced
            }
            
            // Consider accessibility settings
            if isReduceMotionEnabled {
                currentComplexityLevel = .minimal
            }
        }
        
        private static func adjustComplexityLevel() {
            // Adaptive complexity adjustment
            let targetComplexity: ComplexityLevel
            
            if frameRate < 30.0 {
                targetComplexity = .minimal
            } else if frameRate < 45.0 {
                targetComplexity = .reduced
            } else if frameRate < 55.0 {
                targetComplexity = .standard
            } else if frameRate >= 58.0 {
                targetComplexity = .enhanced
            } else {
                targetComplexity = .standard
            }
            
            if currentComplexityLevel != targetComplexity {
                currentComplexityLevel = targetComplexity
                print("Animation complexity adjusted to: \(targetComplexity)")
            }
        }
        
        // MARK: - Enhanced Animation Tracking
        
        static func trackAnimationStart() {
            activeAnimations += 1
        }
        
        static func trackAnimationEnd() {
            activeAnimations = max(0, activeAnimations - 1)
        }
        
        static var currentActiveAnimations: Int { activeAnimations }
        
        // MARK: - Enhanced Battery Awareness
        
        static func setBatteryLevel(_ level: Float) {
            batteryLevel = level
            updatePerformanceMetrics()
        }
        
        // MARK: - Enhanced Accessibility Awareness
        
        static func setReduceMotionEnabled(_ enabled: Bool) {
            isReduceMotionEnabled = enabled
            updatePerformanceMetrics()
        }
        
        // MARK: - Enhanced Performance Reporting
        
        static func getPerformanceReport() -> PerformanceReport {
            return PerformanceReport(
                currentFrameRate: frameRate,
                averageFrameRate: performanceHistory.isEmpty ? 60.0 : performanceHistory.reduce(0, +) / Double(performanceHistory.count),
                complexityLevel: currentComplexityLevel,
                activeAnimations: activeAnimations,
                batteryLevel: batteryLevel,
                isReduceMotionEnabled: isReduceMotionEnabled,
                isPerformanceOptimal: frameRate >= targetFrameRate
            )
        }
        
        struct PerformanceReport {
            let currentFrameRate: Double
            let averageFrameRate: Double
            let complexityLevel: ComplexityLevel
            let activeAnimations: Int
            let batteryLevel: Float
            let isReduceMotionEnabled: Bool
            let isPerformanceOptimal: Bool
        }
        
        // MARK: - Enhanced Animation Optimization
        
        static func shouldOptimizeAnimations() -> Bool {
            return frameRate < targetFrameRate || 
                   activeAnimations > currentComplexityLevel.maxSimultaneousAnimations ||
                   batteryLevel < 0.2 ||
                   isReduceMotionEnabled
        }
        
        static func getOptimizedAnimation() -> Animation {
            if shouldOptimizeAnimations() {
                return .easeInOut(duration: currentComplexityLevel.animationDuration)
            } else {
                return .easeInOut(duration: 0.3)
            }
        }
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

// MARK: - Enhanced Animation Extensions

extension View {
    // MARK: - Enhanced Entrance Animations
    
    func staggeredEntrance(delay: Double = 0.1) -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.staggeredEntrance(delay: delay))
    }
    
    func breathing() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.breathing())
    }
    
    func pulse() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.pulse())
    }
    
    func shimmer() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.shimmer())
    }
    
    func floating() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.floating())
    }
    
    func morphing() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.morphing())
    }
    
    func scale() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.scale())
    }
    
    func fade() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.fade())
    }
    
    // MARK: - Enhanced Advanced Effects
    
    func energyField() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.energyField())
    }
    
    func particleSystem() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.particleSystem())
    }
    
    func liquidMorph() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.liquidMorph())
    }
    
    func magneticPull() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.magneticPull())
    }
    
    func holographic() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.holographic())
    }
    
    func neuralNetwork() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.neuralNetwork())
    }
    
    func quantumState() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.quantumState())
    }
    
    func elasticBounce() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.elasticBounce())
    }
    
    func smoothMorph() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.smoothMorph())
    }
    
    func quickResponse() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.quickResponse())
    }
    
    func gentleFloat() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.gentleFloat())
    }
    
    // MARK: - Enhanced Performance-Aware Animations
    
    func performanceAware() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.performanceAware())
    }
    
    func accessibilityAware() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.accessibilityAware())
    }
    
    func batteryAware() -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.batteryAware())
    }
    
    func conditionalAnimation(
        when condition: Bool,
        animation: Animation = .easeInOut(duration: 0.3)
    ) -> some View {
        modifier(AppleDesignSystem.AnimationModifiers.conditionalAnimation(when: condition, animation: animation))
    }
    
    // MARK: - Enhanced Device-Specific Animations
    
    func deviceAnimation(for deviceType: RingDevice.DeviceType) -> some View {
        switch deviceType {
        case .camera:
            return self.energyField()
        case .doorbell:
            return self.particleSystem()
        case .sensor:
            return self.neuralNetwork()
        case .light:
            return self.holographic()
        case .lock:
            return self.magneticPull()
        case .alarm:
            return self.quantumState()
        default:
            return self.gentleFloat()
        }
    }
    
    // MARK: - Enhanced Status-Based Animations
    
    func statusAnimation(for status: RingDevice.DeviceStatus) -> some View {
        switch status {
        case .online:
            return self.energyField()
        case .offline:
            return self.fade()
        case .motion:
            return self.pulse()
        case .recording:
            return self.particleSystem()
        case .alarm:
            return self.quantumState()
        default:
            return self.gentleFloat()
        }
    }
    
    // MARK: - Enhanced Interactive Animations
    
    func interactivePress() -> some View {
        self.scale()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.quickResponse)
    }
    
    func interactiveHover() -> some View {
        self.magneticPull()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.smoothMorph)
    }
    
    func interactiveLongPress() -> some View {
        self.elasticBounce()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.elasticBounce)
    }
    
    // MARK: - Enhanced CarPlay-Specific Animations
    
    func carPlayOptimized() -> some View {
        self.performanceAware()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.carPlayStandard)
    }
    
    func carPlayQuick() -> some View {
        self.quickResponse()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.carPlayFast)
    }
    
    func carPlayGentle() -> some View {
        self.gentleFloat()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.carPlaySlow)
    }
    
    // MARK: - Enhanced Emergency Animations
    
    func emergencyAnimation() -> some View {
        self.quantumState()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.elastic)
    }
    
    func alertAnimation() -> some View {
        self.pulse()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.bouncy)
    }
    
    // MARK: - Enhanced Loading Animations
    
    func loadingAnimation() -> some View {
        self.shimmer()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.shimmer)
    }
    
    func progressAnimation() -> some View {
        self.energyField()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.energyField)
    }
    
    // MARK: - Enhanced Success/Error Animations
    
    func successAnimation() -> some View {
        self.energyField()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.elasticBounce)
    }
    
    func errorAnimation() -> some View {
        self.quantumState()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.bouncy)
    }
    
    // MARK: - Enhanced Transition Animations
    
    func smoothTransition() -> some View {
        self.smoothMorph()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.smoothMorph)
    }
    
    func quickTransition() -> some View {
        self.quickResponse()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.quickResponse)
    }
    
    // MARK: - Enhanced Ambient Animations
    
    func ambientAnimation() -> some View {
        self.gentleFloat()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.gentleFloat)
    }
    
    func breathingAnimation() -> some View {
        self.breathing()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.breathing)
    }
    
    // MARK: - Enhanced Performance Monitoring
    
    func withPerformanceTracking() -> some View {
        self.onAppear {
            AppleDesignSystem.AnimationPerformanceMonitor.trackAnimationStart()
        }
        .onDisappear {
            AppleDesignSystem.AnimationPerformanceMonitor.trackAnimationEnd()
        }
    }
    
    // MARK: - Enhanced Battery-Aware Animations
    
    func withBatteryAwareness() -> some View {
        self.batteryAware()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.batteryAware())
    }
    
    // MARK: - Enhanced Accessibility-Aware Animations
    
    func withAccessibilityAwareness() -> some View {
        self.accessibilityAware()
            .conditionalAnimation(when: true, animation: AppleDesignSystem.Animations.accessibilityAware())
    }
    
    // MARK: - Enhanced Conditional Animations
    
    func animateWhen(_ condition: Bool, animation: Animation = .easeInOut(duration: 0.3)) -> some View {
        self.conditionalAnimation(when: condition, animation: animation)
    }
    
    func animateIf(_ condition: Bool, animation: Animation = .easeInOut(duration: 0.3)) -> some View {
        self.conditionalAnimation(when: condition, animation: animation)
    }
    
    // MARK: - Enhanced Staggered Animations
    
    func staggeredAnimation(delay: Double = 0.1, animation: Animation = .easeInOut(duration: 0.3)) -> some View {
        self.staggeredEntrance(delay: delay)
            .conditionalAnimation(when: true, animation: animation)
    }
    
    // MARK: - Enhanced Multi-Effect Animations
    
    func multiEffectAnimation() -> some View {
        self.energyField()
            .particleSystem()
            .holographic()
    }
    
    func premiumAnimation() -> some View {
        self.energyField()
            .particleSystem()
            .holographic()
            .neuralNetwork()
            .quantumState()
    }
    
    // MARK: - Enhanced Context-Aware Animations
    
    func contextAwareAnimation(for context: String) -> some View {
        switch context {
        case "device":
            return self.deviceAnimation(for: .camera)
        case "status":
            return self.statusAnimation(for: .online)
        case "interaction":
            return self.interactivePress()
        case "emergency":
            return self.emergencyAnimation()
        case "loading":
            return self.loadingAnimation()
        case "success":
            return self.successAnimation()
        case "error":
            return self.errorAnimation()
        case "ambient":
            return self.ambientAnimation()
        default:
            return self.gentleFloat()
        }
    }
}