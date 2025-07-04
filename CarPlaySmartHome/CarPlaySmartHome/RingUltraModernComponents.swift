import SwiftUI

// MARK: - Ultra Modern Components
struct RingUltraModernComponents: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var showUltraEffects = false
    @State private var animateUltra = false
    @State private var morphingUltra = false
    
    var body: some View {
        ZStack {
            // Ultra modern background
            UltraModernBackground()
            
            // Floating ultra elements
            if showUltraEffects {
                UltraFloatingElements()
            }
            
            VStack(spacing: 0) {
                // Ultra modern header
                UltraModernHeader(smartHomeManager: smartHomeManager)
                    .offset(y: animateUltra ? 0 : -40)
                    .opacity(animateUltra ? 1 : 0)
                
                // Ultra modern content
                UltraModernContent(smartHomeManager: smartHomeManager)
                    .offset(y: animateUltra ? 0 : 40)
                    .opacity(animateUltra ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 1.2, dampingFraction: 0.8).delay(0.4)) {
                animateUltra = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 2.0)) {
                    showUltraEffects = true
                }
            }
            
            withAnimation(.easeInOut(duration: 15.0).repeatForever(autoreverses: true)) {
                morphingUltra = true
            }
        }
    }
}

// MARK: - Ultra Modern Background
struct UltraModernBackground: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var animateGradient = false
    @State private var morphingColors = false
    @State private var rotateBackground = false
    
    var body: some View {
        ZStack {
            // Primary ultra gradient
            LinearGradient(
                colors: morphingColors ? 
                    [.purple.opacity(0.9), .blue.opacity(0.7), .pink.opacity(0.5), .cyan.opacity(0.3)] :
                    [.blue.opacity(0.9), .purple.opacity(0.7), .cyan.opacity(0.5), .pink.opacity(0.3)],
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .rotationEffect(.degrees(rotateBackground ? 5 : -5))
            
            // Secondary ultra gradient overlay
            RadialGradient(
                colors: [.clear, .white.opacity(0.15), .clear],
                center: animateGradient ? .topLeading : .bottomTrailing,
                startRadius: 0,
                endRadius: 400
            )
            .ignoresSafeArea()
            
            // Ultra mesh gradient
            UltraMeshGradientView()
                .opacity(0.4)
                .allowsHitTesting(false)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 12.0).repeatForever(autoreverses: true)) {
                animateGradient = true
            }
            withAnimation(.easeInOut(duration: 18.0).repeatForever(autoreverses: true)) {
                morphingColors = true
            }
            withAnimation(.easeInOut(duration: 20.0).repeatForever(autoreverses: true)) {
                rotateBackground = true
            }
        }
    }
}

// MARK: - Ultra Mesh Gradient View
struct UltraMeshGradientView: View {
    @State private var animate = false
    @State private var morphing = false
    
    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size)
            
            // Create ultra mesh gradient effect
            for i in 0..<8 {
                for j in 0..<8 {
                    let x = size.width * Double(i) / 7
                    let y = size.height * Double(j) / 7
                    let radius = 60.0
                    
                    let color = Color(
                        hue: (Double(i + j) / 16 + animate ? 0.7 : 0.0 + morphing ? 0.3 : 0.0).truncatingRemainder(dividingBy: 1.0),
                        saturation: 0.8,
                        brightness: 0.9
                    )
                    
                    context.fill(
                        Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)),
                        with: .color(color.opacity(0.4))
                    )
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                animate = true
            }
            withAnimation(.easeInOut(duration: 12.0).repeatForever(autoreverses: true)) {
                morphing = true
            }
        }
    }
}

