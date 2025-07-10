import SwiftUI
import MapKit
import CoreLocation

// MARK: - Ring Neighborhood & Security Center

/// Main Ring Neighborhood and Security Center interface
struct RingNeighborhoodCenter: View {
    @StateObject private var neighborhoodManager = RingNeighborhoodManager()
    @State private var selectedTab = 0
    @State private var showingIncidentReport = false
    @State private var showingNeighborhoodMap = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with Ring branding
            RingSecurityHeader()
            
            // Tab navigation
            RingTabSelector(selectedTab: $selectedTab)
            
            // Content based on selected tab
            TabView(selection: $selectedTab) {
                // Neighborhood Feed
                RingNeighborhoodFeed(neighborhoodManager: neighborhoodManager)
                    .tag(0)
                
                // Security Alerts
                RingSecurityAlerts(neighborhoodManager: neighborhoodManager)
                    .tag(1)
                
                // Crime Map
                RingCrimeMap(neighborhoodManager: neighborhoodManager)
                    .tag(2)
                
                // Emergency Center
                RingEmergencyCenter()
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.smooth, value: selectedTab)
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .onAppear {
            neighborhoodManager.loadNeighborhoodData()
        }
    }
}

/// Ring Security Header with premium branding
struct RingSecurityHeader: View {
    @State private var isGlowing = false
    
    var body: some View {
        HStack {
            // Ring logo with glow effect
            ZStack {
                Circle()
                    .fill(RadialGradient(
                        gradient: Gradient(colors: [.blue, .blue.opacity(0.3), .clear]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 25
                    ))
                    .frame(width: 50, height: 50)
                    .scaleEffect(isGlowing ? 1.2 : 1.0)
                    .opacity(isGlowing ? 0.8 : 0.6)
                
                Image(systemName: "shield.lefthalf.filled")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Ring Neighborhood")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Always Home Security Network")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.blue.opacity(0.8))
            }
            
            Spacer()
            
            // Live status indicator
            RingLiveSecurityStatus()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            LiquidGlassMaterial(
                intensity: 0.3,
                tint: .blue,
                cornerRadius: 0
            )
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                isGlowing = true
            }
        }
    }
}

/// Live security status indicator
struct RingLiveSecurityStatus: View {
    @State private var isPulsing = false
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.green)
                .frame(width: 8, height: 8)
                .scaleEffect(isPulsing ? 1.3 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isPulsing)
            
            Text("LIVE")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(.green)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color.green.opacity(0.1))
                .overlay(
                    Capsule()
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
        )
        .onAppear {
            isPulsing = true
        }
    }
}

/// Tab selector for Ring Neighborhood sections
struct RingTabSelector: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        ("Feed", "newspaper.fill"),
        ("Alerts", "exclamationmark.triangle.fill"),
        ("Crime Map", "map.fill"),
        ("Emergency", "phone.fill")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                RingTabButton(
                    title: tab.0,
                    icon: tab.1,
                    isSelected: selectedTab == index
                ) {
                    withAnimation(.smooth) {
                        selectedTab = index
                    }
                    HapticFeedback.impact(style: .light)
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 8)
        .background(
            LiquidGlassMaterial(
                intensity: 0.4,
                tint: .gray,
                cornerRadius: 20
            )
        )
        .padding(.horizontal, 16)
    }
}

