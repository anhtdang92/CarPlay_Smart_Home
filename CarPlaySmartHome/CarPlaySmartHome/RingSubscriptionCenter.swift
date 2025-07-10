import SwiftUI
import StoreKit

// MARK: - Ring Subscription & Premium Features Center

/// Main Ring Subscription and Premium Features interface
struct RingSubscriptionCenter: View {
    @StateObject private var subscriptionManager = RingSubscriptionManager()
    @State private var selectedPlan: RingProtectPlan = .basic
    @State private var showingBilling = false
    @State private var showingFeatureDetail = false
    @State private var selectedFeature: RingPremiumFeature?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with Ring Protect branding
                RingProtectHeader()
                
                // Current subscription status
                RingSubscriptionStatusCard(
                    subscription: subscriptionManager.currentSubscription
                )
                
                // Available plans
                RingProtectPlansSection(
                    selectedPlan: $selectedPlan,
                    subscriptionManager: subscriptionManager
                )
                
                // Premium features showcase
                RingPremiumFeaturesGrid(
                    selectedFeature: $selectedFeature,
                    showingFeatureDetail: $showingFeatureDetail
                )
                
                // Storage and analytics
                RingStorageAnalytics(
                    subscription: subscriptionManager.currentSubscription
                )
                
                // Ring Protect benefits
                RingProtectBenefits()
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 16)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    Color.blue.opacity(0.1),
                    Color.black
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingBilling) {
            RingBillingSheet(subscriptionManager: subscriptionManager)
        }
        .sheet(isPresented: $showingFeatureDetail) {
            if let feature = selectedFeature {
                RingFeatureDetailSheet(feature: feature)
            }
        }
        .onAppear {
            subscriptionManager.loadSubscriptionStatus()
        }
    }
}

/// Ring Protect header with premium branding
struct RingProtectHeader: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Ring Protect logo with premium effects
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                .blue,
                                .purple,
                                .blue.opacity(0.3)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .blur(radius: isAnimating ? 2 : 0)
                
                Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .blue, radius: 10)
            }
            
            VStack(spacing: 8) {
                Text("Ring Protect")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.white, .blue, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Premium security features for ultimate peace of mind")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.top, 20)
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

/// Current subscription status card
struct RingSubscriptionStatusCard: View {
    let subscription: RingProtectSubscription?
    
    var body: some View {
        LiquidGlassCard(tint: subscription?.plan.color ?? .gray, cornerRadius: 20) {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(subscription?.plan.displayName ?? "No Active Plan")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(subscription?.statusDescription ?? "Upgrade for premium features")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    RingSubscriptionBadge(plan: subscription?.plan)
                }
                
                // Subscription details
                if let subscription = subscription {
                    HStack(spacing: 20) {
                        RingSubscriptionDetailItem(
                            icon: "calendar",
                            title: "Next Billing",
                            value: subscription.nextBillingDate
                        )
                        
                        RingSubscriptionDetailItem(
                            icon: "creditcard",
                            title: "Monthly Cost",
                            value: subscription.plan.price
                        )
                        
                        RingSubscriptionDetailItem(
                            icon: "devices",
                            title: "Devices",
                            value: "\(subscription.plan.maxDevices)"
                        )
                    }
                } else {
                    Button("Upgrade to Ring Protect") {
                        // Handle upgrade action
                    }
                    .buttonStyle(AppleButtonStyle(variant: .primary, size: .large))
                }
            }
            .padding(20)
        }
    }
}

/// Subscription badge
struct RingSubscriptionBadge: View {
    let plan: RingProtectPlan?
    
    var body: some View {
        if let plan = plan {
            Text(plan.displayName)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [plan.color, plan.color.opacity(0.7)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
        } else {
            Text("FREE")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.gray)
                )
        }
    }
}

/// Subscription detail item
struct RingSubscriptionDetailItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
            
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

/// Ring Protect plans section
struct RingProtectPlansSection: View {
    @Binding var selectedPlan: RingProtectPlan
    @ObservedObject var subscriptionManager: RingSubscriptionManager
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Ring Protect Plans")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("Compare Plans") {
                    // Show comparison
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.blue)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(RingProtectPlan.allCases, id: \.self) { plan in
                        RingProtectPlanCard(
                            plan: plan,
                            isSelected: selectedPlan == plan,
                            isCurrentPlan: subscriptionManager.currentSubscription?.plan == plan
                        ) {
                            selectedPlan = plan
                            HapticFeedback.impact(style: .light)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.horizontal, -16)
        }
    }
}

