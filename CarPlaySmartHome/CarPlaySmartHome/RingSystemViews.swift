import SwiftUI

// MARK: - System Status View

struct SystemStatusView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var refreshTimer: Timer?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: RingDesignSystem.Spacing.md) {
                    systemOverviewCard
                    deviceHealthCard
                    networkStatusCard
                    alertSummaryCard
                    quickActionsCard
                }
                .padding(RingDesignSystem.Spacing.md)
            }
            .background(RingDesignSystem.Colors.Background.primary.ignoresSafeArea())
            .navigationTitle("System Status")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                startRefreshTimer()
            }
            .onDisappear {
                refreshTimer?.invalidate()
            }
        }
    }
    
    private var systemOverviewCard: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("System Overview")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: RingDesignSystem.Spacing.sm) {
                StatusMetric(
                    title: "Devices",
                    value: "\(smartHomeManager.getDevices().count)",
                    icon: "house.fill",
                    color: RingDesignSystem.Colors.ringBlue
                )
                
                StatusMetric(
                    title: "Online",
                    value: "\(smartHomeManager.getOnlineDevices().count)",
                    icon: "wifi",
                    color: RingDesignSystem.Colors.ringGreen
                )
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private var deviceHealthCard: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Device Health")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            VStack(spacing: RingDesignSystem.Spacing.xs) {
                HealthRow(
                    title: "Low Battery",
                    count: smartHomeManager.getDevicesWithLowBattery().count,
                    icon: "battery.25",
                    color: smartHomeManager.getDevicesWithLowBattery().isEmpty ? 
                        RingDesignSystem.Colors.ringGreen : RingDesignSystem.Colors.ringRed
                )
                
                HealthRow(
                    title: "Offline",
                    count: smartHomeManager.getOfflineDevices().count,
                    icon: "wifi.slash",
                    color: smartHomeManager.getOfflineDevices().isEmpty ? 
                        RingDesignSystem.Colors.ringGreen : RingDesignSystem.Colors.ringRed
                )
                
                HealthRow(
                    title: "Motion Disabled",
                    count: smartHomeManager.getDevicesWithMotionDetectionDisabled().count,
                    icon: "sensor.tag.radiowaves.forward",
                    color: smartHomeManager.getDevicesWithMotionDetectionDisabled().isEmpty ? 
                        RingDesignSystem.Colors.ringGreen : RingDesignSystem.Colors.ringOrange
                )
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private var networkStatusCard: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Network Status")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            HStack(spacing: RingDesignSystem.Spacing.md) {
                Image(systemName: "wifi")
                    .font(.title2)
                    .foregroundColor(RingDesignSystem.Colors.ringGreen)
                
                VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.xs) {
                    Text("Connected")
                        .font(RingDesignSystem.Typography.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                    
                    Text("Uptime: 99.8% • Latency: 24ms")
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                }
                
                Spacer()
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private var alertSummaryCard: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Recent Activity")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            VStack(spacing: RingDesignSystem.Spacing.xs) {
                AlertSummaryRow(
                    title: "Motion Alerts (24h)",
                    count: smartHomeManager.getTotalActiveAlerts(),
                    icon: "sensor.tag.radiowaves.forward.fill",
                    color: RingDesignSystem.Colors.ringOrange
                )
                
                AlertSummaryRow(
                    title: "Snapshots Captured",
                    count: 28,
                    icon: "camera.fill",
                    color: RingDesignSystem.Colors.ringBlue
                )
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private var quickActionsCard: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            Text("Quick Actions")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            VStack(spacing: RingDesignSystem.Spacing.sm) {
                QuickActionButton(
                    title: "Refresh All Devices",
                    icon: "arrow.clockwise",
                    color: RingDesignSystem.Colors.ringBlue
                ) {
                    smartHomeManager.refreshDevices()
                    RingDesignSystem.Haptics.light()
                }
                
                QuickActionButton(
                    title: "Test All Notifications",
                    icon: "bell.fill",
                    color: RingDesignSystem.Colors.ringOrange
                ) {
                    // Test notifications
                    RingDesignSystem.Haptics.medium()
                }
            }
        }
        .padding(RingDesignSystem.Spacing.md)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
    }
    
    private func startRefreshTimer() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            // Auto-refresh status
        }
    }
}

