import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @StateObject private var smartHomeManager = SmartHomeManager.shared
    @StateObject private var themeManager = ThemeManager()
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var selectedTab = 0
    @State private var showingOnboarding = false
    @State private var showingQuickActions = false
    @State private var showingDeviceComparison = false
    @State private var showingAutomationRules = false
    @State private var showingDeviceSharing = false
    @State private var showingEnhancedSearch = false
    @State private var showingMaintenance = false
    @State private var showingEnergyUsage = false
    @State private var showingInsights = false
    @State private var showingSiriShortcuts = false
    @State private var showingWidgets = false
    @State private var showingHomeKit = false
    @State private var showingMultiAccount = false
    @State private var showingSettings = false
    @State private var showingDeviceSetup = false
    @State private var showingAnalytics = false
    @State private var showingHealthDashboard = false
    @State private var showingVoiceSearch = false
    @State private var showingMaintenanceScheduler = false
    @State private var showingEnergyAnalytics = false
    @State private var showingInsightsDashboard = false
    @State private var showingDataBackup = false
    @State private var showingPerformanceMonitor = false
    @State private var showingSearchFilters = false
    @State private var showingDeviceGroups = false
    @State private var showingFavorites = false
    @State private var showingPushNotifications = false
    
    // Animation states
    @State private var isAnimating = false
    @State private var showConfetti = false
    @State private var pulseAnimation = false
    
    // Search and filter states
    @State private var searchText = ""
    @State private var selectedCategory: DeviceCategory = .all
    @State private var selectedStatus: DeviceStatus = .all
    @State private var showingAdvancedSearch = false
    
    // UI Enhancement states
    @State private var isDarkMode = false
    @State private var showHapticFeedback = true
    @State private var animationSpeed: AnimationSpeed = .normal
    
    // New states for the enhanced UI
    @State private var showFloatingMenu = false
    @State private var animateBackground = false
    @State private var showParticles = false
    @State private var morphingState = false
    @State private var showPremiumMode = false
    @State private var showThemeSettings = false
    
    enum AnimationSpeed: String, CaseIterable {
        case slow = "Slow"
        case normal = "Normal"
        case fast = "Fast"
        
        var duration: Double {
            switch self {
            case .slow: return 0.8
            case .normal: return 0.4
            case .fast: return 0.2
            }
        }
    }
    
    var body: some View {
        ZStack {
            if showPremiumMode {
                // Ultra-modern mode with cutting-edge components
                RingUltraModernComponents(smartHomeManager: smartHomeManager)
            } else {
                // Standard advanced mode with liquid glass
                ZStack {
                    // Liquid glass background
                    LiquidGlassBackground()
                    
                    VStack(spacing: 0) {
                        // Enhanced header with liquid glass effects
                        LiquidGlassHeader()
                            .offset(y: animateBackground ? 0 : -20)
                            .opacity(animateBackground ? 1 : 0)
                        
                        // Enhanced tab navigation with morphing effects
                        LiquidGlassTabNavigation(selectedTab: $selectedTab)
                            .offset(y: animateBackground ? 0 : 20)
                            .opacity(animateBackground ? 1 : 0)
                        
                        // Enhanced tab content with 3D transitions
                        TabView(selection: $selectedTab) {
                            // Home Tab
                            RingDeviceHomeView(smartHomeManager: smartHomeManager)
                                .tag(0)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .leading).combined(with: .opacity),
                                    removal: .move(edge: .trailing).combined(with: .opacity)
                                ))
                            
                            // Devices Tab
                            RingUltraDeviceControl(smartHomeManager: smartHomeManager)
                                .tag(1)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                            
                            // Automation Tab
                            RingAdvancedDesign(smartHomeManager: smartHomeManager)
                                .tag(2)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .opacity),
                                    removal: .move(edge: .top).combined(with: .opacity)
                                ))
                            
                            // Settings Tab
                            RingSystemViews(smartHomeManager: smartHomeManager)
                                .tag(3)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .top).combined(with: .opacity),
                                    removal: .move(edge: .bottom).combined(with: .opacity)
                                ))
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .animation(.spring(response: 0.8, dampingFraction: 0.8), value: selectedTab)
                    }
                    
                    // Enhanced floating action menu with liquid glass
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            
                            VStack(spacing: 16) {
                                if showFloatingMenu {
                                    // Quick actions with liquid glass effects
                                    VStack(spacing: 12) {
                                        LiquidGlassActionButton(
                                            title: "All On",
                                            icon: "power",
                                            color: .green
                                        ) {
                                            smartHomeManager.turnAllDevicesOn()
                                        }
                                        
                                        LiquidGlassActionButton(
                                            title: "All Off",
                                            icon: "poweroff",
                                            color: .red
                                        ) {
                                            smartHomeManager.turnAllDevicesOff()
                                        }
                                        
                                        LiquidGlassActionButton(
                                            title: "Away Mode",
                                            icon: "house",
                                            color: .orange
                                        ) {
                                            smartHomeManager.setAwayMode()
                                        }
                                        
                                        LiquidGlassActionButton(
                                            title: "Night Mode",
                                            icon: "moon.fill",
                                            color: .purple
                                        ) {
                                            smartHomeManager.setNightMode()
                                        }
                                        
                                        LiquidGlassActionButton(
                                            title: "Theme",
                                            icon: "paintbrush.fill",
                                            color: .blue
                                        ) {
                                            showThemeSettings = true
                                        }
                                        
                                        LiquidGlassActionButton(
                                            title: showPremiumMode ? "Standard" : "Ultra",
                                            icon: showPremiumMode ? "sparkles" : "sparkles.rectangle.stack",
                                            color: .purple
                                        ) {
                                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                                showPremiumMode.toggle()
                                            }
                                            HapticFeedback.impact(style: .heavy)
                                        }
                                    }
                                    .transition(.scale.combined(with: .opacity))
                                }
                                
                                // Main floating action button with liquid glass effect
                                LiquidGlassFloatingButton(
                                    icon: showFloatingMenu ? "xmark" : "plus",
                                    action: {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            showFloatingMenu.toggle()
                                        }
                                        HapticFeedback.impact(style: .medium)
                                    }
                                )
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                        }
                    }
                }
            }
        }
        .onAppear {
            // Show background animations after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    animateBackground = true
                }
            }
            
            // Continuous background animations
            withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                morphingState = true
            }
            
            // Show particles after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    showParticles = true
                }
            }
            
            // Check for first launch
            if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
                showingOnboarding = true
                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            }
        }
        .sheet(isPresented: $showingOnboarding) {
            OnboardingView()
        }
        .sheet(isPresented: $showingQuickActions) {
            QuickActionsView()
                .environmentObject(smartHomeManager)
        }
        .sheet(isPresented: $showingDeviceComparison) {
            DeviceComparisonView()
                .environmentObject(smartHomeManager)
        }
        .sheet(isPresented: $showingAutomationRules) {
            AutomationRulesView()
        }
        .sheet(isPresented: $showingDeviceSharing) {
            DeviceSharingView()
                .environmentObject(smartHomeManager)
        }
        .sheet(isPresented: $showingEnhancedSearch) {
            EnhancedSearchView()
                .environmentObject(smartHomeManager)
        }
        .sheet(isPresented: $showingMaintenance) {
            DeviceMaintenanceView()
        }
        .sheet(isPresented: $showingEnergyUsage) {
            EnergyUsageView()
        }
        .sheet(isPresented: $showingInsights) {
            SmartHomeInsightsView()
        }
        .sheet(isPresented: $showingSiriShortcuts) {
            SiriShortcutsView()
        }
        .sheet(isPresented: $showingWidgets) {
            WidgetsView()
        }
        .sheet(isPresented: $showingHomeKit) {
            HomeKitIntegrationView()
                .environmentObject(smartHomeManager)
        }
        .sheet(isPresented: $showingMultiAccount) {
            MultiAccountView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(
                smartHomeManager: smartHomeManager,
                multiAccountManager: MultiAccountManager(),
                siriShortcutsManager: SiriShortcutsManager(),
                widgetManager: WidgetManager(),
                homeKitManager: HomeKitIntegration()
            )
        }
        .sheet(isPresented: $showingDeviceSetup) {
            DeviceSetupWizardView(smartHomeManager: smartHomeManager)
        }
        .sheet(isPresented: $showingAnalytics) {
            AnalyticsView(smartHomeManager: smartHomeManager)
        }
        .sheet(isPresented: $showingHealthDashboard) {
            SystemHealthDashboardView(smartHomeManager: smartHomeManager)
        }
        .sheet(isPresented: $showingVoiceSearch) {
            VoiceSearchView(smartHomeManager: smartHomeManager)
        }
        .sheet(isPresented: $showingMaintenanceScheduler) {
            MaintenanceSchedulerView(smartHomeManager: smartHomeManager)
        }
        .sheet(isPresented: $showingEnergyAnalytics) {
            EnergyAnalyticsView(smartHomeManager: smartHomeManager)
        }
        .sheet(isPresented: $showingInsightsDashboard) {
            SmartHomeInsightsView(smartHomeManager: smartHomeManager)
        }
        .sheet(isPresented: $showingDataBackup) {
            DataBackupRestoreView()
        }
        .sheet(isPresented: $showingPerformanceMonitor) {
            PerformanceMonitorView()
        }
        .sheet(isPresented: $showingSearchFilters) {
            SearchFiltersView(
                selectedCategory: $selectedCategory,
                selectedStatus: $selectedStatus
            )
        }
        .sheet(isPresented: $showingDeviceGroups) {
            DeviceGroupsView(smartHomeManager: smartHomeManager)
        }
        .sheet(isPresented: $showingFavorites) {
            FavoritesView(smartHomeManager: smartHomeManager)
        }
        .sheet(isPresented: $showingPushNotifications) {
            PushNotificationPreferencesView()
        }
        .sheet(isPresented: $showThemeSettings) {
            RingThemeSystem()
        }
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
    }
    
    private let tabItems = [
        TabItem(title: "Home", icon: "house.fill"),
        TabItem(title: "Devices", icon: "lightbulb.fill"),
        TabItem(title: "Automation", icon: "gearshape.fill"),
        TabItem(title: "Settings", icon: "person.fill")
    ]
}