/// Individual tab button
struct RingTabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isSelected ? .blue : .gray)
                
                Text(title)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(isSelected ? .blue : .gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                isSelected ? 
                    LiquidGlassMaterial(intensity: 0.8, tint: .blue, cornerRadius: 16) :
                    Color.clear
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Ring Neighborhood Feed with community posts
struct RingNeighborhoodFeed: View {
    @ObservedObject var neighborhoodManager: RingNeighborhoodManager
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(neighborhoodManager.neighborhoodPosts) { post in
                    RingNeighborhoodPostCard(post: post)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
}

/// Individual neighborhood post card
struct RingNeighborhoodPostCard: View {
    let post: RingNeighborhoodPost
    @State private var isLiked = false
    @State private var showingComments = false
    
    var body: some View {
        LiquidGlassCard(tint: post.priority.color, cornerRadius: 16) {
            VStack(alignment: .leading, spacing: 12) {
                // Post header
                HStack {
                    Circle()
                        .fill(post.priority.color.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: post.category.icon)
                                .font(.title3)
                                .foregroundColor(post.priority.color)
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(post.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 8) {
                            Text(post.location)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Circle()
                                .fill(Color.secondary)
                                .frame(width: 3, height: 3)
                            
                            Text(post.timeAgo)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    RingPriorityBadge(priority: post.priority)
                }
                
                // Post content
                Text(post.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.primary)
                    .lineLimit(3)
                
                // Media preview if available
                if let videoURL = post.videoURL {
                    RingVideoPreview(videoURL: videoURL)
                }
                
                // Interaction buttons
                HStack(spacing: 20) {
                    Button(action: { isLiked.toggle() }) {
                        HStack(spacing: 6) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? .red : .gray)
                            Text("\(post.likes + (isLiked ? 1 : 0))")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button(action: { showingComments = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: "message")
                                .foregroundColor(.gray)
                            Text("\(post.comments)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button(action: sharePost) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    if post.isVerified {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.shield.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                            Text("Verified")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .padding(16)
        }
        .sheet(isPresented: $showingComments) {
            RingPostCommentsSheet(post: post)
        }
    }
    
    private func sharePost() {
        HapticFeedback.impact(style: .light)
        Logger.shared.logUserAction("ring_post_shared", context: post.category.rawValue)
    }
}

/// Ring priority badge
struct RingPriorityBadge: View {
    let priority: RingPostPriority
    
    var body: some View {
        Text(priority.displayName)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(priority.color)
            )
    }
}

/// Video preview component
struct RingVideoPreview: View {
    let videoURL: URL
    @State private var showingPlayer = false
    
    var body: some View {
        Button(action: { showingPlayer = true }) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black)
                .frame(height: 120)
                .overlay(
                    VStack {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                        
                        Text("Tap to play video")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                )
        }
        .sheet(isPresented: $showingPlayer) {
            RingVideoPlayerSheet(videoURL: videoURL)
        }
    }
}

/// Security alerts view
struct RingSecurityAlerts: View {
    @ObservedObject var neighborhoodManager: RingNeighborhoodManager
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(neighborhoodManager.securityAlerts) { alert in
                    RingSecurityAlertCard(alert: alert)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
}

/// Security alert card
struct RingSecurityAlertCard: View {
    let alert: RingSecurityAlert
    @State private var isExpanded = false
    
    var body: some View {
        LiquidGlassCard(tint: alert.severity.color, cornerRadius: 12) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: alert.type.icon)
                        .font(.title2)
                        .foregroundColor(alert.severity.color)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(alert.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text(alert.location)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(alert.timeAgo)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        RingSeverityBadge(severity: alert.severity)
                    }
                }
                
                Text(alert.description)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                    .lineLimit(isExpanded ? nil : 2)
                
                if isExpanded {
                    RingAlertActions(alert: alert)
                }
                
                Button(action: { withAnimation(.smooth) { isExpanded.toggle() } }) {
                    HStack {
                        Text(isExpanded ? "Show Less" : "Show More")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.blue)
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 10))
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(12)
        }
    }
}

/// Ring severity badge
struct RingSeverityBadge: View {
    let severity: RingAlertSeverity
    
    var body: some View {
        Text(severity.displayName)
            .font(.system(size: 9, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(severity.color)
            )
    }
}

/// Alert action buttons
struct RingAlertActions: View {
    let alert: RingSecurityAlert
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: reportAlert) {
                HStack(spacing: 6) {
                    Image(systemName: "flag.fill")
                    Text("Report")
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.red)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.red.opacity(0.1))
                )
            }
            
            Button(action: shareAlert) {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share")
                }
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.blue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.blue.opacity(0.1))
                )
            }
            
            Spacer()
        }
    }
    
    private func reportAlert() {
        HapticFeedback.impact(style: .medium)
        Logger.shared.logUserAction("ring_alert_reported", context: alert.type.rawValue)
    }
    
    private func shareAlert() {
        HapticFeedback.impact(style: .light)
        Logger.shared.logUserAction("ring_alert_shared", context: alert.type.rawValue)
    }
}

/// Crime map view
struct RingCrimeMap: View {
    @ObservedObject var neighborhoodManager: RingNeighborhoodManager
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    var body: some View {
        VStack(spacing: 0) {
            // Map controls
            HStack {
                Text("Crime Activity Map")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("Refresh") {
                    neighborhoodManager.refreshCrimeData()
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.blue)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Map view
            Map(coordinateRegion: $region, annotationItems: neighborhoodManager.crimeIncidents) { incident in
                MapAnnotation(coordinate: incident.coordinate) {
                    RingCrimeMarker(incident: incident)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            // Crime legend
            RingCrimeLegend()
                .padding(.horizontal, 16)
                .padding(.top, 12)
        }
    }
}

/// Crime map marker
struct RingCrimeMarker: View {
    let incident: RingCrimeIncident
    
    var body: some View {
        Circle()
            .fill(incident.type.color)
            .frame(width: 20, height: 20)
            .overlay(
                Image(systemName: incident.type.icon)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
            )
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            )
    }
}

/// Crime legend
struct RingCrimeLegend: View {
    var body: some View {
        LiquidGlassCard(tint: .gray, cornerRadius: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Crime Legend")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(RingCrimeType.allCases, id: \.self) { type in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(type.color)
                                .frame(width: 12, height: 12)
                            
                            Text(type.displayName)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                    }
                }
            }
            .padding(12)
        }
    }
}

