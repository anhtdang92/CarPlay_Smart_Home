import SwiftUI

struct RingAdvancedDesign: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedDevice: RingDevice?
    @State private var showingDeviceDetail = false
    @State private var isAnimating = false
    @State private var showWelcomeAnimation = false
    @State private var selectedTab = 0
    @State private var showParticleSystem = false
    @State private var animate3D = false
    @State private var morphingState = false
    @State private var showHolographicEffect = false
    @State private var floatingElements = false
    
    // Advanced UI states
    @State private var show3DEffects = true
    @State private var showParticleEffects = false
    @State private var showAdvancedControls = false
    @State private var showDeviceComparison = false
    @State private var showAutomationWizard = false
    
    var body: some View {
        ZStack {
            // Advanced particle system background
            if showParticleSystem {
                AdvancedParticleSystem()
                    .allowsHitTesting(false)
            }
            
            // Holographic overlay effect
            if showHolographicEffect {
                HolographicOverlay()
                    .allowsHitTesting(false)
            }
            
            VStack(spacing: 0) {
                // Ultra-premium header with 3D effects
                UltraPremiumHeader(smartHomeManager: smartHomeManager)
                    .offset(y: floatingElements ? 0 : -20)
                    .opacity(floatingElements ? 1 : 0)
                
                // Advanced tab navigation with morphing effects
                AdvancedTabNavigation(selectedTab: $selectedTab)
                    .offset(y: floatingElements ? 0 : 20)
                    .opacity(floatingElements ? 1 : 0)
                
                // Enhanced tab content with 3D transitions
                TabView(selection: $selectedTab) {
                    // Automation Studio
                    AdvancedAutomationStudio(smartHomeManager: smartHomeManager)
                        .tag(0)
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                    
                    // Analytics Dashboard
                    AdvancedAnalyticsDashboard(smartHomeManager: smartHomeManager)
                        .tag(1)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                    
                    // System Monitor
                    AdvancedSystemMonitor(smartHomeManager: smartHomeManager)
                        .tag(2)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        ))
                    
                    // Device Control Center
                    AdvancedDeviceControlCenter(smartHomeManager: smartHomeManager)
                        .tag(3)
                        .transition(.asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        ))
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.spring(response: 0.8, dampingFraction: 0.8), value: selectedTab)
            }
            
            // Floating action menu
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    AdvancedFloatingActionMenu(
                        showAdvancedControls: $showAdvancedControls,
                        showDeviceComparison: $showDeviceComparison,
                        showAutomationWizard: $showAutomationWizard
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            // Staggered animation sequence
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                floatingElements = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    showParticleSystem = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 1.5)) {
                    showHolographicEffect = true
                }
            }
            
            // Continuous 3D animations
            withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                animate3D = true
            }
            
            withAnimation(.easeInOut(duration: 12.0).repeatForever(autoreverses: true)) {
                morphingState = true
            }
        }
        .sheet(isPresented: $showDeviceComparison) {
            DeviceComparisonView(smartHomeManager: smartHomeManager)
        }
        .sheet(isPresented: $showAutomationWizard) {
            AutomationWizardView(smartHomeManager: smartHomeManager)
        }
    }
}

// MARK: - Advanced Particle System
struct AdvancedParticleSystem: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Multiple particle layers
            ForEach(0..<3) { layer in
                ForEach(0..<15) { index in
                    AdvancedParticle(
                        color: [.blue, .purple, .pink, .cyan].randomElement()!,
                        size: CGFloat.random(in: 2...8),
                        speed: Double.random(in: 3...8),
                        delay: Double(index) * 0.1 + Double(layer) * 0.3
                    )
                }
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct AdvancedParticle: View {
    let color: Color
    let size: CGFloat
    let speed: Double
    let delay: Double
    
    @State private var animate = false
    @State private var position = CGSize.zero
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [color, color.opacity(0.3), .clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: size
                )
            )
            .frame(width: size, height: size)
            .scaleEffect(animate ? 1.5 : 0.5)
            .opacity(animate ? 0.8 : 0.2)
            .offset(position)
            .onAppear {
                // Random initial position
                position = CGSize(
                    width: CGFloat.random(in: -200...200),
                    height: CGFloat.random(in: -400...400)
                )
                
                // Animate particle
                withAnimation(
                    .easeInOut(duration: speed)
                    .repeatForever(autoreverses: false)
                    .delay(delay)
                ) {
                    animate = true
                    position = CGSize(
                        width: CGFloat.random(in: -200...200),
                        height: CGFloat.random(in: -400...400)
                    )
                }
            }
    }
}

