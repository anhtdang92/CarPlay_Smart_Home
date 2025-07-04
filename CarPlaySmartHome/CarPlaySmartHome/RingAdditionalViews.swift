import SwiftUI
import CoreLocation

// MARK: - Enhanced Motion Alerts View

struct MotionAlertsView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedTimeframe: AlertTimeframe = .today
    @State private var searchText = ""
    @State private var selectedAlertType: MotionAlert.AlertType?
    @State private var showingFilterSheet = false
    @Environment(\.colorScheme) var colorScheme

    enum AlertTimeframe: String, CaseIterable {
        case hour = "Last Hour"
        case today = "Today"
        case week = "This Week"
        case month = "This Month"
        
        var timeInterval: TimeInterval {
            switch self {
            case .hour: return 3600
            case .today: return 86400
            case .week: return 604800
            case .month: return 2629746 // ~30.44 days
            }
        }
        
        var icon: String {
            switch self {
            case .hour: return "clock.fill"
            case .today: return "calendar.day.timeline.left"
            case .week: return "calendar.weekday.number.fill"
            case .month: return "calendar.fill"
            }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                RingDesignSystem.Colors.Background.primary.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Filter Section
                    filterSection
                    
                    // Content
                    if filteredAlerts.isEmpty {
                        emptyAlertsView
                    } else {
                        alertsList
                    }
                }
            }
            .navigationTitle("Motion Alerts")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search alerts...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Filter by Type") {
                            showingFilterSheet = true
                        }
                        
                        Divider()
                        
                        Button("Clear Old Alerts") {
                            clearOldAlerts()
                        }
                        
                        Button("Export Alerts") {
                            exportAlerts()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                    }
                }
            }
            .sheet(isPresented: $showingFilterSheet) {
                AlertFilterSheet(
                    selectedAlertType: $selectedAlertType,
                    selectedTimeframe: $selectedTimeframe
                )
            }
            .refreshable {
                await refreshAlerts()
            }
        }
    }
    
    private var filterSection: some View {
        VStack(spacing: RingDesignSystem.Spacing.sm) {
            // Quick Actions Row
            quickActionsRow
            
            // Timeframe Picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: RingDesignSystem.Spacing.sm) {
                    ForEach(AlertTimeframe.allCases, id: \.self) { timeframe in
                        TimeframeChip(
                            timeframe: timeframe,
                            isSelected: selectedTimeframe == timeframe
                        ) {
                            selectedTimeframe = timeframe
                            RingDesignSystem.Haptics.selection()
                        }
                    }
                }
                .padding(.horizontal, RingDesignSystem.Spacing.md)
            }
            
            // Alert Stats Row
            alertStatsRow
        }
        .padding(.vertical, RingDesignSystem.Spacing.sm)
        .background(
            RingDesignSystem.Colors.Background.secondary
                .ignoresSafeArea(edges: .horizontal)
        )
    }
    
    private var quickActionsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: RingDesignSystem.Spacing.md) {
                QuickActionButton(
                    title: "All Cameras",
                    icon: "video.fill",
                    color: RingDesignSystem.Colors.ringBlue
                ) {
                    // Navigate to all cameras
                }
                
                QuickActionButton(
                    title: "Live View",
                    icon: "eye.fill",
                    color: RingDesignSystem.Colors.ringGreen
                ) {
                    // Open live view
                }
                
                QuickActionButton(
                    title: "Arm System",
                    icon: "lock.shield.fill",
                    color: RingDesignSystem.Colors.ringOrange
                ) {
                    // Arm security system
                }
                
                QuickActionButton(
                    title: "Settings",
                    icon: "gear",
                    color: RingDesignSystem.Colors.ringPurple
                ) {
                    // Open settings
                }
            }
            .padding(.horizontal, RingDesignSystem.Spacing.md)
        }
    }
    
    private var alertStatsRow: some View {
        HStack(spacing: RingDesignSystem.Spacing.lg) {
            AlertStat(
                title: "Total",
                count: filteredAlerts.count,
                color: RingDesignSystem.Colors.ringBlue
            )
            
            AlertStat(
                title: "High Confidence",
                count: filteredAlerts.filter { $0.confidence > 0.8 }.count,
                color: RingDesignSystem.Colors.ringGreen
            )
            
            AlertStat(
                title: "With Video",
                count: filteredAlerts.filter { $0.hasVideo }.count,
                color: RingDesignSystem.Colors.ringPurple
            )
            
            Spacer()
        }
        .padding(.horizontal, RingDesignSystem.Spacing.md)
    }
    
    private var alertsList: some View {
        ScrollView {
            LazyVStack(spacing: RingDesignSystem.Spacing.sm) {
                ForEach(groupedAlerts.keys.sorted(by: >), id: \.self) { date in
                    if let alerts = groupedAlerts[date] {
                        AlertSection(
                            date: date,
                            alerts: alerts,
                            smartHomeManager: smartHomeManager
                        )
                    }
                }
            }
            .padding(.horizontal, RingDesignSystem.Spacing.md)
            .padding(.bottom, RingDesignSystem.Spacing.xxxl)
        }
    }
    
    private var emptyAlertsView: some View {
        VStack(spacing: RingDesignSystem.Spacing.lg) {
            Image(systemName: "bell.slash.circle")
                .font(.system(size: 64))
                .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
                .pulse(active: false)
            
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                Text("No Motion Alerts")
                    .font(RingDesignSystem.Typography.title2)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Text(searchText.isEmpty ? 
                     "No motion detected in the selected timeframe" :
                     "No alerts match your search")
                    .font(RingDesignSystem.Typography.body)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Refresh Alerts") {
                Task { await refreshAlerts() }
            }
            .frame(minWidth: RingDesignSystem.TouchTarget.minimumSize, minHeight: RingDesignSystem.TouchTarget.minimumSize)
            .padding(.horizontal, RingDesignSystem.Spacing.md)
            .padding(.vertical, RingDesignSystem.Spacing.sm)
            .background(RingDesignSystem.Colors.ringBlue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(RingDesignSystem.Spacing.xl)
    }
    
    private var filteredAlerts: [MotionAlert] {
        let cutoffTime = Date().addingTimeInterval(-selectedTimeframe.timeInterval)
        var alerts = smartHomeManager.recentMotionAlerts.filter { $0.timestamp > cutoffTime }
        
        if !searchText.isEmpty {
            alerts = alerts.filter { alert in
                alert.description.localizedCaseInsensitiveContains(searchText) ||
                alert.alertType.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let selectedType = selectedAlertType {
            alerts = alerts.filter { $0.alertType == selectedType }
        }
        
        return alerts.sorted { $0.timestamp > $1.timestamp }
    }
    
    private var groupedAlerts: [String: [MotionAlert]] {
        let formatter = DateFormatter.dayFormatter
        return Dictionary(grouping: filteredAlerts) { alert in
            formatter.string(from: alert.timestamp)
        }
    }
    
    private func refreshAlerts() async {
        // Refresh alerts from the manager
        smartHomeManager.refreshDevices()
    }
    
    private func clearOldAlerts() {
        // Clear alerts older than 7 days
        let cutoffDate = Date().addingTimeInterval(-7 * 24 * 3600)
        // This would be implemented in SmartHomeManager
    }
    
    private func exportAlerts() {
        // Export alerts functionality
    }
}

// MARK: - Supporting Components for Motion Alerts

struct TimeframeChip: View {
    let timeframe: MotionAlertsView.AlertTimeframe
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: RingDesignSystem.Spacing.xs) {
                Image(systemName: timeframe.icon)
                    .font(RingDesignSystem.Typography.caption1)
                
                Text(timeframe.rawValue)
                    .font(RingDesignSystem.Typography.caption1)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, RingDesignSystem.Spacing.md)
            .padding(.vertical, RingDesignSystem.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                    .fill(
                        isSelected ?
                        RingDesignSystem.Colors.ringBlue :
                        RingDesignSystem.Colors.Background.primary
                    )
                    .shadow(
                        color: isSelected ? RingDesignSystem.Colors.ringBlue.opacity(0.3) : .clear,
                        radius: 4,
                        x: 0,
                        y: 2
                    )
            )
            .foregroundColor(
                isSelected ?
                .white :
                RingDesignSystem.Colors.Foreground.primary
            )
        }
        .animation(RingDesignSystem.Animations.quick, value: isSelected)
    }
}

