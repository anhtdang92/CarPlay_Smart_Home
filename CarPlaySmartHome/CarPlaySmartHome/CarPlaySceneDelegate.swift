import CarPlay

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {

    var interfaceController: CPInterfaceController?
    private let smartHomeManager = SmartHomeManager.shared
    private let authManager = AuthenticationManager.shared

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene,
                                  didConnect interfaceController: CPInterfaceController) {
        // Called when CarPlay is connected.
        self.interfaceController = interfaceController
        updateRootTemplate()
    }

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene,
                                  didDisconnect interfaceController: CPInterfaceController) {
        // Called when CarPlay is disconnected.
        self.interfaceController = nil
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
            self?.authManager.signIn { success in
                if success {
                    self?.updateRootTemplate()
                }
            }
        }
        let alertTemplate = CPAlertTemplate(title: "Not Signed In", primaryAction: alertAction, secondaryActions: [])
        return alertTemplate
    }

    func createMainListTemplate() -> CPListTemplate {
        let devices = smartHomeManager.getDevices()
        var items: [CPListItem] = []

        // Add motion alerts section if any exist
        let motionAlertsItem = CPListItem(text: "Recent Motion Alerts", detailText: "View recent activity")
        motionAlertsItem.handler = { [weak self] item, completion in
            self?.showMotionAlertsTemplate()
            completion()
        }
        items.append(motionAlertsItem)

        // Group devices by type for better organization
        let cameras = devices.filter { $0.deviceType == .camera }
        let doorbells = devices.filter { $0.deviceType == .doorbell }
        let sensors = devices.filter { $0.deviceType == .motionSensor }

        // Add camera devices
        for device in cameras {
            let item = CPListItem(text: device.name, detailText: "Camera • \(device.status)")
            item.handler = { [weak self] item, completion in
                self?.showCameraActionSheet(for: device)
                completion()
            }
            items.append(item)
        }

        // Add doorbell devices
        for device in doorbells {
            let item = CPListItem(text: device.name, detailText: "Doorbell • \(device.status)")
            item.handler = { [weak self] item, completion in
                self?.showDoorbellActionSheet(for: device)
                completion()
            }
            items.append(item)
        }

        // Add sensor devices
        for device in sensors {
            let item = CPListItem(text: device.name, detailText: "Sensor • \(device.status)")
            item.handler = { [weak self] item, completion in
                self?.showSensorActionSheet(for: device)
                completion()
            }
            items.append(item)
        }

        let section = CPListSection(items: items)
        let listTemplate = CPListTemplate(title: "Ring Smart Home", sections: [section])
        return listTemplate
    }
    
    // MARK: - Ring Intervention Action Sheets
    
    func showCameraActionSheet(for device: SmartDevice) {
        let actions: [CPAlertAction] = [
            CPAlertAction(title: "View Live Stream", style: .default) { [weak self] _ in
                self?.startLiveStream(for: device)
            },
            CPAlertAction(title: "Capture Snapshot", style: .default) { [weak self] _ in
                self?.captureSnapshot(for: device)
            },
            CPAlertAction(title: "Toggle Motion Detection", style: .default) { [weak self] _ in
                self?.toggleMotionDetection(for: device)
            },
            CPAlertAction(title: "View Motion Alerts", style: .default) { [weak self] _ in
                self?.showDeviceMotionAlerts(for: device)
            },
            CPAlertAction(title: "Cancel", style: .cancel) { _ in }
        ]
        
        let actionSheet = CPActionSheetTemplate(title: device.name, message: "Choose an action", actions: actions)
        interfaceController?.presentTemplate(actionSheet, animated: true, completion: nil)
    }
    
    func showDoorbellActionSheet(for device: SmartDevice) {
        let actions: [CPAlertAction] = [
            CPAlertAction(title: "View Live Stream", style: .default) { [weak self] _ in
                self?.startLiveStream(for: device)
            },
            CPAlertAction(title: "Capture Snapshot", style: .default) { [weak self] _ in
                self?.captureSnapshot(for: device)
            },
            CPAlertAction(title: "Activate Siren", style: .destructive) { [weak self] _ in
                self?.activateSiren(for: device)
            },
            CPAlertAction(title: "Toggle Motion Detection", style: .default) { [weak self] _ in
                self?.toggleMotionDetection(for: device)
            },
            CPAlertAction(title: "Cancel", style: .cancel) { _ in }
        ]
        
        let actionSheet = CPActionSheetTemplate(title: device.name, message: "Choose an action", actions: actions)
        interfaceController?.presentTemplate(actionSheet, animated: true, completion: nil)
    }
    
    func showSensorActionSheet(for device: SmartDevice) {
        let actions: [CPAlertAction] = [
            CPAlertAction(title: "Toggle Motion Detection", style: .default) { [weak self] _ in
                self?.toggleMotionDetection(for: device)
            },
            CPAlertAction(title: "View Recent Alerts", style: .default) { [weak self] _ in
                self?.showDeviceMotionAlerts(for: device)
            },
            CPAlertAction(title: "Cancel", style: .cancel) { _ in }
        ]
        
        let actionSheet = CPActionSheetTemplate(title: device.name, message: "Choose an action", actions: actions)
        interfaceController?.presentTemplate(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Ring Intervention Actions
    
    func startLiveStream(for device: SmartDevice) {
        smartHomeManager.getLiveStream(for: device.id) { [weak self] url in
            DispatchQueue.main.async {
                if let url = url {
                    let alert = CPAlertTemplate(
                        title: "Live Stream Ready",
                        primaryAction: CPAlertAction(title: "OK", style: .default) { _ in
                            self?.interfaceController?.dismissTemplate(animated: true, completion: nil)
                        },
                        secondaryActions: []
                    )
                    self?.interfaceController?.presentTemplate(alert, animated: true, completion: nil)
                } else {
                    self?.showErrorAlert(message: "Unable to start live stream")
                }
            }
        }
    }
    
    func captureSnapshot(for device: SmartDevice) {
        smartHomeManager.captureSnapshot(for: device.id) { [weak self] success, url in
            DispatchQueue.main.async {
                if success {
                    let alert = CPAlertTemplate(
                        title: "Snapshot Captured",
                        primaryAction: CPAlertAction(title: "OK", style: .default) { _ in
                            self?.interfaceController?.dismissTemplate(animated: true, completion: nil)
                        },
                        secondaryActions: []
                    )
                    self?.interfaceController?.presentTemplate(alert, animated: true, completion: nil)
                } else {
                    self?.showErrorAlert(message: "Failed to capture snapshot")
                }
            }
        }
    }
    
    func toggleMotionDetection(for device: SmartDevice) {
        smartHomeManager.toggleMotionDetection(for: device.id) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    let alert = CPAlertTemplate(
                        title: "Motion Detection Updated",
                        primaryAction: CPAlertAction(title: "OK", style: .default) { _ in
                            self?.interfaceController?.dismissTemplate(animated: true, completion: nil)
                        },
                        secondaryActions: []
                    )
                    self?.interfaceController?.presentTemplate(alert, animated: true, completion: nil)
                } else {
                    self?.showErrorAlert(message: "Failed to update motion detection")
                }
            }
        }
    }
    
    func activateSiren(for device: SmartDevice) {
        smartHomeManager.activateSiren(for: device.id) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    let alert = CPAlertTemplate(
                        title: "Siren Activated",
                        primaryAction: CPAlertAction(title: "Deactivate", style: .destructive) { _ in
                            self?.smartHomeManager.deactivateSiren(for: device.id) { _ in
                                self?.interfaceController?.dismissTemplate(animated: true, completion: nil)
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
    
    // MARK: - Motion Alerts Templates
    
    func showMotionAlertsTemplate() {
        // Get all motion alerts from all devices
        let devices = smartHomeManager.getDevices()
        var allAlerts: [MotionAlert] = []
        let group = DispatchGroup()
        
        for device in devices {
            group.enter()
            smartHomeManager.getRecentMotionAlerts(for: device.id) { alerts in
                allAlerts.append(contentsOf: alerts)
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.presentMotionAlertsTemplate(alerts: allAlerts.sorted { $0.timestamp > $1.timestamp })
        }
    }
    
    func showDeviceMotionAlerts(for device: SmartDevice) {
        smartHomeManager.getRecentMotionAlerts(for: device.id) { [weak self] alerts in
            DispatchQueue.main.async {
                self?.presentMotionAlertsTemplate(alerts: alerts)
            }
        }
    }
    
    func presentMotionAlertsTemplate(alerts: [MotionAlert]) {
        var items: [CPListItem] = []
        
        if alerts.isEmpty {
            let item = CPListItem(text: "No Recent Alerts", detailText: "All quiet!")
            items.append(item)
        } else {
            for alert in alerts.prefix(10) { // Show max 10 alerts
                let formatter = DateFormatter()
                formatter.dateStyle = .none
                formatter.timeStyle = .short
                let timeString = formatter.string(from: alert.timestamp)
                
                let item = CPListItem(text: alert.description, detailText: timeString)
                items.append(item)
            }
        }
        
        let section = CPListSection(items: items)
        let alertsTemplate = CPListTemplate(title: "Motion Alerts", sections: [section])
        interfaceController?.pushTemplate(alertsTemplate, animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
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
} 