/// Individual Ring Protect plan card
struct RingProtectPlanCard: View {
    let plan: RingProtectPlan
    let isSelected: Bool
    let isCurrentPlan: Bool
    let onSelect: () -> Void
    
    @State private var isGlowing = false
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 16) {
                // Plan header
                VStack(spacing: 8) {
                    Circle()
                        .fill(plan.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: plan.icon)
                                .font(.title2)
                                .foregroundColor(plan.color)
                        )
                        .scaleEffect(isGlowing ? 1.1 : 1.0)
                    
                    Text(plan.displayName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(plan.price)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(plan.color)
                    
                    Text("per month")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                // Plan features
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(plan.features.prefix(4), id: \.self) { feature in
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.green)
                            
                            Text(feature)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                            
                            Spacer()
                        }
                    }
                    
                    if plan.features.count > 4 {
                        Text("+ \(plan.features.count - 4) more features")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
                
                // Action button
                if isCurrentPlan {
                    Text("Current Plan")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                                )
                        )
                } else {
                    Text(plan == .basic ? "Downgrade" : "Upgrade")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(plan.color)
                        )
                }
            }
            .padding(20)
            .frame(width: 280)
            .background(
                LiquidGlassMaterial(
                    intensity: isSelected ? 0.8 : 0.4,
                    tint: plan.color,
                    cornerRadius: 20
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        plan.color.opacity(isSelected ? 0.8 : 0.3),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .shadow(
                color: plan.color.opacity(isGlowing ? 0.4 : 0.2),
                radius: isGlowing ? 20 : 10,
                x: 0,
                y: 10
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            if plan == .plus {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    isGlowing = true
                }
            }
        }
    }
}

/// Premium features grid
struct RingPremiumFeaturesGrid: View {
    @Binding var selectedFeature: RingPremiumFeature?
    @Binding var showingFeatureDetail: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Premium Features")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Available with Ring Protect")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.blue)
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(RingPremiumFeature.allCases, id: \.self) { feature in
                    RingPremiumFeatureCard(feature: feature) {
                        selectedFeature = feature
                        showingFeatureDetail = true
                    }
                }
            }
        }
    }
}

/// Premium feature card
struct RingPremiumFeatureCard: View {
    let feature: RingPremiumFeature
    let onTap: () -> Void
    
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Feature icon
                ZStack {
                    Circle()
                        .fill(feature.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                    
                    Image(systemName: feature.icon)
                        .font(.title2)
                        .foregroundColor(feature.color)
                }
                
                // Feature info
                VStack(spacing: 4) {
                    Text(feature.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    
                    Text(feature.description)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                }
                
                // Premium badge
                if feature.isPremium {
                    Text("PREMIUM")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue, .purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
            }
            .padding(16)
            .frame(height: 160)
            .frame(maxWidth: .infinity)
            .background(
                LiquidGlassMaterial(
                    intensity: 0.4,
                    tint: feature.color,
                    cornerRadius: 16
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(feature.color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(Double.random(in: 0...1))) {
                isAnimating = true
            }
        }
    }
}

/// Storage and analytics section
struct RingStorageAnalytics: View {
    let subscription: RingProtectSubscription?
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Storage & Analytics")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            HStack(spacing: 16) {
                // Storage usage
                RingAnalyticsCard(
                    title: "Cloud Storage",
                    value: subscription?.storageUsed ?? "0 GB",
                    subtitle: "of \(subscription?.plan.storageLimit ?? "60 days") history",
                    icon: "icloud.fill",
                    color: .blue,
                    progress: subscription?.storageProgress ?? 0.0
                )
                
                // Video history
                RingAnalyticsCard(
                    title: "Video History",
                    value: "\(subscription?.videoCount ?? 0)",
                    subtitle: "recordings saved",
                    icon: "video.fill",
                    color: .purple,
                    progress: nil
                )
            }
            
            HStack(spacing: 16) {
                // Motion events
                RingAnalyticsCard(
                    title: "Motion Events",
                    value: "\(subscription?.motionEvents ?? 0)",
                    subtitle: "this month",
                    icon: "figure.walk",
                    color: .green,
                    progress: nil
                )
                
                // Smart alerts
                RingAnalyticsCard(
                    title: "Smart Alerts",
                    value: "\(subscription?.smartAlerts ?? 0)",
                    subtitle: "AI detections",
                    icon: "brain.head.profile",
                    color: .orange,
                    progress: nil
                )
            }
        }
    }
}

