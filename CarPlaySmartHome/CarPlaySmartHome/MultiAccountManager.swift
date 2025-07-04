import Foundation
import SwiftUI

// MARK: - Multi-Account Manager
class MultiAccountManager: ObservableObject {
    @Published var accounts: [UserAccount] = []
    @Published var currentAccount: UserAccount?
    @Published var familyMembers: [FamilyMember] = []
    @Published var guestAccess: [GuestAccess] = []
    @Published var isFamilySharingEnabled = false
    
    init() {
        loadSampleData()
    }
    
    func addAccount(_ account: UserAccount) {
        accounts.append(account)
        if currentAccount == nil {
            currentAccount = account
        }
        saveAccounts()
    }
    
    func switchAccount(_ account: UserAccount) {
        currentAccount = account
        UserDefaults.standard.set(account.id, forKey: "currentAccountId")
    }
    
    func addFamilyMember(_ member: FamilyMember) {
        familyMembers.append(member)
        saveFamilyMembers()
    }
    
    func removeFamilyMember(_ member: FamilyMember) {
        familyMembers.removeAll { $0.id == member.id }
        saveFamilyMembers()
    }
    
    func addGuestAccess(_ access: GuestAccess) {
        guestAccess.append(access)
        saveGuestAccess()
    }
    
    func removeGuestAccess(_ access: GuestAccess) {
        guestAccess.removeAll { $0.id == access.id }
        saveGuestAccess()
    }
    
    private func loadSampleData() {
        // Load current account
        if let accountId = UserDefaults.standard.string(forKey: "currentAccountId") {
            // Load account from storage
        }
        
        // Sample accounts
        let sampleAccounts = [
            UserAccount(
                id: "1",
                name: "John Doe",
                email: "john@example.com",
                role: .owner,
                avatar: "👤",
                isActive: true
            ),
            UserAccount(
                id: "2",
                name: "Jane Smith",
                email: "jane@example.com",
                role: .admin,
                avatar: "👩",
                isActive: true
            )
        ]
        
        accounts = sampleAccounts
        currentAccount = sampleAccounts.first
        
        // Sample family members
        familyMembers = [
            FamilyMember(
                id: "1",
                name: "Sarah Doe",
                email: "sarah@example.com",
                relationship: .daughter,
                permissions: [.viewDevices, .viewAlerts],
                avatar: "👧"
            ),
            FamilyMember(
                id: "2",
                name: "Mike Doe",
                email: "mike@example.com",
                relationship: .son,
                permissions: [.viewDevices, .controlDevices, .viewAlerts],
                avatar: "👦"
            )
        ]
        
        // Sample guest access
        guestAccess = [
            GuestAccess(
                id: "1",
                name: "House Sitter",
                email: "sitter@example.com",
                accessLevel: .limited,
                devices: ["Front Door Camera", "Backyard Camera"],
                expiresAt: Date().addingTimeInterval(7 * 24 * 3600),
                avatar: "👷"
            )
        ]
    }
    
    private func saveAccounts() {
        if let data = try? JSONEncoder().encode(accounts) {
            UserDefaults.standard.set(data, forKey: "userAccounts")
        }
    }
    
    private func saveFamilyMembers() {
        if let data = try? JSONEncoder().encode(familyMembers) {
            UserDefaults.standard.set(data, forKey: "familyMembers")
        }
    }
    
    private func saveGuestAccess() {
        if let data = try? JSONEncoder().encode(guestAccess) {
            UserDefaults.standard.set(data, forKey: "guestAccess")
        }
    }
}

// MARK: - User Account Model
struct UserAccount: Identifiable, Codable {
    let id: String
    var name: String
    var email: String
    var role: UserRole
    var avatar: String
    var isActive: Bool
    var lastLogin: Date?
    var preferences: [String: String] = [:]
    
