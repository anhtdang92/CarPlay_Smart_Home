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