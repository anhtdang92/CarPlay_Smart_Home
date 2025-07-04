import SwiftUI

// MARK: - Ultra Premium Components
struct RingPremiumComponents: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var showPremiumEffects = false
    @State private var animatePremium = false
    @State private var morphingPremium = false
    
    var body: some View {
        ZStack {
            // Premium gradient background
            PremiumGradientBackground()
            
            // Floating premium elements
            if showPremiumEffects {
                PremiumFloatingElements()
            }
            
            VStack(spacing: 0) {
                // Premium header
                PremiumHeader(smartHomeManager: smartHomeManager)
                    .offset(y: animatePremium ? 0 : -30)
                    .opacity(animatePremium ? 1 : 0)
                
                // Premium content
                PremiumContent(smartHomeManager: smartHomeManager)
                    .offset(y: animatePremium ? 0 : 30)
                    .opacity(animatePremium ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
                animatePremium = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeInOut(duration: 1.5)) {
                    showPremiumEffects = true
                }
            }
            
            withAnimation(.easeInOut(duration: 10.0).repeatForever(autoreverses: true)) {
                morphingPremium = true
            }
        }
    }
}

// MARK: - Premium Gradient Background
struct PremiumGradientBackground: View {
    @State private var animateGradient = false
    @State private var morphingColors = false
    
    var body: some View {
        ZStack {
            // Primary gradient
            LinearGradient(
                colors: morphingColors ? 
                    [.purple.opacity(0.8), .blue.opacity(0.6), .pink.opacity(0.4)] :
                    [.blue.opacity(0.8), .purple.opacity(0.6), .cyan.opacity(0.4)],
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            
            // Secondary gradient overlay
            RadialGradient(
                colors: [.clear, .white.opacity(0.1), .clear],
                center: animateGradient ? .topLeading : .bottomTrailing,
                startRadius: 0,
                endRadius: 300
            )
            .ignoresSafeArea()
            
            // Animated mesh gradient
            MeshGradientView()
                .opacity(0.3)
                .allowsHitTesting(false)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                animateGradient = true
            }
            withAnimation(.easeInOut(duration: 12.0).repeatForever(autoreverses: true)) {
                morphingColors = true
            }
        }
    }
}

// MARK: - Mesh Gradient View
struct MeshGradientView: View {
    @State private var animate = false
    
    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size)
            
            // Create mesh gradient effect
            for i in 0..<5 {
                for j in 0..<5 {
                    let x = size.width * Double(i) / 4
                    let y = size.height * Double(j) / 4
                    let radius = 50.0
                    
                    let color = Color(
                        hue: (Double(i + j) / 10 + animate ? 0.5 : 0.0).truncatingRemainder(dividingBy: 1.0),
                        saturation: 0.7,
                        brightness: 0.8
                    )
                    
                    context.fill(
                        Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)),
                        with: .color(color.opacity(0.3))
                    )
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 6.0).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