struct TabItem {
    let title: String
    let icon: String
}

// MARK: - Main Tab View

struct MainTabView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedTab = 0
    @State private var animationEnabled = true
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Devices Tab
            NavigationView {
                RingDeviceHomeView()
                    .environmentObject(smartHomeManager)
                    .navigationTitle("Devices")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                Button(action: { showingDeviceComparison = true }) {
                                    Label("Compare Devices", systemImage: "chart.bar.xaxis")
                                }
                                
                                Button(action: { showingDeviceSharing = true }) {
                                    Label("Share Devices", systemImage: "square.and.arrow.up")
                                }
                                
                                Button(action: { showingEnhancedSearch = true }) {
                                    Label("Advanced Search", systemImage: "magnifyingglass.circle")
                                }
                                
                                Divider()
                                
                                Button(action: { showingMaintenance = true }) {
                                    Label("Maintenance", systemImage: "wrench.and.screwdriver")
                                }
                                
                                Button(action: { showingEnergyUsage = true }) {
                                    Label("Energy Usage", systemImage: "bolt")
                                }
                                
                                Divider()
                                
                                Button(action: { showingQuickActions = true }) {
                                    Label("Quick Actions", systemImage: "bolt")
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                            }
                        }
                    }
            }
            .tabItem {
                Image(systemName: "house")
                Text("Devices")
            }
            .tag(0)
            
            // Alerts Tab
            NavigationView {
                MotionAlertsView()
                    .environmentObject(smartHomeManager)
                    .navigationTitle("Alerts")
            }
            .tabItem {
                Image(systemName: "bell")
                Text("Alerts")
            }
            .tag(1)
            
            // System Status Tab
            NavigationView {
                SystemHealthDashboardView()
                    .environmentObject(smartHomeManager)
                    .navigationTitle("System")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                Button(action: { showingAutomationRules = true }) {
                                    Label("Automation Rules", systemImage: "gearshape")
                                }
                                
                                Button(action: { showingInsights = true }) {
                                    Label("Smart Insights", systemImage: "brain.head.profile")
                                }
                                
                                Button(action: { showingEnergyUsage = true }) {
                                    Label("Energy Analytics", systemImage: "bolt.circle")
                                }
                                
                                Divider()
                                
                                Button(action: { showingSiriShortcuts = true }) {
                                    Label("Siri Shortcuts", systemImage: "mic.circle")
                                }
                                
                                Button(action: { showingWidgets = true }) {
                                    Label("Home Screen Widgets", systemImage: "square.grid.2x2")
                                }
                                
                                Button(action: { showingHomeKit = true }) {
                                    Label("HomeKit Integration", systemImage: "house.fill")
                                }
                                
                                Divider()
                                
                                Button(action: { showingMultiAccount = true }) {
                                    Label("Multi-Account", systemImage: "person.2")
                                }
                            } label: {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                            }
                        }
                    }
            }
            .tabItem {
                Image(systemName: "chart.line.uptrend.xyaxis")
                Text("System")
            }
            .tag(2)
            
            // Settings Tab
            NavigationView {
                UserPreferencesView()
                    .environmentObject(smartHomeManager)
                    .navigationTitle("Settings")
            }
            .tabItem {
                Image(systemName: "person.circle")
                Text("Settings")
            }
            .tag(3)
        }
        .accentColor(.blue)
        .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.reduceMotionStatusDidChangeNotification)) { _ in
            animationEnabled = !UIAccessibility.isReduceMotionEnabled
        }
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
        VStack(spacing: RingDesignSystem.Spacing.sm) {
            HStack(spacing: RingDesignSystem.Spacing.sm) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(RingDesignSystem.Colors.Alert.critical)
                
                Text("Connection Issue")
                    .font(RingDesignSystem.Typography.headline)
                    .foregroundColor(RingDesignSystem.Colors.Alert.critical)
            }
            
            Text(message)
                .font(RingDesignSystem.Typography.body)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                errorMessage = nil
                if message.contains("Ring") {
                    signInWithRing()
                } else {
                    signInGeneric()
                }
            }
            .frame(minWidth: RingDesignSystem.TouchTarget.minimumSize, minHeight: RingDesignSystem.TouchTarget.minimumSize)
            .padding(.horizontal, RingDesignSystem.Spacing.md)
            .padding(.vertical, RingDesignSystem.Spacing.sm)
            .background(RingDesignSystem.Colors.ringBlue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md))
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
            
            // Secondary Generic Sign In Button
            Button {
                signInGeneric()
            } label: {
                HStack(spacing: RingDesignSystem.Spacing.sm) {
                    Image(systemName: "person.crop.circle")
                        .font(.title2)
                    Text("Generic Sign In")
                        .font(RingDesignSystem.Typography.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, RingDesignSystem.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                        .fill(RingDesignSystem.Colors.Fill.secondary)
                        .overlay(
                            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                                .stroke(RingDesignSystem.Colors.Separator.primary, lineWidth: 1)
                        )
                )
            }
            .scaleEffect(isSigningIn ? 0.95 : 1.0)
            .onTapWithFeedback(haptic: .light) {
                // Action handled in closure
            }
        }
    }
    
    private func signInWithRing() {
        isSigningIn = true
        errorMessage = nil
        RingDesignSystem.Haptics.medium()
        
        RingAPIManager.shared.signInWithRing { result in
            DispatchQueue.main.async {
                isSigningIn = false
                
                switch result {
                case .success:
                    RingDesignSystem.Haptics.success()
                    // Success - view will automatically switch
                    break
                case .failure(let error):
                    RingDesignSystem.Haptics.error()
                    errorMessage = "Ring sign-in failed: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func signInGeneric() {
        isSigningIn = true
        errorMessage = nil
        RingDesignSystem.Haptics.medium()
        
        authManager.signIn { success in
            DispatchQueue.main.async {
                isSigningIn = false
                if success {
                    RingDesignSystem.Haptics.success()
                } else {
                    RingDesignSystem.Haptics.error()
                    errorMessage = "Sign-in failed. Please try again."
                }
            }
        }
    }
}

// MARK: - Extensions

extension Color {
    var gradientColors: [Color] {
        return [self, self.opacity(0.7)]
    }
}

// MARK: - Onboarding View

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            title: "Welcome to Smart Home",
            subtitle: "Control your home with ease",
            image: "house.fill",
            color: .blue
        ),
        OnboardingPage(
            title: "Smart Automation",
            subtitle: "Set up rules and schedules",
            image: "clock.fill",
            color: .purple
        ),
        OnboardingPage(
            title: "Voice Control",
            subtitle: "Use Siri to control devices",
            image: "mic.fill",
            color: .orange
        ),
        OnboardingPage(
            title: "Analytics & Insights",
            subtitle: "Monitor your home's performance",
            image: "chart.bar.fill",
            color: .green
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedGradientBackground(colors: [.blue.opacity(0.1), .purple.opacity(0.1)])
            
            VStack(spacing: 30) {
                // Page indicator
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? pages[index].color : .gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                    }
                }
                .padding(.top, 50)
                
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentPage)
                
                // Navigation buttons
                HStack {
                    if currentPage > 0 {
                        Button("Back") {
                            withAnimation {
                                currentPage -= 1
                            }
                            HapticFeedback.impact(style: .light)
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    }
                    
                    Spacer()
                    
                    Button(currentPage == pages.count - 1 ? "Get Started" : "Next") {
                        if currentPage == pages.count - 1 {
                            dismiss()
                            HapticFeedback.notification(type: .success)
                        } else {
                            withAnimation {
                                currentPage += 1
                            }
                            HapticFeedback.impact(style: .light)
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
        .ignoresSafeArea()
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let image: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 40) {
            // Animated icon
            Image(systemName: page.image)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(page.color)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.ringTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.ringBody)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Enhanced Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.ringBody)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(
                        color: .blue.opacity(0.3),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.ringBody)
            .fontWeight(.medium)
            .foregroundColor(.primary)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.gray.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Liquid Glass Header
struct LiquidGlassHeader: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var animateTitle = false
    @State private var pulseGlow = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.lg) {
            HStack {
                // Animated title with liquid glass effect
                VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.sm) {
                    AnimatedGradientText(
                        text: "Smart Home",
                        colors: colorScheme == .dark ? 
                            [.white, .blue, .purple] :
                            [.black, .blue, .cyan]
                    )
                    .font(RingDesignSystem.Typography.largeTitle)
                    .fontWeight(.bold)
                    .offset(x: animateTitle ? 0 : -20)
                    .opacity(animateTitle ? 1 : 0)
                    
                    Text("Liquid Glass Experience")
                        .font(RingDesignSystem.Typography.subheadline)
                        .foregroundColor(.secondary)
                        .offset(x: animateTitle ? 0 : -20)
                        .opacity(animateTitle ? 1 : 0)
                }
                
                Spacer()
                
                // Premium mode toggle with liquid glass
                LiquidGlassToggleButton(
                    icon: "crown.fill",
                    isActive: false,
                    action: {}
                )
            }
            
            // Enhanced status overview with liquid glass cards
            HStack(spacing: RingDesignSystem.Spacing.md) {
                LiquidGlassStatusCard(
                    title: "Online",
                    value: "12",
                    icon: "checkmark.circle.fill",
                    color: .green,
                    glow: pulseGlow
                )
                
                LiquidGlassStatusCard(
                    title: "Offline",
                    value: "3",
                    icon: "exclamationmark.triangle.fill",
                    color: .orange,
                    glow: pulseGlow
                )
                
                LiquidGlassStatusCard(
                    title: "Active",
                    value: "8",
                    icon: "bolt.fill",
                    color: .blue,
                    glow: pulseGlow
                )
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
        .shadow(
            color: colorScheme == .dark ? 
                Color.black.opacity(0.3) : 
                Color.black.opacity(0.1),
            radius: 20,
            x: 0,
            y: 10
        )
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                animateTitle = true
            }
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                pulseGlow = true
            }
        }
    }
}