struct AlertStat: View {
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xxs) {
            Text("\(count)")
                .font(RingDesignSystem.Typography.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(RingDesignSystem.Typography.caption2)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
        }
    }
}

struct AlertSection: View {
    let date: String
    let alerts: [MotionAlert]
    let smartHomeManager: SmartHomeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.sm) {
            Text(date)
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                .padding(.horizontal, RingDesignSystem.Spacing.sm)
            
            ForEach(alerts) { alert in
                EnhancedMotionAlertRow(
                    alert: alert,
                    smartHomeManager: smartHomeManager
                )
            }
        }
        .padding(.vertical, RingDesignSystem.Spacing.sm)
    }
}

struct EnhancedMotionAlertRow: View {
    let alert: MotionAlert
    let smartHomeManager: SmartHomeManager
    @State private var deviceName: String = "Unknown Device"
    @State private var showingDetail = false
    
    var body: some View {
        Button {
            showingDetail = true
            RingDesignSystem.Haptics.light()
        } label: {
            HStack(spacing: RingDesignSystem.Spacing.md) {
                // Alert Icon
                alertIcon
                
                // Alert Information
                VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.xs) {
                    HStack {
                        Text(alert.description)
                            .font(RingDesignSystem.Typography.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        confidenceBadge
                    }
                    
                    HStack(spacing: RingDesignSystem.Spacing.sm) {
                        Text(deviceName)
                            .font(RingDesignSystem.Typography.caption1)
                            .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                        
                        Circle()
                            .fill(RingDesignSystem.Colors.Foreground.tertiary)
                            .frame(width: 2, height: 2)
                        
                        Text(timeAgoString)
                            .font(RingDesignSystem.Typography.caption1)
                            .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
                        
                        Spacer()
                        
                        if alert.hasVideo {
                            Image(systemName: "video.fill")
                                .font(RingDesignSystem.Typography.caption1)
                                .foregroundColor(RingDesignSystem.Colors.ringBlue)
                        }
                    }
                }
            }
            .padding(RingDesignSystem.Spacing.md)
            .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                    .stroke(alert.alertType.color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            loadDeviceName()
        }
        .sheet(isPresented: $showingDetail) {
            AlertDetailView(alert: alert, deviceName: deviceName)
        }
    }
    
    private var alertIcon: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            alert.alertType.color,
                            alert.alertType.color.opacity(0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 44, height: 44)
            
            Image(systemName: alertIconName)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
        }
        .shadow(color: alert.alertType.color.opacity(0.3), radius: 4, x: 0, y: 2)
    }
    
    private var alertIconName: String {
        switch alert.alertType {
        case .motion: return "sensor.tag.radiowaves.forward.fill"
        case .person: return "person.fill"
        case .vehicle: return "car.fill"
        case .package: return "shippingbox.fill"
        case .doorbell: return "bell.fill"
        }
    }
    
    private var confidenceBadge: some View {
        Text("\(Int(alert.confidence * 100))%")
            .font(RingDesignSystem.Typography.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, RingDesignSystem.Spacing.xs)
            .padding(.vertical, RingDesignSystem.Spacing.xxs)
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xs)
                    .fill(confidenceColor.opacity(0.2))
            )
            .foregroundColor(confidenceColor)
    }
    
    private var confidenceColor: Color {
        alert.confidence > 0.8 ? RingDesignSystem.Colors.ringGreen : 
        alert.confidence > 0.6 ? RingDesignSystem.Colors.ringOrange :
        RingDesignSystem.Colors.ringRed
    }
    
    private var timeAgoString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: alert.timestamp, relativeTo: Date())
    }
    
    private func loadDeviceName() {
        if let device = smartHomeManager.getDevice(withId: alert.deviceId) {
            deviceName = device.name
        }
    }
}

// MARK: - Alert Detail View

struct AlertDetailView: View {
    let alert: MotionAlert
    let deviceName: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: RingDesignSystem.Spacing.lg) {
                    // Alert Header
                    alertHeader
                    
                    // Alert Details
                    alertDetails
                    
                    // Video Preview (if available)
                    if alert.hasVideo {
                        videoPreview
                    }
                    
                    // Actions
                    actionButtons
                }
                .padding(RingDesignSystem.Spacing.md)
            }
            .background(RingDesignSystem.Colors.Background.primary.ignoresSafeArea())
            .navigationTitle("Alert Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(RingDesignSystem.Colors.ringBlue)
                }
            }
        }
    }
    
    private var alertHeader: some View {
        VStack(spacing: RingDesignSystem.Spacing.md) {
            // Alert Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                alert.alertType.color,
                                alert.alertType.color.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: alertIconName)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
            }
            .shadow(color: alert.alertType.color.opacity(0.3), radius: 12, x: 0, y: 6)
            
            VStack(spacing: RingDesignSystem.Spacing.xs) {
                Text(alert.description)
                    .font(RingDesignSystem.Typography.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                    .multilineTextAlignment(.center)
                
                Text("Detected on \(deviceName)")
                    .font(RingDesignSystem.Typography.subheadline)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                
                Text(formatDate(alert.timestamp))
                    .font(RingDesignSystem.Typography.caption1)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
            }
        }
        .padding(RingDesignSystem.Spacing.lg)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private var alertDetails: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Alert Information")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            VStack(spacing: RingDesignSystem.Spacing.xs) {
                DetailRow(label: "Type", value: alert.alertType.rawValue)
                DetailRow(label: "Confidence", value: "\(Int(alert.confidence * 100))%")
                DetailRow(label: "Has Video", value: alert.hasVideo ? "Yes" : "No")
                DetailRow(label: "Timestamp", value: formatDate(alert.timestamp))
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private var videoPreview: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Video Recording")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                .fill(
                    LinearGradient(
                        colors: [
                            RingDesignSystem.Colors.ringBlue.opacity(0.3),
                            RingDesignSystem.Colors.ringBlue.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)
                .overlay(
                    VStack(spacing: RingDesignSystem.Spacing.md) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(RingDesignSystem.Colors.ringBlue)
                        
                        Text("Tap to Play Video")
                            .font(RingDesignSystem.Typography.subheadline)
                            .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                    }
                )
                .onTapGesture {
                    RingDesignSystem.Haptics.medium()
                    // Play video functionality
                }
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private var actionButtons: some View {
        VStack(spacing: RingDesignSystem.Spacing.sm) {
            HStack(spacing: RingDesignSystem.Spacing.sm) {
                Button("Share Alert") {
                    RingDesignSystem.Haptics.light()
                    // Share functionality
                }
                .ringButton(style: .secondary, size: .medium)
                
                Button("Download Video") {
                    RingDesignSystem.Haptics.light()
                    // Download functionality
                }
                .ringButton(style: .primary, size: .medium)
            }
            
            Button("Delete Alert") {
                RingDesignSystem.Haptics.heavy()
                // Delete functionality
            }
            .ringButton(style: .destructive, size: .medium)
        }
    }
    
    private var alertIconName: String {
        switch alert.alertType {
        case .motion: return "sensor.tag.radiowaves.forward.fill"
        case .person: return "person.fill"
        case .vehicle: return "car.fill"
        case .package: return "shippingbox.fill"
        case .doorbell: return "bell.fill"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Alert Filter Sheet

struct AlertFilterSheet: View {
    @Binding var selectedAlertType: MotionAlert.AlertType?
    @Binding var selectedTimeframe: AlertTimeframe
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Alert Type") {
                    Button("All Types") {
                        selectedAlertType = nil
                        dismiss()
                    }
                    .foregroundColor(selectedAlertType == nil ? RingDesignSystem.Colors.ringBlue : RingDesignSystem.Colors.Foreground.primary)
                    
                    ForEach(MotionAlert.AlertType.allCases, id: \.self) { type in
                        Button(type.rawValue.capitalized) {
                            selectedAlertType = type
                            dismiss()
                        }
                        .foregroundColor(selectedAlertType == type ? RingDesignSystem.Colors.ringBlue : RingDesignSystem.Colors.Foreground.primary)
                    }
                }
                
                Section("Timeframe") {
                    ForEach(AlertTimeframe.allCases, id: \.self) { timeframe in
                        Button(timeframe.rawValue) {
                            selectedTimeframe = timeframe
                            dismiss()
                        }
                        .foregroundColor(selectedTimeframe == timeframe ? RingDesignSystem.Colors.ringBlue : RingDesignSystem.Colors.Foreground.primary)
                    }
                }
            }
            .navigationTitle("Filter Alerts")
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

// MARK: - Extensions

extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }()
}