// MARK: - Premium Floating Elements
struct PremiumFloatingElements: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Geometric shapes
            ForEach(0..<8) { index in
                PremiumGeometricShape(
                    type: index % 4,
                    color: [.blue, .purple, .pink, .cyan][index % 4],
                    size: CGFloat.random(in: 20...60),
                    delay: Double(index) * 0.3
                )
            }
            
            // Floating orbs
            ForEach(0..<6) { index in
                PremiumFloatingOrb(
                    color: [.blue, .purple, .pink, .cyan, .orange, .green][index],
                    size: CGFloat.random(in: 10...30),
                    delay: Double(index) * 0.2
                )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct PremiumGeometricShape: View {
    let type: Int
    let color: Color
    let size: CGFloat
    let delay: Double
    
    @State private var animate = false
    @State private var position = CGSize.zero
    @State private var rotation = 0.0
    
    var body: some View {
        Group {
            switch type {
            case 0:
                Circle()
                    .fill(color.opacity(0.3))
            case 1:
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.3))
            case 2:
                Triangle()
                    .fill(color.opacity(0.3))
            case 3:
                Diamond()
                    .fill(color.opacity(0.3))
            default:
                Circle()
                    .fill(color.opacity(0.3))
            }
        }
        .frame(width: size, height: size)
        .scaleEffect(animate ? 1.2 : 0.8)
        .opacity(animate ? 0.6 : 0.2)
        .rotationEffect(.degrees(rotation))
        .offset(position)
        .onAppear {
            // Random initial position
            position = CGSize(
                width: CGFloat.random(in: -150...150),
                height: CGFloat.random(in: -300...300)
            )
            
            // Animate shape
            withAnimation(
                .easeInOut(duration: 4.0)
                .repeatForever(autoreverses: true)
                .delay(delay)
            ) {
                animate = true
                rotation = 360
                position = CGSize(
                    width: CGFloat.random(in: -150...150),
                    height: CGFloat.random(in: -300...300)
                )
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

struct PremiumFloatingOrb: View {
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
            .scaleEffect(animate ? 1.3 : 0.7)
            .opacity(animate ? 0.8 : 0.3)
            .offset(position)
            .onAppear {
                // Random initial position
                position = CGSize(
                    width: CGFloat.random(in: -100...100),
                    height: CGFloat.random(in: -200...200)
                )
                
                // Animate orb
                withAnimation(
                    .easeInOut(duration: 5.0)
                    .repeatForever(autoreverses: true)
                    .delay(delay)
                ) {
                    animate = true
                    position = CGSize(
                        width: CGFloat.random(in: -100...100),
                        height: CGFloat.random(in: -200...200)
                    )
                }
            }
    }
}

// MARK: - Premium Header
struct PremiumHeader: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var rotateIcon = false
    @State private var pulseGlow = false
    @State private var morphingGradient = false
    @State private var showParticles = false
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                // Premium 3D icon with particles
                ZStack {
                    // Background glow
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: morphingGradient ? 
                                    [.blue, .purple, .pink] :
                                    [.purple, .blue, .cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .shadow(
                            color: .blue.opacity(pulseGlow ? 0.8 : 0.4),
                            radius: pulseGlow ? 30 : 15,
                            x: 0,
                            y: 0
                        )
                    
                    // Main icon
                    Image(systemName: "sparkles")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .rotation3DEffect(
                            .degrees(rotateIcon ? 360 : 0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                    
                    // Orbiting particles
                    if showParticles {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(.white.opacity(0.6))
                                .frame(width: 6, height: 6)
                                .offset(
                                    x: 35 * cos(Double(index) * 2 * .pi / 3),
                                    y: 35 * sin(Double(index) * 2 * .pi / 3)
                                )
                                .rotationEffect(.degrees(rotateIcon ? 360 : 0))
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Premium Control")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("Ultra-Premium Smart Home Experience")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Premium status indicator
                VStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(.green)
                            .frame(width: 16, height: 16)
                            .scaleEffect(pulseGlow ? 1.3 : 1.0)
                        
                        Circle()
                            .stroke(.green.opacity(0.5), lineWidth: 2)
                            .frame(width: 24, height: 24)
                            .scaleEffect(pulseGlow ? 1.5 : 1.0)
                    }
                    
                    Text("Premium")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.green)
                }
            }
            
            // Premium status cards
            HStack(spacing: 16) {
                PremiumStatusCard(
                    title: "Devices",
                    value: "\(smartHomeManager.devices.count)",
                    icon: "square.grid.3x3",
                    color: .blue,
                    trend: .up,
                    trendValue: "+15%"
                )
                
                PremiumStatusCard(
                    title: "Automations",
                    value: "\(smartHomeManager.activeAutomations)",
                    icon: "bolt.circle",
                    color: .orange,
                    trend: .stable,
                    trendValue: "0%"
                )
                
                PremiumStatusCard(
                    title: "Energy",
                    value: "\(smartHomeManager.totalEnergyUsage, specifier: "%.1f") kWh",
                    icon: "leaf.circle",
                    color: .green,
                    trend: .down,
                    trendValue: "-8%"
                )
            }
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 15)
        .onAppear {
            withAnimation(.linear(duration: 6.0).repeatForever(autoreverses: false)) {
                rotateIcon = true
            }
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                pulseGlow = true
            }
            withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                morphingGradient = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    showParticles = true
                }
            }
        }
    }
}

