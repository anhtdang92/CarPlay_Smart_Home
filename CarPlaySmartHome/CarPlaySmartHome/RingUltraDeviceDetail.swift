import SwiftUI

// MARK: - Ultra Device Detail View
struct UltraDeviceDetailView: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @Environment(\.dismiss) private var dismiss
    @State private var animateContent = false
    @State private var showAdvancedControls = false
    @State private var selectedTab = 0
    @State private var morphingBackground = false
    
    var body: some View {
        ZStack {
            // Ultra morphing background
            UltraMorphingBackground()
            
            VStack(spacing: 0) {
                // Ultra header
                UltraDetailHeader(
                    device: device,
                    dismiss: dismiss
                )
                .offset(y: animateContent ? 0 : -50)
                .opacity(animateContent ? 1 : 0)
                
                // Ultra content
                UltraDetailContent(
                    device: device,
                    smartHomeManager: smartHomeManager,
                    selectedTab: $selectedTab,
                    showAdvancedControls: $showAdvancedControls
                )
                .offset(y: animateContent ? 0 : 50)
                .opacity(animateContent ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 1.2, dampingFraction: 0.8).delay(0.3)) {
                animateContent = true
            }
            withAnimation(.easeInOut(duration: 15.0).repeatForever(autoreverses: true)) {
                morphingBackground = true
            }
        }
    }
}

// MARK: - Ultra Morphing Background
struct UltraMorphingBackground: View {
    @State private var animate = false
    @State private var morphing = false
    
    var body: some View {
        ZStack {
            // Primary morphing gradient
            LinearGradient(
                colors: morphing ? 
                    [.purple.opacity(0.8), .blue.opacity(0.6), .pink.opacity(0.4), .cyan.opacity(0.2)] :
                    [.blue.opacity(0.8), .purple.opacity(0.6), .cyan.opacity(0.4), .pink.opacity(0.2)],
                startPoint: animate ? .topLeading : .bottomTrailing,
                endPoint: animate ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            
            // Morphing shapes
            ForEach(0..<6) { index in
                UltraMorphingShape(
                    index: index,
                    animate: animate,
                    morphing: morphing
                )
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 20.0).repeatForever(autoreverses: true)) {
                animate = true
            }
            withAnimation(.easeInOut(duration: 25.0).repeatForever(autoreverses: true)) {
                morphing = true
            }
        }
    }
}

struct UltraMorphingShape: View {
    let index: Int
    let animate: Bool
    let morphing: Bool
    
    @State private var rotation = 0.0
    @State private var scale = 1.0
    
    var body: some View {
        Group {
            switch index % 4 {
            case 0:
                Circle()
                    .fill(.white.opacity(0.1))
            case 1:
                RoundedRectangle(cornerRadius: 50)
                    .fill(.white.opacity(0.1))
            case 2:
                Triangle()
                    .fill(.white.opacity(0.1))
            case 3:
                Diamond()
                    .fill(.white.opacity(0.1))
            default:
                Circle()
                    .fill(.white.opacity(0.1))
            }
        }
        .frame(width: CGFloat.random(in: 100...300), height: CGFloat.random(in: 100...300))
        .rotationEffect(.degrees(rotation))
        .scaleEffect(scale)
        .offset(
            x: CGFloat.random(in: -200...200),
            y: CGFloat.random(in: -400...400)
        )
        .onAppear {
            withAnimation(
                .easeInOut(duration: Double.random(in: 15...25))
                .repeatForever(autoreverses: true)
            ) {
                rotation = 360
                scale = 1.5
            }
        }
    }
}

// MARK: - Ultra Detail Header
struct UltraDetailHeader: View {
    let device: RingDevice
    let dismiss: DismissAction
    @State private var animateIcon = false
    @State private var pulseGlow = false
    @State private var rotateBackground = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xl) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 44, height: 44)
                        )
                }
                
                Spacer()
                
                // Ultra device icon
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    device.status == .online ? device.category.color : .red,
                                    device.status == .online ? device.category.color.opacity(0.3) : .red.opacity(0.3)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 60
                            )
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(rotateBackground ? 360 : 0))
                        .shadow(
                            color: device.status == .online ? 
                                device.category.color.opacity(pulseGlow ? 1.0 : 0.6) : 
                                .red.opacity(pulseGlow ? 1.0 : 0.6),
                            radius: pulseGlow ? 40 : 25,
                            x: 0,
                            y: pulseGlow ? 20 : 12
                        )
                    
                    Image(systemName: device.category.icon)
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(animateIcon ? 360 : 0))
                }
                
                Spacer()
                
                Button(action: {
                    // Toggle favorite
                }) {
                    Image(systemName: device.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(device.isFavorite ? .red : .white)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 44, height: 44)
                        )
                }
            }
            
            VStack(spacing: RingDesignSystem.Spacing.md) {
                Text(device.name)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(device.category.displayName)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                
                // Status indicator
                HStack(spacing: RingDesignSystem.Spacing.sm) {
                    Circle()
                        .fill(device.status == .online ? .green : .red)
                        .frame(width: 12, height: 12)
                        .scaleEffect(pulseGlow ? 1.4 : 1.0)
                    
                    Text(device.status.rawValue.capitalized)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(RingDesignSystem.Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xxl)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xxl)
                        .stroke(.white.opacity(0.2), lineWidth: 2)
                )
        )
        .onAppear {
            withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: false)) {
                animateIcon = true
            }
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                pulseGlow = true
            }
            withAnimation(.linear(duration: 20.0).repeatForever(autoreverses: false)) {
                rotateBackground = true
            }
        }
    }
}

