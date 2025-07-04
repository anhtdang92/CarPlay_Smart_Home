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

    var body: some View {
        ZStack {
            // Dynamic background gradient
            backgroundGradient
                .ignoresSafeArea()
            
            if !hasCompletedOnboarding {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            } else if authManager.isAuthenticated {
                MainTabView(smartHomeManager: smartHomeManager)
            } else {
                LoginView(authManager: authManager)
            }
        }
        .animation(RingDesignSystem.Animations.gentle, value: authManager.isAuthenticated)
        .animation(RingDesignSystem.Animations.gentle, value: hasCompletedOnboarding)
        .onAppear {
            checkOnboardingStatus()
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
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: colorScheme == .dark ? 
            [RingDesignSystem.DarkMode.enhancedBackground, Color(red: 0.05, green: 0.05, blue: 0.1)] :
            [Color(red: 0.95, green: 0.97, blue: 1.0), Color.white],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private func checkOnboardingStatus() {
        // Check if user has completed onboarding
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        if !hasCompletedOnboarding {
            showingOnboarding = true
        }
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
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    @Environment(\.colorScheme) var colorScheme
    
    private let onboardingPages = [
        OnboardingPage(
            title: "Welcome to Ring Smart Home",
            subtitle: "Control your home security from anywhere with CarPlay integration",
            icon: "shield.lefthalf.filled.badge.checkmark",
            color: RingDesignSystem.Colors.ringBlue
        ),
        OnboardingPage(
            title: "Smart Device Control",
            subtitle: "Monitor cameras, doorbells, and sensors with real-time alerts",
            icon: "video.fill",
            color: RingDesignSystem.Colors.ringGreen
        ),
        OnboardingPage(
            title: "CarPlay Integration",
            subtitle: "Access your home security while driving with voice commands",
            icon: "car.fill",
            color: RingDesignSystem.Colors.ringOrange
        ),
        OnboardingPage(
            title: "Privacy & Security",
            subtitle: "Your data is encrypted and secure. You're in control.",
            icon: "lock.shield.fill",
            color: RingDesignSystem.Colors.ringPurple
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Page Content
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(RingDesignSystem.Animations.gentle, value: currentPage)
                
                // Bottom Section
                VStack(spacing: RingDesignSystem.Spacing.lg) {
                    // Page Indicators
                    pageIndicators
                    
                    // Action Buttons
                    actionButtons
                }
                .padding(.horizontal, RingDesignSystem.Spacing.xl)
                .padding(.bottom, geometry.safeAreaInsets.bottom + RingDesignSystem.Spacing.xl)
            }
        }
    }
    
    private var pageIndicators: some View {
        HStack(spacing: RingDesignSystem.Spacing.sm) {
            ForEach(0..<onboardingPages.count, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? 
                          onboardingPages[index].color : 
                          RingDesignSystem.Colors.Foreground.tertiary)
                    .frame(width: index == currentPage ? 12 : 8, height: index == currentPage ? 12 : 8)
                    .animation(RingDesignSystem.Animations.quick, value: currentPage)
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: RingDesignSystem.Spacing.md) {
            if currentPage == onboardingPages.count - 1 {
                // Get Started Button
                Button {
                    RingDesignSystem.Haptics.success()
                    withAnimation(RingDesignSystem.Animations.gentle) {
                        hasCompletedOnboarding = true
                    }
                } label: {
                    Text("Get Started")
                        .font(RingDesignSystem.Typography.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: RingDesignSystem.TouchTarget.minimumSize)
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
            } else {
                // Next Button
                Button {
                    RingDesignSystem.Haptics.navigation()
                    withAnimation(RingDesignSystem.Animations.gentle) {
                        currentPage += 1
                    }
                } label: {
                    Text("Next")
                        .font(RingDesignSystem.Typography.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(RingDesignSystem.Colors.ringBlue)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: RingDesignSystem.TouchTarget.minimumSize)
                        .background(
                            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                                .fill(RingDesignSystem.Colors.Fill.secondary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                                        .stroke(RingDesignSystem.Colors.ringBlue.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                
                // Skip Button
                Button {
                    RingDesignSystem.Haptics.navigation()
                    withAnimation(RingDesignSystem.Animations.gentle) {
                        hasCompletedOnboarding = true
                    }
                } label: {
                    Text("Skip")
                        .font(RingDesignSystem.Typography.subheadline)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                }
                .frame(minHeight: RingDesignSystem.TouchTarget.minimumSize)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xxl) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: page.color.gradientColors,
                            center: .center,
                            startRadius: 30,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .liquidGlass(style: .regular, cornerRadius: 80)
                
                Image(systemName: page.icon)
                    .font(.system(size: 64, weight: .medium))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .pulse(active: true)
            
            // Content
            VStack(spacing: RingDesignSystem.Spacing.lg) {
                Text(page.title)
                    .font(RingDesignSystem.Typography.largeTitle)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(RingDesignSystem.Typography.body)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, RingDesignSystem.Spacing.xl)
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
} 