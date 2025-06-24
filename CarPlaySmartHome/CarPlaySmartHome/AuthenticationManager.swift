import Foundation
import Combine

class AuthenticationManager: ObservableObject {

    static let shared = AuthenticationManager()

    @Published private(set) var isAuthenticated: Bool = false

    private init() {}

    func isSignedIn() -> Bool {
        return isAuthenticated
    }

    func signIn(completion: @escaping (Bool) -> Void) {
        // Simulate a network request for signing in
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isAuthenticated = true
            print("User signed in successfully.")
            completion(true)
        }
    }

    func signOut() {
        isAuthenticated = false
        print("User signed out.")
    }
} 