import Foundation
import HomeKit
import SwiftUI

// MARK: - HomeKit Integration Manager
class HomeKitIntegrationManager: ObservableObject {
    @Published var homeManager = HMHomeManager()
    @Published var homes: [HMHome] = []
    @Published var selectedHome: HMHome?
    @Published var accessories: [HMAccessory] = []
    @Published var isHomeKitAvailable = false
    @Published var bridgeStatus: BridgeStatus = .notConnected
    
    enum BridgeStatus: String, CaseIterable {
        case notConnected = "Not Connected"
        case connecting = "Connecting"
        case connected = "Connected"
        case error = "Error"
        
        var color: Color {
            switch self {
            case .notConnected: return .gray
            case .connecting: return .orange
            case .connected: return .green
            case .error: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .notConnected: return "link.badge.plus"
            case .connecting: return "clock"
            case .connected: return "checkmark.circle"
            case .error: return "exclamationmark.triangle"
            }
        }
    }
    
    init() {
        setupHomeKit()
    }
    
    private func setupHomeKit() {
        homeManager.delegate = self
        isHomeKitAvailable = homeManager.authorizationStatus == .authorized
        
        if isHomeKitAvailable {
            homes = homeManager.homes
            selectedHome = homeManager.primaryHome
            loadAccessories()
        }
    }
    
    func requestHomeKitPermission() {
        // HomeKit permission is requested when accessing homes
        _ = homeManager.homes
    }
    
    func selectHome(_ home: HMHome) {
        selectedHome = home
        loadAccessories()
    }
    
    func createHome(name: String, completion: @escaping (Bool) -> Void) {
        homeManager.addHome(withName: name) { [weak self] home, error in
            DispatchQueue.main.async {
                if let home = home {
                    self?.homes.append(home)
                    self?.selectedHome = home
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func addRingDeviceToHome(_ device: SmartDevice, completion: @escaping (Bool) -> Void) {
        guard let home = selectedHome else {
            completion(false)
            return
        }
        
        // Create a virtual accessory for the Ring device
        let accessoryName = device.name
        let accessoryType = mapDeviceTypeToHomeKit(device.type)
        
        // In a real implementation, you would create actual HomeKit accessories
        // For now, we'll simulate the process
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(true)
        }
    }
    
    private func mapDeviceTypeToHomeKit(_ deviceType: DeviceType) -> String {
        switch deviceType {
        case .camera:
            return "Camera"
        case .doorbell:
            return "Doorbell"
        case .motionSensor:
            return "Motion Sensor"
        case .floodlight:
            return "Light"
        case .chime:
            return "Speaker"
        }
    }
    
    private func loadAccessories() {
        guard let home = selectedHome else {
            accessories = []
            return
        }
        
        accessories = home.accessories
    }
    
    func bridgeRingToHomeKit() {
        bridgeStatus = .connecting
        
        // Simulate bridging process
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.bridgeStatus = .connected
        }
    }
    
    func disconnectBridge() {
        bridgeStatus = .notConnected
    }
}

// MARK: - HMHomeManager Delegate
extension HomeKitIntegrationManager: HMHomeManagerDelegate {
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        DispatchQueue.main.async {
            self.homes = manager.homes
            self.isHomeKitAvailable = manager.authorizationStatus == .authorized
            
            if self.selectedHome == nil {
                self.selectedHome = manager.primaryHome
            }
            
            self.loadAccessories()
        }
    }
    
    func homeManager(_ manager: HMHomeManager, didAdd home: HMHome) {
        DispatchQueue.main.async {
            self.homes.append(home)
        }
    }
    
    func homeManager(_ manager: HMHomeManager, didRemove home: HMHome) {
        DispatchQueue.main.async {
            self.homes.removeAll { $0 == home }
            if self.selectedHome == home {
                self.selectedHome = manager.primaryHome
            }
        }
    }
}

// MARK: - HomeKit Integration Views
struct HomeKitIntegrationView: View {
    @StateObject private var homeKitManager = HomeKitIntegrationManager()
    @State private var showingCreateHome = false
    @State private var showingAddDevice = false
    @State private var selectedDevice: SmartDevice?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Bridge Status
                BridgeStatusCard(homeKitManager: homeKitManager)
                
                // Home Selection
                if !homeKitManager.homes.isEmpty {
                    HomeSelectionView(homeKitManager: homeKitManager)
                }
                
                // Accessories List
                List {
                    Section(header: Text("HomeKit Accessories")) {
                        if homeKitManager.accessories.isEmpty {
                            Text("No accessories found")
                                .foregroundColor(.secondary)
                                .italic()
                        } else {
                            ForEach(homeKitManager.accessories, id: \.uniqueIdentifier) { accessory in
                                HomeKitAccessoryRow(accessory: accessory)
                            }
                        }
                    }
                    
                    Section(header: Text("Ring Devices")) {
                        ForEach(smartHomeManager.devices) { device in
                            RingDeviceRow(device: device) {
                                selectedDevice = device
                                showingAddDevice = true
                            }
                        }
                    }
                }
            }
            .navigationTitle("HomeKit Integration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showingCreateHome = true }) {
                            Label("Create Home", systemImage: "house")
                        }
                        