// MARK: - Holographic Overlay
struct HolographicOverlay: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Holographic grid
            ForEach(0..<10) { row in
                ForEach(0..<10) { col in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.blue.opacity(0.1))
                        .frame(width: 40, height: 2)
                        .offset(
                            x: CGFloat(col * 40 - 200),
                            y: CGFloat(row * 40 - 200)
                        )
                        .opacity(animate ? 0.3 : 0.1)
                        .animation(
                            .easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true)
                            .delay(Double(row + col) * 0.1),
                            value: animate
                        )
                }
            }
            
            // Scanning line effect
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.clear, .blue.opacity(0.3), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 2)
                .offset(x: animate ? 200 : -200)
                .animation(
                    .linear(duration: 3.0)
                    .repeatForever(autoreverses: false),
                    value: animate
                )
        }
        .onAppear {
            animate = true
        }
    }
}

// MARK: - Ultra Premium Header
struct UltraPremiumHeader: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var rotateIcon = false
    @State private var pulseGlow = false
    @State private var morphingGradient = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                // Rotating 3D icon
                ZStack {
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
                        .frame(width: 60, height: 60)
                        .shadow(
                            color: .blue.opacity(pulseGlow ? 0.6 : 0.3),
                            radius: pulseGlow ? 20 : 10,
                            x: 0,
                            y: 0
                        )
                    
                    Image(systemName: "gearshape.2")
                        .font(.title)
                        .foregroundColor(.white)
                        .rotation3DEffect(
                            .degrees(rotateIcon ? 360 : 0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Advanced Control")
                        .font(.ringTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("Professional Smart Home Management")
                        .font(.ringCaption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Animated status indicator
                VStack(spacing: 4) {
                    Circle()
                        .fill(.green)
                        .frame(width: 12, height: 12)
                        .scaleEffect(pulseGlow ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: pulseGlow)
                    
                    Text("Online")
                        .font(.ringSmall)
                        .foregroundColor(.green)
                }
            }
            
            // Advanced status cards with 3D effects
            HStack(spacing: 12) {
                AdvancedStatusCard(
                    title: "Devices",
                    value: "\(smartHomeManager.devices.count)",
                    icon: "square.grid.2x2",
                    color: .blue,
                    trend: .up
                )
                
                AdvancedStatusCard(
                    title: "Automations",
                    value: "\(smartHomeManager.activeAutomations)",
                    icon: "bolt.fill",
                    color: .orange,
                    trend: .stable
                )
                
                AdvancedStatusCard(
                    title: "Energy",
                    value: "\(smartHomeManager.totalEnergyUsage, specifier: "%.1f") kWh",
                    icon: "leaf.fill",
                    color: .green,
                    trend: .down
                )
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        .onAppear {
            withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
                rotateIcon = true
            }
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                pulseGlow = true
            }
            withAnimation(.easeInOut(duration: 6.0).repeatForever(autoreverses: true)) {
                morphingGradient = true
            }
        }
    }
}

struct AdvancedStatusCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let trend: TrendType
    
    @State private var animate = false
    
    enum TrendType {
        case up, down, stable
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .scaleEffect(animate ? 1.1 : 1.0)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .rotationEffect(.degrees(animate ? 360 : 0))
            }
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.ringTitle)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.ringSmall)
                    .foregroundColor(.secondary)
                
                // Trend indicator
                HStack(spacing: 2) {
                    Image(systemName: trendIcon)
                        .font(.caption)
                        .foregroundColor(trendColor)
                    
                    Text(trendText)
                        .font(.ringSmall)
                        .foregroundColor(trendColor)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                animate = true
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
    
    private var trendText: String {
        switch trend {
        case .up: return "+12%"
        case .down: return "-5%"
        case .stable: return "0%"
        }
    }
}

// MARK: - Advanced Tab Navigation
struct AdvancedTabNavigation: View {
    @Binding var selectedTab: Int
    @State private var animateSelection = false
    
    private let tabs = [
        ("Automation", "bolt.fill", .blue),
        ("Analytics", "chart.bar.fill", .green),
        ("Monitor", "gauge", .orange),
        ("Control", "slider.horizontal.3", .purple)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                AdvancedTabButton(
                    title: tab.0,
                    icon: tab.1,
                    color: tab.2,
                    isSelected: selectedTab == index
                ) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedTab = index
                    }
                    HapticFeedback.impact(style: .light)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct AdvancedTabButton: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(isSelected ? color : .clear)
                        .frame(width: 40, height: 40)
                        .scaleEffect(animate ? 1.1 : 1.0)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .secondary)
                        .rotationEffect(.degrees(animate ? 360 : 0))
                }
                
                Text(title)
                    .font(.ringSmall)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? color : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            if isSelected {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    animate = true
                }
            }
        }
        .onChange(of: isSelected) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    animate = true
                }
            } else {
                animate = false
            }
        }
    }
}