extension MotionAlert.AlertType {
    var iconName: String {
        switch self {
        case .motion: return "sensor.tag.radiowaves.forward.fill"
        case .person: return "person.fill"
        case .vehicle: return "car.fill"
        case .package: return "shippingbox.fill"
        case .doorbell: return "bell.fill"
        }
    }
}

// MARK: - Enhanced Dashboard View

struct EnhancedDashboardView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedTimeFilter: TimeFilter = .today
    @State private var showingWeather = true
    @State private var searchText = ""
    @State private var selectedDeviceType: DeviceType? = nil
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: RingDesignSystem.Spacing.lg) {
                    // Weather Header
                    weatherHeader
                    
                    // System Health Section
                    systemHealthSection
                    
                    // Quick Stats Grid
                    quickStatsGrid
                    
                    // Search and Filters
                    searchAndFiltersSection
                    
                    // Device Grid
                    deviceGridSection
                    
                    // Quick Actions
                    quickActionsSection
                }
                .padding(RingDesignSystem.Spacing.md)
            }
            .background(RingDesignSystem.Colors.Background.primary.ignoresSafeArea())
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await refreshData()
            }
            .onAppear {
                smartHomeManager.updateSystemHealth()
            }
        }
    }
    
    private var weatherHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.xs) {
                Text("Good Morning")
                    .font(RingDesignSystem.Typography.title2)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Text("Your home is secure")
                    .font(RingDesignSystem.Typography.subheadline)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
            }
            
            Spacer()
            
            // Weather Widget
            HStack(spacing: RingDesignSystem.Spacing.sm) {
                Image(systemName: "sun.max.fill")
                    .font(.title2)
                    .foregroundColor(RingDesignSystem.Colors.ringYellow)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("72°")
                        .font(RingDesignSystem.Typography.headline)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                    
                    Text("Sunny")
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                }
            }
            .padding(RingDesignSystem.Spacing.sm)
            .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.md)
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private var systemHealthSection: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            HStack {
                Text("System Health")
                    .font(RingDesignSystem.Typography.headline)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Spacer()
                
                Button("View Details") {
                    // Navigate to system health details
                    RingDesignSystem.Haptics.navigation()
                }
                .font(RingDesignSystem.Typography.subheadline)
                .foregroundColor(RingDesignSystem.Colors.ringBlue)
            }
            
            // Health Score Card
            healthScoreCard
            
            // Performance Metrics
            performanceMetricsRow
            
            // System Alerts
            if !smartHomeManager.getSystemAlerts().isEmpty {
                systemAlertsSection
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private var healthScoreCard: some View {
        HStack(spacing: RingDesignSystem.Spacing.lg) {
            // Health Score Circle
            ZStack {
                Circle()
                    .stroke(
                        RingDesignSystem.Colors.Fill.tertiary,
                        lineWidth: 8
                    )
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: CGFloat(smartHomeManager.systemHealth.score) / 100)
                    .stroke(
                        healthScoreColor,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                    .animation(RingDesignSystem.Animations.gentle, value: smartHomeManager.systemHealth.score)
                
                VStack(spacing: 2) {
                    Text("\(smartHomeManager.systemHealth.score)")
                        .font(RingDesignSystem.Typography.title2)
                        .fontWeight(.bold)
                        .foregroundColor(healthScoreColor)
                    
                    Text("Score")
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                }
            }
            
            VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.sm) {
                Text(healthStatusText)
                    .font(RingDesignSystem.Typography.headline)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Text(healthStatusDescription)
                    .font(RingDesignSystem.Typography.body)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    .lineLimit(2)
                
                if !smartHomeManager.systemHealth.issues.isEmpty {
                    Text("\(smartHomeManager.systemHealth.issues.count) issue(s) detected")
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(RingDesignSystem.Colors.Alert.warning)
                }
            }
            
            Spacer()
        }
    }
    
    private var performanceMetricsRow: some View {
        HStack(spacing: RingDesignSystem.Spacing.lg) {
            PerformanceMetric(
                title: "Response Time",
                value: String(format: "%.1fs", smartHomeManager.performanceMetrics.averageResponseTime),
                icon: "clock",
                color: smartHomeManager.performanceMetrics.averageResponseTime < 1.0 ? 
                    RingDesignSystem.Colors.ringGreen : RingDesignSystem.Colors.ringOrange
            )
            
            PerformanceMetric(
                title: "Online Rate",
                value: String(format: "%.0f%%", smartHomeManager.performanceMetrics.deviceOnlineRate * 100),
                icon: "wifi",
                color: smartHomeManager.performanceMetrics.deviceOnlineRate > 0.9 ? 
                    RingDesignSystem.Colors.ringGreen : RingDesignSystem.Colors.ringOrange
            )
            
            PerformanceMetric(
                title: "Battery Health",
                value: "\(smartHomeManager.performanceMetrics.batteryHealthScore)%",
                icon: "battery.100",
                color: smartHomeManager.performanceMetrics.batteryHealthScore > 80 ? 
                    RingDesignSystem.Colors.ringGreen : RingDesignSystem.Colors.ringOrange
            )
        }
    }
    
    private var systemAlertsSection: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.sm) {
            Text("System Alerts")
                .font(RingDesignSystem.Typography.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            ForEach(smartHomeManager.getSystemAlerts(), id: \.timestamp) { alert in
                SystemAlertRow(alert: alert)
            }
        }
    }
    
    private var healthScoreColor: Color {
        switch smartHomeManager.systemHealth.score {
        case 90...100: return RingDesignSystem.Colors.ringGreen
        case 75..<90: return RingDesignSystem.Colors.ringBlue
        case 60..<75: return RingDesignSystem.Colors.ringOrange
        case 40..<60: return RingDesignSystem.Colors.ringRed
        default: return RingDesignSystem.Colors.Alert.critical
        }
    }
    
    private var healthStatusText: String {
        switch smartHomeManager.systemHealth.score {
        case 90...100: return "Excellent"
        case 75..<90: return "Good"
        case 60..<75: return "Fair"
        case 40..<60: return "Poor"
        default: return "Critical"
        }
    }
    
    private var healthStatusDescription: String {
        switch smartHomeManager.systemHealth.score {
        case 90...100: return "All systems operating optimally"
        case 75..<90: return "Minor issues detected"
        case 60..<75: return "Some systems need attention"
        case 40..<60: return "Multiple issues require action"
        default: return "System requires immediate attention"
        }
    }
    
    private var searchAndFiltersSection: some View {
        VStack(spacing: RingDesignSystem.Spacing.md) {
            // Time Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: RingDesignSystem.Spacing.sm) {
                    ForEach(TimeFilter.allCases, id: \.self) { filter in
                        FilterChip(
                            title: filter.displayName,
                            isSelected: selectedTimeFilter == filter
                        ) {
                            selectedTimeFilter = filter
                            RingDesignSystem.Haptics.light()
                        }
                    }
                }
                .padding(.horizontal, RingDesignSystem.Spacing.md)
            }
            
            // Device Type Filter
            if !searchText.isEmpty || selectedDeviceType != nil {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: RingDesignSystem.Spacing.sm) {
                        FilterChip(
                            title: "All Types",
                            isSelected: selectedDeviceType == nil
                        ) {
                            selectedDeviceType = nil
                            RingDesignSystem.Haptics.light()
                        }
                        
                        ForEach(DeviceType.allCases, id: \.self) { type in
                            FilterChip(
                                title: type.rawValue.capitalized,
                                isSelected: selectedDeviceType == type
                            ) {
                                selectedDeviceType = type
                                RingDesignSystem.Haptics.light()
                            }
                        }
                    }
                    .padding(.horizontal, RingDesignSystem.Spacing.md)
                }
            }
        }
    }
    
    private var deviceGridSection: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            HStack {
                Text("Devices")
                    .font(RingDesignSystem.Typography.headline)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Spacer()
                
                Button("View All") {
                    // Navigate to full device list
                }
                .font(RingDesignSystem.Typography.subheadline)
                .foregroundColor(RingDesignSystem.Colors.ringBlue)
            }
            
            let filteredDevices = getFilteredDevices()
            
            if filteredDevices.isEmpty {
                emptyStateView
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: RingDesignSystem.Spacing.md) {
                    ForEach(filteredDevices.prefix(6), id: \.id) { device in
                        CompactDeviceCard(device: device)
                    }
                }
            }
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Quick Actions")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: RingDesignSystem.Spacing.md) {
                QuickActionCard(
                    title: "Capture All",
                    subtitle: "Take snapshots",
                    icon: "camera.fill",
                    color: RingDesignSystem.Colors.ringBlue
                ) {
                    // Capture all snapshots
                    RingDesignSystem.Haptics.medium()
                }
                
                QuickActionCard(
                    title: "Test Siren",
                    subtitle: "Emergency alert",
                    icon: "speaker.wave.3.fill",
                    color: RingDesignSystem.Colors.ringRed
                ) {
                    // Test siren
                    RingDesignSystem.Haptics.heavy()
                }
                
                QuickActionCard(
                    title: "Privacy Mode",
                    subtitle: "Pause recording",
                    icon: "eye.slash.fill",
                    color: RingDesignSystem.Colors.ringPurple
                ) {
                    // Toggle privacy mode
                    RingDesignSystem.Haptics.light()
                }
                
                QuickActionCard(
                    title: "System Check",
                    subtitle: "Health scan",
                    icon: "stethoscope",
                    color: RingDesignSystem.Colors.ringGreen
                ) {
                    // System health check
                    RingDesignSystem.Haptics.medium()
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: RingDesignSystem.Spacing.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
            
            Text("No devices found")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            Text("Try adjusting your search or filters")
                .font(RingDesignSystem.Typography.subheadline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(RingDesignSystem.Spacing.xl)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private func getFilteredDevices() -> [SmartDevice] {
        var devices = smartHomeManager.getDevices()
        
        // Apply search filter
        if !searchText.isEmpty {
            devices = devices.filter { device in
                device.name.localizedCaseInsensitiveContains(searchText) ||
                device.location?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
        
        // Apply device type filter
        if let selectedType = selectedDeviceType {
            devices = devices.filter { $0.deviceType == selectedType }
        }
        
        return devices
    }
    
    private func refreshData() async {
        // Simulate async refresh
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        smartHomeManager.refreshDevices()
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    let trend: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                if let trend = trend {
                    Text(trend)
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(trend.hasPrefix("+") ? RingDesignSystem.Colors.ringGreen : RingDesignSystem.Colors.ringRed)
                        .padding(.horizontal, RingDesignSystem.Spacing.xs)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xs)
                                .fill(trend.hasPrefix("+") ? RingDesignSystem.Colors.ringGreen.opacity(0.1) : RingDesignSystem.Colors.ringRed.opacity(0.1))
                        )
                }
            }
            
            Text(value)
                .font(RingDesignSystem.Typography.title2)
                .fontWeight(.bold)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            Text(title)
                .font(RingDesignSystem.Typography.subheadline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            Text(subtitle)
                .font(RingDesignSystem.Typography.caption1)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
}

struct CompactDeviceCard: View {
    let device: SmartDevice
    @State private var showingActions = false
    
    var body: some View {
        Button {
            showingActions = true
            RingDesignSystem.Haptics.light()
        } label: {
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                // Device Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: device.deviceType.gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: device.deviceType.iconName)
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    // Status indicator
                    Circle()
                        .fill(device.status.color)
                        .frame(width: 10, height: 10)
                        .overlay(
                            Circle()
                                .stroke(RingDesignSystem.Colors.Background.primary, lineWidth: 2)
                        )
                        .offset(x: 15, y: -15)
                }
                
                // Device Info
                VStack(spacing: 2) {
                    Text(device.name)
                        .font(RingDesignSystem.Typography.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                        .lineLimit(1)
                    
                    if let batteryLevel = device.batteryLevel {
                        Text("\(batteryLevel)%")
                            .font(RingDesignSystem.Typography.caption2)
                            .foregroundColor(batteryLevel < 20 ? RingDesignSystem.Colors.ringRed : RingDesignSystem.Colors.Foreground.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(RingDesignSystem.Spacing.md)
            .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.md)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingActions) {
            DeviceActionsSheet(
                device: device,
                smartHomeManager: SmartHomeManager.shared,
                deviceStatus: nil
            )
        }
    }
}

struct ActivityRow: View {
    let title: String
    let subtitle: String
    let time: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: RingDesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(RingDesignSystem.Typography.subheadline)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Text(subtitle)
                    .font(RingDesignSystem.Typography.caption1)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
            }
            
            Spacer()
            
            Text(time)
                .font(RingDesignSystem.Typography.caption2)
                .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
        }
        .padding(RingDesignSystem.Spacing.sm)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.sm)
    }
}

struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(RingDesignSystem.Typography.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                    
                    Text(subtitle)
                        .font(RingDesignSystem.Typography.caption2)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(RingDesignSystem.Spacing.md)
            .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.md)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Enums

enum TimeFilter: CaseIterable {
    case lastHour, today, week, month
    
    var displayName: String {
        switch self {
        case .lastHour: return "Last Hour"
        case .today: return "Today"
        case .week: return "This Week"
        case .month: return "This Month"
        }
    }
}

// MARK: - Extensions

extension SmartHomeManager {
    func getOnlineDevices() -> [SmartDevice] {
        return devices.filter { $0.status == .on }
    }
    
    func getOfflineDevices() -> [SmartDevice] {
        return devices.filter { $0.status == .off }
    }
    
    func getDevicesWithLowBattery() -> [SmartDevice] {
        return devices.filter { device in
            guard let batteryLevel = device.batteryLevel else { return false }
            return batteryLevel < 20
        }
    }
    
    func getDevicesWithGoodBattery() -> [SmartDevice] {
        return devices.filter { device in
            guard let batteryLevel = device.batteryLevel else { return true }
            return batteryLevel > 50
        }
    }
    
    func getDevicesWithMotionDetectionDisabled() -> [SmartDevice] {
        return devices.filter { device in
            // This would check actual motion detection status
            return false // Placeholder
        }
    }
    
    func getTotalActiveAlerts() -> Int {
        return Int.random(in: 5...25) // Placeholder
    }
    
    func refreshDevices() {
        // Trigger device refresh
        loadDevicesFromRing()
    }
}

// MARK: - Notification Center

