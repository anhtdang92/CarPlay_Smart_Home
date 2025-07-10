import SwiftUI

// MARK: - Modern CarPlay Interface

struct ModernCarPlayInterface: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedTab: CarPlayTab = .dashboard
    @State private var showQuickActions = false
    @State private var searchText = ""
    @State private var showAddDevice = false
    @Environment(\.colorScheme) var colorScheme
    
    enum CarPlayTab: String, CaseIterable {
        case dashboard = "Dashboard"
        case devices = "Devices"
        case security = "Security"
        case settings = "Settings"
        
        var icon: String {
            switch self {
            case .dashboard: return "house.fill"
            case .devices: return "square.grid.3x3.fill"
            case .security: return "shield.fill"
            case .settings: return "gear"
            }
        }
        
        var color: Color {
            switch self {
            case .dashboard: return AppleDesignSystem.Colors.accentBlue
            case .devices: return AppleDesignSystem.Colors.accentPurple
            case .security: return .red
            case .settings: return .gray
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                backgroundView
                
                VStack(spacing: 0) {
                    // Navigation Header
                    navigationHeader
                    
                    // Main Content
                    mainContent
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // Bottom Navigation
                    bottomNavigation
                }
                
                // Floating Quick Actions
                if showQuickActions {
                    quickActionsOverlay
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                }
                
                // Emergency Button (always visible)
                emergencyButton
            }
        }
        .carPlayOptimized()
        .animation(AppleDesignSystem.Animations.smooth, value: selectedTab)
        .animation(AppleDesignSystem.Animations.snappy, value: showQuickActions)
    }
    
    // MARK: - Background
    
    private var backgroundView: some View {
        ZStack {
            // Adaptive background
            AppleDesignSystem.Colors.adaptiveBackground(for: colorScheme)
                .ignoresSafeArea()
            
            // Subtle gradient overlay
            LinearGradient(
                colors: [
                    selectedTab.color.opacity(0.1),
                    Color.clear,
                    selectedTab.color.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated background elements
            ForEach(0..<3) { index in
                Circle()
                    .fill(selectedTab.color.opacity(0.03))
                    .frame(width: 200, height: 200)
                    .offset(
                        x: CGFloat.random(in: -100...100),
                        y: CGFloat.random(in: -100...100)
                    )
                    .blur(radius: 50)
                    .animation(
                        Animation.easeInOut(duration: 20.0)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 2.0),
                        value: selectedTab
                    )
            }
        }
    }
    
    // MARK: - Navigation Header
    
    private var navigationHeader: some View {
        CarPlayNavigation(
            title: selectedTab.rawValue,
            subtitle: headerSubtitle,
            leadingIcon: "line.3.horizontal",
            leadingAction: {
                withAnimation(AppleDesignSystem.Animations.snappy) {
                    showQuickActions.toggle()
                }
                HapticFeedback.medium()
            },
            trailingIcon: trailingIcon,
            trailingAction: trailingAction
        )
    }
    
    private var headerSubtitle: String {
        switch selectedTab {
        case .dashboard:
            return "\(smartHomeManager.devices.filter { $0.status == .online }.count) devices online"
        case .devices:
            return "\(smartHomeManager.devices.count) total devices"
        case .security:
            return "All systems secure"
        case .settings:
            return "System configuration"
        }
    }
    
    private var trailingIcon: String {
        switch selectedTab {
        case .dashboard: return "plus.circle.fill"
        case .devices: return "magnifyingglass"
        case .security: return "exclamationmark.triangle.fill"
        case .settings: return "questionmark.circle.fill"
        }
    }
    
    private var trailingAction: () -> Void {
        return {
            switch selectedTab {
            case .dashboard:
                showAddDevice = true
            case .devices:
                // Toggle search
                break
            case .security:
                triggerSecurityAlert()
            case .settings:
                // Show help
                break
            }
            HapticFeedback.light()
        }
    }
    
    // MARK: - Main Content
    
    private var mainContent: some View {
        TabView(selection: $selectedTab) {
            // Dashboard
            dashboardContent
                .tag(CarPlayTab.dashboard)
            
            // Devices
            devicesContent
                .tag(CarPlayTab.devices)
            
            // Security
            securityContent
                .tag(CarPlayTab.security)
            
            // Settings
            settingsContent
                .tag(CarPlayTab.settings)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .padding(.horizontal, AppleDesignSystem.Spacing.carPlayStandard)
    }
    
    // MARK: - Tab Content Views
    
    private var dashboardContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: AppleDesignSystem.Spacing.carPlayLoose) {
                // Status Dashboard
                StatusDashboard(smartHomeManager: smartHomeManager)
                
                // Quick Device Grid (favorite devices)
                if !favoriteDevices.isEmpty {
                    VStack(alignment: .leading, spacing: AppleDesignSystem.Spacing.md) {
                        Text("Favorites")
                            .font(AppleDesignSystem.Typography.carPlayLarge)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.horizontal, AppleDesignSystem.Spacing.md)
                        
                        ModernDeviceGrid(devices: favoriteDevices, smartHomeManager: smartHomeManager)
                    }
                }
            }
            .padding(.vertical, AppleDesignSystem.Spacing.carPlayTight)
        }
    }
    
    private var devicesContent: some View {
        VStack(spacing: AppleDesignSystem.Spacing.carPlayStandard) {
            // Search and filters
            deviceFilters
            
            // Device grid
            ScrollView(.vertical, showsIndicators: false) {
                ModernDeviceGrid(devices: filteredDevices, smartHomeManager: smartHomeManager)
                    .padding(.vertical, AppleDesignSystem.Spacing.carPlayTight)
            }
        }
    }
    
    private var securityContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: AppleDesignSystem.Spacing.carPlayLoose) {
                // Security status
                securityStatusCard
                
                // Security devices
                if !securityDevices.isEmpty {
                    VStack(alignment: .leading, spacing: AppleDesignSystem.Spacing.md) {
                        Text("Security Devices")
                            .font(AppleDesignSystem.Typography.carPlayLarge)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.horizontal, AppleDesignSystem.Spacing.md)
                        
                        ModernDeviceGrid(devices: securityDevices, smartHomeManager: smartHomeManager)
                    }
                }
                
                // Security actions
                securityActions
            }
            .padding(.vertical, AppleDesignSystem.Spacing.carPlayTight)
        }
    }
    
    private var settingsContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: AppleDesignSystem.Spacing.carPlayStandard) {
                // Theme toggle
                FuturisticToggle(
                    "Dark Mode",
                    isOn: .constant(colorScheme == .dark),
                    description: "Switch between light and dark themes"
                )
                
                // Notification settings
                FuturisticToggle(
                    "Motion Alerts",
                    isOn: .constant(smartHomeManager.notificationPreferences.motionAlerts),
                    description: "Receive notifications for motion detection"
                )
                
                // Privacy mode
                FuturisticToggle(
                    "Privacy Mode",
                    isOn: .constant(false),
                    description: "Disable all cameras and recording"
                )
                
                // System settings
                systemSettingsCard
            }
            .padding(.vertical, AppleDesignSystem.Spacing.carPlayTight)
        }
    }
    
    // MARK: - Device Filters
    
    private var deviceFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppleDesignSystem.Spacing.md) {
                filterButton("All", isSelected: selectedFilter == .all) {
                    selectedFilter = .all
                }
                
                filterButton("Online", isSelected: selectedFilter == .online) {
                    selectedFilter = .online
                }
                
                filterButton("Offline", isSelected: selectedFilter == .offline) {
                    selectedFilter = .offline
                }
                
                filterButton("Cameras", isSelected: selectedFilter == .cameras) {
                    selectedFilter = .cameras
                }
                
                filterButton("Sensors", isSelected: selectedFilter == .sensors) {
                    selectedFilter = .sensors
                }
            }
            .padding(.horizontal, AppleDesignSystem.Spacing.carPlayStandard)
        }
    }
    
    @State private var selectedFilter: DeviceFilter = .all
    
    enum DeviceFilter {
        case all, online, offline, cameras, sensors
    }
    
    private func filterButton(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(AppleDesignSystem.Typography.carPlaySmall)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, AppleDesignSystem.Spacing.md)
                .padding(.vertical, AppleDesignSystem.Spacing.sm)
                .background(
                    Group {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppleDesignSystem.Colors.accentBlue)
                        } else {
                            LiquidGlassMaterial(
                                intensity: 0.6,
                                cornerRadius: 20
                            )
                        }
                    }
                )
        }
        .appleButton(variant: isSelected ? .primary : .tertiary, size: .small)
    }
    
    // MARK: - Security Components
    
    private var securityStatusCard: some View {
        VStack(spacing: AppleDesignSystem.Spacing.lg) {
            HStack {
                Image(systemName: "shield.checkered")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Security System")
                        .font(AppleDesignSystem.Typography.carPlayLarge)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("All systems operational")
                        .font(AppleDesignSystem.Typography.carPlaySmall)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Circle()
                    .fill(.green)
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle()
                            .stroke(.green.opacity(0.3), lineWidth: 4)
                            .scaleEffect(1.5)
                    )
            }
            
            // Armed status
            FuturisticToggle(
                "System Armed",
                isOn: .constant(true),
                description: "Security monitoring active",
                accentColor: .green
            )
        }
        .padding(AppleDesignSystem.Spacing.lg)
        .liquidGlassCard(elevation: .medium, cornerRadius: 24, tint: .green.opacity(0.1))
    }
    
    private var securityActions: some View {
        VStack(spacing: AppleDesignSystem.Spacing.md) {
            Text("Emergency Actions")
                .font(AppleDesignSystem.Typography.carPlayLarge)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, AppleDesignSystem.Spacing.md)
            
            HStack(spacing: AppleDesignSystem.Spacing.md) {
                emergencyActionButton(
                    title: "Call Police",
                    icon: "phone.fill",
                    color: .red
                ) {
                    // Emergency action
                    HapticFeedback.criticalAlert()
                }
                
                emergencyActionButton(
                    title: "Activate Sirens",
                    icon: "speaker.wave.3.fill",
                    color: .orange
                ) {
                    activateAllSirens()
                }
            }
        }
    }
    
    private func emergencyActionButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: AppleDesignSystem.Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(AppleDesignSystem.Typography.carPlaySmall)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppleDesignSystem.Spacing.lg)
            .background(
                LinearGradient(
                    colors: [color, color.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - System Settings
    
    private var systemSettingsCard: some View {
        VStack(spacing: AppleDesignSystem.Spacing.md) {
            Text("System Information")
                .font(AppleDesignSystem.Typography.carPlayLarge)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: AppleDesignSystem.Spacing.sm) {
                settingRow(title: "Version", value: "1.0.0")
                settingRow(title: "Last Sync", value: "2 minutes ago")
                settingRow(title: "Storage", value: "2.3 GB used")
                settingRow(title: "Network", value: "Connected")
            }
        }
        .padding(AppleDesignSystem.Spacing.lg)
        .liquidGlassCard(elevation: .low, cornerRadius: 20)
    }
    
    private func settingRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(AppleDesignSystem.Typography.carPlayMedium)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(AppleDesignSystem.Typography.carPlaySmall)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
    
    // MARK: - Bottom Navigation
    
    private var bottomNavigation: some View {
        HStack(spacing: 0) {
            ForEach(CarPlayTab.allCases, id: \.self) { tab in
                carPlayTabButton(tab)
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
    
    private func carPlayTabButton(_ tab: CarPlayTab) -> some View {
        Button(action: {
            withAnimation(AppleDesignSystem.Animations.snappy) {
                selectedTab = tab
            }
            HapticFeedback.selection()
        }) {
            VStack(spacing: 6) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: selectedTab == tab ? .bold : .medium))
                    .foregroundColor(selectedTab == tab ? tab.color : .secondary)
                
                Text(tab.rawValue)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(selectedTab == tab ? tab.color : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppleDesignSystem.Spacing.sm)
            .background(
                Group {
                    if selectedTab == tab {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(tab.color.opacity(0.1))
                    }
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Quick Actions Overlay
    
    private var quickActionsOverlay: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(AppleDesignSystem.Animations.snappy) {
                        showQuickActions = false
                    }
                }
            
            // Quick actions menu
            VStack(spacing: AppleDesignSystem.Spacing.lg) {
                Text("Quick Actions")
                    .font(AppleDesignSystem.Typography.carPlayLarge)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppleDesignSystem.Spacing.md) {
                    quickActionButton("Add Device", icon: "plus.circle.fill", color: .blue) {
                        showAddDevice = true
                        showQuickActions = false
                    }
                    
                    quickActionButton("Refresh All", icon: "arrow.clockwise", color: .green) {
                        refreshAllDevices()
                        showQuickActions = false
                    }
                    
                    quickActionButton("Privacy Mode", icon: "eye.slash.fill", color: .purple) {
                        togglePrivacyMode()
                        showQuickActions = false
                    }
                    
                    quickActionButton("System Info", icon: "info.circle.fill", color: .orange) {
                        showSystemInfo()
                        showQuickActions = false
                    }
                }
            }
            .padding(AppleDesignSystem.Spacing.xl)
            .liquidGlassCard(elevation: .overlay, cornerRadius: 24)
            .padding(AppleDesignSystem.Spacing.carPlayLoose)
        }
    }
    
    private func quickActionButton(_ title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: AppleDesignSystem.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(color)
                
                Text(title)
                    .font(AppleDesignSystem.Typography.carPlaySmall)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(AppleDesignSystem.Spacing.lg)
            .liquidGlassCard(elevation: .low, cornerRadius: 16, tint: color.opacity(0.1))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Emergency Button
    
    private var emergencyButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                Button(action: {
                    triggerEmergency()
                }) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(.red)
                        .clipShape(Circle())
                        .shadow(color: .red.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, AppleDesignSystem.Spacing.carPlayStandard)
                .padding(.bottom, 120) // Above bottom navigation
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var favoriteDevices: [RingDevice] {
        Array(smartHomeManager.devices.prefix(4)) // Mock favorites
    }
    
    private var filteredDevices: [RingDevice] {
        switch selectedFilter {
        case .all:
            return smartHomeManager.devices
        case .online:
            return smartHomeManager.devices.filter { $0.status == .online }
        case .offline:
            return smartHomeManager.devices.filter { $0.status == .offline }
        case .cameras:
            return smartHomeManager.devices.filter { $0.category == .camera || $0.category == .doorbell }
        case .sensors:
            return smartHomeManager.devices.filter { $0.category == .motionSensor }
        }
    }
    
    private var securityDevices: [RingDevice] {
        smartHomeManager.devices.filter { device in
            device.category == .camera || 
            device.category == .doorbell || 
            device.category == .motionSensor
        }
    }
    
    // MARK: - Actions
    
    private func triggerSecurityAlert() {
        HapticFeedback.criticalAlert()
        logWarning("Security alert triggered from CarPlay", category: .device)
    }
    
    private func activateAllSirens() {
        HapticFeedback.criticalAlert()
        let sirenDevices = smartHomeManager.devices.filter { $0.category == .floodlight }
        
        for device in sirenDevices {
            smartHomeManager.activateSiren(for: device.id) { success in
                if success {
                    logInfo("Siren activated for device \(device.name)", category: .device)
                }
            }
        }
    }
    
    private func refreshAllDevices() {
        HapticFeedback.refresh()
        smartHomeManager.refreshDevices()
    }
    
    private func togglePrivacyMode() {
        HapticFeedback.medium()
        logInfo("Privacy mode toggled from CarPlay", category: .device)
    }
    
    private func showSystemInfo() {
        HapticFeedback.light()
        selectedTab = .settings
    }
    
    private func triggerEmergency() {
        HapticFeedback.criticalAlert()
        logCritical("Emergency button pressed from CarPlay", category: .device)
        // Implement emergency protocol
    }
}

#Preview {
    ModernCarPlayInterface(smartHomeManager: SmartHomeManager())
        .preferredColorScheme(.dark)
}