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
            .ringButton(style: .secondary, size: .medium)
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
        Dictionary(grouping: filteredAlerts) { alert in
            DateFormatter.dayFormatter.string(from: alert.timestamp)
        }
    }
    
    private func clearOldAlerts() {
        RingDesignSystem.Haptics.medium()
        smartHomeManager.clearOldAlerts(olderThan: 7)
    }
    
    private func exportAlerts() {
        RingDesignSystem.Haptics.light()
        // Export functionality would go here
    }
    
    private func refreshAlerts() async {
        RingDesignSystem.Haptics.light()
        // Refresh functionality would go here
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
    @Binding var selectedTimeframe: MotionAlertsView.AlertTimeframe
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: RingDesignSystem.Spacing.lg) {
                // Alert Type Filter
                VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
                    Text("Alert Type")
                        .font(RingDesignSystem.Typography.headline)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: RingDesignSystem.Spacing.sm) {
                        // All Types Option
                        FilterTypeButton(
                            title: "All Types",
                            icon: "list.bullet",
                            color: RingDesignSystem.Colors.Foreground.secondary,
                            isSelected: selectedAlertType == nil
                        ) {
                            selectedAlertType = nil
                        }
                        
                        // Individual Alert Types
                        ForEach(MotionAlert.AlertType.allCases, id: \.self) { alertType in
                            FilterTypeButton(
                                title: alertType.rawValue,
                                icon: alertType.iconName,
                                color: alertType.color,
                                isSelected: selectedAlertType == alertType
                            ) {
                                selectedAlertType = alertType
                            }
                        }
                    }
                }
                .padding(RingDesignSystem.Spacing.md)
                .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
                
                Spacer()
                
                // Apply Button
                Button("Apply Filters") {
                    dismiss()
                    RingDesignSystem.Haptics.success()
                }
                .ringButton(style: .primary, size: .large)
                .padding(.horizontal, RingDesignSystem.Spacing.md)
            }
            .padding(RingDesignSystem.Spacing.md)
            .background(RingDesignSystem.Colors.Background.primary.ignoresSafeArea())
            .navigationTitle("Filter Alerts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") {
                        selectedAlertType = nil
                        selectedTimeframe = .today
                        RingDesignSystem.Haptics.light()
                    }
                    .foregroundColor(RingDesignSystem.Colors.ringBlue)
                }
            }
        }
    }
}

struct FilterTypeButton: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? .white : color)
                
                Text(title)
                    .font(RingDesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : RingDesignSystem.Colors.Foreground.primary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, minHeight: 70)
            .padding(RingDesignSystem.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                    .fill(isSelected ? color : color.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                            .stroke(color.opacity(isSelected ? 0 : 0.3), lineWidth: 1)
                    )
            )
        }
        .onTapWithFeedback(haptic: .selection) {
            // Action handled in closure
        }
        .animation(RingDesignSystem.Animations.quick, value: isSelected)
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
                LazyVStack(spacing: RingDesignSystem.Spacing.lg) {
                    // Weather and Time Header
                    if showingWeather {
                        weatherHeader
                    }
                    
                    // Quick Stats
                    quickStatsGrid
                    
                    // Search and Filters
                    searchAndFiltersSection
                    
                    // Device Grid
                    deviceGridSection
                    
                    // Recent Activity
                    recentActivitySection
                    
                    // Quick Actions
                    quickActionsSection
                }
                .padding(RingDesignSystem.Spacing.md)
            }
            .background(backgroundGradient.ignoresSafeArea())
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search devices...")
            .refreshable {
                await refreshData()
            }
        }
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
    
    private var quickStatsGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: RingDesignSystem.Spacing.md) {
            StatCard(
                title: "Devices Online",
                value: "\(smartHomeManager.getOnlineDevices().count)",
                subtitle: "of \(smartHomeManager.getDevices().count) total",
                icon: "wifi",
                color: RingDesignSystem.Colors.ringGreen,
                trend: "+2"
            )
            
            StatCard(
                title: "Motion Alerts",
                value: "\(smartHomeManager.getTotalActiveAlerts())",
                subtitle: "in last 24h",
                icon: "sensor.tag.radiowaves.forward.fill",
                color: RingDesignSystem.Colors.ringOrange,
                trend: "-5"
            )
            
            StatCard(
                title: "Battery Health",
                value: "\(smartHomeManager.getDevicesWithGoodBattery().count)",
                subtitle: "devices above 50%",
                icon: "battery.100",
                color: RingDesignSystem.Colors.ringBlue,
                trend: nil
            )
            
            StatCard(
                title: "System Status",
                value: "Healthy",
                subtitle: "All systems operational",
                icon: "checkmark.shield.fill",
                color: RingDesignSystem.Colors.ringGreen,
                trend: nil
            )
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
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Recent Activity")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                ForEach(0..<3, id: \.self) { index in
                    ActivityRow(
                        title: "Motion detected",
                        subtitle: "Front Door Camera",
                        time: "\(index + 1) minute\(index == 0 ? "" : "s") ago",
                        icon: "sensor.tag.radiowaves.forward.fill",
                        color: RingDesignSystem.Colors.ringOrange
                    )
                }
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
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

