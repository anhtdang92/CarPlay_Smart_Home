import SwiftUI

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