// MARK: - Ultra Detail Content
struct UltraDetailContent: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @Binding var selectedTab: Int
    @Binding var showAdvancedControls: Bool
    @State private var animateTabs = false
    
    private let tabs = ["Controls", "Settings", "Analytics", "Automation"]
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.lg) {
            // Ultra tab navigation
            UltraTabNavigation(
                tabs: tabs,
                selectedTab: $selectedTab,
                animateTabs: $animateTabs
            )
            
            // Tab content
            TabView(selection: $selectedTab) {
                UltraControlsTab(device: device, smartHomeManager: smartHomeManager)
                    .tag(0)
                
                UltraSettingsTab(device: device, smartHomeManager: smartHomeManager)
                    .tag(1)
                
                UltraAnalyticsTab(device: device, smartHomeManager: smartHomeManager)
                    .tag(2)
                
                UltraAutomationTab(device: device, smartHomeManager: smartHomeManager)
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .padding(RingDesignSystem.Spacing.lg)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.5)) {
                animateTabs = true
            }
        }
    }
}

// MARK: - Ultra Tab Navigation
struct UltraTabNavigation: View {
    let tabs: [String]
    @Binding var selectedTab: Int
    @Binding var animateTabs: Bool
    @State private var animateIndicator = false
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedTab = index
                    }
                    HapticFeedback.impact(style: .light)
                }) {
                    VStack(spacing: RingDesignSystem.Spacing.sm) {
                        Text(tab)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(selectedTab == index ? .white : .white.opacity(0.6))
                        
                        // Animated indicator
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: selectedTab == index ? 
                                        [.blue, .purple, .pink] :
                                        [.clear, .clear],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 3)
                            .scaleEffect(selectedTab == index ? 1.0 : 0.0)
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedTab)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
        )
        .offset(y: animateTabs ? 0 : 30)
        .opacity(animateTabs ? 1 : 0)
    }
}

// MARK: - Ultra Controls Tab
struct UltraControlsTab: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var animateControls = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xl) {
            // Main power control
            UltraPowerControl(device: device, smartHomeManager: smartHomeManager)
                .offset(y: animateControls ? 0 : 50)
                .opacity(animateControls ? 1 : 0)
            
            // Device-specific controls
            if device.category == .lights {
                UltraLightControls(device: device, smartHomeManager: smartHomeManager)
                    .offset(y: animateControls ? 0 : 50)
                    .opacity(animateControls ? 1 : 0)
            } else if device.category == .thermostats {
                UltraThermostatControls(device: device, smartHomeManager: smartHomeManager)
                    .offset(y: animateControls ? 0 : 50)
                    .opacity(animateControls ? 1 : 0)
            }
            
            // Quick actions
            UltraQuickActions(device: device, smartHomeManager: smartHomeManager)
                .offset(y: animateControls ? 0 : 50)
                .opacity(animateControls ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
                animateControls = true
            }
        }
    }
}

// MARK: - Ultra Power Control
struct UltraPowerControl: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var animate = false
    @State private var glow = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.lg) {
            Text("Power Control")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: device.isOn ? 
                                [device.category.color, device.category.color.opacity(0.3)] :
                                [.gray, .gray.opacity(0.3)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .shadow(
                        color: device.isOn ? 
                            device.category.color.opacity(glow ? 0.8 : 0.4) : 
                            .gray.opacity(glow ? 0.8 : 0.4),
                        radius: glow ? 30 : 20,
                        x: 0,
                        y: glow ? 15 : 10
                    )
                    .scaleEffect(animate ? 1.1 : 1.0)
                
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        if device.isOn {
                            smartHomeManager.turnDeviceOff(device)
                        } else {
                            smartHomeManager.turnDeviceOn(device)
                        }
                    }
                    HapticFeedback.impact(style: .medium)
                }) {
                    VStack(spacing: RingDesignSystem.Spacing.sm) {
                        Image(systemName: device.isOn ? "power" : "power")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(animate ? 360 : 0))
                        
                        Text(device.isOn ? "ON" : "OFF")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
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
        .padding(RingDesignSystem.Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xl)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xl)
                        .stroke(.white.opacity(0.2), lineWidth: 2)
                )
        )
        .onAppear {
            if device.isOn {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    glow = true
                }
            }
        }
        .onChange(of: device.isOn) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    glow = true
                }
            } else {
                glow = false
            }
        }
    }
}