// MARK: - Advanced Notification System

struct NotificationCenter: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var notifications: [SmartNotification] = []
    @State private var showingAllNotifications = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: RingDesignSystem.Spacing.md) {
                // Notification Summary
                notificationSummary
                
                // Recent Notifications
                recentNotifications
                
                Spacer()
            }
            .padding(RingDesignSystem.Spacing.md)
            .background(RingDesignSystem.Colors.Background.primary.ignoresSafeArea())
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingAllNotifications) {
                AllNotificationsView(notifications: notifications)
            }
            .onAppear {
                loadNotifications()
            }
        }
    }
    
    private var notificationSummary: some View {
        VStack(spacing: RingDesignSystem.Spacing.md) {
            HStack {
                Text("Today")
                    .font(RingDesignSystem.Typography.headline)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Spacer()
                
                Button("View All") {
                    showingAllNotifications = true
                }
                .font(RingDesignSystem.Typography.subheadline)
                .foregroundColor(RingDesignSystem.Colors.ringBlue)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: RingDesignSystem.Spacing.md) {
                NotificationSummaryCard(
                    title: "Motion",
                    count: notifications.filter { $0.type == .motion }.count,
                    icon: "sensor.tag.radiowaves.forward.fill",
                    color: RingDesignSystem.Colors.ringOrange
                )
                
                NotificationSummaryCard(
                    title: "Person",
                    count: notifications.filter { $0.type == .person }.count,
                    icon: "person.fill",
                    color: RingDesignSystem.Colors.ringBlue
                )
                
                NotificationSummaryCard(
                    title: "System",
                    count: notifications.filter { $0.type == .system }.count,
                    icon: "gear",
                    color: RingDesignSystem.Colors.ringPurple
                )
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private var recentNotifications: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Recent")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                ForEach(notifications.prefix(5), id: \.id) { notification in
                    AdvancedNotificationRow(notification: notification)
                }
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private func loadNotifications() {
        notifications = [
            SmartNotification(
                id: UUID(),
                title: "Motion Detected",
                message: "Front door camera detected movement",
                type: .motion,
                timestamp: Date().addingTimeInterval(-300),
                deviceName: "Front Door Camera",
                priority: .high,
                isRead: false
            ),
            SmartNotification(
                id: UUID(),
                title: "Person Detected",
                message: "Backyard camera identified a person",
                type: .person,
                timestamp: Date().addingTimeInterval(-600),
                deviceName: "Backyard Camera",
                priority: .critical,
                isRead: false
            ),
            SmartNotification(
                id: UUID(),
                title: "Battery Low",
                message: "Kitchen sensor battery is below 20%",
                type: .system,
                timestamp: Date().addingTimeInterval(-1800),
                deviceName: "Kitchen Sensor",
                priority: .medium,
                isRead: true
            )
        ]
    }
}

struct AdvancedNotificationRow: View {
    let notification: SmartNotification
    @State private var showingDetails = false
    
    var body: some View {
        Button {
            showingDetails = true
            RingDesignSystem.Haptics.light()
        } label: {
            HStack(spacing: RingDesignSystem.Spacing.sm) {
                // Priority indicator
                Circle()
                    .fill(notification.priority.color)
                    .frame(width: 8, height: 8)
                
                // Icon
                Image(systemName: notification.type.icon)
                    .font(.title3)
                    .foregroundColor(notification.type.color)
                    .frame(width: 32)
                
                // Content
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(notification.title)
                            .font(RingDesignSystem.Typography.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                        
                        if !notification.isRead {
                            Circle()
                                .fill(RingDesignSystem.Colors.ringBlue)
                                .frame(width: 6, height: 6)
                        }
                        
                        Spacer()
                        
                        Text(timeAgoString(from: notification.timestamp))
                            .font(RingDesignSystem.Typography.caption2)
                            .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
                    }
                    
                    Text(notification.message)
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                        .lineLimit(1)
                    
                    Text(notification.deviceName)
                        .font(RingDesignSystem.Typography.caption2)
                        .foregroundColor(notification.type.color)
                }
            }
            .padding(RingDesignSystem.Spacing.sm)
            .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.sm)
            .opacity(notification.isRead ? 0.7 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetails) {
            NotificationDetailView(notification: notification)
        }
    }
}

