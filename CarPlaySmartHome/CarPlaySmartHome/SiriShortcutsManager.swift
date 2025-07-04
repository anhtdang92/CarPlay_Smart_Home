import Foundation
import Intents
import IntentsUI

// MARK: - Siri Shortcuts Manager
class SiriShortcutsManager: ObservableObject {
    @Published var availableShortcuts: [SiriShortcut] = []
    @Published var userShortcuts: [SiriShortcut] = []
    
    init() {
        loadSampleShortcuts()
        loadUserShortcuts()
    }
    
    func createShortcut(for action: ShortcutAction, device: SmartDevice? = nil) -> SiriShortcut {
        let shortcut = SiriShortcut(
            id: UUID().uuidString,
            title: action.title,
            subtitle: action.subtitle,
            intent: action.intent,
            device: device,
            category: action.category
        )
        return shortcut
    }
    
    func addUserShortcut(_ shortcut: SiriShortcut) {
        userShortcuts.append(shortcut)
        saveUserShortcuts()
    }
    
    func removeUserShortcut(_ shortcut: SiriShortcut) {
        userShortcuts.removeAll { $0.id == shortcut.id }
        saveUserShortcuts()
    }
    
    private func loadSampleShortcuts() {
        availableShortcuts = [
            SiriShortcut(
                id: "check_all_devices",
                title: "Check All Devices",
                subtitle: "Get status of all smart home devices",
                intent: .checkAllDevices,
                device: nil,
                category: .status
            ),
            SiriShortcut(
                id: "arm_security",
                title: "Arm Security System",
                subtitle: "Activate all security cameras and sensors",
                intent: .armSecurity,
                device: nil,
                category: .security
            ),
            SiriShortcut(
                id: "disarm_security",
                title: "Disarm Security System",
                subtitle: "Deactivate security system",
                intent: .disarmSecurity,
                device: nil,
                category: .security
            ),
            SiriShortcut(
                id: "emergency_siren",
                title: "Activate Emergency Siren",
                subtitle: "Trigger emergency siren immediately",
                intent: .emergencySiren,
                device: nil,
                category: .emergency
            ),
            SiriShortcut(
                id: "take_snapshot",
                title: "Take Snapshot",
                subtitle: "Capture image from all cameras",
                intent: .takeSnapshot,
                device: nil,
                category: .camera
            ),
            SiriShortcut(
                id: "check_battery",
                title: "Check Battery Levels",
                subtitle: "Get battery status of all devices",
                intent: .checkBattery,
                device: nil,
                category: .status
            )
        ]
    }
    
    private func loadUserShortcuts() {
        // Load from UserDefaults or Core Data
        if let data = UserDefaults.standard.data(forKey: "userShortcuts"),
           let shortcuts = try? JSONDecoder().decode([SiriShortcut].self, from: data) {
            userShortcuts = shortcuts
        }
    }
    
    private func saveUserShortcuts() {
        if let data = try? JSONEncoder().encode(userShortcuts) {
            UserDefaults.standard.set(data, forKey: "userShortcuts")
        }
    }
}

// MARK: - Siri Shortcut Model
struct SiriShortcut: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let intent: ShortcutAction
    let device: SmartDevice?
    let category: ShortcutCategory
    var isEnabled: Bool = true
    var customPhrase: String?
    
    enum ShortcutCategory: String, CaseIterable, Codable {
        case status = "Status"
        case security = "Security"
        case camera = "Camera"
        case emergency = "Emergency"
        case automation = "Automation"
        
        var icon: String {
            switch self {
            case .status: return "chart.bar"
            case .security: return "lock.shield"
            case .camera: return "camera"
            case .emergency: return "exclamationmark.triangle"
            case .automation: return "gearshape"
            }
        }
        
        var color: String {
            switch self {
            case .status: return "blue"
            case .security: return "green"
            case .camera: return "purple"
            case .emergency: return "red"
            case .automation: return "orange"
            }
        }
    }
}

// MARK: - Shortcut Actions
enum ShortcutAction: String, CaseIterable, Codable {
    case checkAllDevices = "Check All Devices"
    case armSecurity = "Arm Security"
    case disarmSecurity = "Disarm Security"
    case emergencySiren = "Emergency Siren"
    case takeSnapshot = "Take Snapshot"
    case checkBattery = "Check Battery"
    case toggleDevice = "Toggle Device"
    case startRecording = "Start Recording"
    case stopRecording = "Stop Recording"
    case checkMotion = "Check Motion"
    case customAction = "Custom Action"
    
    var title: String {
        return rawValue
    }
    
    var subtitle: String {
        switch self {
        case .checkAllDevices:
            return "Get status of all smart home devices"
        case .armSecurity:
            return "Activate all security cameras and sensors"
        case .disarmSecurity:
            return "Deactivate security system"
        case .emergencySiren:
            return "Trigger emergency siren immediately"
        case .takeSnapshot:
            return "Capture image from all cameras"
        case .checkBattery:
            return "Get battery status of all devices"
        case .toggleDevice:
            return "Turn device on or off"
        case .startRecording:
            return "Start video recording"
        case .stopRecording:
            return "Stop video recording"
        case .checkMotion:
            return "Check recent motion activity"
        case .customAction:
            return "Custom device action"
        }
    }
    
