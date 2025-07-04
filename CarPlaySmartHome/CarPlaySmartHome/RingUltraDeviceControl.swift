import SwiftUI

// MARK: - Ultra Modern Device Control
struct RingUltraDeviceControl: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedCategory: DeviceCategory = .all
    @State private var showAddDevice = false
    @State private var animateDevices = false
    @State private var searchText = ""
    @State private var showSearch = false
    
    var body: some View {
        ZStack {
            // Ultra background
            UltraModernBackground()
            
            VStack(spacing: 0) {
                // Ultra search and filter header
                UltraSearchHeader(
                    searchText: $searchText,
                    showSearch: $showSearch,
                    selectedCategory: $selectedCategory
                )
                .offset(y: animateDevices ? 0 : -30)
                .opacity(animateDevices ? 1 : 0)
                
                // Ultra device grid
                UltraDeviceGrid(
                    smartHomeManager: smartHomeManager,
                    selectedCategory: selectedCategory,
                    searchText: searchText
                )
                .offset(y: animateDevices ? 0 : 30)
                .opacity(animateDevices ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
                animateDevices = true
            }
        }
        .sheet(isPresented: $showAddDevice) {
            UltraAddDeviceView(smartHomeManager: smartHomeManager)
        }
    }
}

// MARK: - Ultra Search Header
struct UltraSearchHeader: View {
    @Binding var searchText: String
    @Binding var showSearch: Bool
    @Binding var selectedCategory: DeviceCategory
    @Environment(\.colorScheme) var colorScheme
    @State private var animateSearch = false
    
    private let categories: [DeviceCategory] = [.all, .lights, .switches, .sensors, .cameras, .thermostats]
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.lg) {
            // Search bar
            HStack(spacing: RingDesignSystem.Spacing.md) {
                HStack(spacing: RingDesignSystem.Spacing.sm) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    TextField("Search devices...", text: $searchText)
                        .font(RingDesignSystem.Typography.body)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(RingDesignSystem.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                        )
                )
                .scaleEffect(animateSearch ? 1.02 : 1.0)
                
                Button(action: {
                    showSearch.toggle()
                }) {
                    Image(systemName: showSearch ? "xmark.circle.fill" : "slider.horizontal.3")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.blue)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Circle()
                                        .stroke(.blue.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
            }
            
            // Category filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: RingDesignSystem.Spacing.md) {
                    ForEach(categories, id: \.self) { category in
                        UltraCategoryButton(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedCategory = category
                            }
                            HapticFeedback.impact(style: .light)
                        }
                    }
                }
                .padding(.horizontal, RingDesignSystem.Spacing.lg)
            }
        }
        .padding(RingDesignSystem.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xl)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xl)
                        .stroke(
                            colorScheme == .dark ? 
                                Color.white.opacity(0.1) : 
                                Color.black.opacity(0.1),
                            lineWidth: 1
                        )
                )
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                animateSearch = true
            }
        }
    }
}

struct UltraCategoryButton: View {
    let category: DeviceCategory
    let isSelected: Bool
    let action: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: RingDesignSystem.Spacing.xs) {
                ZStack {
                    Circle()
                        .fill(isSelected ? category.color : .clear)
                        .frame(width: 50, height: 50)
                        .scaleEffect(animate ? 1.1 : 1.0)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(isSelected ? .white : category.color)
                        .rotationEffect(.degrees(animate ? 360 : 0))
                }
                
                Text(category.displayName)
                    .font(RingDesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? category.color : .secondary)
            }
            .padding(.vertical, RingDesignSystem.Spacing.sm)
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

// MARK: - Ultra Device Grid
struct UltraDeviceGrid: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    let selectedCategory: DeviceCategory
    let searchText: String
    @State private var animateGrid = false
    
    var filteredDevices: [RingDevice] {
        var devices = smartHomeManager.devices
        
        if selectedCategory != .all {
            devices = devices.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            devices = devices.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return devices
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: RingDesignSystem.Spacing.lg) {
                if filteredDevices.isEmpty {
                    UltraEmptyState(
                        category: selectedCategory,
                        searchText: searchText
                    )
                } else {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: RingDesignSystem.Spacing.md), count: 2),
                        spacing: RingDesignSystem.Spacing.md
                    ) {
                        ForEach(Array(filteredDevices.enumerated()), id: \.offset) { index, device in
                            UltraDeviceCard(
                                device: device,
                                smartHomeManager: smartHomeManager
                            )
                            .offset(y: animateGrid ? 0 : 100)
                            .opacity(animateGrid ? 1 : 0)
                            .animation(
                                .spring(response: 0.8, dampingFraction: 0.8)
                                .delay(Double(index) * 0.1),
                                value: animateGrid
                            )
                        }
                    }
                    .padding(.horizontal, RingDesignSystem.Spacing.lg)
                }
            }
            .padding(.vertical, RingDesignSystem.Spacing.lg)
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.5)) {
                animateGrid = true
            }
        }
    }
}