// MARK: - Enhanced Settings View

struct SettingsView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var showingNotificationSettings = false
    @State private var showingDataManagement = false
    @State private var showingAnalytics = false
    @State private var showingDeviceSetup = false
    @State private var showingBackupRestore = false
    @State private var showingAbout = false
    
    var body: some View {
        NavigationView {
            List {
                // Account Section
                accountSection
                
                // Notifications Section
                notificationsSection
                
                // Device Management Section
                deviceManagementSection
                
                // Data & Privacy Section
                dataPrivacySection
                
                // System Section
                systemSection
                
                // Support Section
                supportSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingNotificationSettings) {
                NotificationSettingsView(smartHomeManager: smartHomeManager)
            }
            .sheet(isPresented: $showingDataManagement) {
                DataManagementView(smartHomeManager: smartHomeManager)
            }
            .sheet(isPresented: $showingAnalytics) {
                AnalyticsView(smartHomeManager: smartHomeManager)
            }
            .sheet(isPresented: $showingDeviceSetup) {
                DeviceSetupWizardView(smartHomeManager: smartHomeManager)
            }
            .sheet(isPresented: $showingBackupRestore) {
                BackupRestoreView(smartHomeManager: smartHomeManager)
            }
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
        }
    }
    
    private var accountSection: some View {
        Section("Account") {
            SettingsRow(
                title: "Ring Account",
                subtitle: "Manage your Ring account settings",
                icon: "person.circle.fill",
                color: RingDesignSystem.Colors.ringBlue
            ) {
                // Navigate to Ring account settings
                RingDesignSystem.Haptics.navigation()
            }
            
            SettingsRow(
                title: "CarPlay Settings",
                subtitle: "Configure CarPlay integration",
                icon: "car.fill",
                color: RingDesignSystem.Colors.ringGreen
            ) {
                // Navigate to CarPlay settings
                RingDesignSystem.Haptics.navigation()
            }
        }
    }
    
    private var notificationsSection: some View {
        Section("Notifications") {
            SettingsRow(
                title: "Notification Preferences",
                subtitle: "Customize alert settings",
                icon: "bell.fill",
                color: RingDesignSystem.Colors.ringOrange
            ) {
                showingNotificationSettings = true
                RingDesignSystem.Haptics.navigation()
            }
            
            SettingsRow(
                title: "Quiet Hours",
                subtitle: smartHomeManager.notificationPreferences.quietHours.enabled ? "Enabled" : "Disabled",
                icon: "moon.fill",
                color: RingDesignSystem.Colors.ringPurple
            ) {
                showingNotificationSettings = true
                RingDesignSystem.Haptics.navigation()
            }
        }
    }
    
    private var deviceManagementSection: some View {
        Section("Device Management") {
            SettingsRow(
                title: "Add Device",
                subtitle: "Set up a new Ring device",
                icon: "plus.circle.fill",
                color: RingDesignSystem.Colors.ringBlue
            ) {
                showingDeviceSetup = true
                RingDesignSystem.Haptics.navigation()
            }
            
            SettingsRow(
                title: "Device Organization",
                subtitle: "Group and organize devices",
                icon: "folder.fill",
                color: RingDesignSystem.Colors.ringGreen
            ) {
                // Navigate to device organization
                RingDesignSystem.Haptics.navigation()
            }
            
            SettingsRow(
                title: "System Health",
                subtitle: "Monitor device performance",
                icon: "heart.fill",
                color: RingDesignSystem.Colors.ringRed
            ) {
                // Navigate to system health
                RingDesignSystem.Haptics.navigation()
            }
        }
    }
    
    private var dataPrivacySection: some View {
        Section("Data & Privacy") {
            SettingsRow(
                title: "Data Management",
                subtitle: "Backup and restore data",
                icon: "icloud.fill",
                color: RingDesignSystem.Colors.ringBlue
            ) {
                showingDataManagement = true
                RingDesignSystem.Haptics.navigation()
            }
            
            SettingsRow(
                title: "Analytics & Usage",
                subtitle: "View app usage statistics",
                icon: "chart.bar.fill",
                color: RingDesignSystem.Colors.ringOrange
            ) {
                showingAnalytics = true
                RingDesignSystem.Haptics.navigation()
            }
            
            SettingsRow(
                title: "Privacy Settings",
                subtitle: "Control data sharing",
                icon: "lock.shield.fill",
                color: RingDesignSystem.Colors.ringPurple
            ) {
                // Navigate to privacy settings
                RingDesignSystem.Haptics.navigation()
            }
        }
    }
    
    private var systemSection: some View {
        Section("System") {
            SettingsRow(
                title: "Performance",
                subtitle: "Monitor app performance",
                icon: "speedometer",
                color: RingDesignSystem.Colors.ringGreen
            ) {
                // Navigate to performance monitoring
                RingDesignSystem.Haptics.navigation()
            }
            
            SettingsRow(
                title: "App Version",
                subtitle: "1.0.0 (Build 1)",
                icon: "info.circle.fill",
                color: RingDesignSystem.Colors.Foreground.secondary
            ) {
                showingAbout = true
                RingDesignSystem.Haptics.navigation()
            }
        }
    }
    
    private var supportSection: some View {
        Section("Support") {
            SettingsRow(
                title: "Help & Support",
                subtitle: "Get help and contact support",
                icon: "questionmark.circle.fill",
                color: RingDesignSystem.Colors.ringBlue
            ) {
                // Navigate to help and support
                RingDesignSystem.Haptics.navigation()
            }
            
            SettingsRow(
                title: "Feedback",
                subtitle: "Send feedback and suggestions",
                icon: "envelope.fill",
                color: RingDesignSystem.Colors.ringGreen
            ) {
                // Open feedback form
                RingDesignSystem.Haptics.navigation()
            }
        }
    }
}