/// Analytics card
struct RingAnalyticsCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    let progress: Double?
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon and title
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Value
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(color)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Progress bar if applicable
            if let progress = progress {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 4)
                            .cornerRadius(2)
                        
                        Rectangle()
                            .fill(color)
                            .frame(width: geometry.size.width * progress, height: 4)
                            .cornerRadius(2)
                    }
                }
                .frame(height: 4)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            LiquidGlassMaterial(
                intensity: 0.3,
                tint: color,
                cornerRadius: 12
            )
        )
    }
}

/// Ring Protect benefits section
struct RingProtectBenefits: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Why Ring Protect?")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(RingProtectBenefit.allCases, id: \.self) { benefit in
                    RingBenefitRow(benefit: benefit)
                }
            }
        }
    }
}

/// Benefit row
struct RingBenefitRow: View {
    let benefit: RingProtectBenefit
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(benefit.color.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: benefit.icon)
                        .font(.title3)
                        .foregroundColor(benefit.color)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(benefit.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(benefit.description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            LiquidGlassMaterial(
                intensity: 0.3,
                tint: benefit.color,
                cornerRadius: 12
            )
        )
    }
}

// MARK: - Supporting Models

class RingSubscriptionManager: ObservableObject {
    @Published var currentSubscription: RingProtectSubscription?
    @Published var availablePlans: [RingProtectPlan] = RingProtectPlan.allCases
    
    func loadSubscriptionStatus() {
        // Simulate loading current subscription
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.currentSubscription = RingProtectSubscription(
                plan: .plus,
                startDate: Date().addingTimeInterval(-86400 * 30),
                nextBillingDate: "Feb 15, 2024",
                storageUsed: "2.4 GB",
                storageProgress: 0.4,
                videoCount: 127,
                motionEvents: 89,
                smartAlerts: 34
            )
        }
    }
    
    func subscribeTo(plan: RingProtectPlan) {
        // Handle subscription logic
        HapticFeedback.success()
        Logger.shared.logUserAction("ring_subscription_upgrade", context: plan.rawValue)
    }
}

struct RingProtectSubscription {
    let plan: RingProtectPlan
    let startDate: Date
    let nextBillingDate: String
    let storageUsed: String
    let storageProgress: Double
    let videoCount: Int
    let motionEvents: Int
    let smartAlerts: Int
    
    var statusDescription: String {
        return "Active since \(startDate.formatted(date: .abbreviated, time: .omitted))"
    }
}

enum RingProtectPlan: String, CaseIterable {
    case basic = "basic"
    case plus = "plus"
    case pro = "pro"
    
    var displayName: String {
        switch self {
        case .basic: return "Ring Protect Basic"
        case .plus: return "Ring Protect Plus"
        case .pro: return "Ring Protect Pro"
        }
    }
    
    var price: String {
        switch self {
        case .basic: return "$3.99"
        case .plus: return "$10.99"
        case .pro: return "$20.99"
        }
    }
    
    var color: Color {
        switch self {
        case .basic: return .green
        case .plus: return .blue
        case .pro: return .purple
        }
    }
    
    var icon: String {
        switch self {
        case .basic: return "shield.fill"
        case .plus: return "shield.lefthalf.filled.badge.checkmark"
        case .pro: return "crown.fill"
        }
    }
    
    var maxDevices: Int {
        switch self {
        case .basic: return 1
        case .plus: return 10
        case .pro: return 99
        }
    }
    
    var storageLimit: String {
        switch self {
        case .basic: return "60 days"
        case .plus: return "60 days"
        case .pro: return "180 days"
        }
    }
    
    var features: [String] {
        switch self {
        case .basic:
            return [
                "Video recording for 1 device",
                "60-day video history",
                "Person alerts",
                "Motion alerts",
                "Rich notifications"
            ]
        case .plus:
            return [
                "Video recording for unlimited devices",
                "60-day video history",
                "Person, Package & Animal alerts",
                "Motion alerts with zones",
                "Rich notifications",
                "Snapshot Capture",
                "Extended warranties",
                "10% off accessories"
            ]
        case .pro:
            return [
                "Everything in Plus",
                "180-day video history",
                "24/7 Professional Monitoring",
                "Cellular backup",
                "Extended warranties",
                "Priority support",
                "Smart home integration",
                "AI-powered insights"
            ]
        }
    }
}

enum RingPremiumFeature: String, CaseIterable {
    case smartAlerts = "smart_alerts"
    case videoHistory = "video_history"
    case snapshotCapture = "snapshot_capture"
    case personDetection = "person_detection"
    case packageDetection = "package_detection"
    case animalDetection = "animal_detection"
    case professionalMonitoring = "professional_monitoring"
    case aiInsights = "ai_insights"
    
