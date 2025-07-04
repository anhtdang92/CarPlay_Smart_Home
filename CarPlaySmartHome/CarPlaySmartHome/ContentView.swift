import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @StateObject private var smartHomeManager = SmartHomeManager.shared
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
            // Animated gradient background
            AnimatedGradientBackground(colors: [.blue.opacity(0.1), .purple.opacity(0.1), .pink.opacity(0.1)])
            
            VStack(spacing: 0) {
                // Enhanced header with glassmorphism
                GlassmorphismCard {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Smart Home")
                                    .font(.ringTitle)
                                    .foregroundColor(.primary)
                                
                                Text("\(smartHomeManager.devices.count) devices connected")
                                    .font(.ringCaption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            // Status indicators with animations
                            HStack(spacing: 12) {
                                // Online devices counter
                                VStack(spacing: 2) {
                                    AnimatedCounter(
                                        value: smartHomeManager.devices.filter { $0.status == .online }.count,
                                        prefix: "",
                                        suffix: ""
                                    )
                                    .font(.ringSmall)
                                    .foregroundColor(.successGreen)
                                    
                                    Text("Online")
                                        .font(.ringSmall)
                                        .foregroundColor(.secondary)
                                }
                                
                                // Pulse animation for active devices
                                if smartHomeManager.devices.contains(where: { $0.status == .online }) {
                                    PulseAnimation()
                                        .frame(width: 8, height: 8)
                                }
                                
                                // Settings button with haptic feedback
                                Button(action: {
                                    HapticFeedback.impact(style: .light)
                                    showingSettings = true
                                }) {
                                    Image(systemName: "gearshape.fill")
                                        .font(.title2)
                                        .foregroundColor(.primary)
                                        .frame(width: 44, height: 44)
                                        .background(
                                            Circle()
                                                .fill(.ultraThinMaterial)
                                        )
                                }
                            }
                        }
                        
                        // Enhanced search bar with floating label
                        FloatingLabelTextField(
                            placeholder: "Search devices...",
                            text: $searchText,
                            icon: "magnifyingglass"
                        )
                        .onTapGesture {
                            HapticFeedback.selection()
                        }
                    }
                    .padding()
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Enhanced tab bar with animations
                AnimatedTabBar(
                    selectedTab: $selectedTab,
                    tabs: [
                        .init(title: "Home", icon: "house.fill", color: .blue),
                        .init(title: "Devices", icon: "lightbulb.fill", color: .orange),
                        .init(title: "Automation", icon: "clock.fill", color: .purple),
                        .init(title: "Analytics", icon: "chart.bar.fill", color: .green),
                        .init(title: "Settings", icon: "person.fill", color: .gray)
                    ]
                )
                .padding(.vertical, 8)
                
                // Main content with parallax effect
                ParallaxScrollView(headerHeight: 100) {
                    VStack(spacing: 20) {
                        switch selectedTab {
                        case 0:
                            RingDeviceHomeView(smartHomeManager: smartHomeManager)
                        case 1:
                            RingDeviceViews(smartHomeManager: smartHomeManager)
                        case 2:
                            RingAdvancedDesign(smartHomeManager: smartHomeManager)
                        case 3:
                            RingSystemViews(smartHomeManager: smartHomeManager)
                        case 4:
                            RingPolishedComponents(smartHomeManager: smartHomeManager)
                        default:
                            RingDeviceHomeView(smartHomeManager: smartHomeManager)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100) // Space for floating action button
                }
            }
            
            // Floating action button with gradient
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    FloatingActionButton(
                        icon: "plus",
                        action: {
                            HapticFeedback.impact(style: .medium)
                            showingDeviceSetup = true
                        },
                        color: .blue
                    )
                    .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulseAnimation)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            
            // Confetti overlay for celebrations
            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            // Start animations
            withAnimation(.easeInOut(duration: 1.0)) {
                isAnimating = true
            }
            
            // Start pulse animation after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                pulseAnimation = true
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
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
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

#Preview {
    ContentView()
} 