// MARK: - Ultra Device Card
struct UltraDeviceCard: View {
    let device: RingDevice
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var isPressed = false
    @State private var glow = false
    @State private var rotate = false
    @State private var showDetails = false
    
    var body: some View {
        Button(action: {
            showDetails = true
        }) {
            VStack(spacing: RingDesignSystem.Spacing.md) {
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
                                endRadius: 50
                            )
                        )
                        .frame(width: 100, height: 100)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                        .shadow(
                            color: device.status == .online ? 
                                device.category.color.opacity(glow ? 0.8 : 0.4) : 
                                .red.opacity(glow ? 0.8 : 0.4),
                            radius: glow ? 25 : 15,
                            x: 0,
                            y: glow ? 15 : 8
                        )
                    
                    Image(systemName: device.category.icon)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(rotate ? 360 : 0))
                }
                
                VStack(spacing: RingDesignSystem.Spacing.xs) {
                    Text(device.name)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .lineLimit(1)
                        .foregroundColor(.primary)
                    
                    Text(device.category.displayName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    // Status indicator
                    HStack(spacing: RingDesignSystem.Spacing.xs) {
                        Circle()
                            .fill(device.status == .online ? .green : .red)
                            .frame(width: 10, height: 10)
                            .scaleEffect(glow ? 1.3 : 1.0)
                        
                        Text(device.status.rawValue.capitalized)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Ultra toggle
                UltraToggle(
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
                    color: device.status == .online ? device.category.color : .gray
                )
            }
            .padding(RingDesignSystem.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xl)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xl)
                            .stroke(
                                device.status == .online ? 
                                    device.category.color.opacity(glow ? 0.6 : 0.3) : 
                                    .red.opacity(glow ? 0.6 : 0.3),
                                lineWidth: glow ? 3 : 2
                            )
                    )
            )
            .shadow(
                color: device.status == .online ? 
                    device.category.color.opacity(glow ? 0.3 : 0.1) : 
                    .red.opacity(glow ? 0.3 : 0.1),
                radius: glow ? 20 : 10,
                x: 0,
                y: glow ? 10 : 5
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
                glow = true
            }
            withAnimation(.linear(duration: 10.0).repeatForever(autoreverses: false)) {
                rotate = true
            }
        }
        .sheet(isPresented: $showDetails) {
            UltraDeviceDetailView(device: device, smartHomeManager: smartHomeManager)
        }
    }
}

// MARK: - Ultra Toggle
struct UltraToggle: View {
    @Binding var isOn: Bool
    let color: Color
    @State private var animate = false
    @State private var glow = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                isOn.toggle()
            }
            HapticFeedback.impact(style: .light)
        }) {
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        LinearGradient(
                            colors: isOn ? 
                                [color, color.opacity(0.8)] :
                                [.gray.opacity(0.4), .gray.opacity(0.2)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 70, height: 36)
                    .shadow(
                        color: isOn ? color.opacity(glow ? 0.6 : 0.3) : .clear,
                        radius: glow ? 15 : 8,
                        x: 0,
                        y: glow ? 8 : 4
                    )
                
                // Thumb
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.white, .gray.opacity(0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 32, height: 32)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    .offset(x: isOn ? 17 : -17)
                    .scaleEffect(animate ? 1.1 : 1.0)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                animate = pressing
            }
        }, perform: {})
        .onAppear {
            if isOn {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    glow = true
                }
            }
        }
        .onChange(of: isOn) { newValue in
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

// MARK: - Ultra Empty State
struct UltraEmptyState: View {
    let category: DeviceCategory
    let searchText: String
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xl) {
            ZStack {
                Circle()
                    .fill(category.color.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(animate ? 1.2 : 1.0)
                
                Image(systemName: category.icon)
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(category.color)
                    .rotationEffect(.degrees(animate ? 360 : 0))
            }
            
            VStack(spacing: RingDesignSystem.Spacing.md) {
                Text(emptyStateTitle)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                
                Text(emptyStateMessage)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(RingDesignSystem.Spacing.xxl)
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
    
    private var emptyStateTitle: String {
        if !searchText.isEmpty {
            return "No devices found"
        }
        
        switch category {
        case .all:
            return "No devices yet"
        case .lights:
            return "No lights connected"
        case .switches:
            return "No switches connected"
        case .sensors:
            return "No sensors connected"
        case .cameras:
            return "No cameras connected"
        case .thermostats:
            return "No thermostats connected"
        }
    }
    
    private var emptyStateMessage: String {
        if !searchText.isEmpty {
            return "Try adjusting your search terms"
        }
        
        switch category {
        case .all:
            return "Add your first smart device to get started"
        case .lights:
            return "Connect smart lights to control your home lighting"
        case .switches:
            return "Add smart switches to control your appliances"
        case .sensors:
            return "Install sensors to monitor your home environment"
        case .cameras:
            return "Set up security cameras to watch over your home"
        case .thermostats:
            return "Connect thermostats to manage your home temperature"
        }
    }
}

#Preview {
    RingUltraDeviceControl(smartHomeManager: SmartHomeManager())
        .preferredColorScheme(.dark)
} 