// MARK: - Ultra Light Controls
struct UltraLightControls: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var brightness: Double = 100
    @State private var animateSlider = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.lg) {
            Text("Brightness Control")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            VStack(spacing: RingDesignSystem.Spacing.md) {
                HStack {
                    Image(systemName: "sun.min")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                    
                    UltraSlider(
                        value: $brightness,
                        range: 0...100,
                        color: device.category.color
                    )
                    .frame(height: 40)
                    
                    Image(systemName: "sun.max")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Text("\(Int(brightness))%")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .padding(RingDesignSystem.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
        )
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.5)) {
                animateSlider = true
            }
        }
    }
}

// MARK: - Ultra Slider
struct UltraSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let color: Color
    @State private var isDragging = false
    @State private var glow = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.2))
                    .frame(height: 8)
                
                // Progress
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: progressWidth(in: geometry), height: 8)
                    .shadow(
                        color: color.opacity(glow ? 0.6 : 0.3),
                        radius: glow ? 10 : 5,
                        x: 0,
                        y: glow ? 5 : 2
                    )
                
                // Thumb
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white, color.opacity(0.8)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 20
                        )
                    )
                    .frame(width: 40, height: 40)
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    .offset(x: thumbOffset(in: geometry))
                    .scaleEffect(isDragging ? 1.2 : 1.0)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                isDragging = true
                                updateValue(gesture: gesture, in: geometry)
                            }
                            .onEnded { _ in
                                isDragging = false
                                HapticFeedback.impact(style: .light)
                            }
                    )
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                glow = true
            }
        }
    }
    
    private func progressWidth(in geometry: GeometryProxy) -> CGFloat {
        let percentage = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return geometry.size.width * CGFloat(percentage)
    }
    
    private func thumbOffset(in geometry: GeometryProxy) -> CGFloat {
        let percentage = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return geometry.size.width * CGFloat(percentage) - 20
    }
    
    private func updateValue(gesture: DragGesture.Value, in geometry: GeometryProxy) {
        let percentage = max(0, min(1, gesture.location.x / geometry.size.width))
        value = range.lowerBound + (range.upperBound - range.lowerBound) * Double(percentage)
    }
}

// MARK: - Ultra Quick Actions
struct UltraQuickActions: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var animateActions = false
    
    private let quickActions = [
        ("Schedule", "clock"),
        ("Share", "square.and.arrow.up"),
        ("Rename", "pencil"),
        ("Delete", "trash")
    ]
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.lg) {
            Text("Quick Actions")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: RingDesignSystem.Spacing.md), count: 2),
                spacing: RingDesignSystem.Spacing.md
            ) {
                ForEach(Array(quickActions.enumerated()), id: \.offset) { index, action in
                    UltraQuickActionButton(
                        title: action.0,
                        icon: action.1,
                        color: [.blue, .purple, .orange, .red][index]
                    ) {
                        // Handle action
                        HapticFeedback.impact(style: .light)
                    }
                    .offset(y: animateActions ? 0 : 30)
                    .opacity(animateActions ? 1 : 0)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.8)
                        .delay(Double(index) * 0.1),
                        value: animateActions
                    )
                }
            }
        }
        .padding(RingDesignSystem.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
        )
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.7)) {
                animateActions = true
            }
        }
    }
}

struct UltraQuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    @State private var animate = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .scaleEffect(animate ? 1.1 : 1.0)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(color)
                        .rotationEffect(.degrees(animate ? 360 : 0))
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(RingDesignSystem.Spacing.md)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                animate = pressing
            }
        }, perform: {})
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

// MARK: - Placeholder Views for Other Tabs
struct UltraSettingsTab: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xl) {
            Text("Device Settings")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Advanced settings and configuration options will be available here.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding(RingDesignSystem.Spacing.xl)
    }
}

struct UltraAnalyticsTab: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xl) {
            Text("Device Analytics")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Usage statistics and performance metrics will be displayed here.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding(RingDesignSystem.Spacing.xl)
    }
}

struct UltraAutomationTab: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xl) {
            Text("Device Automation")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Automation rules and scheduling options will be available here.")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding(RingDesignSystem.Spacing.xl)
    }
}

#Preview {
    UltraDeviceDetailView(
        device: RingDevice(
            id: "1",
            name: "Living Room Light",
            category: .lights,
            status: .online,
            isOn: true
        ),
        smartHomeManager: SmartHomeManager()
    )
    .preferredColorScheme(.dark)
} 