// MARK: - Notification Settings View

struct NotificationSettingsView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var preferences: SmartHomeManager.NotificationPreferences
    @Environment(\.dismiss) var dismiss
    
    init(smartHomeManager: SmartHomeManager) {
        self.smartHomeManager = smartHomeManager
        self._preferences = State(initialValue: smartHomeManager.notificationPreferences)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Alert Types") {
                    Toggle("Motion Alerts", isOn: $preferences.motionAlerts)
                    Toggle("Doorbell Rings", isOn: $preferences.doorbellRings)
                    Toggle("System Alerts", isOn: $preferences.systemAlerts)
                    Toggle("Battery Warnings", isOn: $preferences.batteryWarnings)
                }
                
                Section("Quiet Hours") {
                    Toggle("Enable Quiet Hours", isOn: $preferences.quietHours.enabled)
                    
                    if preferences.quietHours.enabled {
                        DatePicker("Start Time", selection: $preferences.quietHours.startTime, displayedComponents: .hourAndMinute)
                        DatePicker("End Time", selection: $preferences.quietHours.endTime, displayedComponents: .hourAndMinute)
                    }
                }
                
                Section("Device-Specific Alerts") {
                    ForEach(smartHomeManager.getDevices(), id: \.id) { device in
                        Toggle(device.name, isOn: Binding(
                            get: { preferences.deviceSpecificAlerts[device.id.uuidString] ?? true },
                            set: { preferences.deviceSpecificAlerts[device.id.uuidString] = $0 }
                        ))
                    }
                }
            }
            .navigationTitle("Notification Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        smartHomeManager.updateNotificationPreferences(preferences)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Data Management View

struct DataManagementView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var showingBackupOptions = false
    @State private var showingRestoreOptions = false
    @State private var showingExportOptions = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Backup & Restore") {
                    SettingsRow(
                        title: "Create Backup",
                        subtitle: "Save your data locally",
                        icon: "icloud.and.arrow.up.fill",
                        color: RingDesignSystem.Colors.ringBlue
                    ) {
                        showingBackupOptions = true
                        RingDesignSystem.Haptics.navigation()
                    }
                    
                    SettingsRow(
                        title: "Restore Backup",
                        subtitle: "Restore from saved backup",
                        icon: "icloud.and.arrow.down.fill",
                        color: RingDesignSystem.Colors.ringGreen
                    ) {
                        showingRestoreOptions = true
                        RingDesignSystem.Haptics.navigation()
                    }
                }
                
                Section("Export Data") {
                    SettingsRow(
                        title: "Export Device Data",
                        subtitle: "Export as JSON file",
                        icon: "square.and.arrow.up.fill",
                        color: RingDesignSystem.Colors.ringOrange
                    ) {
                        showingExportOptions = true
                        RingDesignSystem.Haptics.navigation()
                    }
                }
                
                Section("Data Usage") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Local Storage")
                                .font(RingDesignSystem.Typography.subheadline)
                            Text("2.4 MB used")
                                .font(RingDesignSystem.Typography.caption1)
                                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                        }
                        
                        Spacer()
                        
                        ProgressView(value: 0.24)
                            .frame(width: 60)
                    }
                }
            }
            .navigationTitle("Data Management")
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