struct PremiumStatusCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let trend: PremiumTrendType
    let trendValue: String
    
    @State private var animate = false
    @State private var glow = false
    
    enum PremiumTrendType {
        case up, down, stable
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .scaleEffect(animate ? 1.15 : 1.0)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(color)
                    .rotationEffect(.degrees(glow ? 360 : 0))
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                
                // Trend indicator
                HStack(spacing: 4) {
                    Image(systemName: trendIcon)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(trendColor)
                    
                    Text(trendValue)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(trendColor)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(color.opacity(glow ? 0.5 : 0.2), lineWidth: glow ? 2 : 1)
        )
        .shadow(
            color: color.opacity(glow ? 0.3 : 0.1),
            radius: glow ? 15 : 8,
            x: 0,
            y: glow ? 8 : 4
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                animate = true
            }
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                glow = true
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

// MARK: - Premium Content
struct PremiumContent: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedSection = 0
    @State private var animateContent = false
    
    private let sections = [
        ("Devices", "square.grid.3x3", .blue),
        ("Automation", "bolt.circle", .orange),
        ("Analytics", "chart.bar.circle", .green),
        ("Settings", "gearshape.circle", .purple)
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            // Premium section navigation
            HStack(spacing: 0) {
                ForEach(Array(sections.enumerated()), id: \.offset) { index, section in
                    PremiumSectionButton(
                        title: section.0,
                        icon: section.1,
                        color: section.2,
                        isSelected: selectedSection == index
                    ) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            selectedSection = index
                        }
                        HapticFeedback.impact(style: .light)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
            
            // Premium content area
            TabView(selection: $selectedSection) {
                PremiumDeviceSection(smartHomeManager: smartHomeManager)
                    .tag(0)
                
                PremiumAutomationSection(smartHomeManager: smartHomeManager)
                    .tag(1)
                
                PremiumAnalyticsSection(smartHomeManager: smartHomeManager)
                    .tag(2)
                
                PremiumSettingsSection(smartHomeManager: smartHomeManager)
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.spring(response: 0.8, dampingFraction: 0.8), value: selectedSection)
        }
        .padding(.horizontal, 20)
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.5)) {
                animateContent = true
            }
        }
    }
}

struct PremiumSectionButton: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? color : .clear)
                        .frame(width: 50, height: 50)
                        .scaleEffect(animate ? 1.1 : 1.0)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .secondary)
                        .rotationEffect(.degrees(animate ? 360 : 0))
                }
                
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(isSelected ? color : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            if isSelected {
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    animate = true
                }
            }
        }
        .onChange(of: isSelected) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    animate = true
                }
            } else {
                animate = false
            }
        }
    }
}

// MARK: - Premium Device Section
struct PremiumDeviceSection: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var animateDevices = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Premium device grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(smartHomeManager.devices.indices, id: \.self) { index in
                        PremiumDeviceCard(
                            device: smartHomeManager.devices[index],
                            smartHomeManager: smartHomeManager
                        )
                        .offset(y: animateDevices ? 0 : 100)
                        .opacity(animateDevices ? 1 : 0)
                        .animation(
                            .spring(response: 0.8, dampingFraction: 0.8)
                            .delay(Double(index) * 0.1),
                            value: animateDevices
                        )
                    }
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
                animateDevices = true
            }
        }
    }
}

