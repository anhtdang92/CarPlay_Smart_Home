# CarPlay Smart Home

An iOS app for CarPlay that provides a simple interface to control smart home devices from your car.

## Scope

This app aims to integrate with popular smart home ecosystems to allow users to perform common actions such as:
- Viewing security cameras (e.g., Ring)
- Controlling smart home devices (e.g., through Amazon Alexa)
- Opening/closing garage doors
- And more

The primary interface will be through Apple CarPlay for ease of use while in the car.

## Progress

- [X] Basic iOS application structure with SwiftUI.
- [X] CarPlay integration with a dynamic list of devices.
- [X] Mocked `SmartHomeManager` for managing device state.
- [X] Mocked `AuthenticationManager` to simulate user sign-in.
- [X] A basic phone UI that reflects the authentication and device status.
- [X] Placeholder integration with the Ring API, including a simulated OAuth flow.
- [ ] Live video stream view for cameras.
- [ ] Integration with other smart home platforms (e.g., Alexa).