                        Button(action: { homeKitManager.bridgeRingToHomeKit() }) {
                            Label("Bridge Devices", systemImage: "link")
                        }
                        
                        Button(action: { homeKitManager.disconnectBridge() }) {
                            Label("Disconnect", systemImage: "link.badge.minus")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showingCreateHome) {
                CreateHomeView(homeKitManager: homeKitManager)
            }
            .sheet(isPresented: $showingAddDevice) {
                if let device = selectedDevice {
                    AddDeviceToHomeView(homeKitManager: homeKitManager, device: device)
                }
            }
        }
    }
}

struct BridgeStatusCard: View {
    @ObservedObject var homeKitManager: HomeKitIntegrationManager
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: homeKitManager.bridgeStatus.icon)
                    .foregroundColor(homeKitManager.bridgeStatus.color)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("HomeKit Bridge")
                        .font(.headline)
                    
                    Text(homeKitManager.bridgeStatus.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if homeKitManager.bridgeStatus == .connected {
                    Text("Connected")
                        .font(.caption)
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            if homeKitManager.bridgeStatus == .notConnected {
                Button(action: { homeKitManager.bridgeRingToHomeKit() }) {
                    Text("Connect to HomeKit")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal)
    }
}

struct HomeSelectionView: View {
    @ObservedObject var homeKitManager: HomeKitIntegrationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Home")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(homeKitManager.homes, id: \.uniqueIdentifier) { home in
                        HomeCard(
                            home: home,
                            isSelected: homeKitManager.selectedHome?.uniqueIdentifier == home.uniqueIdentifier,
                            onSelect: { homeKitManager.selectHome(home) }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
    }
}

struct HomeCard: View {
    let home: HMHome
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                Image(systemName: "house.fill")
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .blue)
                
                Text(home.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
                
                Text("\(home.accessories.count) accessories")
                    .font(.caption2)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
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

struct HomeKitAccessoryRow: View {
    let accessory: HMAccessory
    
    var body: some View {
        HStack {
            Image(systemName: "gearshape")
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(accessory.name)
                    .font(.headline)
                
                Text(accessory.manufacturer ?? "Unknown")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if accessory.reachable {
                Text("Online")
                    .font(.caption)
                    .foregroundColor(.green)
            } else {
                Text("Offline")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
    }
}

struct RingDeviceRow: View {
    let device: SmartDevice
    let onAdd: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: device.type.iconName)
                .foregroundColor(.orange)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(device.name)
                    .font(.headline)
                
                Text("Ring \(device.type.rawValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
        }
        .padding(.vertical, 4)
    }
}

struct CreateHomeView: View {
    @ObservedObject var homeKitManager: HomeKitIntegrationManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var homeName = ""
    @State private var isCreating = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Home Details")) {
                    TextField("Home Name", text: $homeName)
                }
                
                Section(header: Text("About HomeKit")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("HomeKit allows you to:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("• Control all smart home devices from one app")
                        Text("• Use Siri to control your devices")
                        Text("• Create automated scenes and routines")
                        Text("• Share access with family members")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Create Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        createHome()
                    }
                    .disabled(homeName.isEmpty || isCreating)
                }
            }
        }
    }
    
    private func createHome() {
        isCreating = true
        homeKitManager.createHome(name: homeName) { success in
            isCreating = false
            if success {
                dismiss()
            }
        }
    }
}

struct AddDeviceToHomeView: View {
    @ObservedObject var homeKitManager: HomeKitIntegrationManager
    let device: SmartDevice
    @Environment(\.dismiss) private var dismiss
    
    @State private var isAdding = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Device Info
                VStack(spacing: 12) {
                    Image(systemName: device.type.iconName)
                        .font(.system(size: 48))
                        .foregroundColor(.orange)
                    
                    Text(device.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Ring \(device.type.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // Integration Info
                VStack(alignment: .leading, spacing: 12) {
                    Text("HomeKit Integration")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("• Control this device with Siri")
                        Text("• Include in HomeKit scenes and automations")
                        Text("• Access from Apple Home app")
                        Text("• Share with family members")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                .padding(.horizontal)
                
                Spacer()
                
                // Add Button
                Button(action: addDevice) {
                    HStack {
                        if isAdding {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "plus")
                        }
                        
                        Text(isAdding ? "Adding..." : "Add to HomeKit")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isAdding ? Color.gray : Color.blue)
                    )
                }
                .disabled(isAdding)
                .padding(.horizontal)
            }
            .navigationTitle("Add Device")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func addDevice() {
        isAdding = true
        homeKitManager.addRingDeviceToHome(device) { success in
            isAdding = false
            if success {
                dismiss()
            }
        }
    }
} 