// MARK: - Analytics View

struct AnalyticsView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Usage Statistics") {
                    AnalyticsRow(
                        title: "Total Sessions",
                        value: "\(smartHomeManager.userAnalytics.totalSessions)",
                        icon: "chart.line.uptrend.xyaxis",
                        color: RingDesignSystem.Colors.ringBlue
                    )
                    
                    AnalyticsRow(
                        title: "Average Session",
                        value: String(format: "%.1f min", smartHomeManager.userAnalytics.averageSessionDuration / 60),
                        icon: "clock.fill",
                        color: RingDesignSystem.Colors.ringGreen
                    )
                }
                
                Section("Most Used Features") {
                    ForEach(Array(smartHomeManager.userAnalytics.mostUsedFeatures.prefix(5)), id: \.key) { feature in
                        HStack {
                            Text(feature.key.replacingOccurrences(of: "_", with: " ").capitalized)
                            Spacer()
                            Text("\(feature.value)")
                                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                        }
                    }
                }
                
                Section("Device Interactions") {
                    ForEach(Array(smartHomeManager.userAnalytics.deviceInteractions.prefix(5)), id: \.key) { interaction in
                        HStack {
                            Text(interaction.key.replacingOccurrences(of: "_", with: " ").capitalized)
                            Spacer()
                            Text("\(interaction.value)")
                                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Analytics")
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

// MARK: - Supporting Components

struct HealthRow: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(RingDesignSystem.Typography.subheadline)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(RingDesignSystem.Typography.subheadline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            Spacer()
            
            Text("\(count)")
                .font(RingDesignSystem.Typography.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .padding(.vertical, RingDesignSystem.Spacing.xs)
    }
}

struct AlertSummaryRow: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(RingDesignSystem.Typography.subheadline)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(RingDesignSystem.Typography.subheadline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            Spacer()
            
            Text("\(count)")
                .font(RingDesignSystem.Typography.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .padding(.vertical, RingDesignSystem.Spacing.xs)
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(RingDesignSystem.Typography.subheadline)
                    .foregroundColor(color)
                
                Text(title)
                    .font(RingDesignSystem.Typography.subheadline)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(RingDesignSystem.Typography.caption1)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
            }
            .padding(RingDesignSystem.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                    .fill(color.opacity(0.1))
            )
        }
        .onTapWithFeedback(haptic: .light) {
            // Action handled in closure
        }
    }
}

struct SettingsRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(RingDesignSystem.Typography.subheadline)
                    .foregroundColor(color)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.xs) {
                    Text(title)
                        .font(RingDesignSystem.Typography.subheadline)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                    
                    Text(subtitle)
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(RingDesignSystem.Typography.caption2)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
            }
        }
        .onTapWithFeedback(haptic: .medium) {
            // Action handled in closure
        }
    }
}

