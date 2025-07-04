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
                MainTabView(smartHomeManager: smartHomeManager)
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

// MARK: - Main Tab View

struct MainTabView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            EnhancedDashboardView(smartHomeManager: smartHomeManager)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Dashboard")
                }
                .tag(0)
            
            RingDeviceHomeView(smartHomeManager: smartHomeManager)
                .tabItem {
                    Image(systemName: "video.fill")
                    Text("Devices")
                }
                .tag(1)
            
            NotificationCenter(smartHomeManager: smartHomeManager)
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Alerts")
                }
                .tag(2)
            
            AdvancedAnalyticsView(smartHomeManager: smartHomeManager)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Analytics")
                }
                .tag(3)
            
            DeviceMapView(smartHomeManager: smartHomeManager)
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }
                .tag(4)
            
            SettingsView(smartHomeManager: smartHomeManager)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(5)
        }
        .accentColor(RingDesignSystem.Colors.ringBlue)
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
        
        RingAPIManager.shared.signInWithRing { result in
            DispatchQueue.main.async {
                isSigningIn = false
                
                switch result {
                case .success:
                    // Success - view will automatically switch
                    break
                case .failure(let error):
                    errorMessage = "Ring sign-in failed: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func signInGeneric() {
        isSigningIn = true
        errorMessage = nil
        
        authManager.signIn { success in
            DispatchQueue.main.async {
                isSigningIn = false
                if !success {
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

#Preview {
    ContentView()
} 