struct PremiumDeviceCard: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var isPressed = false
    @State private var glow = false
    @State private var rotate = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Premium device icon
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                device.status == .online ? .green : .red,
                                device.status == .online ? .green.opacity(0.3) : .red.opacity(0.3)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 40
                        )
                    )
                    .frame(width: 80, height: 80)
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                    .shadow(
                        color: device.status == .online ? .green.opacity(glow ? 0.6 : 0.3) : .red.opacity(glow ? 0.6 : 0.3),
                        radius: glow ? 20 : 10,
                        x: 0,
                        y: glow ? 10 : 5
                    )
                
                Image(systemName: device.category.icon)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(rotate ? 360 : 0))
            }
            
            VStack(spacing: 6) {
                Text(device.name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .lineLimit(1)
                
                Text(device.category.displayName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                
                // Status indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(device.status == .online ? .green : .red)
                        .frame(width: 8, height: 8)
                        .scaleEffect(glow ? 1.3 : 1.0)
                    
                    Text(device.status.rawValue.capitalized)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            
            // Premium toggle
            PremiumToggle(
                isOn: Binding(
                    get: { device.isOn },
                    set: { newValue in
                        if newValue {
                            smartHomeManager.turnDeviceOn(device)
                        } else {
                            smartHomeManager.turnDeviceOff(device)
                        }
                    }
                ),
                color: device.status == .online ? .blue : .gray
            )
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    device.status == .online ? .green : .red,
                    lineWidth: glow ? 2 : 1
                )
        )
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                glow = true
            }
            withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: false)) {
                rotate = true
            }
        }
    }
}

struct PremiumToggle: View {
    @Binding var isOn: Bool
    let color: Color
    
    @State private var animate = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                isOn.toggle()
            }
            HapticFeedback.impact(style: .light)
        }) {
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 25)
                    .fill(isOn ? color : .gray.opacity(0.3))
                    .frame(width: 60, height: 30)
                
                // Thumb
                Circle()
                    .fill(.white)
                    .frame(width: 26, height: 26)
                    .offset(x: isOn ? 15 : -15)
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
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

// MARK: - Premium Automation Section
struct PremiumAutomationSection: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var animateAutomations = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Create automation card
                PremiumAutomationCard(
                    title: "Create New Automation",
                    description: "Build advanced automation rules",
                    icon: "plus.circle.fill",
                    color: .blue,
                    action: {}
                )
                .offset(y: animateAutomations ? 0 : 50)
                .opacity(animateAutomations ? 1 : 0)
                
                // Sample automations
                ForEach(0..<5) { index in
                    PremiumAutomationCard(
                        title: "Premium Automation \(index + 1)",
                        description: "Advanced automation rule with premium features",
                        icon: "bolt.circle.fill",
                        color: [.green, .orange, .purple, .pink, .cyan][index],
                        action: {}
                    )
                    .offset(y: animateAutomations ? 0 : 50)
                    .opacity(animateAutomations ? 1 : 0)
                    .animation(
                        .spring(response: 0.8, dampingFraction: 0.8)
                        .delay(Double(index) * 0.1),
                        value: animateAutomations
                    )
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
                animateAutomations = true
            }
        }
    }
}

struct PremiumAutomationCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var glow = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(color)
                        .rotationEffect(.degrees(glow ? 360 : 0))
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                    
                    Text(description)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color.opacity(glow ? 0.5 : 0.2), lineWidth: glow ? 2 : 1)
            )
            .shadow(
                color: color.opacity(glow ? 0.3 : 0.1),
                radius: glow ? 15 : 8,
                x: 0,
                y: glow ? 8 : 4
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .onAppear {
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                glow = true
            }
        }
    }
}