    enum UserRole: String, CaseIterable, Codable {
        case owner = "Owner"
        case admin = "Admin"
        case member = "Member"
        case guest = "Guest"
        
        var permissions: [Permission] {
            switch self {
            case .owner:
                return Permission.allCases
            case .admin:
                return [.viewDevices, .controlDevices, .viewAlerts, .manageAutomation, .manageUsers]
            case .member:
                return [.viewDevices, .controlDevices, .viewAlerts]
            case .guest:
                return [.viewDevices]
            }
        }
    }
}

// MARK: - Family Member Model
struct FamilyMember: Identifiable, Codable {
    let id: String
    var name: String
    var email: String
    var relationship: FamilyRelationship
    var permissions: [Permission]
    var avatar: String
    var isActive: Bool = true
    var lastActive: Date?
    
    enum FamilyRelationship: String, CaseIterable, Codable {
        case spouse = "Spouse"
        case child = "Child"
        case parent = "Parent"
        case sibling = "Sibling"
        case other = "Other"
    }
}

// MARK: - Guest Access Model
struct GuestAccess: Identifiable, Codable {
    let id: String
    var name: String
    var email: String
    var accessLevel: AccessLevel
    var devices: [String]
    var expiresAt: Date
    var avatar: String
    var isActive: Bool = true
    var lastUsed: Date?
    
    enum AccessLevel: String, CaseIterable, Codable {
        case viewOnly = "View Only"
        case limited = "Limited"
        case full = "Full Access"
        
        var permissions: [Permission] {
            switch self {
            case .viewOnly:
                return [.viewDevices]
            case .limited:
                return [.viewDevices, .viewAlerts]
            case .full:
                return [.viewDevices, .controlDevices, .viewAlerts]
            }
        }
    }
}

// MARK: - Permission Model
enum Permission: String, CaseIterable, Codable {
    case viewDevices = "View Devices"
    case controlDevices = "Control Devices"
    case viewAlerts = "View Alerts"
    case manageAutomation = "Manage Automation"
    case manageUsers = "Manage Users"
    case viewAnalytics = "View Analytics"
    case manageSettings = "Manage Settings"
    
    var icon: String {
        switch self {
        case .viewDevices: return "eye"
        case .controlDevices: return "slider.horizontal.3"
        case .viewAlerts: return "bell"
        case .manageAutomation: return "gearshape"
        case .manageUsers: return "person.2"
        case .viewAnalytics: return "chart.bar"
        case .manageSettings: return "gear"
        }
    }
    
    var description: String {
        switch self {
        case .viewDevices:
            return "Can view device status and information"
        case .controlDevices:
            return "Can control devices and change settings"
        case .viewAlerts:
            return "Can view motion alerts and notifications"
        case .manageAutomation:
            return "Can create and manage automation rules"
        case .manageUsers:
            return "Can add and remove family members"
        case .viewAnalytics:
            return "Can view usage analytics and insights"
        case .manageSettings:
            return "Can change app and system settings"
        }
    }
}

// MARK: - Multi-Account Views
struct MultiAccountView: View {
    @StateObject private var accountManager = MultiAccountManager()
    @State private var showingAddAccount = false
    @State private var showingAddFamilyMember = false
    @State private var showingAddGuest = false
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Current Account Header
                if let currentAccount = accountManager.currentAccount {
                    CurrentAccountHeader(account: currentAccount)
                }
                
                // Tab Selection
                Picker("View", selection: $selectedTab) {
                    Text("Accounts").tag(0)
                    Text("Family").tag(1)
                    Text("Guests").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Content
                TabView(selection: $selectedTab) {
                    AccountsTabView(accountManager: accountManager)
                        .tag(0)
                    
                    FamilyTabView(accountManager: accountManager)
                        .tag(1)
                    
                    GuestsTabView(accountManager: accountManager)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Multi-Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showingAddAccount = true }) {
                            Label("Add Account", systemImage: "person.badge.plus")
                        }
                        