    var intent: String {
        switch self {
        case .checkAllDevices:
            return "Check all my smart home devices"
        case .armSecurity:
            return "Arm my security system"
        case .disarmSecurity:
            return "Disarm my security system"
        case .emergencySiren:
            return "Activate emergency siren"
        case .takeSnapshot:
            return "Take a snapshot from all cameras"
        case .checkBattery:
            return "Check battery levels of all devices"
        case .toggleDevice:
            return "Toggle device"
        case .startRecording:
            return "Start recording"
        case .stopRecording:
            return "Stop recording"
        case .checkMotion:
            return "Check motion activity"
        case .customAction:
            return "Perform custom action"
        }
    }
    
    var category: SiriShortcut.ShortcutCategory {
        switch self {
        case .checkAllDevices, .checkBattery, .checkMotion:
            return .status
        case .armSecurity, .disarmSecurity:
            return .security
        case .takeSnapshot, .startRecording, .stopRecording:
            return .camera
        case .emergencySiren:
            return .emergency
        case .toggleDevice, .customAction:
            return .automation
        }
    }
}

// MARK: - Siri Shortcuts View
struct SiriShortcutsView: View {
    @StateObject private var shortcutsManager = SiriShortcutsManager()
    @State private var selectedCategory: SiriShortcut.ShortcutCategory?
    @State private var showingAddShortcut = false
    
    var filteredShortcuts: [SiriShortcut] {
        if let category = selectedCategory {
            return shortcutsManager.availableShortcuts.filter { $0.category == category }
        }
        return shortcutsManager.availableShortcuts
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryFilterChip(
                            title: "All",
                            isSelected: selectedCategory == nil,
                            onTap: { selectedCategory = nil }
                        )
                        
                        ForEach(SiriShortcut.ShortcutCategory.allCases, id: \.self) { category in
                            CategoryFilterChip(
                                title: category.rawValue,
                                isSelected: selectedCategory == category,
                                onTap: { selectedCategory = category }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // Shortcuts List
                List {
                    Section(header: Text("Available Shortcuts")) {
                        ForEach(filteredShortcuts) { shortcut in
                            SiriShortcutRow(shortcut: shortcut) {
                                addShortcutToSiri(shortcut)
                            }
                        }
                    }
                    
                    if !shortcutsManager.userShortcuts.isEmpty {
                        Section(header: Text("My Shortcuts")) {
                            ForEach(shortcutsManager.userShortcuts) { shortcut in
                                UserShortcutRow(shortcut: shortcut) {
                                    shortcutsManager.removeUserShortcut(shortcut)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Siri Shortcuts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Custom") {
                        showingAddShortcut = true
                    }
                }
            }
            .sheet(isPresented: $showingAddShortcut) {
                AddCustomShortcutView(shortcutsManager: shortcutsManager)
            }
        }
    }
    
    private func addShortcutToSiri(_ shortcut: SiriShortcut) {
        // Implementation for adding shortcut to Siri
        shortcutsManager.addUserShortcut(shortcut)
    }
}

struct CategoryFilterChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? Color.blue : Color(.systemGray5))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SiriShortcutRow: View {
    let shortcut: SiriShortcut
    let onAdd: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: shortcut.category.icon)
                .foregroundColor(Color(shortcut.category.color))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(shortcut.title)
                    .font(.headline)
                
                Text(shortcut.subtitle)
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

struct UserShortcutRow: View {
    let shortcut: SiriShortcut
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: shortcut.category.icon)
                .foregroundColor(Color(shortcut.category.color))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(shortcut.title)
                    .font(.headline)
                
                if let phrase = shortcut.customPhrase {
                    Text("\"\(phrase)\"")
                        .font(.caption)
                        .foregroundColor(.blue)
                } else {
                    Text(shortcut.subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
                    .font(.title2)
            }
        }
        .padding(.vertical, 4)
    }
}

struct AddCustomShortcutView: View {
    @ObservedObject var shortcutsManager: SiriShortcutsManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var shortcutTitle = ""
    @State private var shortcutSubtitle = ""
    @State private var customPhrase = ""
    @State private var selectedCategory = SiriShortcut.ShortcutCategory.automation
    @State private var selectedAction = ShortcutAction.customAction
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Shortcut Details")) {
                    TextField("Shortcut Title", text: $shortcutTitle)
                    TextField("Description", text: $shortcutSubtitle)
                    TextField("Custom Phrase", text: $customPhrase, placeholder: "Hey Siri, ...")
                }
                
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(SiriShortcut.ShortcutCategory.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                Text(category.rawValue)
                            }
                            .tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Action")) {
                    Picker("Action", selection: $selectedAction) {
                        ForEach(ShortcutAction.allCases, id: \.self) { action in
                            Text(action.title).tag(action)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .navigationTitle("Add Custom Shortcut")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveCustomShortcut()
                    }
                    .disabled(shortcutTitle.isEmpty)
                }
            }
        }
    }
    
    private func saveCustomShortcut() {
        let customShortcut = SiriShortcut(
            id: UUID().uuidString,
            title: shortcutTitle,
            subtitle: shortcutSubtitle.isEmpty ? selectedAction.subtitle : shortcutSubtitle,
            intent: selectedAction,
            device: nil,
            category: selectedCategory,
            customPhrase: customPhrase.isEmpty ? nil : customPhrase
        )
        
        shortcutsManager.addUserShortcut(customShortcut)
        dismiss()
    }
} 