// MARK: - Advanced Automation Studio
struct AdvancedAutomationStudio: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var showCreateAutomation = false
    @State private var animateCards = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Automation creation card
                AdvancedAutomationCard(
                    title: "Create New Automation",
                    description: "Build custom automation rules",
                    icon: "plus.circle.fill",
                    color: .blue,
                    action: { showCreateAutomation = true }
                )
                .offset(y: animateCards ? 0 : 50)
                .opacity(animateCards ? 1 : 0)
                
                // Sample automations
                ForEach(0..<5) { index in
                    AdvancedAutomationCard(
                        title: "Automation \(index + 1)",
                        description: "Sample automation rule",
                        icon: "bolt.fill",
                        color: [.green, .orange, .purple, .pink, .cyan][index],
                        action: {}
                    )
                    .offset(y: animateCards ? 0 : 50)
                    .opacity(animateCards ? 1 : 0)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.8)
                        .delay(Double(index) * 0.1),
                        value: animateCards
                    )
                }
            }
            .padding()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                animateCards = true
            }
        }
    }
}

struct AdvancedAutomationCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var glow = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                    
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
                        .rotationEffect(.degrees(glow ? 360 : 0))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.ringBody)
                        .fontWeight(.semibold)
                    
                    Text(description)
                        .font(.ringSmall)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(glow ? 0.5 : 0.2), lineWidth: glow ? 2 : 1)
            )
            .shadow(
                color: color.opacity(glow ? 0.3 : 0.1),
                radius: glow ? 10 : 5,
                x: 0,
                y: glow ? 5 : 2
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                glow = true
            }
        }
    }
}

// MARK: - Advanced Analytics Dashboard
struct AdvancedAnalyticsDashboard: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var animateCharts = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Energy usage chart
                AdvancedChartCard(
                    title: "Energy Usage",
                    subtitle: "Last 7 days",
                    data: [2.1, 3.2, 2.8, 4.1, 3.5, 2.9, 3.8],
                    color: .green
                )
                .offset(y: animateCharts ? 0 : 50)
                .opacity(animateCharts ? 1 : 0)
                
                // Device activity chart
                AdvancedChartCard(
                    title: "Device Activity",
                    subtitle: "Active devices over time",
                    data: [8, 12, 10, 15, 11, 13, 9],
                    color: .blue
                )
                .offset(y: animateCharts ? 0 : 50)
                .opacity(animateCharts ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCharts)
                
                // System health chart
                AdvancedChartCard(
                    title: "System Health",
                    subtitle: "Overall system performance",
                    data: [95, 92, 98, 89, 96, 94, 97],
                    color: .orange
                )
                .offset(y: animateCharts ? 0 : 50)
                .opacity(animateCharts ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCharts)
            }
            .padding()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                animateCharts = true
            }
        }
    }
}

struct AdvancedChartCard: View {
    let title: String
    let subtitle: String
    let data: [Double]
    let color: Color
    
    @State private var animateChart = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ringBody)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .font(.ringSmall)
                    .foregroundColor(.secondary)
            }
            
            // Simple bar chart
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, value in
                    VStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(color)
                            .frame(
                                width: 20,
                                height: animateChart ? CGFloat(value * 3) : 0
                            )
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.8)
                                .delay(Double(index) * 0.1),
                                value: animateChart
                            )
                        
                        Text("\(Int(value))")
                            .font(.ringSmall)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(height: 100)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                animateChart = true
            }
        }
    }
}

// MARK: - Advanced System Monitor
struct AdvancedSystemMonitor: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var animateMetrics = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // System health overview
                AdvancedMetricCard(
                    title: "System Health",
                    value: "\(Int(smartHomeManager.systemHealth.overallHealth * 100))%",
                    icon: "heart.fill",
                    color: .green,
                    trend: .up
                )
                .offset(y: animateMetrics ? 0 : 50)
                .opacity(animateMetrics ? 1 : 0)
                
                // Performance metrics
                ForEach(0..<3) { index in
                    AdvancedMetricCard(
                        title: ["Response Time", "Uptime", "Error Rate"][index],
                        value: ["0.2s", "99.8%", "0.1%"],
                        icon: ["clock.fill", "checkmark.circle.fill", "exclamationmark.triangle.fill"][index],
                        color: [.blue, .green, .orange][index],
                        trend: [.down, .up, .stable][index]
                    )
                    .offset(y: animateMetrics ? 0 : 50)
                    .opacity(animateMetrics ? 1 : 0)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.8)
                        .delay(Double(index) * 0.1),
                        value: animateMetrics
                    )
                }
            }
            .padding()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                animateMetrics = true
            }
        }
    }
}

