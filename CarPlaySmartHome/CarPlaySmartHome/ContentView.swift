import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @StateObject private var smartHomeManager = SmartHomeManager.shared
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            // Dynamic background gradient
            backgroundGradient
                .ignoresSafeArea()
            
            if authManager.isAuthenticated {
                RingDeviceHomeView(smartHomeManager: smartHomeManager)
            } else {
                LoginView(authManager: authManager)
            }
        }
        .animation(RingDesignSystem.Animations.gentle, value: authManager.isAuthenticated)
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: colorScheme == .dark ? 
            [Color.black, Color(red: 0.05, green: 0.05, blue: 0.1)] :
            [Color(red: 0.95, green: 0.97, blue: 1.0), Color.white],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Enhanced Login View

struct LoginView: View {
    @ObservedObject var authManager: AuthenticationManager
    @State private var isSigningIn = false
    @State private var errorMessage: String?
    @State private var logoRotation = 0.0
    @State private var showWelcome = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: RingDesignSystem.Spacing.xl) {
                    Spacer(minLength: geometry.size.height * 0.1)
                    
                    // Animated Ring Logo
                    heroSection
                        .onAppear {
                            withAnimation(RingDesignSystem.Animations.gentle.delay(0.5)) {
                                showWelcome = true
                            }
                            withAnimation(RingDesignSystem.Animations.gentle.repeatForever(autoreverses: false)) {
                                logoRotation = 360
                            }
                        }
                    
                    // Welcome Text
                    welcomeSection
                        .opacity(showWelcome ? 1 : 0)
                        .offset(y: showWelcome ? 0 : 20)
                        .animation(RingDesignSystem.Animations.gentle.delay(0.8), value: showWelcome)
                    
                    // Error Display
                    if let errorMessage = errorMessage {
                        errorSection(message: errorMessage)
                    }
                    
                    // Sign In Buttons
                    signInSection
                        .opacity(showWelcome ? 1 : 0)
                        .offset(y: showWelcome ? 0 : 30)
                        .animation(RingDesignSystem.Animations.gentle.delay(1.2), value: showWelcome)
                    
                    Spacer(minLength: geometry.size.height * 0.1)
                }
                .padding(.horizontal, RingDesignSystem.Spacing.lg)
            }
        }
    }
    
    private var heroSection: some View {
        VStack(spacing: RingDesignSystem.Spacing.lg) {
            // Ring Logo with Liquid Glass Effect
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: RingDesignSystem.Colors.ringBlue.gradientColors,
                            center: .center,
                            startRadius: 30,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .liquidGlass(style: .regular, cornerRadius: 80)
                    .rotationEffect(.degrees(logoRotation))
                
                Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                    .font(.system(size: 64, weight: .medium))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .pulse(active: !isSigningIn)
        }
    }
    
    private var welcomeSection: some View {
        VStack(spacing: RingDesignSystem.Spacing.md) {
            Text("Ring Smart Home")
                .font(RingDesignSystem.Typography.largeTitle)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                .multilineTextAlignment(.center)

            Text("Experience seamless home security control from your car with CarPlay integration")
                .font(RingDesignSystem.Typography.body)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private func errorSection(message: String) -> some View {
        HStack(spacing: RingDesignSystem.Spacing.sm) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(RingDesignSystem.Colors.Alert.critical)
            
            Text(message)
                .font(RingDesignSystem.Typography.footnote)
                .foregroundColor(RingDesignSystem.Colors.Alert.critical)
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                .stroke(RingDesignSystem.Colors.Alert.critical.opacity(0.3), lineWidth: 1)
        )
        .transition(.scale.combined(with: .opacity))
    }
    
    private var signInSection: some View {
        VStack(spacing: RingDesignSystem.Spacing.md) {
            if isSigningIn {
                loadingView
            } else {
                authButtons
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: RingDesignSystem.Spacing.md) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: RingDesignSystem.Colors.ringBlue))
                .scaleEffect(1.2)
            
            Text("Signing in...")
                .font(RingDesignSystem.Typography.subheadline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
        }
        .padding(RingDesignSystem.Spacing.xl)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
        .shimmer(active: true)
    }
    
    private var authButtons: some View {
        VStack(spacing: RingDesignSystem.Spacing.md) {
            // Primary Ring Sign In Button
            Button {
                signInWithRing()
            } label: {
                HStack(spacing: RingDesignSystem.Spacing.sm) {
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .font(.title2)
                    Text("Sign In with Ring")
                        .font(RingDesignSystem.Typography.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, RingDesignSystem.Spacing.md)
                .background(
                    LinearGradient(
                        colors: [RingDesignSystem.Colors.ringBlue, RingDesignSystem.Colors.ringBlue.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg))
                .shadow(color: RingDesignSystem.Colors.ringBlue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .scaleEffect(isSigningIn ? 0.95 : 1.0)
            .onTapWithFeedback(haptic: .medium) {
                // Action handled in closure
            }
            
            // Secondary Demo Button
            Button {
                demoSignIn()
            } label: {
                HStack(spacing: RingDesignSystem.Spacing.sm) {
                    Image(systemName: "person.circle")
                        .font(.title2)
                    Text("Demo Sign In")
                        .font(RingDesignSystem.Typography.headline)
                }
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, RingDesignSystem.Spacing.md)
                .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
                .overlay(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                        .stroke(RingDesignSystem.Colors.Separator.primary, lineWidth: 1)
                )
            }
            .onTapWithFeedback(haptic: .light) {
                // Action handled in closure
            }
        }
    }
    
    private func signInWithRing() {
        withAnimation(RingDesignSystem.Animations.quick) {
            isSigningIn = true
            errorMessage = nil
        }
        
        RingDesignSystem.Haptics.light()
        
        RingAPIManager.shared.signInWithRing { result in
            DispatchQueue.main.async {
                withAnimation(RingDesignSystem.Animations.smooth) {
                    isSigningIn = false
                    
                    switch result {
                    case .success:
                        RingDesignSystem.Haptics.success()
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                        RingDesignSystem.Haptics.error()
                    }
                }
            }
        }
    }
    
    private func demoSignIn() {
        withAnimation(RingDesignSystem.Animations.quick) {
            isSigningIn = true
            errorMessage = nil
        }
        
        RingDesignSystem.Haptics.light()
        
        authManager.signIn { success in
            withAnimation(RingDesignSystem.Animations.smooth) {
                isSigningIn = false
                if !success {
                    errorMessage = "Demo sign in failed"
                    RingDesignSystem.Haptics.error()
                } else {
                    RingDesignSystem.Haptics.success()
                }
            }
        }
    }
}

// MARK: - Enhanced Home View

struct RingDeviceHomeView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedTab = 0
    @State private var showingSystemHealth = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DeviceListView(smartHomeManager: smartHomeManager)
                .tabItem {
                    Label("Devices", systemImage: "house.fill")
                }
                .tag(0)
            
            MotionAlertsView(smartHomeManager: smartHomeManager)
                .tabItem {
                    Label("Alerts", systemImage: "exclamationmark.triangle.fill")
                }
                .tag(1)
            
            SystemStatusView(smartHomeManager: smartHomeManager)
                .tabItem {
                    Label("Status", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(2)
            
            SettingsView(smartHomeManager: smartHomeManager)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
        .accentColor(RingDesignSystem.Colors.ringBlue)
        .onAppear {
            setupTabBarAppearance()
            
            // Ensure devices are loaded
            if smartHomeManager.getDevices().isEmpty {
                smartHomeManager.refreshDevices()
            }
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - Enhanced Device List View

struct DeviceListView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var showingBulkActions = false
    @State private var searchText = ""
    @State private var selectedDeviceType: DeviceType?
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            ZStack {
                // Background
                RingDesignSystem.Colors.Background.primary.ignoresSafeArea()
                
                if smartHomeManager.isLoading {
                    loadingView
                } else {
                    deviceContent
                }
            }
            .navigationTitle("Ring Smart Home")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    systemStatusButton
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    moreButton
                }
            }
            .searchable(text: $searchText, prompt: "Search devices...")
            .refreshable {
                await refreshDevices()
            }
            .sheet(isPresented: $showingBulkActions) {
                BulkActionsView(smartHomeManager: smartHomeManager)
            }
        }
    }
    
    private var loadingView: some View {
        PremiumLoadingView(
            title: "Loading Devices",
            subtitle: "Connecting to your Ring smart home system..."
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var deviceContent: some View {
        if filteredDevices.isEmpty {
            emptyStateView
        } else {
            deviceList
        }
    }
    
    private var filteredDevices: [SmartDevice] {
        var devices = smartHomeManager.getDevices()
        
        if !searchText.isEmpty {
            devices = devices.filter { device in
                device.name.localizedCaseInsensitiveContains(searchText) ||
                device.deviceType.rawValue.localizedCaseInsensitiveContains(searchText) ||
                device.location?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
        
        if let selectedType = selectedDeviceType {
            devices = devices.filter { $0.deviceType == selectedType }
        }
        
        return devices
    }
    
    private var deviceList: some View {
        ScrollView {
            LazyVStack(spacing: RingDesignSystem.Spacing.md) {
                // Device Type Filter with enhanced styling
                enhancedDeviceTypeFilter
                
                // Premium Device Cards
                ForEach(DeviceType.allCases, id: \.self) { deviceType in
                    let devices = filteredDevices.filter { $0.deviceType == deviceType }
                    if !devices.isEmpty {
                        PremiumDeviceSection(
                            deviceType: deviceType,
                            devices: devices,
                            smartHomeManager: smartHomeManager
                        )
                    }
                }
            }
            .padding(.horizontal, RingDesignSystem.Spacing.md)
            .padding(.bottom, RingDesignSystem.Spacing.xxxl)
        }
        .refreshable {
            await refreshDevices()
        }
    }
    
    private var enhancedDeviceTypeFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: RingDesignSystem.Spacing.sm) {
                // All devices filter with premium styling
                PremiumFilterChip(
                    title: "All Devices",
                    count: smartHomeManager.getDevices().count,
                    icon: "house.fill",
                    color: RingDesignSystem.Colors.Foreground.secondary,
                    isSelected: selectedDeviceType == nil,
                    action: { 
                        selectedDeviceType = nil
                        RingDesignSystem.Haptics.selection()
                    }
                )
                
                // Device type filters with premium styling
                ForEach(DeviceType.allCases, id: \.self) { deviceType in
                    let count = smartHomeManager.getDevices(ofType: deviceType).count
                    if count > 0 {
                        PremiumFilterChip(
                            title: deviceType.rawValue.capitalized,
                            count: count,
                            icon: deviceType.iconName,
                            color: deviceType.accentColor,
                            isSelected: selectedDeviceType == deviceType,
                            action: { 
                                selectedDeviceType = deviceType
                                RingDesignSystem.Haptics.selection()
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, RingDesignSystem.Spacing.md)
        }
        .padding(.vertical, RingDesignSystem.Spacing.sm)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: RingDesignSystem.Spacing.lg) {
            Image(systemName: "house.circle")
                .font(.system(size: 64))
                .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
            
            Text("No Devices Found")
                .font(RingDesignSystem.Typography.title2)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            Text(searchText.isEmpty ? 
                 "Your Ring devices will appear here" : 
                 "No devices match your search")
                .font(RingDesignSystem.Typography.body)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                .multilineTextAlignment(.center)
            
            Button("Refresh Devices") {
                Task {
                    await refreshDevices()
                }
            }
            .ringButton(style: .primary, size: .medium)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(RingDesignSystem.Spacing.xl)
    }
    
    private var systemStatusButton: some View {
        Button {
            // Show system status
        } label: {
            HStack(spacing: RingDesignSystem.Spacing.xxs) {
                let lowBatteryCount = smartHomeManager.getDevicesWithLowBattery().count
                let offlineCount = smartHomeManager.getOfflineDevices().count
                
                Circle()
                    .fill(
                        lowBatteryCount > 0 || offlineCount > 0 ?
                        RingDesignSystem.Colors.Alert.warning :
                        RingDesignSystem.Colors.Alert.success
                    )
                    .frame(width: 8, height: 8)
                
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.title3)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            }
        }
        .onTapWithFeedback(haptic: .light) {
            // Handle tap
        }
    }
    
    private var moreButton: some View {
        Menu {
            Button("Refresh Devices") {
                Task { await refreshDevices() }
            }
            
            Button("Bulk Actions") {
                showingBulkActions = true
            }
            
            Divider()
            
            Button("Sign Out") {
                signOut()
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.title3)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
        }
    }
    
    private func refreshDevices() async {
        RingDesignSystem.Haptics.light()
        smartHomeManager.refreshDevices()
    }
    
    private func signOut() {
        RingDesignSystem.Haptics.medium()
        RingAPIManager.shared.signOut()
        AuthenticationManager.shared.signOut()
    }
}

// MARK: - Filter Chip Component

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(RingDesignSystem.Typography.footnote)
                .fontWeight(.medium)
                .padding(.horizontal, RingDesignSystem.Spacing.sm)
                .padding(.vertical, RingDesignSystem.Spacing.xs)
                .background(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                        .fill(
                            isSelected ?
                            RingDesignSystem.Colors.ringBlue :
                            RingDesignSystem.Colors.Background.secondary
                        )
                )
                .foregroundColor(
                    isSelected ?
                    .white :
                    RingDesignSystem.Colors.Foreground.primary
                )
        }
        .onTapWithFeedback(haptic: .selection) {
            // Action handled in closure
        }
        .animation(RingDesignSystem.Animations.quick, value: isSelected)
    }
}

// MARK: - Device Section Component

struct DeviceSection: View {
    let deviceType: DeviceType
    let devices: [SmartDevice]
    let smartHomeManager: SmartHomeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.sm) {
            // Section Header
            HStack {
                HStack(spacing: RingDesignSystem.Spacing.xs) {
                    Image(systemName: deviceType.iconName)
                        .foregroundColor(deviceType.accentColor)
                    
                    Text("\(deviceType.rawValue)s")
                        .font(RingDesignSystem.Typography.headline)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                }
                
                Spacer()
                
                Text("\(devices.count)")
                    .font(RingDesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .padding(.horizontal, RingDesignSystem.Spacing.xs)
                    .padding(.vertical, RingDesignSystem.Spacing.xxs)
                    .background(
                        RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xs)
                            .fill(deviceType.accentColor.opacity(0.2))
                    )
                    .foregroundColor(deviceType.accentColor)
            }
            .padding(.horizontal, RingDesignSystem.Spacing.sm)
            
            // Devices
            LazyVStack(spacing: RingDesignSystem.Spacing.xs) {
                ForEach(devices) { device in
                    EnhancedRingDeviceRow(
                        device: device,
                        smartHomeManager: smartHomeManager
                    )
                }
            }
        }
        .padding(.vertical, RingDesignSystem.Spacing.sm)
    }
}

// This is getting quite long, so I'll continue with the enhanced device row in the next part
#Preview {
    ContentView()
} 