// MARK: - Premium Analytics Section
struct PremiumAnalyticsSection: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var animateCharts = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Premium charts
                PremiumChartCard(
                    title: "Energy Usage",
                    subtitle: "Last 7 days",
                    data: [2.1, 3.2, 2.8, 4.1, 3.5, 2.9, 3.8],
                    color: .green
                )
                .offset(y: animateCharts ? 0 : 50)
                .opacity(animateCharts ? 1 : 0)
                
                PremiumChartCard(
                    title: "Device Activity",
                    subtitle: "Active devices over time",
                    data: [8, 12, 10, 15, 11, 13, 9],
                    color: .blue
                )
                .offset(y: animateCharts ? 0 : 50)
                .opacity(animateCharts ? 1 : 0)
                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2), value: animateCharts)
                
                PremiumChartCard(
                    title: "System Health",
                    subtitle: "Overall system performance",
                    data: [95, 92, 98, 89, 96, 94, 97],
                    color: .orange
                )
                .offset(y: animateCharts ? 0 : 50)
                .opacity(animateCharts ? 1 : 0)
                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4), value: animateCharts)
            }
            .padding(.vertical)
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
                animateCharts = true
            }
        }
    }
}

struct PremiumChartCard: View {
    let title: String
    let subtitle: String
    let data: [Double]
    let color: Color
    
    @State private var animateChart = false
    @State private var glow = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                
                Text(subtitle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            // Premium bar chart
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, value in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    colors: [color, color.opacity(0.7)],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .frame(
                                width: 24,
                                height: animateChart ? CGFloat(value * 4) : 0
                            )
                            .shadow(
                                color: color.opacity(glow ? 0.4 : 0.2),
                                radius: glow ? 8 : 4,
                                x: 0,
                                y: glow ? 4 : 2
                            )
                            .animation(
                                .spring(response: 0.8, dampingFraction: 0.8)
                                .delay(Double(index) * 0.1),
                                value: animateChart
                            )
                        
                        Text("\(Int(value))")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(height: 120)
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
                animateChart = true
            }
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                glow = true
            }
        }
    }
}

// MARK: - Premium Settings Section
struct PremiumSettingsSection: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var animateSettings = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Premium settings cards
                PremiumSettingCard(
                    title: "Premium Features",
                    description: "Access to advanced features and analytics",
                    icon: "crown.fill",
                    color: .yellow,
                    action: {}
                )
                .offset(y: animateSettings ? 0 : 50)
                .opacity(animateSettings ? 1 : 0)
                
                PremiumSettingCard(
                    title: "Advanced Analytics",
                    description: "Detailed insights and performance metrics",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .green,
                    action: {}
                )
                .offset(y: animateSettings ? 0 : 50)
                .opacity(animateSettings ? 1 : 0)
                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1), value: animateSettings)
                
                PremiumSettingCard(
                    title: "Custom Automations",
                    description: "Create complex automation workflows",
                    icon: "slider.horizontal.3",
                    color: .purple,
                    action: {}
                )
                .offset(y: animateSettings ? 0 : 50)
                .opacity(animateSettings ? 1 : 0)
                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2), value: animateSettings)
                
                PremiumSettingCard(
                    title: "Priority Support",
                    description: "24/7 premium customer support",
                    icon: "person.crop.circle.badge.checkmark",
                    color: .blue,
                    action: {}
                )
                .offset(y: animateSettings ? 0 : 50)
                .opacity(animateSettings ? 1 : 0)
                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3), value: animateSettings)
            }
            .padding(.vertical)
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
                animateSettings = true
            }
        }
    }
}

struct PremiumSettingCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var glow = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(color)
                        .rotationEffect(.degrees(glow ? 360 : 0))
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                    
                    Text(description)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color.opacity(glow ? 0.5 : 0.2), lineWidth: glow ? 2 : 1)
            )
            .shadow(
                color: color.opacity(glow ? 0.3 : 0.1),
                radius: glow ? 15 : 8,
                x: 0,
                y: glow ? 8 : 4
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .onAppear {
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                glow = true
            }
        }
    }
}

#Preview {
    RingPremiumComponents(smartHomeManager: SmartHomeManager())
        .preferredColorScheme(.dark)
} 