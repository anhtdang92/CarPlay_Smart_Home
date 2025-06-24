import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @StateObject private var smartHomeManager = SmartHomeManager.shared

    var body: some View {
        if authManager.isAuthenticated {
            DeviceListView(smartHomeManager: smartHomeManager)
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
            Text("CarPlay Smart Home")
                .font(.largeTitle)
                .padding()

            if isSigningIn {
                ProgressView()
            } else {
                Button(action: {
                    isSigningIn = true
                    RingAPIManager.shared.signInWithRing { success in
                        // The authManager's state will be updated internally
                        // and the view will switch automatically.
                        if !success {
                            isSigningIn = false // Only reset if sign-in fails
                        }
                    }
                }) {
                    Text("Sign In with Ring")
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                Button(action: {
                    isSigningIn = true
                    authManager.signIn { success in
                        if !success {
                           isSigningIn = false
                        }
                    }
                }) {
                    Text("Generic Sign In")
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct DeviceListView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager

    var body: some View {
        NavigationView {
            List(smartHomeManager.devices) { device in
                HStack {
                    Text(device.name)
                    Spacer()
                    Text(device.status.description)
                    Button(action: {
                        smartHomeManager.toggleDevice(withId: device.id)
                    }) {
                        Image(systemName: "power.circle.fill")
                            .foregroundColor(device.status == .on || device.status == .open ? .green : .red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .navigationTitle("My Smart Home")
            .toolbar {
                Button("Sign Out") {
                    AuthenticationManager.shared.signOut()
                }
            }
        }
    }
}

#Preview {
    ContentView()
} 