struct AnalyticsRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
            
            Spacer()
            
            Text(value)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: RingDesignSystem.Spacing.xl) {
                // App Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [RingDesignSystem.Colors.ringBlue, RingDesignSystem.Colors.ringBlue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                        .font(.system(size: 48, weight: .medium))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: RingDesignSystem.Spacing.md) {
                    Text("Ring Smart Home")
                        .font(RingDesignSystem.Typography.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Version 1.0.0 (Build 1)")
                        .font(RingDesignSystem.Typography.subheadline)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    
                    Text("CarPlay Integration for Ring Smart Home Security")
                        .font(RingDesignSystem.Typography.body)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
            .padding(RingDesignSystem.Spacing.xl)
            .navigationTitle("About")
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

// MARK: - Device Maintenance Scheduler
struct DeviceMaintenanceView: View {
    @StateObject private var maintenanceManager = MaintenanceManager()
    @State private var showingAddMaintenance = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Upcoming Maintenance")) {
                    ForEach(maintenanceManager.upcomingMaintenance) { task in
                        MaintenanceTaskRow(task: task)
                    }
                }
                
                Section(header: Text("Completed Tasks")) {
                    ForEach(maintenanceManager.completedTasks) { task in
                        MaintenanceTaskRow(task: task, isCompleted: true)
                    }
                }
            }
            .navigationTitle("Maintenance")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Task") {
                        showingAddMaintenance = true
                    }
                }
            }
            .sheet(isPresented: $showingAddMaintenance) {
                AddMaintenanceTaskView(maintenanceManager: maintenanceManager)
            }
        }
    }
}

struct MaintenanceTask: Identifiable, Codable {
    let id = UUID()
    var deviceId: String
    var deviceName: String
    var taskType: TaskType
    var scheduledDate: Date
    var isCompleted: Bool
    var notes: String?
    var completedDate: Date?
    
    enum TaskType: String, CaseIterable, Codable {
        case batteryReplacement = "Battery Replacement"
        case firmwareUpdate = "Firmware Update"
        case cleaning = "Cleaning"
        case inspection = "Inspection"
        case calibration = "Calibration"
        
        var icon: String {
            switch self {
            case .batteryReplacement: return "battery.100"
            case .firmwareUpdate: return "arrow.clockwise"
            case .cleaning: return "sparkles"
            case .inspection: return "magnifyingglass"
            case .calibration: return "slider.horizontal.3"
            }
        }
        
        var color: Color {
            switch self {
            case .batteryReplacement: return .red
            case .firmwareUpdate: return .blue
            case .cleaning: return .green
            case .inspection: return .orange
            case .calibration: return .purple
            }
        }
    }
}

class MaintenanceManager: ObservableObject {
    @Published var upcomingMaintenance: [MaintenanceTask] = []
    @Published var completedTasks: [MaintenanceTask] = []
    
    init() {
        loadSampleData()
    }
    
    func addTask(_ task: MaintenanceTask) {
        upcomingMaintenance.append(task)
        sortTasks()
    }
    
    func completeTask(_ task: MaintenanceTask) {
        if let index = upcomingMaintenance.firstIndex(where: { $0.id == task.id }) {
            var completedTask = task
            completedTask.isCompleted = true
            completedTask.completedDate = Date()
            completedTasks.append(completedTask)
            upcomingMaintenance.remove(at: index)
        }
    }
    
    private func sortTasks() {
        upcomingMaintenance.sort { $0.scheduledDate < $1.scheduledDate }
    }
    
