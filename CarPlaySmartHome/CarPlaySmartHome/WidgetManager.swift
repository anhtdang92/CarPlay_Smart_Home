import Foundation
import WidgetKit
import SwiftUI

// MARK: - Widget Manager
class WidgetManager: ObservableObject {
    @Published var availableWidgets: [HomeWidget] = []
    @Published var userWidgets: [HomeWidget] = []
    
    init() {
        loadSampleWidgets()
        loadUserWidgets()
    }
    
    func createWidget(type: WidgetType, devices: [SmartDevice] = []) -> HomeWidget {
        let widget = HomeWidget(
            id: UUID().uuidString,
            name: type.defaultName,
            type: type,
            devices: devices,
            refreshInterval: type.defaultRefreshInterval,
            isEnabled: true
        )
        return widget
    }
    
    func addUserWidget(_ widget: HomeWidget) {
        userWidgets.append(widget)
        saveUserWidgets()
        updateWidgets()
    }
    
    func removeUserWidget(_ widget: HomeWidget) {
        userWidgets.removeAll { $0.id == widget.id }
        saveUserWidgets()
        updateWidgets()
    }
    
    func updateWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func loadSampleWidgets() {
        availableWidgets = [
            HomeWidget(
                id: "device_status",
                name: "Device Status",
                type: .deviceStatus,
                devices: [],
                refreshInterval: 300,
                isEnabled: true
            ),
            HomeWidget(
                id: "security_overview",
                name: "Security Overview",
                type: .securityOverview,
                devices: [],
                refreshInterval: 60,
                isEnabled: true
            ),
            HomeWidget(
                id: "quick_actions",
                name: "Quick Actions",
                type: .quickActions,
                devices: [],
                refreshInterval: 0,
                isEnabled: true
            ),
            HomeWidget(
                id: "battery_monitor",
                name: "Battery Monitor",
                type: .batteryMonitor,
                devices: [],
                refreshInterval: 600,
                isEnabled: true
            ),
            HomeWidget(
                id: "motion_alerts",
                name: "Motion Alerts",
                type: .motionAlerts,
                devices: [],
                refreshInterval: 120,
                isEnabled: true
            )
        ]
    }
    
    private func loadUserWidgets() {
        if let data = UserDefaults.standard.data(forKey: "userWidgets"),
           let widgets = try? JSONDecoder().decode([HomeWidget].self, from: data) {
            userWidgets = widgets
        }
    }
    
    private func saveUserWidgets() {
        if let data = try? JSONEncoder().encode(userWidgets) {
            UserDefaults.standard.set(data, forKey: "userWidgets")
        }
    }
}

// MARK: - Widget Models
struct HomeWidget: Identifiable, Codable {
    let id: String
    var name: String
    let type: WidgetType
    var devices: [SmartDevice]
    var refreshInterval: TimeInterval
    var isEnabled: Bool
    var customSettings: [String: String] = [:]
    
    enum WidgetType: String, CaseIterable, Codable {
        case deviceStatus = "Device Status"
        case securityOverview = "Security Overview"
        case quickActions = "Quick Actions"
        case batteryMonitor = "Battery Monitor"
        case motionAlerts = "Motion Alerts"
        case energyUsage = "Energy Usage"
        case customWidget = "Custom Widget"
        
        var icon: String {
            switch self {
            case .deviceStatus: return "chart.bar"
            case .securityOverview: return "lock.shield"
            case .quickActions: return "bolt"
            case .batteryMonitor: return "battery.100"
            case .motionAlerts: return "bell"
            case .energyUsage: return "bolt.circle"
            case .customWidget: return "gearshape"
            }
        }
        
        var color: String {
            switch self {
            case .deviceStatus: return "blue"
            case .securityOverview: return "green"
            case .quickActions: return "orange"
            case .batteryMonitor: return "yellow"
            case .motionAlerts: return "red"
            case .energyUsage: return "purple"
            case .customWidget: return "gray"
            }
        }
        
        var defaultName: String {
            return rawValue
        }
        