/// Emergency center interface
struct RingEmergencyCenter: View {
    @State private var showingEmergencyCall = false
    @State private var showingIncidentReport = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Emergency header
                VStack(spacing: 12) {
                    Image(systemName: "phone.badge.plus")
                        .font(.system(size: 40))
                        .foregroundColor(.red)
                    
                    Text("Emergency Center")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Quick access to emergency services")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                // Emergency actions
                VStack(spacing: 16) {
                    RingEmergencyButton(
                        title: "Call 911",
                        subtitle: "Emergency Services",
                        icon: "phone.fill",
                        color: .red,
                        isPrimary: true
                    ) {
                        showingEmergencyCall = true
                    }
                    
                    RingEmergencyButton(
                        title: "Call Police",
                        subtitle: "Non-Emergency",
                        icon: "shield.fill",
                        color: .blue,
                        isPrimary: false
                    ) {
                        callPolice()
                    }
                    
                    RingEmergencyButton(
                        title: "Report Incident",
                        subtitle: "File a Report",
                        icon: "doc.text.fill",
                        color: .orange,
                        isPrimary: false
                    ) {
                        showingIncidentReport = true
                    }
                    
                    RingEmergencyButton(
                        title: "Activate Sirens",
                        subtitle: "All Ring Devices",
                        icon: "speaker.wave.3.fill",
                        color: .purple,
                        isPrimary: false
                    ) {
                        activateAllSirens()
                    }
                }
                .padding(.horizontal, 16)
                
                Spacer(minLength: 40)
            }
        }
        .sheet(isPresented: $showingEmergencyCall) {
            RingEmergencyCallSheet()
        }
        .sheet(isPresented: $showingIncidentReport) {
            RingIncidentReportSheet()
        }
    }
    
    private func callPolice() {
        HapticFeedback.criticalAlert()
        Logger.shared.logCritical("Ring emergency: Police called")
    }
    
    private func activateAllSirens() {
        HapticFeedback.criticalAlert()
        Logger.shared.logCritical("Ring emergency: All sirens activated")
    }
}

/// Emergency action button
struct RingEmergencyButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let isPrimary: Bool
    let action: () -> Void
    
    @State private var isPulsing = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .scaleEffect(isPrimary && isPulsing ? 1.1 : 1.0)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
            }
            .padding(20)
            .background(
                LiquidGlassMaterial(
                    intensity: 0.6,
                    tint: color,
                    cornerRadius: 16
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            if isPrimary {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
        }
    }
}

// MARK: - Supporting Models

class RingNeighborhoodManager: ObservableObject {
    @Published var neighborhoodPosts: [RingNeighborhoodPost] = []
    @Published var securityAlerts: [RingSecurityAlert] = []
    @Published var crimeIncidents: [RingCrimeIncident] = []
    
    func loadNeighborhoodData() {
        generateMockNeighborhoodPosts()
        generateMockSecurityAlerts()
        generateMockCrimeIncidents()
    }
    
    func refreshCrimeData() {
        generateMockCrimeIncidents()
    }
    
    private func generateMockNeighborhoodPosts() {
        neighborhoodPosts = [
            RingNeighborhoodPost(
                title: "Suspicious Activity",
                description: "Noticed someone checking car doors around 2 AM last night. They left when my floodlight came on.",
                location: "Maple Street",
                category: .suspicious,
                priority: .medium,
                timeAgo: "2h ago",
                likes: 12,
                comments: 5,
                isVerified: true,
                videoURL: nil
            ),
            RingNeighborhoodPost(
                title: "Package Delivery",
                description: "Amazon driver delivered safely today around 3 PM. Great to see on Ring doorbell.",
                location: "Oak Avenue",
                category: .delivery,
                priority: .low,
                timeAgo: "4h ago",
                likes: 8,
                comments: 2,
                isVerified: false,
                videoURL: URL(string: "https://example.com/video1")
            ),
            RingNeighborhoodPost(
                title: "Break-in Attempt",
                description: "Someone tried to break into my garage last night around midnight. Police have been notified.",
                location: "Pine Street",
                category: .crime,
                priority: .high,
                timeAgo: "6h ago",
                likes: 24,
                comments: 15,
                isVerified: true,
                videoURL: URL(string: "https://example.com/video2")
            )
        ]
    }
    