    private func loadSampleData() {
        let sampleTasks = [
            MaintenanceTask(
                deviceId: "1",
                deviceName: "Front Door Camera",
                taskType: .batteryReplacement,
                scheduledDate: Date().addingTimeInterval(7 * 24 * 3600),
                isCompleted: false,
                notes: "Battery level at 15%"
            ),
            MaintenanceTask(
                deviceId: "2",
                deviceName: "Backyard Camera",
                taskType: .cleaning,
                scheduledDate: Date().addingTimeInterval(3 * 24 * 3600),
                isCompleted: false,
                notes: "Lens cleaning needed"
            ),
            MaintenanceTask(
                deviceId: "3",
                deviceName: "Motion Sensor",
                taskType: .inspection,
                scheduledDate: Date().addingTimeInterval(14 * 24 * 3600),
                isCompleted: false
            )
        ]
        
        upcomingMaintenance = sampleTasks
        
        let completedSample = MaintenanceTask(
            deviceId: "4",
            deviceName: "Side Door Camera",
            taskType: .firmwareUpdate,
            scheduledDate: Date().addingTimeInterval(-7 * 24 * 3600),
            isCompleted: true,
            completedDate: Date().addingTimeInterval(-6 * 24 * 3600)
        )
        
        completedTasks = [completedSample]
    }
}

struct MaintenanceTaskRow: View {
    let task: MaintenanceTask
    var isCompleted: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: task.taskType.icon)
                .foregroundColor(task.taskType.color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.deviceName)
                    .font(.headline)
                    .strikethrough(isCompleted)
                
                Text(task.taskType.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let notes = task.notes {
                    Text(notes)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(task.scheduledDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if isCompleted, let completedDate = task.completedDate {
                    Text("Completed: \(completedDate, style: .date)")
                        .font(.caption2)
                        .foregroundColor(.green)
                } else {
                    Text(task.scheduledDate, style: .relative)
                        .font(.caption2)
                        .foregroundColor(task.scheduledDate < Date() ? .red : .secondary)
                }
            }
        }
        .opacity(isCompleted ? 0.6 : 1.0)
    }
}

struct AddMaintenanceTaskView: View {
    @ObservedObject var maintenanceManager: MaintenanceManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDevice = ""
    @State private var selectedTaskType = MaintenanceTask.TaskType.batteryReplacement
    @State private var scheduledDate = Date()
    @State private var notes = ""
    
    let devices = ["Front Door Camera", "Backyard Camera", "Motion Sensor", "Floodlight Camera"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Device")) {
                    Picker("Device", selection: $selectedDevice) {
                        ForEach(devices, id: \.self) { device in
                            Text(device).tag(device)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Task Type")) {
                    Picker("Task Type", selection: $selectedTaskType) {
                        ForEach(MaintenanceTask.TaskType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: type.icon)
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Schedule")) {
                    DatePicker("Scheduled Date", selection: $scheduledDate, displayedComponents: [.date])
                }
                
                Section(header: Text("Notes")) {
                    TextField("Optional notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Maintenance Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTask()
                    }
                    .disabled(selectedDevice.isEmpty)
                }
            }
        }
    }
    
    private func saveTask() {
        let task = MaintenanceTask(
            deviceId: UUID().uuidString,
            deviceName: selectedDevice,
            taskType: selectedTaskType,
            scheduledDate: scheduledDate,
            isCompleted: false,
            notes: notes.isEmpty ? nil : notes
        )
        
        maintenanceManager.addTask(task)
        dismiss()
    }
}

// MARK: - Energy Usage Analytics
struct EnergyUsageView: View {
    @StateObject private var energyManager = EnergyManager()
    @State private var selectedTimeframe = Timeframe.week
    
    enum Timeframe: String, CaseIterable {
        case day = "Day"
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Timeframe Selector
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(Timeframe.allCases, id: \.self) { timeframe in
                        Text(timeframe.rawValue).tag(timeframe)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Energy Summary
                        EnergySummaryCard(energyManager: energyManager, timeframe: selectedTimeframe)
                        
                        // Device Energy Usage
                        DeviceEnergyUsageCard(energyManager: energyManager, timeframe: selectedTimeframe)
                        
                        // Energy Trends
                        EnergyTrendsCard(energyManager: energyManager, timeframe: selectedTimeframe)
                        
                        // Energy Saving Tips
                        EnergySavingTipsCard()
                    }
                    .padding()
                }
            }
            .navigationTitle("Energy Usage")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

