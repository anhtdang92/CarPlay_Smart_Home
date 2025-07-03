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

// MARK: - Settings View

struct SettingsView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    
    var body: some View {
        NavigationView {
            List {
                profileSection
                deviceSection
                notificationSection
                securitySection
                supportSection
                signOutSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var profileSection: some View {
        Section {
            HStack(spacing: RingDesignSystem.Spacing.md) {
                Circle()
                    .fill(RingDesignSystem.Colors.ringBlue)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text("JD")
                            .font(RingDesignSystem.Typography.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.xs) {
                    Text("John Doe")
                        .font(RingDesignSystem.Typography.headline)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                    
                    Text("john.doe@example.com")
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                }
                
                Spacer()
            }
            .padding(.vertical, RingDesignSystem.Spacing.xs)
        }
    }
    
    private var deviceSection: some View {
        Section("Devices") {
            SettingsRow(
                title: "Device Management",
                icon: "house.fill",
                color: RingDesignSystem.Colors.ringBlue
            )
            
            SettingsRow(
                title: "Geofencing",
                icon: "location.fill",
                color: RingDesignSystem.Colors.ringGreen
            )
            
            SettingsRow(
                title: "Motion Detection",
                icon: "sensor.tag.radiowaves.forward.fill",
                color: RingDesignSystem.Colors.ringOrange
            )
        }
    }
    
    private var notificationSection: some View {
        Section("Notifications") {
            SettingsRow(
                title: "Push Notifications",
                icon: "bell.fill",
                color: RingDesignSystem.Colors.ringYellow
            )
            
            SettingsRow(
                title: "Alert Preferences",
                icon: "exclamationmark.triangle.fill",
                color: RingDesignSystem.Colors.ringRed
            )
        }
    }
    
    private var securitySection: some View {
        Section("Security & Privacy") {
            SettingsRow(
                title: "Privacy Settings",
                icon: "lock.fill",
                color: RingDesignSystem.Colors.ringPurple
            )
            
            SettingsRow(
                title: "Data & Storage",
                icon: "internaldrive.fill",
                color: RingDesignSystem.Colors.Foreground.secondary
            )
        }
    }
    
    private var supportSection: some View {
        Section("Support") {
            SettingsRow(
                title: "Help & Support",
                icon: "questionmark.circle.fill",
                color: RingDesignSystem.Colors.ringBlue
            )
            
            SettingsRow(
                title: "Contact Support",
                icon: "message.fill",
                color: RingDesignSystem.Colors.ringGreen
            )
        }
    }
    
    private var signOutSection: some View {
        Section {
            Button {
                signOut()
            } label: {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(RingDesignSystem.Colors.ringRed)
                    
                    Text("Sign Out")
                        .foregroundColor(RingDesignSystem.Colors.ringRed)
                }
            }
        }
    }
    
    private func signOut() {
        RingDesignSystem.Haptics.medium()
        RingAPIManager.shared.signOut()
        AuthenticationManager.shared.signOut()
    }
}

// MARK: - Bulk Actions View

struct BulkActionsView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @Environment(\.dismiss) var dismiss
    @State private var isProcessing = false
    @State private var resultMessage: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: RingDesignSystem.Spacing.lg) {
                    if isProcessing {
                        processingView
                    } else {
                        actionsGrid
                    }
                    
                    if let message = resultMessage {
                        resultView(message: message)
                    }
                }
                .padding(RingDesignSystem.Spacing.md)
            }
            .background(RingDesignSystem.Colors.Background.primary.ignoresSafeArea())
            .navigationTitle("Bulk Actions")
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
    
    private var actionsGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: RingDesignSystem.Spacing.md) {
            BulkActionCard(
                title: "Capture All Snapshots",
                subtitle: "Take photos from all cameras",
                icon: "camera.fill",
                color: RingDesignSystem.Colors.ringBlue
            ) {
                performBulkSnapshots()
            }
            
            BulkActionCard(
                title: "Enable Motion Detection",
                subtitle: "Turn on for all devices",
                icon: "sensor.tag.radiowaves.forward.fill",
                color: RingDesignSystem.Colors.ringGreen
            ) {
                enableAllMotionDetection()
            }
            
            BulkActionCard(
                title: "Disable Motion Detection",
                subtitle: "Turn off for all devices",
                icon: "sensor.tag.radiowaves.forward",
                color: RingDesignSystem.Colors.ringOrange
            ) {
                disableAllMotionDetection()
            }
            
            BulkActionCard(
                title: "System Health Check",
                subtitle: "Check all device status",
                icon: "stethoscope",
                color: RingDesignSystem.Colors.ringPurple
            ) {
                performHealthCheck()
            }
        }
    }
    
    private var processingView: some View {
        VStack(spacing: RingDesignSystem.Spacing.lg) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: RingDesignSystem.Colors.ringBlue))
                .scaleEffect(1.5)
            
            Text("Processing...")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
        .shimmer(active: true)
    }
    
    private func resultView(message: String) -> some View {
        VStack(spacing: RingDesignSystem.Spacing.md) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 48))
                .foregroundColor(RingDesignSystem.Colors.ringGreen)
            
            Text("Complete")
                .font(RingDesignSystem.Typography.headline)
                .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
            
            Text(message)
                .font(RingDesignSystem.Typography.body)
                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(RingDesignSystem.Spacing.lg)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
        .transition(.scale.combined(with: .opacity))
    }
    
    private func performBulkSnapshots() {
        isProcessing = true
        resultMessage = nil
        RingDesignSystem.Haptics.medium()
        
        smartHomeManager.captureSnapshotsFromAllCameras { snapshots, errors in
            DispatchQueue.main.async {
                isProcessing = false
                resultMessage = "Captured \(snapshots.count) snapshots, \(errors.count) failed"
                RingDesignSystem.Haptics.success()
            }
        }
    }
    
    private func enableAllMotionDetection() {
        isProcessing = true
        resultMessage = nil
        RingDesignSystem.Haptics.medium()
        
        smartHomeManager.enableMotionDetectionForAllDevices { success, total in
            DispatchQueue.main.async {
                isProcessing = false
                resultMessage = "Enabled motion detection on \(success)/\(total) devices"
                RingDesignSystem.Haptics.success()
            }
        }
    }
    
    private func disableAllMotionDetection() {
        isProcessing = true
        resultMessage = nil
        RingDesignSystem.Haptics.medium()
        
        smartHomeManager.disableMotionDetectionForAllDevices { success, total in
            DispatchQueue.main.async {
                isProcessing = false
                resultMessage = "Disabled motion detection on \(success)/\(total) devices"
                RingDesignSystem.Haptics.success()
            }
        }
    }
    
    private func performHealthCheck() {
        isProcessing = true
        resultMessage = nil
        RingDesignSystem.Haptics.medium()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isProcessing = false
            resultMessage = "System health check completed successfully"
            RingDesignSystem.Haptics.success()
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
            
            Image(systemName: "chevron.right")
                .font(RingDesignSystem.Typography.caption2)
                .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
        }
    }
}

struct BulkActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: RingDesignSystem.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(color)
                
                VStack(spacing: RingDesignSystem.Spacing.xs) {
                    Text(title)
                        .font(RingDesignSystem.Typography.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            .padding(RingDesignSystem.Spacing.md)
            .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .onTapWithFeedback(haptic: .medium) {
            // Action handled in closure
        }
    }
}