// MARK: - Liquid Glass Tab Navigation
struct LiquidGlassTabNavigation: View {
    @Binding var selectedTab: Int
    @Environment(\.colorScheme) var colorScheme
    @State private var animateTabs = false
    
    private let tabs = [
        ("Home", "house.fill", .blue),
        ("Devices", "lightbulb.fill", .green),
        ("Automation", "gearshape.fill", .orange),
        ("Settings", "person.fill", .purple)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                LiquidGlassTabButton(
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
                .offset(y: animateTabs ? 0 : 20)
                .opacity(animateTabs ? 1 : 0)
                .animation(
                    .spring(response: 0.6, dampingFraction: 0.8)
                    .delay(Double(index) * 0.1),
                    value: animateTabs
                )
            }
        }
        .padding(.horizontal, RingDesignSystem.Spacing.lg)
        .padding(.vertical, RingDesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                        .stroke(
                            colorScheme == .dark ? 
                                Color.white.opacity(0.1) : 
                                Color.black.opacity(0.1),
                            lineWidth: 1
                        )
                )
        )
        .shadow(
            color: colorScheme == .dark ? 
                Color.black.opacity(0.2) : 
                Color.black.opacity(0.1),
            radius: 15,
            x: 0,
            y: 8
        )
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3)) {
                animateTabs = true
            }
        }
    }
}