class EnergyManager: ObservableObject {
    @Published var energyData: [String: Double] = [:]
    @Published var deviceEnergyUsage: [String: Double] = [:]
    @Published var energyTrends: [Date: Double] = [:]
    
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        energyData = [
            "Total Usage": 45.2,
            "Average Daily": 6.8,
            "Peak Usage": 12.3,
            "Cost": 8.45
        ]
        
        deviceEnergyUsage = [
            "Front Door Camera": 12.5,
            "Backyard Camera": 15.2,
            "Motion Sensor": 3.1,
            "Floodlight Camera": 14.4
        ]
        
        // Generate sample trend data
        for i in 0..<7 {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) ?? Date()
            energyTrends[date] = Double.random(in: 5.0...15.0)
        }
    }
}

struct EnergySummaryCard: View {
    @ObservedObject var energyManager: EnergyManager
    let timeframe: EnergyUsageView.Timeframe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Energy Summary")
                .font(.headline)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                EnergyMetricView(
                    title: "Total Usage",
                    value: "\(energyManager.energyData["Total Usage"] ?? 0, specifier: "%.1f") kWh",
                    icon: "bolt.fill",
                    color: .yellow
                )
                
                EnergyMetricView(
                    title: "Cost",
                    value: "$\(energyManager.energyData["Cost"] ?? 0, specifier: "%.2f")",
                    icon: "dollarsign.circle.fill",
                    color: .green
                )
                
                EnergyMetricView(
                    title: "Daily Average",
                    value: "\(energyManager.energyData["Average Daily"] ?? 0, specifier: "%.1f") kWh",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .blue
                )
                