    var title: String {
        switch self {
        case .smartAlerts: return "Smart Alerts"
        case .videoHistory: return "Video History"
        case .snapshotCapture: return "Snapshot Capture"
        case .personDetection: return "Person Detection"
        case .packageDetection: return "Package Detection"
        case .animalDetection: return "Animal Detection"
        case .professionalMonitoring: return "24/7 Monitoring"
        case .aiInsights: return "AI Insights"
        }
    }
    
    var description: String {
        switch self {
        case .smartAlerts: return "Advanced AI-powered motion detection"
        case .videoHistory: return "60-180 days of cloud storage"
        case .snapshotCapture: return "Regular photos when motion detected"
        case .personDetection: return "Distinguish people from objects"
        case .packageDetection: return "Know when packages arrive"
        case .animalDetection: return "Pet and wildlife notifications"
        case .professionalMonitoring: return "Emergency response services"
        case .aiInsights: return "Smart home behavior analysis"
        }
    }
    
    var icon: String {
        switch self {
        case .smartAlerts: return "brain.head.profile"
        case .videoHistory: return "video.fill"
        case .snapshotCapture: return "camera.fill"
        case .personDetection: return "person.fill"
        case .packageDetection: return "shippingbox.fill"
        case .animalDetection: return "pawprint.fill"
        case .professionalMonitoring: return "shield.lefthalf.filled"
        case .aiInsights: return "chart.line.uptrend.xyaxis"
        }
    }
    
    var color: Color {
        switch self {
        case .smartAlerts: return .blue
        case .videoHistory: return .purple
        case .snapshotCapture: return .green
        case .personDetection: return .orange
        case .packageDetection: return .brown
        case .animalDetection: return .pink
        case .professionalMonitoring: return .red
        case .aiInsights: return .cyan
        }
    }
    
    var isPremium: Bool {
        switch self {
        case .smartAlerts, .videoHistory, .snapshotCapture: return false
        default: return true
        }
    }
}

enum RingProtectBenefit: String, CaseIterable {
    case cloudStorage = "cloud_storage"
    case smartDetection = "smart_detection"
    case extendedWarranty = "extended_warranty"
    case discounts = "discounts"
    case prioritySupport = "priority_support"
    
    var title: String {
        switch self {
        case .cloudStorage: return "Secure Cloud Storage"
        case .smartDetection: return "Advanced AI Detection"
        case .extendedWarranty: return "Extended Warranties"
        case .discounts: return "Exclusive Discounts"
        case .prioritySupport: return "Priority Support"
        }
    }
    
    var description: String {
        switch self {
        case .cloudStorage: return "Safe, encrypted video storage in the cloud"
        case .smartDetection: return "AI-powered person, package, and animal detection"
        case .extendedWarranty: return "Extended protection for your Ring devices"
        case .discounts: return "10% off Ring accessories and devices"
        case .prioritySupport: return "Get help faster with priority customer support"
        }
    }
    
    var icon: String {
        switch self {
        case .cloudStorage: return "icloud.fill"
        case .smartDetection: return "brain.head.profile"
        case .extendedWarranty: return "shield.checkered"
        case .discounts: return "percent"
        case .prioritySupport: return "headphones"
        }
    }
    
    var color: Color {
        switch self {
        case .cloudStorage: return .blue
        case .smartDetection: return .purple
        case .extendedWarranty: return .green
        case .discounts: return .orange
        case .prioritySupport: return .red
        }
    }
}

// MARK: - Sheet Views

struct RingBillingSheet: View {
    @ObservedObject var subscriptionManager: RingSubscriptionManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Billing Information")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("Billing management feature coming soon")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct RingFeatureDetailSheet: View {
    let feature: RingPremiumFeature
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Feature icon
                    Circle()
                        .fill(feature.color.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: feature.icon)
                                .font(.system(size: 40))
                                .foregroundColor(feature.color)
                        )
                    
                    // Feature info
                    VStack(spacing: 12) {
                        Text(feature.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(feature.description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    
                    // Feature benefits
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Benefits")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            FeatureBenefitRow(
                                icon: "checkmark.circle.fill",
                                text: "Enhanced security monitoring"
                            )
                            FeatureBenefitRow(
                                icon: "checkmark.circle.fill",
                                text: "Faster response times"
                            )
                            FeatureBenefitRow(
                                icon: "checkmark.circle.fill",
                                text: "Reduced false alarms"
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Feature Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct FeatureBenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
            
            Text(text)
                .font(.body)
            
            Spacer()
        }
    }
}