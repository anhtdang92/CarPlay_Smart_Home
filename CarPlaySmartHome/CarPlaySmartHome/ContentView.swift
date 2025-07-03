import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @StateObject private var smartHomeManager = SmartHomeManager.shared

    var body: some View {
        if authManager.isAuthenticated {
            RingDeviceHomeView(smartHomeManager: smartHomeManager)
        } else {
            LoginView(authManager: authManager)
        }
    }
}

struct LoginView: View {
    @ObservedObject var authManager: AuthenticationManager
    @State private var isSigningIn = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                .font(.system(size: 64))
                .foregroundColor(.blue)
            
            Text("Ring Smart Home")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Connect your Ring devices to control them from your car with CarPlay")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }

            if isSigningIn {
                ProgressView("Signing in...")
                    .padding()
            } else {
                Button(action: signInWithRing) {
                    HStack {
                        Image(systemName: "person.crop.circle.badge.checkmark")
                        Text("Sign In with Ring")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)

                Button(action: demoSignIn) {
                    HStack {
                        Image(systemName: "person.circle")
                        Text("Demo Sign In")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func signInWithRing() {
        isSigningIn = true
        errorMessage = nil
        
        RingAPIManager.shared.signInWithRing { result in
            DispatchQueue.main.async {
                isSigningIn = false
                
                switch result {
                case .success:
                    // Authentication handled by AuthenticationManager
                    break
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func demoSignIn() {
        isSigningIn = true
        errorMessage = nil
        
        authManager.signIn { success in
            isSigningIn = false
            if !success {
                errorMessage = "Demo sign in failed"
            }
        }
    }
}

struct RingDeviceHomeView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DeviceListView(smartHomeManager: smartHomeManager)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Devices")
                }
                .tag(0)
            
            MotionAlertsView(smartHomeManager: smartHomeManager)
                .tabItem {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("Alerts")
                }
                .tag(1)
            
            SystemStatusView(smartHomeManager: smartHomeManager)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Status")
                }
                .tag(2)
        }
        .onAppear {
            // Ensure devices are loaded when view appears
            if smartHomeManager.getDevices().isEmpty {
                smartHomeManager.refreshDevices()
            }
        }
    }
}

struct DeviceListView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var showingActionSheet: SmartDevice?
    @State private var showingBulkActions = false

    var body: some View {
        NavigationView {
            ZStack {
                if smartHomeManager.isLoading {
                    ProgressView("Loading devices...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    deviceListContent
                }
            }
            .navigationTitle("Ring Smart Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    systemStatusButton
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Refresh Devices") {
                            smartHomeManager.refreshDevices()
                        }
                        Button("Bulk Actions") {
                            showingBulkActions = true
                        }
                        Button("Sign Out") {
                            RingAPIManager.shared.signOut()
                            AuthenticationManager.shared.signOut()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showingBulkActions) {
                BulkActionsView(smartHomeManager: smartHomeManager)
            }
        }
        .refreshable {
            smartHomeManager.refreshDevices()
        }
    }
    
    private var systemStatusButton: some View {
        Button(action: {
            // This could show a status sheet or navigate to status view
        }) {
            HStack(spacing: 4) {
                let lowBatteryCount = smartHomeManager.getDevicesWithLowBattery().count
                let offlineCount = smartHomeManager.getOfflineDevices().count
                
                if lowBatteryCount > 0 || offlineCount > 0 {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
        }
    }
    
    @ViewBuilder
    private var deviceListContent: some View {
        if smartHomeManager.lastError != nil {
            errorView
        } else if smartHomeManager.devices.isEmpty {
            emptyStateView
        } else {
            deviceList
        }
    }
    
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("Unable to Load Devices")
                .font(.headline)
            
            if let error = smartHomeManager.lastError {
                Text(error.localizedDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Try Again") {
                smartHomeManager.refreshDevices()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "house.circle")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text("No Devices Found")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Your Ring devices will appear here")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Button("Refresh") {
                smartHomeManager.refreshDevices()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.vertical, 32)
    }
    
    private var deviceList: some View {
        List {
            ForEach(DeviceType.allCases, id: \.self) { deviceType in
                let devices = smartHomeManager.getDevices(ofType: deviceType)
                if !devices.isEmpty {
                    Section(deviceType.rawValue + "s") {
                        ForEach(devices) { device in
                            RingDeviceRow(device: device, smartHomeManager: smartHomeManager)
                        }
                    }
                }
            }
        }
    }
}

struct RingDeviceRow: View {
    let device: SmartDevice
    let smartHomeManager: SmartHomeManager
    @State private var showingActions = false
    @State private var isLoading = false
    @State private var deviceStatus: RingDeviceStatus?
    
    var body: some View {
        HStack {
            deviceIcon
            
            VStack(alignment: .leading, spacing: 4) {
                Text(device.name)
                    .font(.headline)
                
                HStack {
                    Text(device.deviceType.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let batteryLevel = device.batteryLevel {
                        batteryIndicator(level: batteryLevel)
                    }
                    
                    if let status = deviceStatus {
                        signalIndicator(strength: status.signalStrength)
                    }
                    
                    Spacer()
                    
                    StatusBadge(status: device.status)
                }
            }
            
            Spacer()
            
            if isLoading {
                ProgressView()
                    .scaleEffect(0.8)
            } else {
                quickActionButton
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            showingActions = true
        }
        .onAppear {
            loadDeviceStatus()
        }
        .actionSheet(isPresented: $showingActions) {
            createActionSheet()
        }
    }
    
    private var deviceIcon: some View {
        ZStack {
            Circle()
                .fill(device.status == .on ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                .frame(width: 40, height: 40)
            
            Image(systemName: device.deviceType.iconName)
                .font(.title2)
                .foregroundColor(device.status == .on ? .green : .gray)
        }
    }
    
    private func batteryIndicator(level: Int) -> some View {
        HStack(spacing: 2) {
            Image(systemName: level <= 20 ? "battery.25" : level <= 50 ? "battery.50" : "battery.100")
                .font(.caption)
                .foregroundColor(level <= 20 ? .red : level <= 50 ? .orange : .green)
            Text("\(level)%")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
    
    private func signalIndicator(strength: Int) -> some View {
        HStack(spacing: 1) {
            ForEach(1...4, id: \.self) { bar in
                Rectangle()
                    .fill(bar <= strength ? Color.primary : Color.gray.opacity(0.3))
                    .frame(width: 2, height: CGFloat(bar * 2 + 2))
            }
        }
    }
    
    private var quickActionButton: some View {
        Button(action: performQuickAction) {
            Image(systemName: quickActionIcon)
                .font(.title2)
                .foregroundColor(.blue)
        }
    }
    
    private var quickActionIcon: String {
        switch device.deviceType {
        case .camera, .doorbell: return "camera.fill"
        case .motionSensor: return "sensor.tag.radiowaves.forward.fill"
        case .floodlight: return "lightbulb.fill"
        case .chime: return "speaker.wave.3.fill"
        }
    }
    
    private func loadDeviceStatus() {
        smartHomeManager.getDeviceStatus(for: device.id) { status in
            DispatchQueue.main.async {
                self.deviceStatus = status
            }
        }
    }
    
    private func performQuickAction() {
        isLoading = true
        
        switch device.deviceType {
        case .camera, .doorbell:
            smartHomeManager.captureSnapshot(for: device.id) { result in
                DispatchQueue.main.async {
                    isLoading = false
                    // Could show a toast or alert here
                }
            }
        case .motionSensor:
            smartHomeManager.toggleMotionDetection(for: device.id) { _ in
                DispatchQueue.main.async {
                    isLoading = false
                }
            }
        default:
            isLoading = false
        }
    }
    
    private func createActionSheet() -> ActionSheet {
        var buttons: [ActionSheet.Button] = []
        
        switch device.deviceType {
        case .camera, .doorbell:
            buttons.append(.default(Text("📹 View Live Stream")) {
                isLoading = true
                smartHomeManager.getLiveStream(for: device.id) { _ in
                    DispatchQueue.main.async { isLoading = false }
                }
            })
            buttons.append(.default(Text("📸 Capture Snapshot")) {
                performQuickAction()
            })
            buttons.append(.default(Text("🔔 Toggle Motion Detection")) {
                isLoading = true
                smartHomeManager.toggleMotionDetection(for: device.id) { _ in
                    DispatchQueue.main.async { isLoading = false }
                }
            })
            
            if device.deviceType == .doorbell {
                buttons.append(.destructive(Text("🚨 Activate Siren")) {
                    isLoading = true
                    smartHomeManager.activateSiren(for: device.id) { _ in
                        DispatchQueue.main.async { isLoading = false }
                    }
                })
            }
            
        case .motionSensor:
            buttons.append(.default(Text("🔔 Toggle Motion Detection")) {
                performQuickAction()
            })
            
        default:
            break
        }
        
        buttons.append(.cancel())
        
        return ActionSheet(
            title: Text(device.name),
            message: Text("Choose an action"),
            buttons: buttons
        )
    }
}

struct StatusBadge: View {
    let status: DeviceStatus
    
    var body: some View {
        Text(status.description)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(8)
    }
    
    private var backgroundColor: Color {
        switch status {
        case .on, .open: return .green.opacity(0.2)
        case .off, .closed: return .red.opacity(0.2)
        case .unknown: return .gray.opacity(0.2)
        }
    }
    
    private var foregroundColor: Color {
        switch status {
        case .on, .open: return .green
        case .off, .closed: return .red
        case .unknown: return .gray
        }
    }
}

struct MotionAlertsView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var selectedTimeframe: AlertTimeframe = .today
    
    enum AlertTimeframe: String, CaseIterable {
        case hour = "Last Hour"
        case today = "Today"
        case week = "This Week"
        
        var timeInterval: TimeInterval {
            switch self {
            case .hour: return 3600
            case .today: return 86400
            case .week: return 604800
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(AlertTimeframe.allCases, id: \.self) { timeframe in
                        Text(timeframe.rawValue).tag(timeframe)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    if filteredAlerts.isEmpty {
                        emptyAlertsView
                    } else {
                        ForEach(filteredAlerts) { alert in
                            MotionAlertRow(alert: alert, smartHomeManager: smartHomeManager)
                        }
                    }
                }
            }
            .navigationTitle("Motion Alerts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear Old") {
                        smartHomeManager.clearOldAlerts(olderThan: 7)
                    }
                }
            }
        }
    }
    
    private var filteredAlerts: [MotionAlert] {
        let cutoffTime = Date().addingTimeInterval(-selectedTimeframe.timeInterval)
        return smartHomeManager.recentMotionAlerts.filter { $0.timestamp > cutoffTime }
    }
    
    private var emptyAlertsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.slash.circle")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text("No Alerts")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("No motion detected in the selected timeframe")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 32)
    }
}

struct MotionAlertRow: View {
    let alert: MotionAlert
    let smartHomeManager: SmartHomeManager
    @State private var deviceName: String = "Unknown Device"
    
    var body: some View {
        HStack {
            alertIcon
            
            VStack(alignment: .leading, spacing: 4) {
                Text(alert.description)
                    .font(.headline)
                
                HStack {
                    Text(deviceName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    confidenceBadge
                }
                
                Text(timeAgoString)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if alert.hasVideo {
                Image(systemName: "video.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
        .onAppear {
            loadDeviceName()
        }
    }
    
    private var alertIcon: some View {
        Image(systemName: alertIconName)
            .font(.title2)
            .foregroundColor(alertColor)
            .frame(width: 32)
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
    
    private var alertColor: Color {
        switch alert.alertType {
        case .motion: return .orange
        case .person: return .blue
        case .vehicle: return .purple
        case .package: return .green
        case .doorbell: return .yellow
        }
    }
    
    private var confidenceBadge: some View {
        Text("\(Int(alert.confidence * 100))%")
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(alert.confidence > 0.8 ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
            .foregroundColor(alert.confidence > 0.8 ? .green : .orange)
            .cornerRadius(4)
    }
    
    private var timeAgoString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter.localizedString(for: alert.timestamp, relativeTo: Date())
    }
    
    private func loadDeviceName() {
        if let device = smartHomeManager.getDevice(withId: alert.deviceId) {
            deviceName = device.name
        }
    }
}

struct SystemStatusView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    
    var body: some View {
        NavigationView {
            List {
                overviewSection
                deviceHealthSection
                alertsSection
                maintenanceSection
            }
            .navigationTitle("System Status")
        }
    }
    
    private var overviewSection: some View {
        Section("Overview") {
            StatusRow(
                title: "Total Devices",
                value: "\(smartHomeManager.getDevices().count)",
                icon: "house.fill",
                color: .blue
            )
            
            StatusRow(
                title: "Active Alerts (1h)",
                value: "\(smartHomeManager.getTotalActiveAlerts())",
                icon: "exclamationmark.triangle.fill",
                color: smartHomeManager.getTotalActiveAlerts() > 0 ? .orange : .green
            )
        }
    }
    
    private var deviceHealthSection: some View {
        Section("Device Health") {
            let lowBatteryDevices = smartHomeManager.getDevicesWithLowBattery()
            let offlineDevices = smartHomeManager.getOfflineDevices()
            
            StatusRow(
                title: "Low Battery",
                value: "\(lowBatteryDevices.count)",
                icon: "battery.25",
                color: lowBatteryDevices.isEmpty ? .green : .red
            )
            
            StatusRow(
                title: "Offline Devices",
                value: "\(offlineDevices.count)",
                icon: "wifi.slash",
                color: offlineDevices.isEmpty ? .green : .red
            )
        }
    }
    
    private var alertsSection: some View {
        Section("Motion Detection") {
            let disabledDevices = smartHomeManager.getDevicesWithMotionDetectionDisabled()
            
            StatusRow(
                title: "Motion Detection Disabled",
                value: "\(disabledDevices.count)",
                icon: "sensor.tag.radiowaves.forward.fill",
                color: disabledDevices.isEmpty ? .green : .orange
            )
        }
    }
    
    private var maintenanceSection: some View {
        Section("Quick Actions") {
            Button(action: {
                smartHomeManager.refreshDevices()
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.blue)
                    Text("Refresh All Devices")
                    Spacer()
                }
            }
            
            Button(action: {
                smartHomeManager.clearOldAlerts(olderThan: 7)
            }) {
                HStack {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                    Text("Clear Old Alerts")
                    Spacer()
                }
            }
        }
    }
}

struct StatusRow: View {
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
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
    }
}

struct BulkActionsView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @Environment(\.presentationMode) var presentationMode
    @State private var isProcessing = false
    @State private var resultMessage: String?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Bulk Device Actions")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                
                if isProcessing {
                    ProgressView("Processing...")
                        .padding()
                } else {
                    VStack(spacing: 16) {
                        ActionButton(
                            title: "Capture All Snapshots",
                            icon: "camera.fill",
                            color: .blue,
                            action: captureAllSnapshots
                        )
                        
                        ActionButton(
                            title: "Enable All Motion Detection",
                            icon: "sensor.tag.radiowaves.forward.fill",
                            color: .green,
                            action: enableAllMotionDetection
                        )
                        
                        ActionButton(
                            title: "Disable All Motion Detection",
                            icon: "sensor.tag.radiowaves.forward",
                            color: .orange,
                            action: disableAllMotionDetection
                        )
                    }
                    .padding()
                }
                
                if let message = resultMessage {
                    Text(message)
                        .foregroundColor(.green)
                        .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Bulk Actions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func captureAllSnapshots() {
        isProcessing = true
        resultMessage = nil
        
        smartHomeManager.captureSnapshotsFromAllCameras { snapshots, errors in
            DispatchQueue.main.async {
                isProcessing = false
                resultMessage = "Captured \(snapshots.count) snapshots, \(errors.count) failed"
            }
        }
    }
    
    private func enableAllMotionDetection() {
        isProcessing = true
        resultMessage = nil
        
        smartHomeManager.enableMotionDetectionForAllDevices { success, total in
            DispatchQueue.main.async {
                isProcessing = false
                resultMessage = "Enabled motion detection on \(success)/\(total) devices"
            }
        }
    }
    
    private func disableAllMotionDetection() {
        isProcessing = true
        resultMessage = nil
        
        smartHomeManager.disableMotionDetectionForAllDevices { success, total in
            DispatchQueue.main.async {
                isProcessing = false
                resultMessage = "Disabled motion detection on \(success)/\(total) devices"
            }
        }
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding()
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(12)
        }
    }
}

#Preview {
    ContentView()
} 