        var defaultRefreshInterval: TimeInterval {
            switch self {
            case .deviceStatus: return 300 // 5 minutes
            case .securityOverview: return 60 // 1 minute
            case .quickActions: return 0 // No refresh needed
            case .batteryMonitor: return 600 // 10 minutes
            case .motionAlerts: return 120 // 2 minutes
            case .energyUsage: return 900 // 15 minutes
            case .customWidget: return 300
            }
        }
        
        var description: String {
            switch self {
            case .deviceStatus:
                return "Shows status of all devices with online/offline indicators"
            case .securityOverview:
                return "Displays security system status and recent alerts"
            case .quickActions:
                return "Provides quick access to common device actions"
            case .batteryMonitor:
                return "Monitors battery levels across all devices"
            case .motionAlerts:
                return "Shows recent motion alerts and activity"
            case .energyUsage:
                return "Displays energy consumption and cost data"
            case .customWidget:
                return "Customizable widget with user-defined content"
            }
        }
    }
}

// MARK: - Widget Views
struct WidgetsView: View {
    @StateObject private var widgetManager = WidgetManager()
    @State private var showingAddWidget = false
    @State private var selectedWidget: HomeWidget?
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("My Widgets")) {
                    if widgetManager.userWidgets.isEmpty {
                        Text("No widgets added yet")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(widgetManager.userWidgets) { widget in
                            UserWidgetRow(widget: widget) {
                                selectedWidget = widget
                            }
                        }
                        .onDelete(perform: deleteWidgets)
                    }
                }
                
                Section(header: Text("Available Widgets")) {
                    ForEach(widgetManager.availableWidgets) { widget in
                        AvailableWidgetRow(widget: widget) {
                            addWidget(widget)
                        }
                    }
                }
            }
            .navigationTitle("Home Screen Widgets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Widget") {
                        showingAddWidget = true
                    }
                }
            }
            .sheet(isPresented: $showingAddWidget) {
                AddWidgetView(widgetManager: widgetManager)
            }
            .sheet(item: $selectedWidget) { widget in
                WidgetSettingsView(widget: widget, widgetManager: widgetManager)
            }
        }
    }
    
    private func addWidget(_ widget: HomeWidget) {
        widgetManager.addUserWidget(widget)
    }
    
    private func deleteWidgets(offsets: IndexSet) {
        for index in offsets {
            let widget = widgetManager.userWidgets[index]
            widgetManager.removeUserWidget(widget)
        }
    }
}