struct NotificationCenter: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedTimeframe: AlertTimeframe = .today
    @State private var searchText = ""
    @State private var selectedAlertType: MotionAlert.AlertType?
    @State private var showingFilterSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                RingDesignSystem.Colors.Background.primary.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Filter Section
                    filterSection
                    
                    // Content
                    if filteredAlerts.isEmpty {
                        emptyAlertsView
                    } else {
                        alertsList
                    }
                }
            }
            .navigationTitle("Alerts")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search alerts...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Filter by Type") {
                            showingFilterSheet = true
                        }
                        
                        Divider()
                        
                        Button("Clear Old Alerts") {
                            clearOldAlerts()
                        }
                        
                        Button("Export Alerts") {
                            exportAlerts()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                    }
                    .frame(minWidth: RingDesignSystem.TouchTarget.minimumSize, minHeight: RingDesignSystem.TouchTarget.minimumSize)
                }
            }
            .sheet(isPresented: $showingFilterSheet) {
                AlertFilterSheet(
                    selectedAlertType: $selectedAlertType,
                    selectedTimeframe: $selectedTimeframe
                )
            }
            .refreshable {
                await refreshAlerts()
            }
        }
    }
    
    private var filterSection: some View {
        VStack(spacing: RingDesignSystem.Spacing.sm) {
            // Quick Actions Row
            quickActionsRow
            
            // Timeframe Picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: RingDesignSystem.Spacing.sm) {
                    ForEach(AlertTimeframe.allCases, id: \.self) { timeframe in
                        TimeframeChip(
                            timeframe: timeframe,
                            isSelected: selectedTimeframe == timeframe
                        ) {
                            selectedTimeframe = timeframe
                            RingDesignSystem.Haptics.selection()
                        }
                    }
                }
                .padding(.horizontal, RingDesignSystem.Spacing.md)
            }
            
            // Alert Stats Row
            alertStatsRow
        }
        .padding(.vertical, RingDesignSystem.Spacing.sm)
        .background(
            RingDesignSystem.Colors.Background.secondary
                .ignoresSafeArea(edges: .horizontal)
        )
    }
    
    private var quickActionsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: RingDesignSystem.Spacing.md) {
                QuickActionButton(
                    title: "All Cameras",
                    icon: "video.fill",
                    color: RingDesignSystem.Colors.ringBlue
                ) {
                    // Navigate to all cameras
                }
                
                QuickActionButton(
                    title: "Live View",
                    icon: "eye.fill",
                    color: RingDesignSystem.Colors.ringGreen
                ) {
                    // Open live view
                }
                
                QuickActionButton(
                    title: "Arm System",
                    icon: "lock.shield.fill",
                    color: RingDesignSystem.Colors.ringOrange
                ) {
                    // Arm security system
                }
                
                QuickActionButton(
                    title: "Settings",
                    icon: "gear",
                    color: RingDesignSystem.Colors.ringPurple
                ) {
                    // Open settings
                }
            }
            .padding(.horizontal, RingDesignSystem.Spacing.md)
        }
    }
    
    private var alertStatsRow: some View {
        HStack(spacing: RingDesignSystem.Spacing.lg) {
            AlertStat(
                title: "Total",
                count: filteredAlerts.count,
                color: RingDesignSystem.Colors.ringBlue
            )
            
            AlertStat(
                title: "High Confidence",
                count: filteredAlerts.filter { $0.confidence > 0.8 }.count,
                color: RingDesignSystem.Colors.ringGreen
            )
            
            AlertStat(
                title: "With Video",
                count: filteredAlerts.filter { $0.hasVideo }.count,
                color: RingDesignSystem.Colors.ringPurple
            )
            
            Spacer()
        }
        .padding(.horizontal, RingDesignSystem.Spacing.md)
    }
    
    private var alertsList: some View {
        ScrollView {
            LazyVStack(spacing: RingDesignSystem.Spacing.sm) {
                ForEach(groupedAlerts.keys.sorted(by: >), id: \.self) { date in
                    if let alerts = groupedAlerts[date] {
                        AlertSection(
                            date: date,
                            alerts: alerts,
                            smartHomeManager: smartHomeManager
                        )
                    }
                }
            }
            .padding(.horizontal, RingDesignSystem.Spacing.md)
            .padding(.bottom, RingDesignSystem.Spacing.xxxl)
        }
    }
    
    private var emptyAlertsView: some View {
        VStack(spacing: RingDesignSystem.Spacing.lg) {
            Image(systemName: "bell.slash.circle")
                .font(.system(size: 64))
                .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
                .pulse(active: false)
            
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                Text("No Motion Alerts")
                    .font(RingDesignSystem.Typography.title2)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Text(searchText.isEmpty ? 
                     "No motion detected in the selected timeframe" :
                     "No alerts match your search")
                    .font(RingDesignSystem.Typography.body)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Refresh Alerts") {
                Task { await refreshAlerts() }
            }
            .frame(minWidth: RingDesignSystem.TouchTarget.minimumSize, minHeight: RingDesignSystem.TouchTarget.minimumSize)
            .padding(.horizontal, RingDesignSystem.Spacing.md)
            .padding(.vertical, RingDesignSystem.Spacing.sm)
            .background(RingDesignSystem.Colors.ringBlue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(RingDesignSystem.Spacing.xl)
    }
    
    private var filteredAlerts: [MotionAlert] {
        let cutoffTime = Date().addingTimeInterval(-selectedTimeframe.timeInterval)
        var alerts = smartHomeManager.recentMotionAlerts.filter { $0.timestamp > cutoffTime }
        
        if !searchText.isEmpty {
            alerts = alerts.filter { alert in
                alert.description.localizedCaseInsensitiveContains(searchText) ||
                alert.alertType.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let selectedType = selectedAlertType {
            alerts = alerts.filter { $0.alertType == selectedType }
        }
        
        return alerts.sorted { $0.timestamp > $1.timestamp }
    }
    
    private var groupedAlerts: [String: [MotionAlert]] {
        let formatter = DateFormatter.dayFormatter
        return Dictionary(grouping: filteredAlerts) { alert in
            formatter.string(from: alert.timestamp)
        }
    }
    
    private func refreshAlerts() async {
        // Refresh alerts from the manager
        smartHomeManager.refreshDevices()
    }
    
    private func clearOldAlerts() {
        // Clear alerts older than 7 days
        let cutoffDate = Date().addingTimeInterval(-7 * 24 * 3600)
        // This would be implemented in SmartHomeManager
    }
    
    private func exportAlerts() {
        // Export alerts functionality
    }
}

// MARK: - Device Type Extensions

extension DeviceType {
    var gradientColors: [Color] {
        switch self {
        case .camera:
            return [RingDesignSystem.Colors.ringBlue, RingDesignSystem.Colors.ringBlue.opacity(0.7)]
        case .doorbell:
            return [RingDesignSystem.Colors.ringOrange, RingDesignSystem.Colors.ringOrange.opacity(0.7)]
        case .motionSensor:
            return [RingDesignSystem.Colors.ringGreen, RingDesignSystem.Colors.ringGreen.opacity(0.7)]
        case .floodlight:
            return [RingDesignSystem.Colors.ringYellow, RingDesignSystem.Colors.ringYellow.opacity(0.7)]
        case .chime:
            return [RingDesignSystem.Colors.ringPurple, RingDesignSystem.Colors.ringPurple.opacity(0.7)]
        }
    }
    
    var accentColor: Color {
        switch self {
        case .camera: return RingDesignSystem.Colors.ringBlue
        case .doorbell: return RingDesignSystem.Colors.ringOrange
        case .motionSensor: return RingDesignSystem.Colors.ringGreen
        case .floodlight: return RingDesignSystem.Colors.ringYellow
        case .chime: return RingDesignSystem.Colors.ringPurple
        }
    }
}

// MARK: - Device Status Extensions

extension DeviceStatus {
    var description: String {
        switch self {
        case .online: return "Online"
        case .offline: return "Offline"
        case .motion: return "Motion"
        case .recording: return "Recording"
        case .error: return "Error"
        }
    }
}

// MARK: - Advanced Loading States

struct LoadingOverlay: View {
    let message: String
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: RingDesignSystem.Spacing.lg) {
                ZStack {
                    Circle()
                        .stroke(RingDesignSystem.Colors.ringBlue.opacity(0.2), lineWidth: 4)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            RingDesignSystem.Colors.ringBlue,
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(
                            Animation.linear(duration: 1)
                                .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                }
                
                Text(message)
                    .font(RingDesignSystem.Typography.subheadline)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            }
            .padding(RingDesignSystem.Spacing.xl)
            .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Enhanced Error States

struct ErrorStateView: View {
    let title: String
    let message: String
    let icon: String
    let actionTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(RingDesignSystem.Colors.Alert.critical)
            
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                Text(title)
                    .font(RingDesignSystem.Typography.title2)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Text(message)
                    .font(RingDesignSystem.Typography.body)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: action) {
                Text(actionTitle)
                    .font(RingDesignSystem.Typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, RingDesignSystem.Spacing.md)
                    .background(RingDesignSystem.Colors.ringBlue)
                    .clipShape(RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg))
            }
            .onTapWithFeedback(haptic: .medium) {
                // Action handled in closure
            }
        }
        .padding(RingDesignSystem.Spacing.xl)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
}