    private func generateMockSecurityAlerts() {
        securityAlerts = [
            RingSecurityAlert(
                title: "Motion Detected",
                description: "Unusual motion detected at front door camera at 11:47 PM",
                location: "123 Main Street",
                type: .motion,
                severity: .medium,
                timeAgo: "13m ago"
            ),
            RingSecurityAlert(
                title: "Doorbell Pressed",
                description: "Someone rang the doorbell multiple times",
                location: "123 Main Street",
                type: .doorbell,
                severity: .low,
                timeAgo: "1h ago"
            ),
            RingSecurityAlert(
                title: "Person Detected",
                description: "Person detected loitering near garage for extended period",
                location: "123 Main Street",
                type: .person,
                severity: .high,
                timeAgo: "2h ago"
            )
        ]
    }
    
    private func generateMockCrimeIncidents() {
        crimeIncidents = [
            RingCrimeIncident(
                coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                type: .theft,
                description: "Car break-in reported"
            ),
            RingCrimeIncident(
                coordinate: CLLocationCoordinate2D(latitude: 37.7759, longitude: -122.4184),
                type: .vandalism,
                description: "Property damage reported"
            ),
            RingCrimeIncident(
                coordinate: CLLocationCoordinate2D(latitude: 37.7739, longitude: -122.4204),
                type: .suspicious,
                description: "Suspicious activity reported"
            )
        ]
    }
}

struct RingNeighborhoodPost: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let location: String
    let category: RingPostCategory
    let priority: RingPostPriority
    let timeAgo: String
    let likes: Int
    let comments: Int
    let isVerified: Bool
    let videoURL: URL?
}

enum RingPostCategory: String, CaseIterable {
    case crime, suspicious, delivery, community, safety
    
    var icon: String {
        switch self {
        case .crime: return "exclamationmark.triangle.fill"
        case .suspicious: return "eye.fill"
        case .delivery: return "shippingbox.fill"
        case .community: return "person.3.fill"
        case .safety: return "shield.fill"
        }
    }
}

enum RingPostPriority: String, CaseIterable {
    case low, medium, high, critical
    
    var displayName: String {
        switch self {
        case .low: return "LOW"
        case .medium: return "MEDIUM"
        case .high: return "HIGH"
        case .critical: return "CRITICAL"
        }
    }
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        case .critical: return .purple
        }
    }
}

struct RingSecurityAlert: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let location: String
    let type: RingAlertType
    let severity: RingAlertSeverity
    let timeAgo: String
}

enum RingAlertType: String, CaseIterable {
    case motion, person, vehicle, doorbell, package, suspicious
    
    var icon: String {
        switch self {
        case .motion: return "figure.walk"
        case .person: return "person.fill"
        case .vehicle: return "car.fill"
        case .doorbell: return "bell.fill"
        case .package: return "shippingbox.fill"
        case .suspicious: return "eye.fill"
        }
    }
}

enum RingAlertSeverity: String, CaseIterable {
    case low, medium, high, critical
    
    var displayName: String {
        return rawValue.uppercased()
    }
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        case .critical: return .purple
        }
    }
}

struct RingCrimeIncident: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let type: RingCrimeType
    let description: String
}

enum RingCrimeType: String, CaseIterable {
    case theft, vandalism, suspicious, violence
    
    var displayName: String {
        return rawValue.capitalized
    }
    
    var icon: String {
        switch self {
        case .theft: return "person.crop.circle.badge.minus"
        case .vandalism: return "hammer.fill"
        case .suspicious: return "eye.fill"
        case .violence: return "exclamationmark.triangle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .theft: return .red
        case .vandalism: return .orange
        case .suspicious: return .yellow
        case .violence: return .purple
        }
    }
}

// MARK: - Sheet Views

struct RingPostCommentsSheet: View {
    let post: RingNeighborhoodPost
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Comments")
                    .font(.title2)
                    .padding()
                
                Spacer()
                
                Text("Comments feature coming soon")
                    .foregroundColor(.secondary)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct RingVideoPlayerSheet: View {
    let videoURL: URL
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Video Player")
                    .font(.title2)
                    .padding()
                
                Spacer()
                
                Text("Video playback feature coming soon")
                    .foregroundColor(.secondary)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct RingEmergencyCallSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "phone.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                
                Text("Emergency Call")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("This would initiate an emergency call in a real implementation")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                Button("Call 911") {
                    // Emergency call logic
                    HapticFeedback.criticalAlert()
                    dismiss()
                }
                .buttonStyle(AppleButtonStyle(variant: .destructive, size: .large))
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

struct RingIncidentReportSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Incident Report")
                    .font(.title2)
                    .padding()
                
                Spacer()
                
                Text("Incident reporting feature coming soon")
                    .foregroundColor(.secondary)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}