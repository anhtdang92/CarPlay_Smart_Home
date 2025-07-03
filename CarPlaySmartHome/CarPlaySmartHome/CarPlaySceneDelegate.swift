import CarPlay

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {

    var interfaceController: CPInterfaceController?
    private let smartHomeManager = SmartHomeManager.shared
    private let authManager = AuthenticationManager.shared
    private var isProcessingAction = false

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene,
                                  didConnect interfaceController: CPInterfaceController) {
        // Called when CarPlay is connected.
        self.interfaceController = interfaceController
        updateRootTemplate()
        
        // Setup real-time updates
        setupNotificationObservers()
    }

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene,
                                  didDisconnect interfaceController: CPInterfaceController) {
        // Called when CarPlay is disconnected.
        self.interfaceController = nil
        removeNotificationObservers()
    }

    func updateRootTemplate() {
        if authManager.isSignedIn() {
            let listTemplate = createMainListTemplate()
            interfaceController?.setRootTemplate(listTemplate, animated: true, completion: nil)
        } else {
            let alertTemplate = createLoginAlertTemplate()
            interfaceController?.setRootTemplate(alertTemplate, animated: true, completion: nil)
        }
    }

    func createLoginAlertTemplate() -> CPAlertTemplate {
        let alertAction = CPAlertAction(title: "Sign In", style: .default) { [weak self] _ in
            self?.performRingSignIn()
        }
        let alertTemplate = CPAlertTemplate(title: "Ring Smart Home", primaryAction: alertAction, secondaryActions: [])
        return alertTemplate
    }
    
    private func performRingSignIn() {
        RingAPIManager.shared.signInWithRing { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.updateRootTemplate()
                case .failure(let error):
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }

    func createMainListTemplate() -> CPListTemplate {
        let devices = smartHomeManager.getDevices()
        var items: [CPListItem] = []

        // Add system status item
        let statusItem = createSystemStatusItem()
        items.append(statusItem)

        // Add motion alerts section if any exist
        let alertsCount = smartHomeManager.getTotalActiveAlerts()
        let motionAlertsItem = CPListItem(
            text: "Recent Motion Alerts", 
            detailText: alertsCount > 0 ? "\(alertsCount) active alerts" : "No recent activity"
        )
        motionAlertsItem.handler = { [weak self] item, completion in
            self?.showMotionAlertsTemplate()
            completion()
        }
        items.append(motionAlertsItem)

        // Add quick actions section
        let quickActionsItem = CPListItem(text: "Quick Actions", detailText: "Bulk device controls")
        quickActionsItem.handler = { [weak self] item, completion in
            self?.showQuickActionsSheet()
            completion()
        }
        items.append(quickActionsItem)

        // Group devices by type for better organization
        let cameras = devices.filter { $0.deviceType == .camera }
        let doorbells = devices.filter { $0.deviceType == .doorbell }
        let sensors = devices.filter { $0.deviceType == .motionSensor }
        let floodlights = devices.filter { $0.deviceType == .floodlight }

        // Add camera devices
        for device in cameras {
            let item = createDeviceListItem(for: device, type: "Camera")
            items.append(item)
        }

        // Add doorbell devices
        for device in doorbells {
            let item = createDeviceListItem(for: device, type: "Doorbell")
            items.append(item)
        }

        // Add floodlight devices
        for device in floodlights {
            let item = createDeviceListItem(for: device, type: "Floodlight")
            items.append(item)
        }

        // Add sensor devices
        for device in sensors {
            let item = createDeviceListItem(for: device, type: "Sensor")
            items.append(item)
        }

        let section = CPListSection(items: items)
        let listTemplate = CPListTemplate(title: "Ring Smart Home", sections: [section])
        
        // Add refresh button
        let refreshButton = CPBarButton(type: .text) { [weak self] button in
            self?.refreshDevices()
        }
        refreshButton.title = "Refresh"
        listTemplate.trailingNavigationBarButtons = [refreshButton]
        
        return listTemplate
    }
    
    private func createSystemStatusItem() -> CPListItem {
        let lowBatteryDevices = smartHomeManager.getDevicesWithLowBattery()
        let offlineDevices = smartHomeManager.getOfflineDevices()
        
        var statusText = "System OK"
        var detailText = "All devices operational"
        
        if !lowBatteryDevices.isEmpty || !offlineDevices.isEmpty {
            statusText = "⚠️ Attention Needed"
            var issues: [String] = []
            if !lowBatteryDevices.isEmpty {
                issues.append("\(lowBatteryDevices.count) low battery")
            }
            if !offlineDevices.isEmpty {
                issues.append("\(offlineDevices.count) offline")
            }
            detailText = issues.joined(separator: ", ")
        }
        
        let item = CPListItem(text: statusText, detailText: detailText)
        item.handler = { [weak self] _, completion in
            self?.showSystemStatusTemplate()
            completion()
        }
        return item
    }
    
    private func createDeviceListItem(for device: SmartDevice, type: String) -> CPListItem {
        var detailComponents: [String] = [type]
        
        // Add battery info if available
        if let batteryLevel = device.batteryLevel {
            if batteryLevel <= 20 {
                detailComponents.append("🔋\(batteryLevel)%")
            } else if batteryLevel <= 50 {
                detailComponents.append("⚡\(batteryLevel)%")
            }
        }
        
        // Add status
        detailComponents.append(device.status.description)
        
        let item = CPListItem(text: device.name, detailText: detailComponents.joined(separator: " • "))
        item.handler = { [weak self] item, completion in
            self?.showDeviceActionSheet(for: device)
            completion()
        }
        return item
    }
    
    // MARK: - Quick Actions
    
    func showQuickActionsSheet() {
        let actions: [CPAlertAction] = [
            CPAlertAction(title: "📸 Capture All Snapshots", style: .default) { [weak self] _ in
                self?.captureAllSnapshots()
            },
            CPAlertAction(title: "🔔 Enable All Motion Detection", style: .default) { [weak self] _ in
                self?.enableAllMotionDetection()
            },
            CPAlertAction(title: "🔕 Disable All Motion Detection", style: .default) { [weak self] _ in
                self?.disableAllMotionDetection()
            },
            CPAlertAction(title: "🔄 Refresh All Devices", style: .default) { [weak self] _ in
                self?.refreshDevices()
            },
            CPAlertAction(title: "Cancel", style: .cancel) { _ in }
        ]
        
        let actionSheet = CPActionSheetTemplate(title: "Quick Actions", message: "Control multiple devices", actions: actions)
        interfaceController?.presentTemplate(actionSheet, animated: true, completion: nil)
    }
    
    private func captureAllSnapshots() {
        guard !isProcessingAction else { return }
        isProcessingAction = true
        
        showLoadingAlert(message: "Capturing snapshots from all cameras...")
        
        smartHomeManager.captureSnapshotsFromAllCameras { [weak self] snapshots, errors in
            DispatchQueue.main.async {
                self?.isProcessingAction = false
                self?.interfaceController?.dismissTemplate(animated: true) {
                    let successCount = snapshots.count
                    let errorCount = errors.count
                    let message = "Successfully captured \(successCount) snapshots" + 
                                 (errorCount > 0 ? ", \(errorCount) failed" : "")
                    self?.showSuccessAlert(message: message)
                }
            }
        }
    }
    
    private func enableAllMotionDetection() {
        guard !isProcessingAction else { return }
        isProcessingAction = true
        
        showLoadingAlert(message: "Enabling motion detection for all devices...")
        
        smartHomeManager.enableMotionDetectionForAllDevices { [weak self] success, total in
            DispatchQueue.main.async {
                self?.isProcessingAction = false
                self?.interfaceController?.dismissTemplate(animated: true) {
                    let message = "Enabled motion detection on \(success)/\(total) devices"
                    self?.showSuccessAlert(message: message)
                }
            }
        }
    }
    
    private func disableAllMotionDetection() {
        guard !isProcessingAction else { return }
        isProcessingAction = true
        
        showLoadingAlert(message: "Disabling motion detection for all devices...")
        
        smartHomeManager.disableMotionDetectionForAllDevices { [weak self] success, total in
            DispatchQueue.main.async {
                self?.isProcessingAction = false
                self?.interfaceController?.dismissTemplate(animated: true) {
                    let message = "Disabled motion detection on \(success)/\(total) devices"
                    self?.showSuccessAlert(message: message)
                }
            }
        }
    }
    
    private func refreshDevices() {
        smartHomeManager.refreshDevices()
        showSuccessAlert(message: "Refreshing device status...")
    }
    
    // MARK: - Ring Intervention Action Sheets
    
    func showDeviceActionSheet(for device: SmartDevice) {
        var actions: [CPAlertAction] = []
        
        switch device.deviceType {
        case .camera:
            actions = createCameraActions(for: device)
        case .doorbell:
            actions = createDoorbellActions(for: device)
        case .motionSensor:
            actions = createSensorActions(for: device)
        case .floodlight:
            actions = createFloodlightActions(for: device)
        default:
            actions = createGenericActions(for: device)
        }
        
        actions.append(CPAlertAction(title: "Cancel", style: .cancel) { _ in })
        
        let actionSheet = CPActionSheetTemplate(title: device.name, message: "Choose an action", actions: actions)
        interfaceController?.presentTemplate(actionSheet, animated: true, completion: nil)
    }
    
    private func createCameraActions(for device: SmartDevice) -> [CPAlertAction] {
        return [
            CPAlertAction(title: "📹 View Live Stream", style: .default) { [weak self] _ in
                self?.startLiveStream(for: device)
            },
            CPAlertAction(title: "📸 Capture Snapshot", style: .default) { [weak self] _ in
                self?.captureSnapshot(for: device)
            },
            CPAlertAction(title: "🔔 Toggle Motion Detection", style: .default) { [weak self] _ in
                self?.toggleMotionDetection(for: device)
            },
            CPAlertAction(title: "📋 View Motion Alerts", style: .default) { [weak self] _ in
                self?.showDeviceMotionAlerts(for: device)
            },
            CPAlertAction(title: "🔒 Toggle Privacy Mode", style: .default) { [weak self] _ in
                self?.togglePrivacyMode(for: device)
            }
        ]
    }
    
    private func createDoorbellActions(for device: SmartDevice) -> [CPAlertAction] {
        return [
            CPAlertAction(title: "📹 View Live Stream", style: .default) { [weak self] _ in
                self?.startLiveStream(for: device)
            },
            CPAlertAction(title: "📸 Capture Snapshot", style: .default) { [weak self] _ in
                self?.captureSnapshot(for: device)
            },
            CPAlertAction(title: "🚨 Activate Siren", style: .destructive) { [weak self] _ in
                self?.activateSiren(for: device)
            },
            CPAlertAction(title: "🔔 Toggle Motion Detection", style: .default) { [weak self] _ in
                self?.toggleMotionDetection(for: device)
            },
            CPAlertAction(title: "📋 View Motion Alerts", style: .default) { [weak self] _ in
                self?.showDeviceMotionAlerts(for: device)
            }
        ]
    }
    
    private func createFloodlightActions(for device: SmartDevice) -> [CPAlertAction] {
        return [
            CPAlertAction(title: "📹 View Live Stream", style: .default) { [weak self] _ in
                self?.startLiveStream(for: device)
            },
            CPAlertAction(title: "📸 Capture Snapshot", style: .default) { [weak self] _ in
                self?.captureSnapshot(for: device)
            },
            CPAlertAction(title: "💡 Toggle Light", style: .default) { [weak self] _ in
                self?.toggleFloodlight(for: device)
            },
            CPAlertAction(title: "🔔 Toggle Motion Detection", style: .default) { [weak self] _ in
                self?.toggleMotionDetection(for: device)
            }
        ]
    }
    
    private func createSensorActions(for device: SmartDevice) -> [CPAlertAction] {
        return [
            CPAlertAction(title: "🔔 Toggle Motion Detection", style: .default) { [weak self] _ in
                self?.toggleMotionDetection(for: device)
            },
            CPAlertAction(title: "📋 View Recent Alerts", style: .default) { [weak self] _ in
                self?.showDeviceMotionAlerts(for: device)
            },
            CPAlertAction(title: "📊 View Device Status", style: .default) { [weak self] _ in
                self?.showDeviceStatus(for: device)
            }
        ]
    }
    
    private func createGenericActions(for device: SmartDevice) -> [CPAlertAction] {
        return [
            CPAlertAction(title: "📊 View Device Status", style: .default) { [weak self] _ in
                self?.showDeviceStatus(for: device)
            }
        ]
    }
    
    // MARK: - Ring Intervention Actions
    
    func startLiveStream(for device: SmartDevice) {
        showLoadingAlert(message: "Starting live stream...")
        
        smartHomeManager.getLiveStream(for: device.id, quality: .high) { [weak self] result in
            DispatchQueue.main.async {
                self?.interfaceController?.dismissTemplate(animated: true) {
                    switch result {
                    case .success:
                        self?.showSuccessAlert(message: "Live stream ready in main app")
                    case .failure(let error):
                        self?.showErrorAlert(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func captureSnapshot(for device: SmartDevice) {
        showLoadingAlert(message: "Capturing snapshot...")
        
        smartHomeManager.captureSnapshot(for: device.id) { [weak self] result in
            DispatchQueue.main.async {
                self?.interfaceController?.dismissTemplate(animated: true) {
                    switch result {
                    case .success:
                        self?.showSuccessAlert(message: "Snapshot captured successfully")
                    case .failure(let error):
                        self?.showErrorAlert(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func toggleMotionDetection(for device: SmartDevice) {
        showLoadingAlert(message: "Updating motion detection...")
        
        smartHomeManager.toggleMotionDetection(for: device.id) { [weak self] success in
            DispatchQueue.main.async {
                self?.interfaceController?.dismissTemplate(animated: true) {
                    if success {
                        self?.showSuccessAlert(message: "Motion detection updated")
                    } else {
                        self?.showErrorAlert(message: "Failed to update motion detection")
                    }
                }
            }
        }
    }
    
    func togglePrivacyMode(for device: SmartDevice) {
        showLoadingAlert(message: "Toggling privacy mode...")
        
        smartHomeManager.setPrivacyMode(for: device.id, enabled: true) { [weak self] success in
            DispatchQueue.main.async {
                self?.interfaceController?.dismissTemplate(animated: true) {
                    if success {
                        self?.showSuccessAlert(message: "Privacy mode updated")
                    } else {
                        self?.showErrorAlert(message: "Failed to update privacy mode")
                    }
                }
            }
        }
    }
    
    func toggleFloodlight(for device: SmartDevice) {
        showLoadingAlert(message: "Toggling floodlight...")
        
        // For now, simulate floodlight toggle
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.interfaceController?.dismissTemplate(animated: true) {
                self?.showSuccessAlert(message: "Floodlight toggled")
            }
        }
    }
    
    func activateSiren(for device: SmartDevice) {
        let confirmAction = CPAlertAction(title: "Activate", style: .destructive) { [weak self] _ in
            self?.performSirenActivation(for: device)
        }
        
        let cancelAction = CPAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        let alert = CPAlertTemplate(
            title: "⚠️ Emergency Siren",
            primaryAction: confirmAction,
            secondaryActions: [cancelAction]
        )
        
        interfaceController?.presentTemplate(alert, animated: true, completion: nil)
    }
    
    private func performSirenActivation(for device: SmartDevice) {
        showLoadingAlert(message: "Activating emergency siren...")
        
        smartHomeManager.activateSiren(for: device.id, duration: 30) { [weak self] success in
            DispatchQueue.main.async {
                self?.interfaceController?.dismissTemplate(animated: true) {
                    if success {
                        let alert = CPAlertTemplate(
                            title: "🚨 Siren Activated",
                            primaryAction: CPAlertAction(title: "Deactivate Now", style: .destructive) { _ in
                                self?.smartHomeManager.deactivateSiren(for: device.id) { _ in
                                    self?.showSuccessAlert(message: "Siren deactivated")
                                }
                            },
                            secondaryActions: [
                                CPAlertAction(title: "Keep Active", style: .default) { _ in
                                    self?.interfaceController?.dismissTemplate(animated: true, completion: nil)
                                }
                            ]
                        )
                        self?.interfaceController?.presentTemplate(alert, animated: true, completion: nil)
                    } else {
                        self?.showErrorAlert(message: "Failed to activate siren")
                    }
                }
            }
        }
    }
    
    // MARK: - Device Status and Alerts
    
    func showDeviceStatus(for device: SmartDevice) {
        smartHomeManager.getDeviceStatus(for: device.id) { [weak self] status in
            DispatchQueue.main.async {
                self?.presentDeviceStatusTemplate(device: device, status: status)
            }
        }
    }
    
    private func presentDeviceStatusTemplate(device: SmartDevice, status: RingDeviceStatus?) {
        var items: [CPListItem] = []
        
        // Basic device info
        items.append(CPListItem(text: "Device Type", detailText: device.deviceType.rawValue))
        items.append(CPListItem(text: "Status", detailText: device.status.description))
        
        if let status = status {
            items.append(CPListItem(text: "Online", detailText: status.isOnline ? "Yes" : "No"))
            items.append(CPListItem(text: "Battery", detailText: "\(status.batteryLevel)%"))
            items.append(CPListItem(text: "Signal Strength", detailText: "\(status.signalStrength)/4 bars"))
            items.append(CPListItem(text: "Motion Detection", detailText: status.motionDetectionEnabled ? "Enabled" : "Disabled"))
            items.append(CPListItem(text: "Firmware", detailText: status.firmwareVersion))
            
            if let lastMotion = status.lastMotionTime {
                let formatter = RelativeDateTimeFormatter()
                formatter.dateTimeStyle = .named
                let timeString = formatter.localizedString(for: lastMotion, relativeTo: Date())
                items.append(CPListItem(text: "Last Motion", detailText: timeString))
            }
        }
        
        let section = CPListSection(items: items)
        let statusTemplate = CPListTemplate(title: device.name, sections: [section])
        interfaceController?.pushTemplate(statusTemplate, animated: true, completion: nil)
    }
    
    func showSystemStatusTemplate() {
        var items: [CPListItem] = []
        
        let lowBatteryDevices = smartHomeManager.getDevicesWithLowBattery()
        let offlineDevices = smartHomeManager.getOfflineDevices()
        let disabledDevices = smartHomeManager.getDevicesWithMotionDetectionDisabled()
        
        // System overview
        items.append(CPListItem(text: "Total Devices", detailText: "\(smartHomeManager.getDevices().count)"))
        items.append(CPListItem(text: "Active Alerts (1h)", detailText: "\(smartHomeManager.getTotalActiveAlerts())"))
        
        if !lowBatteryDevices.isEmpty {
            items.append(CPListItem(text: "⚠️ Low Battery", detailText: "\(lowBatteryDevices.count) devices"))
        }
        
        if !offlineDevices.isEmpty {
            items.append(CPListItem(text: "⚠️ Offline", detailText: "\(offlineDevices.count) devices"))
        }
        
        if !disabledDevices.isEmpty {
            items.append(CPListItem(text: "🔕 Motion Disabled", detailText: "\(disabledDevices.count) devices"))
        }
        
        if lowBatteryDevices.isEmpty && offlineDevices.isEmpty && disabledDevices.isEmpty {
            items.append(CPListItem(text: "✅ All Systems", detailText: "Operating normally"))
        }
        
        let section = CPListSection(items: items)
        let statusTemplate = CPListTemplate(title: "System Status", sections: [section])
        interfaceController?.pushTemplate(statusTemplate, animated: true, completion: nil)
    }
    
    // MARK: - Motion Alerts Templates
    
    func showMotionAlertsTemplate() {
        let alerts = smartHomeManager.recentMotionAlerts
        presentMotionAlertsTemplate(alerts: Array(alerts.prefix(15))) // Show max 15 alerts
    }
    
    func showDeviceMotionAlerts(for device: SmartDevice) {
        let alerts = smartHomeManager.getAlertsForDevice(device.id)
        presentMotionAlertsTemplate(alerts: Array(alerts.prefix(10)))
    }
    
    func presentMotionAlertsTemplate(alerts: [MotionAlert]) {
        var items: [CPListItem] = []
        
        if alerts.isEmpty {
            let item = CPListItem(text: "No Recent Alerts", detailText: "All quiet! 🌙")
            items.append(item)
        } else {
            for alert in alerts {
                let formatter = RelativeDateTimeFormatter()
                formatter.dateTimeStyle = .named
                let timeString = formatter.localizedString(for: alert.timestamp, relativeTo: Date())
                
                let confidenceText = alert.confidence > 0.8 ? " (High confidence)" : ""
                let item = CPListItem(text: alert.description + confidenceText, detailText: timeString)
                items.append(item)
            }
        }
        
        let section = CPListSection(items: items)
        let alertsTemplate = CPListTemplate(title: "Motion Alerts", sections: [section])
        interfaceController?.pushTemplate(alertsTemplate, animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    func showLoadingAlert(message: String) {
        let alert = CPAlertTemplate(title: "Processing...", primaryAction: nil, secondaryActions: [])
        interfaceController?.presentTemplate(alert, animated: true, completion: nil)
    }
    
    func showSuccessAlert(message: String) {
        let alert = CPAlertTemplate(
            title: "Success",
            primaryAction: CPAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.interfaceController?.dismissTemplate(animated: true, completion: nil)
            },
            secondaryActions: []
        )
        interfaceController?.presentTemplate(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(message: String) {
        let alert = CPAlertTemplate(
            title: "Error",
            primaryAction: CPAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.interfaceController?.dismissTemplate(animated: true, completion: nil)
            },
            secondaryActions: []
        )
        interfaceController?.presentTemplate(alert, animated: true, completion: nil)
    }
    
    // MARK: - Real-time Updates
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            forName: .ringMotionAlert,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            // Refresh the main template when new motion alerts arrive
            self?.updateRootTemplate()
        }
    }
    
    private func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self)
    }
} 