struct NotificationSummaryCard: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text("\(count)")
                .font(RingDesignSystem.Typography.title2)
                .fontWeight(.bold)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            Text(title)
                .font(RingDesignSystem.Typography.caption1)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.md)
    }
}

// MARK: - Interactive Map View

struct DeviceMapView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedDevice: SmartDevice?
    @State private var showingDeviceDetails = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Map background (simulated)
                mapBackground
                
                // Device markers
                deviceMarkers
                
                // Selected device overlay
                if let selectedDevice = selectedDevice {
                    deviceOverlay(device: selectedDevice)
                }
            }
            .navigationTitle("Device Map")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingDeviceDetails) {
                if let device = selectedDevice {
                    DeviceDetailView(device: device)
                }
            }
        }
    }
    
    private var mapBackground: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        RingDesignSystem.Colors.Background.secondary,
                        RingDesignSystem.Colors.Background.primary
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                // Simulated map grid
                Path { path in
                    for i in 0...10 {
                        let x = CGFloat(i) * 40
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: 400))
                        
                        let y = CGFloat(i) * 40
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: 400, y: y))
                    }
                }
                .stroke(RingDesignSystem.Colors.Separator.primary.opacity(0.3), lineWidth: 0.5)
            )
    }
    
    private var deviceMarkers: some View {
        ZStack {
            ForEach(smartHomeManager.getDevices(), id: \.id) { device in
                DeviceMarker(
                    device: device,
                    isSelected: selectedDevice?.id == device.id
                ) {
                    withAnimation(RingDesignSystem.Animations.gentle) {
                        selectedDevice = selectedDevice?.id == device.id ? nil : device
                    }
                    RingDesignSystem.Haptics.light()
                }
            }
        }
    }
    
    private func deviceOverlay(device: SmartDevice) -> some View {
        VStack {
            Spacer()
            
            VStack(spacing: RingDesignSystem.Spacing.md) {
                HStack {
                    VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.xs) {
                        Text(device.name)
                            .font(RingDesignSystem.Typography.headline)
                            .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                        
                        Text(device.deviceType.rawValue.capitalized)
                            .font(RingDesignSystem.Typography.subheadline)
                            .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    }
                    
                    Spacer()
                    
                    Button {
                        showingDeviceDetails = true
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.title2)
                            .foregroundColor(RingDesignSystem.Colors.ringBlue)
                    }
                }
                
                HStack(spacing: RingDesignSystem.Spacing.md) {
                    DeviceStatusBadge(status: device.status)
                    
                    if let batteryLevel = device.batteryLevel {
                        BatteryIndicator(level: batteryLevel)
                    }
                    
                    Spacer()
                    
                    Button("View Live") {
                        // Open live stream
                        RingDesignSystem.Haptics.medium()
                    }
                    .font(RingDesignSystem.Typography.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, RingDesignSystem.Spacing.md)
                    .padding(.vertical, RingDesignSystem.Spacing.sm)
                    .background(RingDesignSystem.Colors.ringBlue)
                    .clipShape(RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.sm))
                }
            }
            .padding(RingDesignSystem.Spacing.md)
            .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
            .padding(.horizontal, RingDesignSystem.Spacing.md)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

struct DeviceMarker: View {
    let device: SmartDevice
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Marker background
                Circle()
                    .fill(
                        LinearGradient(
                            colors: device.deviceType.gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: isSelected ? 50 : 40, height: isSelected ? 50 : 40)
                    .shadow(
                        color: device.deviceType.accentColor.opacity(0.3),
                        radius: isSelected ? 12 : 8,
                        x: 0,
                        y: isSelected ? 6 : 4
                    )
                
                // Device icon
                Image(systemName: device.deviceType.iconName)
                    .font(.system(size: isSelected ? 20 : 16, weight: .medium))
                    .foregroundColor(.white)
                
                // Status indicator
                Circle()
                    .fill(device.status.color)
                    .frame(width: 8, height: 8)
                    .overlay(
                        Circle()
                            .stroke(.white, lineWidth: 2)
                    )
                    .offset(x: isSelected ? 15 : 12, y: isSelected ? -15 : -12)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.2 : 1.0)
        .animation(RingDesignSystem.Animations.bouncy, value: isSelected)
    }
}

// MARK: - Helper Functions and Extensions

func timeAgoString(from date: Date) -> String {
    let interval = Date().timeIntervalSince(date)
    
    if interval < 60 {
        return "Just now"
    } else if interval < 3600 {
        let minutes = Int(interval / 60)
        return "\(minutes)m ago"
    } else if interval < 86400 {
        let hours = Int(interval / 3600)
        return "\(hours)h ago"
    } else {
        let days = Int(interval / 86400)
        return "\(days)d ago"
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