// MARK: - Advanced Device Control Center
struct AdvancedDeviceControlCenter: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var animateDevices = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Quick controls
                AdvancedQuickControls(smartHomeManager: smartHomeManager)
                    .offset(y: animateDevices ? 0 : 50)
                    .opacity(animateDevices ? 1 : 0)
                
                // Device grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(smartHomeManager.devices.indices, id: \.self) { index in
                        AdvancedDeviceCard(
                            device: smartHomeManager.devices[index],
                            smartHomeManager: smartHomeManager
                        )
                        .offset(y: animateDevices ? 0 : 100)
                        .opacity(animateDevices ? 1 : 0)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.8)
                            .delay(Double(index) * 0.1),
                            value: animateDevices
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                animateDevices = true
            }
        }
    }
}

struct AdvancedQuickControls: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var animateControls = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Quick Controls")
                .font(.ringTitle)
                .fontWeight(.bold)
            
            HStack(spacing: 12) {
                ForEach(0..<4) { index in
                    AdvancedControlButton(
                        title: ["All On", "All Off", "Away", "Night"][index],
                        icon: ["power", "poweroff", "house", "moon.fill"][index],
                        color: [.green, .red, .orange, .purple][index],
                        action: {
                            switch index {
                            case 0: smartHomeManager.turnAllDevicesOn()
                            case 1: smartHomeManager.turnAllDevicesOff()
                            case 2: smartHomeManager.setAwayMode()
                            case 3: smartHomeManager.setNightMode()
                            default: break
                            }
                        }
                    )
                    .scaleEffect(animateControls ? 1.0 : 0.8)
                    .opacity(animateControls ? 1.0 : 0.0)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.8)
                        .delay(Double(index) * 0.1),
                        value: animateControls
                    )
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                animateControls = true
            }
        }
    }
}

struct AdvancedControlButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var glow = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                    
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
                        .rotationEffect(.degrees(glow ? 360 : 0))
                }
                
                Text(title)
                    .font(.ringSmall)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                glow = true
            }
        }
    }
}

struct AdvancedDeviceCard: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var isPressed = false
    @State private var glow = false
    
    var body: some View {
        VStack(spacing: 12) {
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
                            endRadius: 30
                        )
                    )
                    .frame(width: 60, height: 60)
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                
                Image(systemName: device.category.icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(glow ? 360 : 0))
            }
            
            VStack(spacing: 4) {
                Text(device.name)
                    .font(.ringBody)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text(device.category.displayName)
                    .font(.ringSmall)
                    .foregroundColor(.secondary)
            }
            
            AnimatedToggle(
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
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
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
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                glow = true
            }
        }
    }
}

// MARK: - Floating Action Menu
struct AdvancedFloatingActionMenu: View {
    @Binding var showAdvancedControls: Bool
    @Binding var showDeviceComparison: Bool
    @Binding var showAutomationWizard: Bool
    @State private var isExpanded = false
    @State private var animateButtons = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Secondary action buttons
            if isExpanded {
                VStack(spacing: 12) {
                    FloatingActionButton(
                        icon: "chart.bar.xaxis",
                        action: {
                            HapticFeedback.impact(style: .medium)
                            showDeviceComparison = true
                        },
                        color: .green
                    )
                    .scaleEffect(animateButtons ? 1.0 : 0.5)
                    .opacity(animateButtons ? 1.0 : 0.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.1), value: animateButtons)
                    
                    FloatingActionButton(
                        icon: "wand.and.stars",
                        action: {
                            HapticFeedback.impact(style: .medium)
                            showAutomationWizard = true
                        },
                        color: .purple
                    )
                    .scaleEffect(animateButtons ? 1.0 : 0.5)
                    .opacity(animateButtons ? 1.0 : 0.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.2), value: animateButtons)
                }
            }
            
            // Main action button
            Button(action: {
                HapticFeedback.impact(style: .medium)
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
                
                if isExpanded {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.1)) {
                        animateButtons = true
                    }
                } else {
                    animateButtons = false
                }
            }) {
                Image(systemName: isExpanded ? "xmark" : "plus")
                    .font(.system(size: 20, weight: .semibold))
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
                            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                    .rotationEffect(.degrees(isExpanded ? 45 : 0))
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isExpanded)
            }
        }
    }
}

// MARK: - Preview
struct RingAdvancedDesign_Previews: PreviewProvider {
    static var previews: some View {
        RingAdvancedDesign(smartHomeManager: SmartHomeManager())
    }
}