                EnergyMetricView(
                    title: "Peak Usage",
                    value: "\(energyManager.energyData["Peak Usage"] ?? 0, specifier: "%.1f") kWh",
                    icon: "arrow.up.circle.fill",
                    color: .red
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct EnergyMetricView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct DeviceEnergyUsageCard: View {
    @ObservedObject var energyManager: EnergyManager
    let timeframe: EnergyUsageView.Timeframe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Device Energy Usage")
                .font(.headline)
            
            VStack(spacing: 12) {
                ForEach(Array(energyManager.deviceEnergyUsage.keys.sorted()), id: \.self) { device in
                    DeviceEnergyRow(
                        deviceName: device,
                        usage: energyManager.deviceEnergyUsage[device] ?? 0
                    )
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

struct DeviceEnergyRow: View {
    let deviceName: String
    let usage: Double
    
    var body: some View {
        HStack {
            Text(deviceName)
                .font(.subheadline)
            
            Spacer()
            
            Text("\(usage, specifier: "%.1f") kWh")
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.vertical, 4)
    }
}

struct EnergyTrendsCard: View {
    @ObservedObject var energyManager: EnergyManager
    let timeframe: EnergyUsageView.Timeframe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Energy Trends")
                .font(.headline)
            
            // Simple bar chart representation
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(energyManager.energyTrends.keys.sorted()), id: \.self) { date in
                    let usage = energyManager.energyTrends[date] ?? 0
                    let maxUsage = energyManager.energyTrends.values.max() ?? 1
                    let height = CGFloat(usage / maxUsage) * 100
                    
                    VStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.blue)
                            .frame(width: 20, height: height)
                        
                        Text(date, style: .date)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(height: 120)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct EnergySavingTipsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Energy Saving Tips")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                EnergyTipRow(
                    tip: "Use motion detection instead of continuous recording",
                    icon: "figure.walk",
                    color: .green
                )
                
                EnergyTipRow(
                    tip: "Schedule cameras to turn off during quiet hours",
                    icon: "clock",
                    color: .blue
                )
                
                EnergyTipRow(
                    tip: "Keep firmware updated for optimal efficiency",
                    icon: "arrow.clockwise",
                    color: .orange
                )
                
                EnergyTipRow(
                    tip: "Use LED floodlights instead of traditional bulbs",
                    icon: "lightbulb",
                    color: .yellow
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct EnergyTipRow: View {
    let tip: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(tip)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

// MARK: - Smart Home Insights Dashboard
struct SmartHomeInsightsView: View {
    @StateObject private var insightsManager = InsightsManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Security Insights
                    SecurityInsightsCard(insightsManager: insightsManager)
                    
                    // Activity Patterns
                    ActivityPatternsCard(insightsManager: insightsManager)
                    
                    // Device Health Insights
                    DeviceHealthInsightsCard(insightsManager: insightsManager)
                    
                    // Recommendations
                    RecommendationsCard(insightsManager: insightsManager)
                }
                .padding()
            }
            .navigationTitle("Insights")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

class InsightsManager: ObservableObject {
    @Published var securityScore = 85
    @Published var activityPatterns: [String: Int] = [:]
    @Published var deviceHealthIssues: [String] = []
    @Published var recommendations: [String] = []
    
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        activityPatterns = [
            "Morning (6-9 AM)": 12,
            "Afternoon (12-3 PM)": 8,
            "Evening (6-9 PM)": 15,
            "Night (9 PM-6 AM)": 3
        ]
        
        deviceHealthIssues = [
            "Front Door Camera battery at 15%",
            "Motion Sensor needs calibration",
            "Backyard Camera lens cleaning recommended"
        ]
        
        recommendations = [
            "Add a camera to cover the side entrance",
            "Consider upgrading to 4K cameras for better clarity",
            "Schedule regular maintenance for all devices",
            "Enable motion zones to reduce false alerts"
        ]
    }
}

struct SecurityInsightsCard: View {
    @ObservedObject var insightsManager: InsightsManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Security Score")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(insightsManager.securityScore)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(securityScoreColor)
                    
                    Text("out of 100")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text(securityScoreDescription)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(securityScoreColor)
                    
                    Text("Your home is well protected")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    private var securityScoreColor: Color {
        switch insightsManager.securityScore {
        case 0..<50: return .red
        case 50..<75: return .orange
        default: return .green
        }
    }
    
    private var securityScoreDescription: String {
        switch insightsManager.securityScore {
        case 0..<50: return "Needs Attention"
        case 50..<75: return "Good"
        default: return "Excellent"
        }
    }
}

struct ActivityPatternsCard: View {
    @ObservedObject var insightsManager: InsightsManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity Patterns")
                .font(.headline)
            
            VStack(spacing: 12) {
                ForEach(Array(insightsManager.activityPatterns.keys.sorted()), id: \.self) { timeSlot in
                    ActivityPatternRow(
                        timeSlot: timeSlot,
                        count: insightsManager.activityPatterns[timeSlot] ?? 0
                    )
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

struct ActivityPatternRow: View {
    let timeSlot: String
    let count: Int
    
    var body: some View {
        HStack {
            Text(timeSlot)
                .font(.subheadline)
            
            Spacer()
            
            Text("\(count) events")
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.vertical, 4)
    }
}

struct DeviceHealthInsightsCard: View {
    @ObservedObject var insightsManager: InsightsManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Device Health Issues")
                .font(.headline)
            
            if insightsManager.deviceHealthIssues.isEmpty {
                Text("All devices are healthy!")
                    .font(.subheadline)
                    .foregroundColor(.green)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(insightsManager.deviceHealthIssues, id: \.self) { issue in
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            
                            Text(issue)
                                .font(.subheadline)
                        }
                    }
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

struct RecommendationsCard: View {
    @ObservedObject var insightsManager: InsightsManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommendations")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(insightsManager.recommendations, id: \.self) { recommendation in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                            .frame(width: 20)
                        
                        Text(recommendation)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
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