// MARK: - Ultra Floating Elements
struct UltraFloatingElements: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Ultra geometric shapes
            ForEach(0..<12) { index in
                UltraGeometricShape(
                    type: index % 6,
                    color: [.blue, .purple, .pink, .cyan, .orange, .green][index % 6],
                    size: CGFloat.random(in: 30...80),
                    delay: Double(index) * 0.2
                )
            }
            
            // Ultra floating orbs
            ForEach(0..<8) { index in
                UltraFloatingOrb(
                    color: [.blue, .purple, .pink, .cyan, .orange, .green, .yellow, .red][index],
                    size: CGFloat.random(in: 15...40),
                    delay: Double(index) * 0.15
                )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct UltraGeometricShape: View {
    let type: Int
    let color: Color
    let size: CGFloat
    let delay: Double
    
    @State private var animate = false
    @State private var position = CGSize.zero
    @State private var rotation = 0.0
    @State private var scale = 1.0
    
    var body: some View {
        Group {
            switch type {
            case 0:
                Circle()
                    .fill(color.opacity(0.4))
            case 1:
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.4))
            case 2:
                Triangle()
                    .fill(color.opacity(0.4))
            case 3:
                Diamond()
                    .fill(color.opacity(0.4))
            case 4:
                Star()
                    .fill(color.opacity(0.4))
            case 5:
                Hexagon()
                    .fill(color.opacity(0.4))
            default:
                Circle()
                    .fill(color.opacity(0.4))
            }
        }
        .frame(width: size, height: size)
        .scaleEffect(animate ? scale : 0.6)
        .opacity(animate ? 0.8 : 0.2)
        .rotationEffect(.degrees(rotation))
        .offset(position)
        .onAppear {
            // Random initial position
            position = CGSize(
                width: CGFloat.random(in: -200...200),
                height: CGFloat.random(in: -400...400)
            )
            
            // Animate shape
            withAnimation(
                .easeInOut(duration: 6.0)
                .repeatForever(autoreverses: true)
                .delay(delay)
            ) {
                animate = true
                rotation = 720
                scale = 1.4
                position = CGSize(
                    width: CGFloat.random(in: -200...200),
                    height: CGFloat.random(in: -400...400)
                )
            }
        }
    }
}

struct Star: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let innerRadius = radius * 0.4
        
        for i in 0..<10 {
            let angle = Double(i) * .pi / 5
            let point = CGPoint(
                x: center.x + cos(angle) * (i % 2 == 0 ? radius : innerRadius),
                y: center.y + sin(angle) * (i % 2 == 0 ? radius : innerRadius)
            )
            
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<6 {
            let angle = Double(i) * .pi / 3
            let point = CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )
            
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

struct UltraFloatingOrb: View {
    let color: Color
    let size: CGFloat
    let delay: Double
    
    @State private var animate = false
    @State private var position = CGSize.zero
    @State private var scale = 1.0
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [color, color.opacity(0.6), .clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: size / 2
                )
            )
            .frame(width: size, height: size)
            .blur(radius: 15)
            .scaleEffect(animate ? scale : 0.5)
            .opacity(animate ? 0.9 : 0.3)
            .offset(position)
            .onAppear {
                // Random initial position
                position = CGSize(
                    width: CGFloat.random(in: -150...150),
                    height: CGFloat.random(in: -300...300)
                )
                
                // Animate orb
                withAnimation(
                    .easeInOut(duration: 8.0)
                    .repeatForever(autoreverses: true)
                    .delay(delay)
                ) {
                    animate = true
                    scale = 1.5
                    position = CGSize(
                        width: CGFloat.random(in: -150...150),
                        height: CGFloat.random(in: -300...300)
                    )
                }
            }
    }
}