// MARK: - Liquid Glass Components
struct LiquidGlassStatusCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let glow: Bool
    
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.sm) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .scaleEffect(animate ? 1.1 : 1.0)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(color)
                    .rotationEffect(.degrees(animate ? 360 : 0))
            }
            
            VStack(spacing: 2) {
                Text(value)
                    .font(RingDesignSystem.Typography.title3)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(RingDesignSystem.Typography.caption1)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, RingDesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                        .stroke(
                            color.opacity(glow ? 0.5 : 0.2),
                            lineWidth: glow ? 2 : 1
                        )
                )
        )
        .shadow(
            color: color.opacity(glow ? 0.3 : 0.1),
            radius: glow ? 10 : 5,
            x: 0,
            y: glow ? 5 : 2
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

struct LiquidGlassTabButton: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(isSelected ? color : .clear)
                        .frame(width: 50, height: 50)
                        .scaleEffect(animate ? 1.1 : 1.0)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .secondary)
                        .rotationEffect(.degrees(animate ? 360 : 0))
                }
                
                Text(title)
                    .font(RingDesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? color : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, RingDesignSystem.Spacing.md)
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

struct LiquidGlassActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: RingDesignSystem.Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(RingDesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, RingDesignSystem.Spacing.md)
            .padding(.vertical, RingDesignSystem.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                    )
            )
            .shadow(
                color: color.opacity(0.4),
                radius: isPressed ? 4 : 8,
                x: 0,
                y: isPressed ? 2 : 4
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct LiquidGlassFloatingButton: View {
    let icon: String
    let action: () -> Void
    @State private var isPressed = false
    @State private var rotate = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Circle()
                                .stroke(.white.opacity(0.3), lineWidth: 2)
                        )
                        .shadow(
                            color: .blue.opacity(0.4),
                            radius: isPressed ? 8 : 15,
                            x: 0,
                            y: isPressed ? 4 : 8
                        )
                )
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .rotationEffect(.degrees(rotate ? 360 : 0))
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .onAppear {
            withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
                rotate = true
            }
        }
    }
}

struct LiquidGlassToggleButton: View {
    let icon: String
    let isActive: Bool
    let action: () -> Void
    @State private var isPressed = false
    @State private var glow = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(isActive ? .yellow : .white)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Circle()
                                .stroke(
                                    isActive ? .yellow.opacity(0.5) : .clear,
                                    lineWidth: glow ? 2 : 1
                                )
                        )
                )
                .shadow(
                    color: isActive ? .yellow.opacity(0.3) : .clear,
                    radius: glow ? 10 : 5,
                    x: 0,
                    y: glow ? 5 : 2
                )
                .scaleEffect(isPressed ? 0.9 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .onAppear {
            if isActive {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    glow = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
} 