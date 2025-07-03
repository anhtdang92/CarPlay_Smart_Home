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

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                .font(.system(size: 64))
                .foregroundColor(.blue)
            
            Text("Ring Smart Home")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Connect your Ring devices to control them from your car")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if isSigningIn {
                ProgressView("Signing in...")
                    .padding()
            } else {
                Button(action: {
                    isSigningIn = true
                    RingAPIManager.shared.signInWithRing { success in
                        isSigningIn = false
                        // The authManager's state will be updated internally
                        // and the view will switch automatically.
                    }
                }) {
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

                Button(action: {
                    isSigningIn = true
                    authManager.signIn { success in
                        isSigningIn = false
                    }
                }) {
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
        }
    }
}

struct DeviceListView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var showingActionSheet: SmartDevice?

    var body: some View {
        NavigationView {
            List {
                if !smartHomeManager.getDevices(ofType: .camera).isEmpty {
                    Section("Cameras") {
                        ForEach(smartHomeManager.getDevices(ofType: .camera)) { device in
                            RingDeviceRow(device: device, smartHomeManager: smartHomeManager)
                        }
                    }
                }
                
                if !smartHomeManager.getDevices(ofType: .doorbell).isEmpty {
                    Section("Doorbells") {
                        ForEach(smartHomeManager.getDevices(ofType: .doorbell)) { device in
                            RingDeviceRow(device: device, smartHomeManager: smartHomeManager)
                        }
                    }
                }
                
                if !smartHomeManager.getDevices(ofType: .motionSensor).isEmpty {
                    Section("Motion Sensors") {
                        ForEach(smartHomeManager.getDevices(ofType: .motionSensor)) { device in
                            RingDeviceRow(device: device, smartHomeManager: smartHomeManager)
                        }
                    }
                }
                
                if smartHomeManager.devices.isEmpty {
                    Section {
                        HStack {
                            Spacer()
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
                            }
                            Spacer()
                        }
                        .padding(.vertical, 32)
                    }
                }
            }
            .navigationTitle("Ring Smart Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Refresh Devices") {
                            smartHomeManager.loadDevicesFromRing()
                        }
                        Button("Sign Out") {
                            AuthenticationManager.shared.signOut()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
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
    
    var body: some View {
        HStack {
            Image(systemName: device.deviceType.iconName)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(device.name)
                    .font(.headline)
                
                HStack {
                    Text(device.deviceType.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    StatusBadge(status: device.status)
                }
            }
            
            Spacer()
            
            if isLoading {
                ProgressView()
                    .scaleEffect(0.8)
            } else {
                Button(action: {
                    showingActions = true
                }) {
                    Image(systemName: "ellipsis.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            showingActions = true
        }
        .actionSheet(isPresented: $showingActions) {
            createActionSheet(for: device)
        }
    }
    
    private func createActionSheet(for device: SmartDevice) -> ActionSheet {
        var buttons: [ActionSheet.Button] = []
        
        switch device.deviceType {
        case .camera, .doorbell:
            buttons.append(.default(Text("📹 View Live Stream")) {
                performAction {
                    smartHomeManager.getLiveStream(for: device.id) { _ in }
                }
            })
            buttons.append(.default(Text("📸 Capture Snapshot")) {
                performAction {
                    smartHomeManager.captureSnapshot(for: device.id) { _, _ in }
                }
            })
            buttons.append(.default(Text("🔔 Toggle Motion Detection")) {
                performAction {
                    smartHomeManager.toggleMotionDetection(for: device.id) { _ in }
                }
            })
            
            if device.deviceType == .doorbell {
                buttons.append(.destructive(Text("🚨 Activate Siren")) {
                    performAction {
                        smartHomeManager.activateSiren(for: device.id) { _ in }
                    }
                })
            }
            
        case .motionSensor:
            buttons.append(.default(Text("🔔 Toggle Motion Detection")) {
                performAction {
                    smartHomeManager.toggleMotionDetection(for: device.id) { _ in }
                }
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
    
    private func performAction(_ action: @escaping () -> Void) {
        isLoading = true
        action()
        
        // Reset loading state after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isLoading = false
        }
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
    @State private var alerts: [MotionAlert] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            List {
                if isLoading {
                    HStack {
                        Spacer()
                        ProgressView("Loading alerts...")
                        Spacer()
                    }
                    .padding()
                } else if alerts.isEmpty {
                    HStack {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "bell.slash.circle")
                                .font(.system(size: 48))
                                .foregroundColor(.secondary)
                            Text("No Recent Alerts")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("Motion alerts will appear here")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 32)
                } else {
                    ForEach(alerts) { alert in
                        MotionAlertRow(alert: alert)
                    }
                }
            }
            .navigationTitle("Motion Alerts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        loadAllAlerts()
                    }
                }
            }
        }
        .onAppear {
            loadAllAlerts()
        }
    }
    
    private func loadAllAlerts() {
        isLoading = true
        let devices = smartHomeManager.getDevices()
        var allAlerts: [MotionAlert] = []
        let group = DispatchGroup()
        
        for device in devices {
            group.enter()
            smartHomeManager.getRecentMotionAlerts(for: device.id) { deviceAlerts in
                allAlerts.append(contentsOf: deviceAlerts)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.alerts = allAlerts.sorted { $0.timestamp > $1.timestamp }
            self.isLoading = false
        }
    }
}

struct MotionAlertRow: View {
    let alert: MotionAlert
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(alert.description)
                    .font(.headline)
                
                Text(timeAgoString)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    private var timeAgoString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter.localizedString(for: alert.timestamp, relativeTo: Date())
    }
}

#Preview {
    ContentView()
} 