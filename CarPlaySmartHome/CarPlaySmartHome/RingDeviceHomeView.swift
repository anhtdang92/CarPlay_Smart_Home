import SwiftUI

struct RingDeviceHomeView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedDevice: RingDevice?
    @State private var showingDeviceDetail = false
    @State private var isRefreshing = false
    @State private var showQuickActions = false
    @State private var selectedQuickAction: QuickAction?
    @State private var selectedCategory: DeviceCategory? = nil
    @State private var showGrid = true
    @State private var animateCards = false
    @State private var showLiquidEffects = false
    
    // Animation states
    @State private var showWelcomeAnimation = false
    @State private var pulseAnimation = false
    
    // UI Enhancement states
    @State private var showDeviceStatus = true
    @State private var showEnergyUsage = true
    
    enum QuickAction: String, CaseIterable {
        case allOn = "All On"
        case allOff = "All Off"
        case away = "Away Mode"
        case home = "Home Mode"
        case night = "Night Mode"
        
        var icon: String {
            switch self {
            case .allOn: return "lightbulb.fill"
            case .allOff: return "lightbulb.slash.fill"
            case .away: return "house.slash.fill"
            case .home: return "house.fill"
            case .night: return "moon.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .allOn: return .orange
            case .allOff: return .gray
            case .away: return .red
            case .home: return .green
            case .night: return .purple
            }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Enhanced quick actions section
                FloatingLabelCard(title: "Quick Actions", color: .blue) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        MagneticButton(
                            icon: "power",
                            color: .green
                        ) {
                            smartHomeManager.turnAllDevicesOn()
                        }
                        
                        MagneticButton(
                            icon: "poweroff",
                            color: .red
                        ) {
                            smartHomeManager.turnAllDevicesOff()
                        }
                        
                        MagneticButton(
                            icon: "house",
                            color: .orange
                        ) {
                            smartHomeManager.setAwayMode()
                        }
                        
                        MagneticButton(
                            icon: "moon.fill",
                            color: .purple
                        ) {
                            smartHomeManager.setNightMode()
                        }
                    }
                }
                .offset(y: animateCards ? 0 : 50)
                .opacity(animateCards ? 1 : 0)
                
                // Enhanced device status overview
                FloatingLabelCard(title: "System Status", color: .green) {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Online Devices")
                                    .font(.ringCaption)
                                    .foregroundColor(.secondary)
                                Text("\(smartHomeManager.onlineDevices)")
                                    .font(.ringTitle)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                            
                            AnimatedProgressBar(
                                progress: Double(smartHomeManager.onlineDevices) / Double(max(smartHomeManager.devices.count, 1)),
                                color: .green,
                                height: 8
                            )
                            .frame(width: 100)
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Energy Usage")
                                    .font(.ringCaption)
                                    .foregroundColor(.secondary)
                                Text("\(smartHomeManager.totalEnergyUsage, specifier: "%.1f") kWh")
                                    .font(.ringTitle)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                            
                            AnimatedIcon(
                                icon: "bolt.fill",
                                color: .yellow,
                                animationType: .pulse
                            )
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Active Automations")
                                    .font(.ringCaption)
                                    .foregroundColor(.secondary)
                                Text("\(smartHomeManager.activeAutomations)")
                                    .font(.ringTitle)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                            
                            AnimatedIcon(
                                icon: "gearshape.fill",
                                color: .blue,
                                animationType: .rotate
                            )
                        }
                    }
                }
                .offset(y: animateCards ? 0 : 50)
                .opacity(animateCards ? 1 : 0)
                
                // Enhanced category filters with morphing buttons
                FloatingLabelCard(title: "Categories", color: .purple) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            MorphingButton(
                                title: "All",
                                icon: "square.grid.2x2"
                            ) {
                                selectedCategory = nil
                            }
                            
                            ForEach(DeviceCategory.allCases, id: \.self) { category in
                                MorphingButton(
                                    title: category.displayName,
                                    icon: category.icon
                                ) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .offset(y: animateCards ? 0 : 50)
                .opacity(animateCards ? 1 : 0)
                
                // Enhanced device grid/list toggle
                HStack {
                    Text("Devices")
                        .font(.ringTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showGrid = true
                            }
                        }) {
                            Image(systemName: "square.grid.2x2")
                                .font(.title3)
                                .foregroundColor(showGrid ? .blue : .secondary)
                                .frame(width: 40, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(showGrid ? .blue.opacity(0.2) : .clear)
                                )
                        }
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showGrid = false
                            }
                        }) {
                            Image(systemName: "list.bullet")
                                .font(.title3)
                                .foregroundColor(!showGrid ? .blue : .secondary)
                                .frame(width: 40, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(!showGrid ? .blue.opacity(0.2) : .clear)
                                )
                        }
                    }
                }
                .padding(.horizontal)
                .offset(y: animateCards ? 0 : 50)
                .opacity(animateCards ? 1 : 0)
                
                // Enhanced device display
                if showGrid {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                        ForEach(filteredDevices.indices, id: \.self) { index in
                            EnhancedDeviceCard(
                                device: filteredDevices[index],
                                smartHomeManager: smartHomeManager
                            )
                            .offset(y: animateCards ? 0 : 100)
                            .opacity(animateCards ? 1 : 0)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.8)
                                .delay(Double(index) * 0.1),
                                value: animateCards
                            )
                        }
                    }
                    .padding(.horizontal)
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredDevices.indices, id: \.self) { index in
                            EnhancedDeviceListCard(
                                device: filteredDevices[index],
                                smartHomeManager: smartHomeManager
                            )
                            .offset(y: animateCards ? 0 : 100)
                            .opacity(animateCards ? 1 : 0)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.8)
                                .delay(Double(index) * 0.05),
                                value: animateCards
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Empty state with liquid effects
                if filteredDevices.isEmpty {
                    VStack(spacing: 20) {
                        if showLiquidEffects {
                            LiquidBlobView(color: .blue, size: 100)
                        }
                        
                        VStack(spacing: 12) {
                            Text("No Devices Found")
                                .font(.ringTitle)
                                .fontWeight(.bold)
                            
                            Text("Add some devices to get started with your smart home")
                                .font(.ringBody)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        RippleButton(
                            title: "Add Device",
                            icon: "plus"
                        ) {
                            // Add device action
                        }
                    }
                    .padding(.vertical, 40)
                    .offset(y: animateCards ? 0 : 50)
                    .opacity(animateCards ? 1 : 0)
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                animateCards = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    showLiquidEffects = true
                }
            }
        }
        .sheet(isPresented: $showingDeviceDetail) {
            if let device = selectedDevice {
                DeviceDetailView(device: device, smartHomeManager: smartHomeManager)
            }
        }
    }
    
    private var filteredDevices: [RingDevice] {
        if let category = selectedCategory {
            return smartHomeManager.devices.filter { $0.category == category }
        }
        return smartHomeManager.devices
    }
    
    private func startAnimations() {
        // Welcome animation
        withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
            showWelcomeAnimation = true
        }
        
        // Quick actions animation
        withAnimation(.easeInOut(duration: 0.6).delay(1.0)) {
            showQuickActions = true
        }
        
        // Status overview animation
        withAnimation(.easeInOut(duration: 0.6).delay(0.4)) {
            showDeviceStatus = true
        }
        
        // Energy usage animation
        withAnimation(.easeInOut(duration: 0.6).delay(0.6)) {
            showEnergyUsage = true
        }
        
        // Device cards animation
        withAnimation(.easeInOut(duration: 0.8).delay(0.8)) {
            animateCards = true
        }
        
        // Pulse animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            pulseAnimation = true
        }
    }
    
    private func executeQuickAction(_ action: QuickAction) {
        switch action {
        case .allOn:
            smartHomeManager.turnOnAllDevices()
        case .allOff:
            smartHomeManager.turnOffAllDevices()
        case .away:
            smartHomeManager.setAwayMode()
        case .home:
            smartHomeManager.setHomeMode()
        case .night:
            smartHomeManager.setNightMode()
        }
        
        HapticFeedback.notification(type: .success)
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let action: RingDeviceHomeView.QuickAction
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: action.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : action.color)
                
                Text(action.rawValue)
                    .font(.ringSmall)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? action.color : .ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(action.color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Device Status Overview
struct DeviceStatusOverview: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    
    var body: some View {
        GlassmorphismCard {
            VStack(spacing: 16) {
                HStack {
                    Text("Status Overview")
                        .font(.ringHeadline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    // Refresh button
                    Button(action: {
                        HapticFeedback.impact(style: .light)
                        smartHomeManager.refreshDeviceStatus()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                }
                
                HStack(spacing: 20) {
                    StatusCard(
                        title: "Online",
                        count: smartHomeManager.devices.filter { $0.status == .online }.count,
                        total: smartHomeManager.devices.count,
                        color: .successGreen,
                        icon: "checkmark.circle.fill"
                    )
                    
                    StatusCard(
                        title: "Offline",
                        count: smartHomeManager.devices.filter { $0.status == .offline }.count,
                        total: smartHomeManager.devices.count,
                        color: .errorRed,
                        icon: "xmark.circle.fill"
                    )
                    
                    StatusCard(
                        title: "Active",
                        count: smartHomeManager.devices.filter { $0.isOn }.count,
                        total: smartHomeManager.devices.count,
                        color: .warningOrange,
                        icon: "bolt.fill"
                    )
                }
            }
            .padding()
        }
        .padding(.horizontal)
    }
}

// MARK: - Status Card
struct StatusCard: View {
    let title: String
    let count: Int
    let total: Int
    let color: Color
    let icon: String
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Spacer()
                
                Text("\(count)")
                    .font(.ringHeadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            Text(title)
                .font(.ringSmall)
                .foregroundColor(.secondary)
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(color.opacity(0.2))
                        .frame(height: 4)
                        .cornerRadius(2)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 4)
                        .cornerRadius(2)
                        .animation(.easeInOut(duration: 0.8), value: percentage)
                }
            }
            .frame(height: 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Energy Usage Summary
struct EnergyUsageSummary: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var animateProgress = false
    
    private var totalEnergyUsage: Double {
        smartHomeManager.devices.reduce(0) { $0 + $1.energyUsage }
    }
    
    private var averageUsage: Double {
        smartHomeManager.devices.isEmpty ? 0 : totalEnergyUsage / Double(smartHomeManager.devices.count)
    }
    
    var body: some View {
        GlassmorphismCard {
            VStack(spacing: 16) {
                HStack {
                    Text("Energy Usage")
                        .font(.ringHeadline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("Today")
                        .font(.ringCaption)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 20) {
                    VStack(spacing: 8) {
                        AnimatedCounter(
                            value: Int(totalEnergyUsage),
                            prefix: "",
                            suffix: " kWh"
                        )
                        .font(.ringTitle)
                        .foregroundColor(.primary)
                        
                        Text("Total Usage")
                            .font(.ringSmall)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        AnimatedProgressRing(
                            progress: min(averageUsage / 10.0, 1.0), // Normalize to 0-1
                            lineWidth: 8,
                            size: 60,
                            color: .blue
                        )
                        
                        Text("Avg/Device")
                            .font(.ringSmall)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Usage trend
                HStack {
                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundColor(.successGreen)
                    
                    Text("12% increase from yesterday")
                        .font(.ringSmall)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            .padding()
        }
        .padding(.horizontal)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(0.5)) {
                animateProgress = true
            }
        }
    }
}

// MARK: - Device Grid View
struct DeviceGridView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @Binding var selectedDevice: RingDevice?
    @Binding var showingDeviceDetail: Bool
    @Binding var animateCards: Bool
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(Array(smartHomeManager.devices.enumerated()), id: \.element.id) { index, device in
                DeviceCard(
                    device: device,
                    smartHomeManager: smartHomeManager
                )
                .onTapGesture {
                    HapticFeedback.impact(style: .light)
                    selectedDevice = device
                    showingDeviceDetail = true
                }
                .offset(y: animateCards ? 0 : 50)
                .opacity(animateCards ? 1 : 0)
                .animation(
                    .spring(response: 0.6, dampingFraction: 0.8)
                    .delay(Double(index) * 0.1),
                    value: animateCards
                )
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Device List View
struct DeviceListView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @Binding var selectedDevice: RingDevice?
    @Binding var showingDeviceDetail: Bool
    
    var body: some View {
        LazyVStack(spacing: 12) {
            ForEach(smartHomeManager.devices) { device in
                DeviceListItem(
                    device: device,
                    smartHomeManager: smartHomeManager
                )
                .onTapGesture {
                    HapticFeedback.impact(style: .light)
                    selectedDevice = device
                    showingDeviceDetail = true
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Device Card
struct DeviceCard: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Device icon with status indicator
            ZStack {
                Circle()
                    .fill(device.status == .online ? .successGreen.opacity(0.2) : .errorRed.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: device.icon)
                    .font(.title2)
                    .foregroundColor(device.status == .online ? .successGreen : .errorRed)
                
                // Status indicator
                Circle()
                    .fill(device.status == .online ? .successGreen : .errorRed)
                    .frame(width: 12, height: 12)
                    .offset(x: 20, y: -20)
            }
            
            VStack(spacing: 4) {
                Text(device.name)
                    .font(.ringBody)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(device.status.rawValue.capitalized)
                    .font(.ringSmall)
                    .foregroundColor(.secondary)
            }
            
            // Toggle switch
            Toggle("", isOn: Binding(
                get: { device.isOn },
                set: { newValue in
                    HapticFeedback.impact(style: .medium)
                    smartHomeManager.toggleDevice(device)
                }
            ))
            .toggleStyle(CustomToggleStyle())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(device.status == .online ? .successGreen.opacity(0.3) : .errorRed.opacity(0.3), lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// MARK: - Device List Item
struct DeviceListItem: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Device icon
            ZStack {
                Circle()
                    .fill(device.status == .online ? .successGreen.opacity(0.2) : .errorRed.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: device.icon)
                    .font(.title3)
                    .foregroundColor(device.status == .online ? .successGreen : .errorRed)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(device.name)
                    .font(.ringBody)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                HStack {
                    Text(device.status.rawValue.capitalized)
                        .font(.ringSmall)
                        .foregroundColor(.secondary)
                    
                    if device.status == .online {
                        Text("•")
                            .font(.ringSmall)
                            .foregroundColor(.successGreen)
                        
                        Text("\(Int(device.energyUsage)) kWh")
                            .font(.ringSmall)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            // Toggle switch
            Toggle("", isOn: Binding(
                get: { device.isOn },
                set: { newValue in
                    HapticFeedback.impact(style: .medium)
                    smartHomeManager.toggleDevice(device)
                }
            ))
            .toggleStyle(CustomToggleStyle())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// MARK: - Custom Toggle Style
struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? .blue : .gray.opacity(0.3))
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .fill(.white)
                        .frame(width: 26, height: 26)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isOn)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Device Detail View
struct DeviceDetailView: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Device header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(device.status == .online ? .successGreen.opacity(0.2) : .errorRed.opacity(0.2))
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: device.icon)
                                .font(.system(size: 48))
                                .foregroundColor(device.status == .online ? .successGreen : .errorRed)
                        }
                        
                        VStack(spacing: 8) {
                            Text(device.name)
                                .font(.ringTitle)
                                .fontWeight(.bold)
                            
                            Text(device.status.rawValue.capitalized)
                                .font(.ringBody)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    
                    // Device controls
                    VStack(spacing: 16) {
                        HStack {
                            Text("Controls")
                                .font(.ringHeadline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        // Power toggle
                        HStack {
                            Text("Power")
                                .font(.ringBody)
                            
                            Spacer()
                            
                            Toggle("", isOn: Binding(
                                get: { device.isOn },
                                set: { newValue in
                                    HapticFeedback.impact(style: .medium)
                                    smartHomeManager.toggleDevice(device)
                                }
                            ))
                            .toggleStyle(CustomToggleStyle())
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                        )
                    }
                    .padding(.horizontal)
                    
                    // Device information
                    VStack(spacing: 16) {
                        HStack {
                            Text("Information")
                                .font(.ringHeadline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        VStack(spacing: 12) {
                            InfoRow(title: "Type", value: device.type.rawValue.capitalized)
                            InfoRow(title: "Location", value: device.location)
                            InfoRow(title: "Energy Usage", value: "\(device.energyUsage, specifier: "%.2f") kWh")
                            InfoRow(title: "Last Updated", value: device.lastUpdated.timeAgoDisplay())
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Device Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Info Row
struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.ringBody)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.ringBody)
                .fontWeight(.medium)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Time Extension
extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

// MARK: - Preview
struct RingDeviceHomeView_Previews: PreviewProvider {
    static var previews: some View {
        RingDeviceHomeView(smartHomeManager: SmartHomeManager())
    }
}

struct EnhancedDeviceCard: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var isPressed = false
    @State private var showGlow = false
    
    var body: some View {
        GlowingCard(
            glowColor: device.status == .online ? .green : .red,
            intensity: showGlow ? 0.4 : 0.2
        ) {
            VStack(spacing: 12) {
                // Device icon with animation
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
                        .rotationEffect(.degrees(showGlow ? 360 : 0))
                        .animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: showGlow)
                }
                
                // Device info
                VStack(spacing: 4) {
                    Text(device.name)
                        .font(.ringBody)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Text(device.category.displayName)
                        .font(.ringSmall)
                        .foregroundColor(.secondary)
                }
                
                // Status indicator
                HStack {
                    Circle()
                        .fill(device.status == .online ? .green : .red)
                        .frame(width: 8, height: 8)
                        .scaleEffect(showGlow ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: showGlow)
                    
                    Text(device.status.rawValue.capitalized)
                        .font(.ringSmall)
                        .foregroundColor(.secondary)
                }
                
                // Device toggle
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
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                showGlow = true
            }
        }
    }
}

struct EnhancedDeviceListCard: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var isPressed = false
    @State private var showGlow = false
    
    var body: some View {
        GlowingCard(
            glowColor: device.status == .online ? .green : .red,
            intensity: showGlow ? 0.3 : 0.1
        ) {
            HStack(spacing: 16) {
                // Device icon
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
                                endRadius: 25
                            )
                        )
                        .frame(width: 50, height: 50)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                    
                    Image(systemName: device.category.icon)
                        .font(.title3)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(showGlow ? 360 : 0))
                        .animation(.linear(duration: 3.0).repeatForever(autoreverses: false), value: showGlow)
                }
                
                // Device info
                VStack(alignment: .leading, spacing: 4) {
                    Text(device.name)
                        .font(.ringBody)
                        .fontWeight(.semibold)
                    
                    Text(device.category.displayName)
                        .font(.ringSmall)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Circle()
                            .fill(device.status == .online ? .green : .red)
                            .frame(width: 6, height: 6)
                            .scaleEffect(showGlow ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: showGlow)
                        
                        Text(device.status.rawValue.capitalized)
                            .font(.ringSmall)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Device toggle
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
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                showGlow = true
            }
        }
    }
} 