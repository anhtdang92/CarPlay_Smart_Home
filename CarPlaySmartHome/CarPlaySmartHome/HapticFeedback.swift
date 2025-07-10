import UIKit
import CoreHaptics

// MARK: - Enhanced Haptic Feedback System

final class HapticFeedback {
    static let shared = HapticFeedback()
    
    // MARK: - Haptic Engine
    
    private var hapticEngine: CHHapticEngine?
    private var supportsHaptics: Bool = false
    
    // MARK: - Feedback Generators
    
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationFeedback = UINotificationFeedbackGenerator()
    private let selectionFeedback = UISelectionFeedbackGenerator()
    
    private init() {
        setupHapticEngine()
        prepareGenerators()
    }
    
    // MARK: - Setup
    
    private func setupHapticEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            supportsHaptics = false
            return
        }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
            supportsHaptics = true
            
            hapticEngine?.stoppedHandler = { [weak self] reason in
                logWarning("Haptic engine stopped: \(reason)", category: .ui)
                self?.restartEngine()
            }
            
            hapticEngine?.resetHandler = { [weak self] in
                logInfo("Haptic engine reset", category: .ui)
                self?.restartEngine()
            }
            
        } catch {
            supportsHaptics = false
            logError("Failed to create haptic engine: \(error.localizedDescription)", category: .error)
        }
    }
    
    private func prepareGenerators() {
        impactLight.prepare()
        impactMedium.prepare()
        impactHeavy.prepare()
        notificationFeedback.prepare()
        selectionFeedback.prepare()
    }
    
    private func restartEngine() {
        do {
            try hapticEngine?.start()
        } catch {
            logError("Failed to restart haptic engine: \(error.localizedDescription)", category: .error)
        }
    }
    
    // MARK: - Basic Haptic Feedback
    
    /// Light impact feedback for subtle interactions
    static func light() {
        shared.playLightImpact()
    }
    
    /// Medium impact feedback for standard button presses
    static func medium() {
        shared.playMediumImpact()
    }
    
    /// Heavy impact feedback for significant actions
    static func heavy() {
        shared.playHeavyImpact()
    }
    
    /// Selection feedback for navigation and picker changes
    static func selection() {
        shared.playSelection()
    }
    
    /// Success notification feedback
    static func success() {
        shared.playNotification(.success)
    }
    
    /// Warning notification feedback
    static func warning() {
        shared.playNotification(.warning)
    }
    
    /// Error notification feedback
    static func error() {
        shared.playNotification(.error)
    }
    
    // MARK: - Legacy Support
    
    /// Legacy method for backward compatibility
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        switch style {
        case .light:
            light()
        case .medium:
            medium()
        case .heavy:
            heavy()
        @unknown default:
            medium()
        }
    }
    
    // MARK: - Private Haptic Methods
    
    private func playLightImpact() {
        guard supportsHaptics else { return }
        impactLight.impactOccurred()
    }
    
    private func playMediumImpact() {
        guard supportsHaptics else { return }
        impactMedium.impactOccurred()
    }
    
    private func playHeavyImpact() {
        guard supportsHaptics else { return }
        impactHeavy.impactOccurred()
    }
    
    private func playSelection() {
        guard supportsHaptics else { return }
        selectionFeedback.selectionChanged()
    }
    
    private func playNotification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard supportsHaptics else { return }
        notificationFeedback.notificationOccurred(type)
    }
    
    // MARK: - Advanced Haptic Patterns
    
    /// Play a custom haptic pattern for device operations
    static func deviceOperation(success: Bool) {
        if success {
            shared.playCustomPattern(.deviceSuccess)
        } else {
            shared.playCustomPattern(.deviceError)
        }
    }
    
    /// Play haptic feedback for toggle actions
    static func toggle(isOn: Bool) {
        if isOn {
            shared.playCustomPattern(.toggleOn)
        } else {
            shared.playCustomPattern(.toggleOff)
        }
    }
    
    /// Play haptic feedback for long press gestures
    static func longPress() {
        shared.playCustomPattern(.longPress)
    }
    
    /// Play haptic feedback for swipe gestures
    static func swipe() {
        shared.playSelection()
    }
    
    /// Play haptic feedback for refresh actions
    static func refresh() {
        shared.playCustomPattern(.refresh)
    }
    
    /// Play haptic feedback for critical alerts
    static func criticalAlert() {
        shared.playCustomPattern(.criticalAlert)
    }
    
    /// Play haptic feedback for authentication success
    static func authenticationSuccess() {
        shared.playCustomPattern(.authSuccess)
    }
    
    /// Play haptic feedback for authentication failure
    static func authenticationFailure() {
        shared.playCustomPattern(.authFailure)
    }
    
    // MARK: - Custom Haptic Patterns
    
    private enum HapticPattern {
        case deviceSuccess
        case deviceError
        case toggleOn
        case toggleOff
        case longPress
        case refresh
        case criticalAlert
        case authSuccess
        case authFailure
        
        var events: [CHHapticEvent] {
            switch self {
            case .deviceSuccess:
                return createSuccessPattern()
            case .deviceError:
                return createErrorPattern()
            case .toggleOn:
                return createToggleOnPattern()
            case .toggleOff:
                return createToggleOffPattern()
            case .longPress:
                return createLongPressPattern()
            case .refresh:
                return createRefreshPattern()
            case .criticalAlert:
                return createCriticalAlertPattern()
            case .authSuccess:
                return createAuthSuccessPattern()
            case .authFailure:
                return createAuthFailurePattern()
            }
        }
        
        // MARK: - Pattern Implementations
        
        private func createSuccessPattern() -> [CHHapticEvent] {
            return [
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                ], relativeTime: 0),
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
                ], relativeTime: 0.1)
            ]
        }
        
        private func createErrorPattern() -> [CHHapticEvent] {
            return [
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
                ], relativeTime: 0),
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
                ], relativeTime: 0.05),
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
                ], relativeTime: 0.1)
            ]
        }
        
        private func createToggleOnPattern() -> [CHHapticEvent] {
            return [
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
                ], relativeTime: 0)
            ]
        }
        
        private func createToggleOffPattern() -> [CHHapticEvent] {
            return [
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
                ], relativeTime: 0)
            ]
        }
        
        private func createLongPressPattern() -> [CHHapticEvent] {
            return [
                CHHapticEvent(eventType: .hapticContinuous, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)
                ], relativeTime: 0, duration: 0.3)
            ]
        }
        
        private func createRefreshPattern() -> [CHHapticEvent] {
            return [
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
                ], relativeTime: 0),
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                ], relativeTime: 0.05),
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.9),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)
                ], relativeTime: 0.1)
            ]
        }
        
        private func createCriticalAlertPattern() -> [CHHapticEvent] {
            return [
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
                ], relativeTime: 0),
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
                ], relativeTime: 0.2),
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
                ], relativeTime: 0.4)
            ]
        }
        
        private func createAuthSuccessPattern() -> [CHHapticEvent] {
            return [
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
                ], relativeTime: 0),
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                ], relativeTime: 0.1),
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
                ], relativeTime: 0.2)
            ]
        }
        
        private func createAuthFailurePattern() -> [CHHapticEvent] {
            return [
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
                ], relativeTime: 0),
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)
                ], relativeTime: 0.1),
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
                ], relativeTime: 0.2)
            ]
        }
    }
    
    private func playCustomPattern(_ pattern: HapticPattern) {
        guard let hapticEngine = hapticEngine, supportsHaptics else {
            // Fallback to basic feedback
            switch pattern {
            case .deviceSuccess, .toggleOn, .authSuccess:
                playNotification(.success)
            case .deviceError, .authFailure:
                playNotification(.error)
            case .criticalAlert:
                playNotification(.error)
            case .toggleOff, .longPress, .refresh:
                playMediumImpact()
            }
            return
        }
        
        do {
            let hapticPattern = try CHHapticPattern(events: pattern.events, parameters: [])
            let player = try hapticEngine.makePlayer(with: hapticPattern)
            try player.start(atTime: 0)
        } catch {
            logError("Failed to play custom haptic pattern: \(error.localizedDescription)", category: .ui)
            // Fallback to basic feedback
            playMediumImpact()
        }
    }
    
    // MARK: - Accessibility Support
    
    /// Check if haptics are enabled in accessibility settings
    var isHapticsEnabled: Bool {
        return supportsHaptics && !UIAccessibility.isReduceMotionEnabled
    }
    
    /// Disable haptics for accessibility
    func disableHaptics() {
        supportsHaptics = false
        hapticEngine?.stop()
    }
    
    /// Enable haptics if supported
    func enableHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        setupHapticEngine()
    }
}