                        Button(action: { showingAddFamilyMember = true }) {
                            Label("Add Family Member", systemImage: "person.2")
                        }
                        
                        Button(action: { showingAddGuest = true }) {
                            Label("Add Guest", systemImage: "person.badge.plus")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddAccount) {
                AddAccountView(accountManager: accountManager)
            }
            .sheet(isPresented: $showingAddFamilyMember) {
                AddFamilyMemberView(accountManager: accountManager)
            }
            .sheet(isPresented: $showingAddGuest) {
                AddGuestView(accountManager: accountManager)
            }
        }
    }
}

struct CurrentAccountHeader: View {
    let account: UserAccount
    
    var body: some View {
        HStack {
            Text(account.avatar)
                .font(.title)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(account.name)
                    .font(.headline)
                
                Text(account.role.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if account.isActive {
                Text("Active")
                    .font(.caption)
                    .foregroundColor(.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

struct AccountsTabView: View {
    @ObservedObject var accountManager: MultiAccountManager
    
    var body: some View {
        List {
            ForEach(accountManager.accounts) { account in
                AccountRow(
                    account: account,
                    isCurrent: accountManager.currentAccount?.id == account.id
                ) {
                    accountManager.switchAccount(account)
                }
            }
        }
    }
}

struct AccountRow: View {
    let account: UserAccount
    let isCurrent: Bool
    let onSwitch: () -> Void
    
    var body: some View {
        HStack {
            Text(account.avatar)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(account.name)
                    .font(.headline)
                
                Text(account.email)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(account.role.rawValue)
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            if isCurrent {
                Text("Current")
                    .font(.caption)
                    .foregroundColor(.green)
            } else {
                Button("Switch") {
                    onSwitch()
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
    }
}

struct FamilyTabView: View {
    @ObservedObject var accountManager: MultiAccountManager
    
    var body: some View {
        List {
            ForEach(accountManager.familyMembers) { member in
                FamilyMemberRow(member: member) {
                    accountManager.removeFamilyMember(member)
                }
            }
        }
    }
}

struct FamilyMemberRow: View {
    let member: FamilyMember
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            Text(member.avatar)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(member.name)
                    .font(.headline)
                
                Text(member.relationship.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("\(member.permissions.count) permissions")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
    }
}

struct GuestsTabView: View {
    @ObservedObject var accountManager: MultiAccountManager
    
    var body: some View {
        List {
            ForEach(accountManager.guestAccess) { guest in
                GuestAccessRow(guest: guest) {
                    accountManager.removeGuestAccess(guest)
                }
            }
        }
    }
}

struct GuestAccessRow: View {
    let guest: GuestAccess
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            Text(guest.avatar)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(guest.name)
                    .font(.headline)
                
                Text(guest.accessLevel.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Expires: \(guest.expiresAt, style: .date)")
                    .font(.caption2)
                    .foregroundColor(.orange)
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
    }
}

struct AddAccountView: View {
    @ObservedObject var accountManager: MultiAccountManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var email = ""
    @State private var role = UserAccount.UserRole.member
    @State private var avatar = "👤"
    
    let avatars = ["👤", "👩", "👨", "👧", "👦", "👴", "👵", "🧑"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account Details")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Role")) {
                    Picker("Role", selection: $role) {
                        ForEach(UserAccount.UserRole.allCases, id: \.self) { role in
                            Text(role.rawValue).tag(role)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Avatar")) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                        ForEach(avatars, id: \.self) { avatar in
                            Button(action: { self.avatar = avatar }) {
                                Text(avatar)
                                    .font(.title)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(self.avatar == avatar ? Color.blue.opacity(0.2) : Color.clear)
                                    )
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addAccount()
                    }
                    .disabled(name.isEmpty || email.isEmpty)
                }
            }
        }
    }
    
    private func addAccount() {
        let account = UserAccount(
            id: UUID().uuidString,
            name: name,
            email: email,
            role: role,
            avatar: avatar,
            isActive: true
        )
        
        accountManager.addAccount(account)
        dismiss()
    }
}

struct AddFamilyMemberView: View {
    @ObservedObject var accountManager: MultiAccountManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var email = ""
    @State private var relationship = FamilyMember.FamilyRelationship.child
    @State private var selectedPermissions: Set<Permission> = [.viewDevices, .viewAlerts]
    @State private var avatar = "👤"
    
    let avatars = ["👤", "👩", "👨", "👧", "👦", "👴", "👵", "🧑"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Family Member Details")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    Picker("Relationship", selection: $relationship) {
                        ForEach(FamilyMember.FamilyRelationship.allCases, id: \.self) { relationship in
                            Text(relationship.rawValue).tag(relationship)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Permissions")) {
                    ForEach(Permission.allCases, id: \.self) { permission in
                        HStack {
                            Image(systemName: permission.icon)
                                .foregroundColor(.blue)
                                .frame(width: 20)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(permission.rawValue)
                                    .font(.subheadline)
                                
                                Text(permission.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if selectedPermissions.contains(permission) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedPermissions.contains(permission) {
                                selectedPermissions.remove(permission)
                            } else {
                                selectedPermissions.insert(permission)
                            }
                        }
                    }
                }
                
                Section(header: Text("Avatar")) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                        ForEach(avatars, id: \.self) { avatar in
                            Button(action: { self.avatar = avatar }) {
                                Text(avatar)
                                    .font(.title)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(self.avatar == avatar ? Color.blue.opacity(0.2) : Color.clear)
                                    )
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Family Member")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addFamilyMember()
                    }
                    .disabled(name.isEmpty || email.isEmpty)
                }
            }
        }
    }
    
    private func addFamilyMember() {
        let member = FamilyMember(
            id: UUID().uuidString,
            name: name,
            email: email,
            relationship: relationship,
            permissions: Array(selectedPermissions),
            avatar: avatar
        )
        
        accountManager.addFamilyMember(member)
        dismiss()
    }
}

struct AddGuestView: View {
    @ObservedObject var accountManager: MultiAccountManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var email = ""
    @State private var accessLevel = GuestAccess.AccessLevel.limited
    @State private var selectedDevices: Set<String> = []
    @State private var expiresAt = Date().addingTimeInterval(7 * 24 * 3600)
    @State private var avatar = "👤"
    
    let avatars = ["👤", "👩", "👨", "👧", "👦", "👴", "👵", "🧑"]
    let sampleDevices = ["Front Door Camera", "Backyard Camera", "Motion Sensor", "Floodlight Camera"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Guest Details")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Access Level")) {
                    Picker("Access Level", selection: $accessLevel) {
                        ForEach(GuestAccess.AccessLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Access Expires")) {
                    DatePicker("Expires At", selection: $expiresAt, displayedComponents: [.date])
                }
                
                Section(header: Text("Select Devices")) {
                    ForEach(sampleDevices, id: \.self) { device in
                        HStack {
                            Text(device)
                            
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
                
                Section(header: Text("Avatar")) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                        ForEach(avatars, id: \.self) { avatar in
                            Button(action: { self.avatar = avatar }) {
                                Text(avatar)
                                    .font(.title)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(self.avatar == avatar ? Color.blue.opacity(0.2) : Color.clear)
                                    )
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Guest")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addGuest()
                    }
                    .disabled(name.isEmpty || email.isEmpty || selectedDevices.isEmpty)
                }
            }
        }
    }
    
    private func addGuest() {
        let guest = GuestAccess(
            id: UUID().uuidString,
            name: name,
            email: email,
            accessLevel: accessLevel,
            devices: Array(selectedDevices),
            expiresAt: expiresAt,
            avatar: avatar
        )
        
        accountManager.addGuestAccess(guest)
        dismiss()
    }
} 