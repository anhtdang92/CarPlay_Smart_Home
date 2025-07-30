import SwiftUI
import UIKit

// MARK: - Enhanced Haptic Feedback System

struct HapticFeedback {
    
    // MARK: - Haptic Engine Management
    
    private static var engine: UIImpactFeedbackGenerator?
    private static var notificationEngine: UINotificationFeedbackGenerator?
    private static var selectionEngine: UISelectionFeedbackGenerator?
    
    // MARK: - Device-Specific Feedback Patterns
    
    enum DeviceFeedback {
        case camera
        case doorbell
        case sensor
        case light
        case lock
        case alarm
        case system
        case emergency
        
        var pattern: HapticPattern {
            switch self {
            case .camera:
                return HapticPattern(intensities: [0.7, 0.3, 0.5], intervals: [0.1, 0.2])
            case .doorbell:
                return HapticPattern(intensities: [0.9, 0.6, 0.8], intervals: [0.15, 0.1])
            case .sensor:
                return HapticPattern(intensities: [0.5, 0.4], intervals: [0.2])
            case .light:
                return HapticPattern(intensities: [0.6, 0.3], intervals: [0.1])
            case .lock:
                return HapticPattern(intensities: [0.8, 0.4, 0.6], intervals: [0.2, 0.1])
            case .alarm:
                return HapticPattern(intensities: [1.0, 0.7, 1.0, 0.7], intervals: [0.1, 0.1, 0.1])
            case .system:
                return HapticPattern(intensities: [0.6, 0.3], intervals: [0.15])
            case .emergency:
                return HapticPattern(intensities: [1.0, 0.8, 1.0, 0.8, 1.0], intervals: [0.08, 0.08, 0.08, 0.08])
            }
        }
    }
    
    // MARK: - Haptic Pattern Structure
    
    struct HapticPattern {
        let intensities: [CGFloat]
        let intervals: [TimeInterval]
        
        init(intensities: [CGFloat], intervals: [TimeInterval]) {
            self.intensities = intensities
            self.intervals = intervals
        }
    }
    
    // MARK: - Enhanced Feedback Methods
    
    static func deviceFeedback(for deviceType: DeviceFeedback) {
        let pattern = deviceType.pattern
        playPattern(pattern)
    }
    
    static func success() {
        notificationEngine?.notificationOccurred(.success)
    }
    
    static func warning() {
        notificationEngine?.notificationOccurred(.warning)
    }
    
    static func error() {
        notificationEngine?.notificationOccurred(.error)
    }
    
    static func selection() {
        selectionEngine?.selectionChanged()
    }
    
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        engine?.impactOccurred()
    }
    
    static func longPress() {
        impact(style: .heavy)
    }
    
    static func buttonPress() {
        impact(style: .light)
    }
    
    static func cardTap() {
        impact(style: .soft)
    }
    
    static func emergency() {
        playEmergencyPattern()
    }
    
    // MARK: - Advanced Pattern Playback
    
    private static func playPattern(_ pattern: HapticPattern) {
        guard !pattern.intensities.isEmpty else { return }
        
        for (index, intensity) in pattern.intensities.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + pattern.intervals.prefix(index).reduce(0, +)) {
                playIntensity(intensity)
            }
        }
    }
    
    private static func playIntensity(_ intensity: CGFloat) {
        let style: UIImpactFeedbackGenerator.FeedbackStyle
        switch intensity {
        case 0.0..<0.3:
            style = .soft
        case 0.3..<0.6:
            style = .light
        case 0.6..<0.8:
            style = .medium
        default:
            style = .heavy
        }
        
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred(intensity: intensity)
    }
    
    private static func playEmergencyPattern() {
        let emergencyPattern = HapticPattern(
            intensities: [1.0, 0.8, 1.0, 0.8, 1.0, 0.8],
            intervals: [0.1, 0.1, 0.1, 0.1, 0.1]
        )
        playPattern(emergencyPattern)
    }
    
    // MARK: - Contextual Feedback
    
    static func deviceActivation(for deviceType: RingDevice.DeviceType) {
        switch deviceType {
        case .camera:
            deviceFeedback(for: .camera)
        case .doorbell:
            deviceFeedback(for: .doorbell)
        case .sensor:
            deviceFeedback(for: .sensor)
        case .light:
            deviceFeedback(for: .light)
        case .lock:
            deviceFeedback(for: .lock)
        case .alarm:
            deviceFeedback(for: .alarm)
        default:
            deviceFeedback(for: .system)
        }
    }
    
    static func systemStatusChange(isOnline: Bool) {
        if isOnline {
            success()
        } else {
            warning()
        }
    }
    
    static func securityStateChange(isArmed: Bool) {
        if isArmed {
            deviceFeedback(for: .alarm)
        } else {
            deviceFeedback(for: .system)
        }
    }
    
    // MARK: - CarPlay-Specific Feedback
    
    static func carPlayNavigation() {
        impact(style: .light)
    }
    
    static func carPlaySelection() {
        selection()
    }
    
    static func carPlayEmergency() {
        emergency()
    }
    
    // MARK: - Performance Optimized Feedback
    
    private static var lastFeedbackTime: Date = Date()
    private static let minimumFeedbackInterval: TimeInterval = 0.1
    
    static func throttledFeedback(_ feedback: () -> Void) {
        let now = Date()
        if now.timeIntervalSince(lastFeedbackTime) >= minimumFeedbackInterval {
            feedback()
            lastFeedbackTime = now
        }
    }
    
    // MARK: - Accessibility-Aware Feedback
    
    static func accessibilityFeedback(for action: String) {
        // Respect user's haptic feedback preferences
        if UIAccessibility.isReduceMotionEnabled {
            // Minimal feedback for accessibility users
            impact(style: .soft)
        } else {
            // Full feedback for regular users
            switch action {
            case "select":
                selection()
            case "activate":
                impact(style: .medium)
            case "error":
                error()
            case "success":
                success()
            default:
                impact(style: .light)
            }
        }
    }
    
    // MARK: - Battery-Aware Feedback
    
    private static var batteryLevel: Float = 1.0
    
    static func setBatteryLevel(_ level: Float) {
        batteryLevel = level
    }
    
    static func batteryAwareFeedback(_ feedback: () -> Void) {
        // Reduce haptic intensity when battery is low
        if batteryLevel < 0.2 {
            // Minimal feedback to conserve battery
            impact(style: .soft)
        } else {
            feedback()
        }
    }
}

// MARK: - Haptic Feedback Modifiers

struct HapticFeedbackModifier: ViewModifier {
    let feedback: () -> Void
    let trigger: HapticTrigger
    
    enum HapticTrigger {
        case onTap
        case onLongPress
        case onAppear
        case onDisappear
    }
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                if trigger == .onTap {
                    feedback()
                }
            }
            .onLongPressGesture {
                if trigger == .onLongPress {
                    feedback()
                }
            }
            .onAppear {
                if trigger == .onAppear {
                    feedback()
                }
            }
            .onDisappear {
                if trigger == .onDisappear {
                    feedback()
                }
            }
    }
}

extension View {
    func hapticFeedback(_ feedback: @escaping () -> Void, trigger: HapticFeedbackModifier.HapticTrigger = .onTap) -> some View {
        modifier(HapticFeedbackModifier(feedback: feedback, trigger: trigger))
    }
    
    func deviceHapticFeedback(for deviceType: HapticFeedback.DeviceFeedback, trigger: HapticFeedbackModifier.HapticTrigger = .onTap) -> some View {
        hapticFeedback({
            HapticFeedback.deviceFeedback(for: deviceType)
        }, trigger: trigger)
    }
}