// MARK: - Ultra Modern Header
struct UltraModernHeader: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @Environment(\.colorScheme) var colorScheme
    @State private var rotateIcon = false
    @State private var pulseGlow = false
    @State private var morphingGradient = false
    @State private var showParticles = false
    @State private var animateTitle = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xl) {
            HStack {
                // Ultra modern 3D icon with particles
                ZStack {
                    // Background ultra glow
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: morphingGradient ? 
                                    [.blue, .purple, .pink, .cyan] :
                                    [.purple, .blue, .cyan, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .shadow(
                            color: .blue.opacity(pulseGlow ? 1.0 : 0.5),
                            radius: pulseGlow ? 40 : 20,
                            x: 0,
                            y: 0
                        )
                    
                    // Main ultra icon
                    Image(systemName: "sparkles.rectangle.stack")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .rotation3DEffect(
                            .degrees(rotateIcon ? 360 : 0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                    
                    // Orbiting ultra particles
                    if showParticles {
                        ForEach(0..<5) { index in
                            Circle()
                                .fill(.white.opacity(0.8))
                                .frame(width: 8, height: 8)
                                .offset(
                                    x: 45 * cos(Double(index) * 2 * .pi / 5),
                                    y: 45 * sin(Double(index) * 2 * .pi / 5)
                                )
                                .rotationEffect(.degrees(rotateIcon ? 360 : 0))
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.sm) {
                    AnimatedGradientText(
                        text: "Ultra Smart Home",
                        colors: colorScheme == .dark ? 
                            [.white, .blue, .purple, .pink] :
                            [.black, .blue, .cyan, .purple]
                    )
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .offset(x: animateTitle ? 0 : -30)
                    .opacity(animateTitle ? 1 : 0)
                    
                    Text("Next-Generation Control Experience")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .offset(x: animateTitle ? 0 : -30)
                        .opacity(animateTitle ? 1 : 0)
                }
                
                Spacer()
                
                // Ultra status indicator
                VStack(spacing: RingDesignSystem.Spacing.sm) {
                    ZStack {
                        Circle()
                            .fill(.green)
                            .frame(width: 20, height: 20)
                            .scaleEffect(pulseGlow ? 1.4 : 1.0)
                        
                        Circle()
                            .stroke(.green.opacity(0.6), lineWidth: 3)
                            .frame(width: 32, height: 32)
                            .scaleEffect(pulseGlow ? 1.6 : 1.0)
                        
                        Circle()
                            .stroke(.green.opacity(0.3), lineWidth: 2)
                            .frame(width: 44, height: 44)
                            .scaleEffect(pulseGlow ? 1.8 : 1.0)
                    }
                    
                    Text("Ultra")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.green)
                }
            }
            
            // Ultra status cards
            HStack(spacing: RingDesignSystem.Spacing.lg) {
                UltraStatusCard(
                    title: "Devices",
                    value: "\(smartHomeManager.devices.count)",
                    icon: "square.grid.3x3",
                    color: .blue,
                    trend: .up,
                    trendValue: "+18%"
                )
                
                UltraStatusCard(
                    title: "Automations",
                    value: "\(smartHomeManager.activeAutomations)",
                    icon: "bolt.circle",
                    color: .orange,
                    trend: .stable,
                    trendValue: "0%"
                )
                
                UltraStatusCard(
                    title: "Energy",
                    value: "\(smartHomeManager.totalEnergyUsage, specifier: "%.1f") kWh",
                    icon: "leaf.circle",
                    color: .green,
                    trend: .down,
                    trendValue: "-12%"
                )
            }
        }
        .padding(RingDesignSystem.Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xxl)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xxl)
                        .stroke(
                            colorScheme == .dark ? 
                                Color.white.opacity(0.15) : 
                                Color.black.opacity(0.1),
                            lineWidth: 2
                        )
                )
        )
        .shadow(
            color: colorScheme == .dark ? 
                Color.black.opacity(0.4) : 
                Color.black.opacity(0.2),
            radius: 40,
            x: 0,
            y: 20
        )
        .onAppear {
            withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: false)) {
                rotateIcon = true
            }
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                pulseGlow = true
            }
            withAnimation(.easeInOut(duration: 10.0).repeatForever(autoreverses: true)) {
                morphingGradient = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeInOut(duration: 1.2)) {
                    showParticles = true
                }
            }
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.5)) {
                animateTitle = true
            }
        }
    }
}

struct UltraStatusCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let trend: UltraTrendType
    let trendValue: String
    
    @State private var animate = false
    @State private var glow = false
    @State private var rotate = false
    
    enum UltraTrendType {
        case up, down, stable
    }
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.md) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.25))
                    .frame(width: 70, height: 70)
                    .scaleEffect(animate ? 1.2 : 1.0)
                
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(color)
                    .rotationEffect(.degrees(rotate ? 360 : 0))
            }
            
            VStack(spacing: RingDesignSystem.Spacing.xs) {
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                
                // Trend indicator
                HStack(spacing: RingDesignSystem.Spacing.xs) {
                    Image(systemName: trendIcon)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(trendColor)
                    
                    Text(trendValue)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(trendColor)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, RingDesignSystem.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xl)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xl)
                        .stroke(color.opacity(glow ? 0.6 : 0.3), lineWidth: glow ? 3 : 2)
                )
        )
        .shadow(
            color: color.opacity(glow ? 0.4 : 0.2),
            radius: glow ? 20 : 12,
            x: 0,
            y: glow ? 12 : 6
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                animate = true
            }
            withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                glow = true
            }
            withAnimation(.linear(duration: 6.0).repeatForever(autoreverses: false)) {
                rotate = true
            }
        }
    }
    
    private var trendIcon: String {
        switch trend {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .stable: return "minus"
        }
    }
    
    private var trendColor: Color {
        switch trend {
        case .up: return .green
        case .down: return .red
        case .stable: return .orange
        }
    }
}

#Preview {
    RingUltraModernComponents(smartHomeManager: SmartHomeManager.shared)
        .preferredColorScheme(.dark)
} 