struct UserWidgetRow: View {
    let widget: HomeWidget
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: widget.type.icon)
                    .foregroundColor(Color(widget.type.color))
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(widget.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(widget.type.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("Refresh: \(formatRefreshInterval(widget.refreshInterval))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if widget.isEnabled {
                            Text("Active")
                                .font(.caption2)
                                .foregroundColor(.green)
                        } else {
                            Text("Inactive")
                                .font(.caption2)
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatRefreshInterval(_ interval: TimeInterval) -> String {
        switch interval {
        case 0:
            return "Manual"
        case 1..<60:
            return "\(Int(interval))s"
        case 60..<3600:
            return "\(Int(interval/60))m"
        default:
            return "\(Int(interval/3600))h"
        }
    }
}

struct AvailableWidgetRow: View {
    let widget: HomeWidget
    let onAdd: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: widget.type.icon)
                .foregroundColor(Color(widget.type.color))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(widget.name)
                    .font(.headline)
                
                Text(widget.type.description)
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

struct AddWidgetView: View {
    @ObservedObject var widgetManager: WidgetManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedType = HomeWidget.WidgetType.deviceStatus
    @State private var widgetName = ""
    @State private var selectedDevices: Set<SmartDevice> = []
    @State private var refreshInterval: TimeInterval = 300
    
    let sampleDevices = [
        SmartDevice(id: "1", name: "Front Door Camera", type: .camera, location: "Front Door", isOnline: true, batteryLevel: 85, signalStrength: 90, lastActivity: Date()),
        SmartDevice(id: "2", name: "Backyard Camera", type: .camera, location: "Backyard", isOnline: true, batteryLevel: 72, signalStrength: 85, lastActivity: Date()),
        SmartDevice(id: "3", name: "Motion Sensor", type: .motionSensor, location: "Living Room", isOnline: true, batteryLevel: 95, signalStrength: 92, lastActivity: Date())
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Widget Type")) {
                    Picker("Type", selection: $selectedType) {
                        ForEach(HomeWidget.WidgetType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: type.icon)
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedType) { newType in
                        if widgetName.isEmpty {
                            widgetName = newType.defaultName
                        }
                        refreshInterval = newType.defaultRefreshInterval
                    }
                }
                
                Section(header: Text("Widget Details")) {
                    TextField("Widget Name", text: $widgetName)
                    
                    Picker("Refresh Interval", selection: $refreshInterval) {
                        Text("Manual").tag(TimeInterval(0))
                        Text("30 seconds").tag(TimeInterval(30))
                        Text("1 minute").tag(TimeInterval(60))
                        Text("5 minutes").tag(TimeInterval(300))
                        Text("15 minutes").tag(TimeInterval(900))
                        Text("1 hour").tag(TimeInterval(3600))
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Select Devices")) {
                    ForEach(sampleDevices) { device in
                        HStack {
                            Image(systemName: device.type.iconName)
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(device.name)
                                    .font(.subheadline)
                                
                                Text(device.location)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if selectedDevices.contains(device) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedDevices.contains(device) {
                                selectedDevices.remove(device)
                            } else {
                                selectedDevices.insert(device)
                            }
                        }
                    }
                }
                
                Section(header: Text("Preview")) {
                    WidgetPreviewCard(
                        type: selectedType,
                        name: widgetName.isEmpty ? selectedType.defaultName : widgetName,
                        deviceCount: selectedDevices.count
                    )
                }
            }
            .navigationTitle("Add Widget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addWidget()
                    }
                    .disabled(widgetName.isEmpty)
                }
            }
        }
    }
    
    private func addWidget() {
        let newWidget = HomeWidget(
            id: UUID().uuidString,
            name: widgetName,
            type: selectedType,
            devices: Array(selectedDevices),
            refreshInterval: refreshInterval,
            isEnabled: true
        )
        
        widgetManager.addUserWidget(newWidget)
        dismiss()
    }
}

struct WidgetPreviewCard: View {
    let type: HomeWidget.WidgetType
    let name: String
    let deviceCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: type.icon)
                    .foregroundColor(Color(type.color))
                
                Text(name)
                    .font(.headline)
                
                Spacer()
                
                Text("\(deviceCount) devices")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(type.description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct WidgetSettingsView: View {
    let widget: HomeWidget
    @ObservedObject var widgetManager: WidgetManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var widgetName: String
    @State private var isEnabled: Bool
    @State private var refreshInterval: TimeInterval
    
    init(widget: HomeWidget, widgetManager: WidgetManager) {
        self.widget = widget
        self.widgetManager = widgetManager
        self._widgetName = State(initialValue: widget.name)
        self._isEnabled = State(initialValue: widget.isEnabled)
        self._refreshInterval = State(initialValue: widget.refreshInterval)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Widget Settings")) {
                    TextField("Widget Name", text: $widgetName)
                    
                    Toggle("Enable Widget", isOn: $isEnabled)
                    
                    Picker("Refresh Interval", selection: $refreshInterval) {
                        Text("Manual").tag(TimeInterval(0))
                        Text("30 seconds").tag(TimeInterval(30))
                        Text("1 minute").tag(TimeInterval(60))
                        Text("5 minutes").tag(TimeInterval(300))
                        Text("15 minutes").tag(TimeInterval(900))
                        Text("1 hour").tag(TimeInterval(3600))
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Widget Info")) {
                    HStack {
                        Text("Type")
                        Spacer()
                        Text(widget.type.rawValue)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Devices")
                        Spacer()
                        Text("\(widget.devices.count)")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Button("Remove Widget") {
                        widgetManager.removeUserWidget(widget)
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Widget Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSettings()
                    }
                }
            }
        }
    }
    
    private func saveSettings() {
        // Update widget settings
        var updatedWidget = widget
        updatedWidget.name = widgetName
        updatedWidget.isEnabled = isEnabled
        updatedWidget.refreshInterval = refreshInterval
        
        // Remove old widget and add updated one
        widgetManager.removeUserWidget(widget)
        widgetManager.addUserWidget(updatedWidget)
        
        dismiss()
    }
} 