// MARK: - Empty State Views

struct EmptyStateView: View {
    let title: String
    let message: String
    let icon: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
            
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                Text(title)
                    .font(RingDesignSystem.Typography.title2)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Text(message)
                    .font(RingDesignSystem.Typography.body)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(RingDesignSystem.Typography.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(RingDesignSystem.Colors.ringBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, RingDesignSystem.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                                .stroke(RingDesignSystem.Colors.ringBlue, lineWidth: 2)
                        )
                }
                .onTapWithFeedback(haptic: .light) {
                    // Action handled in closure
                }
            }
        }
        .padding(RingDesignSystem.Spacing.xl)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
}

// MARK: - Success Feedback

struct SuccessFeedbackView: View {
    let title: String
    let message: String
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.md) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 32))
                .foregroundColor(RingDesignSystem.Colors.ringGreen)
                .scaleEffect(isVisible ? 1.0 : 0.5)
                .animation(RingDesignSystem.Animations.bouncy, value: isVisible)
            
            VStack(spacing: RingDesignSystem.Spacing.xs) {
                Text(title)
                    .font(RingDesignSystem.Typography.headline)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Text(message)
                    .font(RingDesignSystem.Typography.subheadline)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(RingDesignSystem.Spacing.lg)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
        .scaleEffect(isVisible ? 1.0 : 0.8)
        .opacity(isVisible ? 1.0 : 0.0)
        .animation(RingDesignSystem.Animations.gentle, value: isVisible)
        .onAppear {
            isVisible = true
            RingDesignSystem.Haptics.success()
        }
    }
}

// MARK: - Confirmation Dialogs

struct ConfirmationDialog: View {
    let title: String
    let message: String
    let confirmTitle: String
    let cancelTitle: String
    let confirmAction: () -> Void
    let cancelAction: () -> Void
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.lg) {
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                Text(title)
                    .font(RingDesignSystem.Typography.title2)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Text(message)
                    .font(RingDesignSystem.Typography.body)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: RingDesignSystem.Spacing.md) {
                Button(action: cancelAction) {
                    Text(cancelTitle)
                        .font(RingDesignSystem.Typography.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, RingDesignSystem.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                                .fill(RingDesignSystem.Colors.Fill.secondary)
                        )
                }
                .onTapWithFeedback(haptic: .light) {
                    // Action handled in closure
                }
                
                Button(action: confirmAction) {
                    Text(confirmTitle)
                        .font(RingDesignSystem.Typography.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, RingDesignSystem.Spacing.md)
                        .background(RingDesignSystem.Colors.ringRed)
                        .clipShape(RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg))
                }
                .onTapWithFeedback(haptic: .medium) {
                    // Action handled in closure
                }
            }
        }
        .padding(RingDesignSystem.Spacing.xl)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
}

// MARK: - Detail Views

struct NotificationDetailView: View {
    let notification: SmartNotification
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: RingDesignSystem.Spacing.lg) {
                // Notification icon
                Image(systemName: notification.type.icon)
                    .font(.system(size: 64))
                    .foregroundColor(notification.type.color)
                
                VStack(spacing: RingDesignSystem.Spacing.md) {
                    Text(notification.title)
                        .font(RingDesignSystem.Typography.title2)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                    
                    Text(notification.message)
                        .font(RingDesignSystem.Typography.body)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                        .multilineTextAlignment(.center)
                    
                    Text("Device: \(notification.deviceName)")
                        .font(RingDesignSystem.Typography.subheadline)
                        .foregroundColor(notification.type.color)
                    
                    Text(timeAgoString(from: notification.timestamp))
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
                }
                
                Spacer()
            }
            .padding(RingDesignSystem.Spacing.xl)
            .navigationTitle("Notification")
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

struct AllNotificationsView: View {
    let notifications: [SmartNotification]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(notifications) { notification in
                AdvancedNotificationRow(notification: notification)
            }
            .navigationTitle("All Notifications")
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

struct DeviceDetailView: View {
    let device: SmartDevice
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: RingDesignSystem.Spacing.lg) {
                // Device icon
                Image(systemName: device.deviceType.iconName)
                    .font(.system(size: 64))
                    .foregroundColor(device.deviceType.accentColor)
                
                VStack(spacing: RingDesignSystem.Spacing.md) {
                    Text(device.name)
                        .font(RingDesignSystem.Typography.title2)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                    
                    Text(device.deviceType.rawValue.capitalized)
                        .font(RingDesignSystem.Typography.subheadline)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    
                    if let location = device.location {
                        Text(location)
                            .font(RingDesignSystem.Typography.caption1)
                            .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
                    }
                }
                
                Spacer()
            }
            .padding(RingDesignSystem.Spacing.xl)
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

// MARK: - Quick Action Button

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            RingDesignSystem.Haptics.light()
            action()
        }) {
            VStack(spacing: RingDesignSystem.Spacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
                
                Text(title)
                    .font(RingDesignSystem.Typography.caption1)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    .lineLimit(1)
            }
            .frame(width: 80, height: 60)
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                    .fill(RingDesignSystem.Colors.Fill.secondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .frame(minWidth: RingDesignSystem.TouchTarget.minimumSize, minHeight: RingDesignSystem.TouchTarget.minimumSize)
        .accessibilityLabel(title)
        .accessibilityHint("Double tap to \(title.lowercased())")
    }
}

// MARK: - System Health Components

struct PerformanceMetric: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(RingDesignSystem.Typography.caption1)
                .fontWeight(.semibold)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            Text(title)
                .font(RingDesignSystem.Typography.caption2)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(RingDesignSystem.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.sm)
                .fill(color.opacity(0.1))
        )
    }
}

struct SystemAlertRow: View {
    let alert: SystemAlert
    
