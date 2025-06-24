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
            let listTemplate = createListTemplate()
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

    func createListTemplate() -> CPListTemplate {
        let devices = smartHomeManager.getDevices()
        var items: [CPListItem] = []

        for device in devices {
            let item = CPListItem(text: device.name, detailText: "\(device.status)")
            item.handler = { [weak self] item, completion in
                self?.smartHomeManager.toggleDevice(withId: device.id)
                self?.updateRootTemplate() // Refresh the list
                completion()
            }
            items.append(item)
        }

        let section = CPListSection(items: items)
        let listTemplate = CPListTemplate(title: "Smart Home", sections: [section])
        return listTemplate
    }
} 