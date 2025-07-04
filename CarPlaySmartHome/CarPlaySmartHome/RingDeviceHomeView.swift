import SwiftUI

struct RingDeviceHomeView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedDevice: RingDevice?
    @State private var showingDeviceDetail = false
    @State private var isRefreshing = false
    @State private var showQuickActions = false
    @State private var selectedQuickAction: QuickAction?
    
    // Animation states
    @State private var animateCards = false
    @State private var showWelcomeAnimation = false
    @State private var pulseAnimation = false
    
    // UI Enhancement states
    @State private var showGridLayout = true
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
        VStack(spacing: 20) {
            // Welcome section with animated counter
            if showWelcomeAnimation {
                GlassmorphismCard {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Welcome Home")
                                    .font(.ringTitle)
                                    .foregroundColor(.primary)
                                
                                Text("Your smart home is ready")
                                    .font(.ringBody)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            // Animated device counter
                            VStack(spacing: 4) {
                                AnimatedCounter(
                                    value: smartHomeManager.devices.count,
                                    prefix: "",
                                    suffix: ""
                                )
                                .font(.ringHeadline)
                                .foregroundColor(.blue)
                                
                                Text("Devices")
                                    .font(.ringSmall)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Quick actions row
                        if showQuickActions {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(QuickAction.allCases, id: \.self) { action in
                                        QuickActionButton(
                                            action: action,
                                            isSelected: selectedQuickAction == action
                                        ) {
                                            HapticFeedback.impact(style: .medium)
                                            selectedQuickAction = action
                                            executeQuickAction(action)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding()
                }
                .padding(.horizontal)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            // Device status overview
            if showDeviceStatus {
                DeviceStatusOverview(smartHomeManager: smartHomeManager)
                    .transition(.scale.combined(with: .opacity))
            }
            
            // Energy usage summary
            if showEnergyUsage {
                EnergyUsageSummary(smartHomeManager: smartHomeManager)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // Device grid/list toggle
            HStack {
                Text("Your Devices")
                    .font(.ringHeadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // Layout toggle
                Button(action: {
                    HapticFeedback.impact(style: .light)
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showGridLayout.toggle()
                    }
                }) {
                    Image(systemName: showGridLayout ? "list.bullet" : "square.grid.2x2")
                        .font(.title3)
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                        )
                }
            }
            .padding(.horizontal)
            
            // Device grid/list
            if showGridLayout {
                DeviceGridView(
                    smartHomeManager: smartHomeManager,
                    selectedDevice: $selectedDevice,
                    showingDeviceDetail: $showingDeviceDetail,
                    animateCards: $animateCards
                )
            } else {
                DeviceListView(
                    smartHomeManager: smartHomeManager,
                    selectedDevice: $selectedDevice,
                    showingDeviceDetail: $showingDeviceDetail
                )
            }
        }
        .onAppear {
            startAnimations()
        }
        .sheet(isPresented: $showingDeviceDetail) {
            if let device = selectedDevice {
                DeviceDetailView(device: device, smartHomeManager: smartHomeManager)
            }
        }
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