    var body: some View {
        HStack(spacing: RingDesignSystem.Spacing.sm) {
            Image(systemName: alertIcon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(alertColor)
            
            VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.xxs) {
                Text(alert.title)
                    .font(RingDesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Text(alert.message)
                    .font(RingDesignSystem.Typography.caption2)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(timeAgoString(from: alert.timestamp))
                .font(RingDesignSystem.Typography.caption2)
                .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
        }
        .padding(RingDesignSystem.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.sm)
                .fill(alertColor.opacity(0.1))
        )
    }
    
    private var alertIcon: String {
        switch alert.type {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .critical: return "exclamationmark.octagon.fill"
        }
    }
    
    private var alertColor: Color {
        switch alert.type {
        case .info: return RingDesignSystem.Colors.ringBlue
        case .warning: return RingDesignSystem.Colors.ringOrange
        case .error: return RingDesignSystem.Colors.ringRed
        case .critical: return RingDesignSystem.Colors.Alert.critical
        }
    }
    
    private func timeAgoString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Device Comparison View
struct DeviceComparisonView: View {
    @State private var selectedDevices: Set<SmartDevice> = []
    @State private var comparisonMetrics: [String: [String: Any]] = [:]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Device Selection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(smartHomeManager.devices) { device in
                            DeviceSelectionCard(
                                device: device,
                                isSelected: selectedDevices.contains(device),
                                onToggle: { toggleDevice(device) }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                if selectedDevices.count >= 2 {
                    // Comparison Table
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(Array(comparisonMetrics.keys.sorted()), id: \.self) { metric in
                                ComparisonMetricRow(
                                    metric: metric,
                                    devices: Array(selectedDevices),
                                    values: comparisonMetrics[metric] ?? [:]
                                )
                            }
                        }
                        .padding()
                    }
                } else {
                    // Empty State
                    VStack(spacing: 16) {
                        Image(systemName: "chart.bar.xaxis")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        
                        Text("Select 2 or more devices to compare")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        
                        Text("Compare battery levels, signal strength, and performance metrics across your devices")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Device Comparison")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                updateComparisonMetrics()
            }
            .onChange(of: selectedDevices) { _ in
                updateComparisonMetrics()
            }
        }
    }
    
    private func toggleDevice(_ device: SmartDevice) {
        if selectedDevices.contains(device) {
            selectedDevices.remove(device)
        } else {
            selectedDevices.insert(device)
        }
    }
    
    private func updateComparisonMetrics() {
        guard selectedDevices.count >= 2 else {
            comparisonMetrics.removeAll()
            return
        }
        
        var metrics: [String: [String: Any]] = [:]
        
        // Battery Levels
        var batteryData: [String: Any] = [:]
        for device in selectedDevices {
            batteryData[device.name] = device.batteryLevel
        }
        metrics["Battery Level"] = batteryData
        
        // Signal Strength
        var signalData: [String: Any] = [:]
        for device in selectedDevices {
            signalData[device.name] = device.signalStrength
        }
        metrics["Signal Strength"] = signalData
        
        // Last Activity
        var activityData: [String: Any] = [:]
        for device in selectedDevices {
            activityData[device.name] = device.lastActivity
        }
        metrics["Last Activity"] = activityData
        
        // Temperature (if applicable)
        var tempData: [String: Any] = [:]
        for device in selectedDevices {
            if let temp = device.temperature {
                tempData[device.name] = temp
            }
        }
        if !tempData.isEmpty {
            metrics["Temperature"] = tempData
        }
        
        comparisonMetrics = metrics
    }
}

struct DeviceSelectionCard: View {
    let device: SmartDevice
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            VStack(spacing: 8) {
                Image(systemName: device.type.iconName)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(device.name)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : .primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ComparisonMetricRow: View {
    let metric: String
    let devices: [SmartDevice]
    let values: [String: Any]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(metric)
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 16) {
                ForEach(devices) { device in
                    VStack(spacing: 4) {
                        Text(device.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if let value = values[device.name] {
                            ComparisonValueView(metric: metric, value: value)
                        } else {
                            Text("N/A")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct ComparisonValueView: View {
    let metric: String
    let value: Any
    
    var body: some View {
        Group {
            switch metric {
            case "Battery Level":
                if let level = value as? Int {
                    HStack(spacing: 4) {
                        Image(systemName: "battery.100")
                            .foregroundColor(batteryColor(level))
                        Text("\(level)%")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                }
            case "Signal Strength":
                if let strength = value as? Int {
                    HStack(spacing: 4) {
                        Image(systemName: "wifi")
                            .foregroundColor(signalColor(strength))
                        Text("\(strength)%")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                }
            case "Last Activity":
                if let date = value as? Date {
                    Text(date, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            case "Temperature":
                if let temp = value as? Double {
                    HStack(spacing: 4) {
                        Image(systemName: "thermometer")
                            .foregroundColor(.orange)
                        Text("\(Int(temp))°F")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                }
            default:
                Text("\(String(describing: value))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func batteryColor(_ level: Int) -> Color {
        switch level {
        case 0..<20: return .red
        case 20..<50: return .orange
        default: return .green
        }
    }
    
    private func signalColor(_ strength: Int) -> Color {
        switch strength {
        case 0..<30: return .red
        case 30..<70: return .orange
        default: return .green
        }
    }
}

// MARK: - Smart Automation Rules
struct AutomationRulesView: View {
    @StateObject private var automationManager = AutomationManager()
    @State private var showingCreateRule = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Active Rules")) {
                    ForEach(automationManager.activeRules) { rule in
                        AutomationRuleRow(rule: rule) {
                            automationManager.toggleRule(rule)
                        }
                    }
                }
                
                Section(header: Text("Inactive Rules")) {
                    ForEach(automationManager.inactiveRules) { rule in
                        AutomationRuleRow(rule: rule) {
                            automationManager.toggleRule(rule)
                        }
                    }
                }
            }
            .navigationTitle("Automation Rules")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Rule") {
                        showingCreateRule = true
                    }
                }
            }
            .sheet(isPresented: $showingCreateRule) {
                CreateAutomationRuleView(automationManager: automationManager)
            }
        }
    }
}

struct AutomationRule: Identifiable, Codable {
    let id = UUID()
    var name: String
    var trigger: AutomationTrigger
    var actions: [AutomationAction]
    var isEnabled: Bool
    var createdAt: Date
    
    enum AutomationTrigger: String, CaseIterable, Codable {
        case motion = "Motion Detected"
        case time = "Time Schedule"
        case location = "Location Based"
        case deviceStatus = "Device Status Change"
        
        var icon: String {
            switch self {
            case .motion: return "figure.walk"
            case .time: return "clock"
            case .location: return "location"
            case .deviceStatus: return "gear"
            }
        }
    }
    
    enum AutomationAction: String, CaseIterable, Codable {
        case turnOnLights = "Turn On Lights"
        case turnOffLights = "Turn Off Lights"
        case startRecording = "Start Recording"
        case stopRecording = "Stop Recording"
        case sendNotification = "Send Notification"
        case activateSiren = "Activate Siren"
        
        var icon: String {
            switch self {
            case .turnOnLights: return "lightbulb.fill"
            case .turnOffLights: return "lightbulb"
            case .startRecording: return "record.circle"
            case .stopRecording: return "stop.circle"
            case .sendNotification: return "bell"
            case .activateSiren: return "speaker.wave.3"
            }
        }
    }
}

class AutomationManager: ObservableObject {
    @Published var activeRules: [AutomationRule] = []
    @Published var inactiveRules: [AutomationRule] = []
    
    init() {
        loadSampleRules()
    }
    
    func toggleRule(_ rule: AutomationRule) {
        // Implementation for toggling rules
    }
    
    private func loadSampleRules() {
        let sampleRules = [
            AutomationRule(
                name: "Night Security",
                trigger: .time,
                actions: [.turnOnLights, .startRecording],
                isEnabled: true,
                createdAt: Date()
            ),
            AutomationRule(
                name: "Motion Alert",
                trigger: .motion,
                actions: [.sendNotification, .activateSiren],
                isEnabled: true,
                createdAt: Date()
            ),
            AutomationRule(
                name: "Away Mode",
                trigger: .location,
                actions: [.turnOffLights, .startRecording],
                isEnabled: false,
                createdAt: Date()
            )
        ]
        
        activeRules = sampleRules.filter { $0.isEnabled }
        inactiveRules = sampleRules.filter { !$0.isEnabled }
    }
}

struct AutomationRuleRow: View {
    let rule: AutomationRule
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(rule.name)
                    .font(.headline)
                
                HStack(spacing: 8) {
                    Image(systemName: rule.trigger.icon)
                        .foregroundColor(.blue)
                    Text(rule.trigger.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 4) {
                    ForEach(rule.actions, id: \.self) { action in
                        Image(systemName: action.icon)
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                }
            }
            
            Spacer()
            
            Toggle("", isOn: .constant(rule.isEnabled))
                .onChange(of: rule.isEnabled) { _ in
                    onToggle()
                }
        }
        .padding(.vertical, 4)
    }
}

struct CreateAutomationRuleView: View {
    @ObservedObject var automationManager: AutomationManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var ruleName = ""
    @State private var selectedTrigger = AutomationRule.AutomationTrigger.motion
    @State private var selectedActions: Set<AutomationRule.AutomationAction> = []
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Rule Name")) {
                    TextField("Enter rule name", text: $ruleName)
                }
                
                Section(header: Text("Trigger")) {
                    Picker("Trigger", selection: $selectedTrigger) {
                        ForEach(AutomationRule.AutomationTrigger.allCases, id: \.self) { trigger in
                            HStack {
                                Image(systemName: trigger.icon)
                                Text(trigger.rawValue)
                            }
                            .tag(trigger)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Actions")) {
                    ForEach(AutomationRule.AutomationAction.allCases, id: \.self) { action in
                        HStack {
                            Image(systemName: action.icon)
                            Text(action.rawValue)
                            Spacer()
                            if selectedActions.contains(action) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedActions.contains(action) {
                                selectedActions.remove(action)
                            } else {
                                selectedActions.insert(action)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Create Rule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveRule()
                    }
                    .disabled(ruleName.isEmpty || selectedActions.isEmpty)
                }
            }
        }
    }
    
    private func saveRule() {
        let newRule = AutomationRule(
            name: ruleName,
            trigger: selectedTrigger,
            actions: Array(selectedActions),
            isEnabled: true,
            createdAt: Date()
        )
        
        automationManager.activeRules.append(newRule)
        dismiss()
    }
}

// MARK: - Device Sharing
struct DeviceSharingView: View {
    @State private var selectedDevices: Set<SmartDevice> = []
    @State private var sharingMode = SharingMode.family
    @State private var showingShareSheet = false
    
    enum SharingMode: String, CaseIterable {
        case family = "Family"
        case guest = "Guest"
        case temporary = "Temporary"
        
        var icon: String {
            switch self {
            case .family: return "person.3"
            case .guest: return "person.badge.plus"
            case .temporary: return "clock"
            }
        }
        
        var description: String {
            switch self {
            case .family: return "Share with family members permanently"
            case .guest: return "Share with guests with limited access"
            case .temporary: return "Share temporarily with time limit"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Sharing Mode Selection
                VStack(spacing: 16) {
                    Text("Select Sharing Mode")
                        .font(.headline)
                        .padding(.top)
                    
                    HStack(spacing: 12) {
                        ForEach(SharingMode.allCases, id: \.self) { mode in
                            SharingModeCard(
                                mode: mode,
                                isSelected: sharingMode == mode,
                                onSelect: { sharingMode = mode }
                            )
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                
                // Device Selection
                List {
                    Section(header: Text("Select Devices to Share")) {
                        ForEach(smartHomeManager.devices) { device in
                            DeviceSharingRow(
                                device: device,
                                isSelected: selectedDevices.contains(device),
                                onToggle: { toggleDevice(device) }
                            )
                        }
                    }
                }
                
                // Share Button
                Button(action: {
                    showingShareSheet = true
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share \(selectedDevices.count) Device\(selectedDevices.count == 1 ? "" : "s")")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedDevices.isEmpty ? Color.gray : Color.blue)
                    )
                }
                .disabled(selectedDevices.isEmpty)
                .padding()
            }
            .navigationTitle("Share Devices")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingShareSheet) {
                ShareSheetView(
                    devices: Array(selectedDevices),
                    mode: sharingMode
                )
            }
        }
    }
    
    private func toggleDevice(_ device: SmartDevice) {
        if selectedDevices.contains(device) {
            selectedDevices.remove(device)
        } else {
            selectedDevices.insert(device)
        }
    }
}

struct SharingModeCard: View {
    let mode: DeviceSharingView.SharingMode
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                Image(systemName: mode.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(mode.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(mode.description)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue : Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color(.systemGray4), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DeviceSharingRow: View {
    let device: SmartDevice
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: device.type.iconName)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(device.name)
                    .font(.headline)
                
                Text(device.type.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onToggle) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onToggle()
        }
    }
}

struct ShareSheetView: View {
    let devices: [SmartDevice]
    let mode: DeviceSharingView.SharingMode
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Share Summary
                VStack(spacing: 12) {
                    Image(systemName: mode.icon)
                        .font(.system(size: 48))
                        .foregroundColor(.blue)
                    
                    Text("Share \(devices.count) Device\(devices.count == 1 ? "" : "s")")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Sharing mode: \(mode.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // Device List
                List {
                    ForEach(devices) { device in
                        HStack {
                            Image(systemName: device.type.iconName)
                                .foregroundColor(.blue)
                            
                            Text(device.name)
                            
                            Spacer()
                            
                            Text(device.type.rawValue)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Share Options
                VStack(spacing: 12) {
                    Button(action: shareViaMessage) {
                        HStack {
                            Image(systemName: "message")
                            Text("Share via Message")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    Button(action: shareViaEmail) {
                        HStack {
                            Image(systemName: "envelope")
                            Text("Share via Email")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    Button(action: generateQRCode) {
                        HStack {
                            Image(systemName: "qrcode")
                            Text("Generate QR Code")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Share Devices")
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
    
    private func shareViaMessage() {
        // Implementation for sharing via message
        dismiss()
    }
    
    private func shareViaEmail() {
        // Implementation for sharing via email
        dismiss()
    }
    
    private func generateQRCode() {
        // Implementation for generating QR code
        dismiss()
    }
}

// MARK: - Enhanced Search with Voice Commands
struct EnhancedSearchView: View {
    @State private var searchText = ""
    @State private var isListening = false
    @State private var searchFilters = SearchFilters()
    @State private var showingVoiceCommands = false
    
    var filteredDevices: [SmartDevice] {
        smartHomeManager.devices.filter { device in
            let matchesSearch = searchText.isEmpty || 
                device.name.localizedCaseInsensitiveContains(searchText) ||
                device.type.rawValue.localizedCaseInsensitiveContains(searchText) ||
                device.location.localizedCaseInsensitiveContains(searchText)
            
            let matchesFilters = searchFilters.matches(device)
            
            return matchesSearch && matchesFilters
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar with Voice
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search devices...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    Button(action: { isListening.toggle() }) {
                        Image(systemName: isListening ? "stop.circle.fill" : "mic.circle.fill")
                            .font(.title2)
                            .foregroundColor(isListening ? .red : .blue)
                    }
                }
                .padding()
                
                // Search Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterChip(
                            title: "All",
                            isSelected: searchFilters.deviceType == nil,
                            onTap: { searchFilters.deviceType = nil }
                        )
                        
                        ForEach(DeviceType.allCases, id: \.self) { type in
                            FilterChip(
                                title: type.rawValue,
                                isSelected: searchFilters.deviceType == type,
                                onTap: { searchFilters.deviceType = type }
                            )
                        }
                        
                        FilterChip(
                            title: "Low Battery",
                            isSelected: searchFilters.lowBatteryOnly,
                            onTap: { searchFilters.lowBatteryOnly.toggle() }
                        )
                        
                        FilterChip(
                            title: "Offline",
                            isSelected: searchFilters.offlineOnly,
                            onTap: { searchFilters.offlineOnly.toggle() }
                        )
                    }
                    .padding(.horizontal)
                }
                
                // Voice Commands Help
                if showingVoiceCommands {
                    VoiceCommandsHelpView()
                }
                
                // Search Results
                List {
                    ForEach(filteredDevices) { device in
                        DeviceRow(device: device)
                    }
                }
            }
            .navigationTitle("Search Devices")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingVoiceCommands.toggle() }) {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
        }
    }
}

struct SearchFilters {
    var deviceType: DeviceType?
    var lowBatteryOnly = false
    var offlineOnly = false
    
    func matches(_ device: SmartDevice) -> Bool {
        if let type = deviceType, device.type != type {
            return false
        }
        
        if lowBatteryOnly && device.batteryLevel > 20 {
            return false
        }
        
        if offlineOnly && device.isOnline {
            return false
        }
        
        return true
    }
}

struct VoiceCommandsHelpView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Voice Commands")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                VoiceCommandRow(command: "Show cameras", description: "Filter to show only cameras")
                VoiceCommandRow(command: "Low battery devices", description: "Show devices with low battery")
                VoiceCommandRow(command: "Offline devices", description: "Show offline devices")
                VoiceCommandRow(command: "Front door", description: "Search for devices at front door")
                VoiceCommandRow(command: "Backyard", description: "Search for devices in backyard")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct VoiceCommandRow: View {
    let command: String
    let description: String
    
    var body: some View {
        HStack {
            Text("\"\(command)\"")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
            
            Text("→")
                .foregroundColor(.secondary)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}