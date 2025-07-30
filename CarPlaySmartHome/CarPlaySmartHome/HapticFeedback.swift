import SwiftUI
import UIKit

// MARK: - Enhanced Haptic Feedback System

struct HapticFeedback {
    
    // MARK: - Haptic Engine Management
    
    private static var engine: UIImpactFeedbackGenerator?
    private static var notificationEngine: UINotificationFeedbackGenerator?
    private static var selectionEngine: UISelectionFeedbackGenerator?
    
    // MARK: - Enhanced Device-Specific Feedback Patterns
    
    enum DeviceFeedback {
        case camera
        case doorbell
        case sensor
        case light
        case lock
        case alarm
        case system
        case emergency
        case success
        case warning
        case error
        case notification
        case selection
        case impact
        case longPress
        case buttonPress
        case cardTap
        case navigation
        case transition
        case loading
        case completion
        
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
            case .success:
                return HapticPattern(intensities: [0.8, 0.4], intervals: [0.1])
            case .warning:
                return HapticPattern(intensities: [0.7, 0.5, 0.7], intervals: [0.15, 0.1])
            case .error:
                return HapticPattern(intensities: [0.9, 0.6, 0.9], intervals: [0.1, 0.1])
            case .notification:
                return HapticPattern(intensities: [0.6, 0.3], intervals: [0.2])
            case .selection:
                return HapticPattern(intensities: [0.5], intervals: [])
            case .impact:
                return HapticPattern(intensities: [0.7], intervals: [])
            case .longPress:
                return HapticPattern(intensities: [0.8, 0.4], intervals: [0.1])
            case .buttonPress:
                return HapticPattern(intensities: [0.6], intervals: [])
            case .cardTap:
                return HapticPattern(intensities: [0.4], intervals: [])
            case .navigation:
                return HapticPattern(intensities: [0.5, 0.3], intervals: [0.1])
            case .transition:
                return HapticPattern(intensities: [0.6, 0.3], intervals: [0.15])
            case .loading:
                return HapticPattern(intensities: [0.4, 0.2, 0.4], intervals: [0.2, 0.2])
            case .completion:
                return HapticPattern(intensities: [0.8, 0.5, 0.8], intervals: [0.1, 0.1])
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
        deviceFeedback(for: .success)
    }
    
    static func warning() {
        deviceFeedback(for: .warning)
    }
    
    static func error() {
        deviceFeedback(for: .error)
    }
    
    static func selection() {
        deviceFeedback(for: .selection)
    }
    
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        deviceFeedback(for: .impact)
    }
    
    static func longPress() {
        deviceFeedback(for: .longPress)
    }
    
    static func buttonPress() {
        deviceFeedback(for: .buttonPress)
    }
    
    static func cardTap() {
        deviceFeedback(for: .cardTap)
    }
    
    static func emergency() {
        deviceFeedback(for: .emergency)
    }
    
    static func notification() {
        deviceFeedback(for: .notification)
    }
    
    static func navigation() {
        deviceFeedback(for: .navigation)
    }
    
    static func transition() {
        deviceFeedback(for: .transition)
    }
    
    static func loading() {
        deviceFeedback(for: .loading)
    }
    
    static func completion() {
        deviceFeedback(for: .completion)
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
    
    // MARK: - Enhanced Contextual Feedback
    
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
    
    static func deviceStatusChange(status: RingDevice.DeviceStatus) {
        switch status {
        case .online:
            success()
        case .offline:
            warning()
        case .motion:
            deviceFeedback(for: .camera)
        case .recording:
            deviceFeedback(for: .camera)
        case .alarm:
            emergency()
        default:
            notification()
        }
    }
    
    static func interactionFeedback(for interaction: String) {
        switch interaction {
        case "tap":
            cardTap()
        case "longPress":
            longPress()
        case "button":
            buttonPress()
        case "selection":
            selection()
        case "navigation":
            navigation()
        case "transition":
            transition()
        case "loading":
            loading()
        case "completion":
            completion()
        default:
            impact()
        }
    }
    
    // MARK: - Enhanced CarPlay-Specific Feedback
    
    static func carPlayNavigation() {
        navigation()
    }
    
    static func carPlaySelection() {
        selection()
    }
    
    static func carPlayEmergency() {
        emergency()
    }
    
    static func carPlayButtonPress() {
        buttonPress()
    }
    
    static func carPlayCardTap() {
        cardTap()
    }
    
    static func carPlayTransition() {
        transition()
    }
    
    // MARK: - Enhanced Performance Optimized Feedback
    
    private static var lastFeedbackTime: Date = Date()
    private static let minimumFeedbackInterval: TimeInterval = 0.1
    private static var feedbackCount = 0
    private static let maxFeedbackPerSecond = 10
    
    static func throttledFeedback(_ feedback: () -> Void) {
        let now = Date()
        if now.timeIntervalSince(lastFeedbackTime) >= minimumFeedbackInterval {
            if feedbackCount < maxFeedbackPerSecond {
                feedback()
                feedbackCount += 1
                lastFeedbackTime = now
            }
        }
    }
    
    static func resetFeedbackCount() {
        feedbackCount = 0
    }
    
    // MARK: - Enhanced Accessibility-Aware Feedback
    
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
            case "warning":
                warning()
            case "notification":
                notification()
            case "navigation":
                navigation()
            case "transition":
                transition()
            case "loading":
                loading()
            case "completion":
                completion()
            default:
                impact(style: .light)
            }
        }
    }
    
    // MARK: - Enhanced Battery-Aware Feedback
    
    private static var batteryLevel: Float = 1.0
    
    static func setBatteryLevel(_ level: Float) {
        batteryLevel = level
    }
    
    static func batteryAwareFeedback(_ feedback: () -> Void) {
        // Reduce haptic intensity when battery is low
        if batteryLevel < 0.2 {
            // Minimal feedback to conserve battery
            impact(style: .soft)
        } else if batteryLevel < 0.5 {
            // Reduced feedback for medium battery
            impact(style: .light)
        } else {
            // Full feedback for high battery
            feedback()
        }
    }
    
    // MARK: - Enhanced Performance-Aware Feedback
    
    static func performanceAwareFeedback(_ feedback: () -> Void) {
        // Check if we should reduce feedback for performance
        if AppleDesignSystem.AnimationPerformanceMonitor.shouldOptimizeAnimations() {
            // Minimal feedback for performance optimization
            impact(style: .soft)
        } else {
            // Full feedback for optimal performance
            feedback()
        }
    }
    
    // MARK: - Enhanced Context-Aware Feedback
    
    static func contextAwareFeedback(for context: String) {
        switch context {
        case "device":
            deviceFeedback(for: .system)
        case "status":
            notification()
        case "interaction":
            cardTap()
        case "emergency":
            emergency()
        case "loading":
            loading()
        case "success":
            success()
        case "error":
            error()
        case "warning":
            warning()
        case "navigation":
            navigation()
        case "transition":
            transition()
        case "completion":
            completion()
        default:
            impact()
        }
    }
    
    // MARK: - Enhanced Multi-Pattern Feedback
    
    static func multiPatternFeedback(patterns: [DeviceFeedback]) {
        for (index, pattern) in patterns.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                deviceFeedback(for: pattern)
            }
        }
    }
    
    static func sequenceFeedback(patterns: [DeviceFeedback]) {
        var delay: TimeInterval = 0
        for pattern in patterns {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                deviceFeedback(for: pattern)
            }
            delay += 0.3
        }
    }
    
    // MARK: - Enhanced Feedback with Animation Coordination
    
    static func coordinatedFeedback(
        pattern: DeviceFeedback,
        animation: Animation = .easeInOut(duration: 0.3)
    ) {
        withAnimation(animation) {
            deviceFeedback(for: pattern)
        }
    }
    
    static func synchronizedFeedback(
        pattern: DeviceFeedback,
        completion: @escaping () -> Void
    ) {
        deviceFeedback(for: pattern)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            completion()
        }
    }
}

// MARK: - Enhanced Haptic Feedback Modifiers

struct HapticFeedbackModifier: ViewModifier {
    let feedback: () -> Void
    let trigger: HapticTrigger
    let condition: Bool
    
    enum HapticTrigger {
        case onTap
        case onLongPress
        case onAppear
        case onDisappear
        case onHover
        case onDrag
        case onScale
        case onRotation
        case onOpacity
        case onOffset
        case onAnimation
        case onStateChange
        case onValueChange
        case onCondition
    }
    
    init(
        feedback: @escaping () -> Void,
        trigger: HapticTrigger = .onTap,
        condition: Bool = true
    ) {
        self.feedback = feedback
        self.trigger = trigger
        self.condition = condition
    }
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                if trigger == .onTap && condition {
                    feedback()
                }
            }
            .onLongPressGesture {
                if trigger == .onLongPress && condition {
                    feedback()
                }
            }
            .onAppear {
                if trigger == .onAppear && condition {
                    feedback()
                }
            }
            .onDisappear {
                if trigger == .onDisappear && condition {
                    feedback()
                }
            }
            .onHover { hovering in
                if trigger == .onHover && condition && hovering {
                    feedback()
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        if trigger == .onDrag && condition {
                            feedback()
                        }
                    }
            )
            .scaleEffect(1.0)
            .onChange(of: 1.0) { _ in
                if trigger == .onScale && condition {
                    feedback()
                }
            }
            .rotationEffect(.degrees(0))
            .onChange(of: 0.0) { _ in
                if trigger == .onRotation && condition {
                    feedback()
                }
            }
            .opacity(1.0)
            .onChange(of: 1.0) { _ in
                if trigger == .onOpacity && condition {
                    feedback()
                }
            }
            .offset(.zero)
            .onChange(of: CGSize.zero) { _ in
                if trigger == .onOffset && condition {
                    feedback()
                }
            }
            .animation(.easeInOut(duration: 0.3))
            .onChange(of: UUID()) { _ in
                if trigger == .onAnimation && condition {
                    feedback()
                }
            }
            .onChange(of: condition) { _ in
                if trigger == .onStateChange && condition {
                    feedback()
                }
            }
            .onChange(of: 1.0) { _ in
                if trigger == .onValueChange && condition {
                    feedback()
                }
            }
            .onChange(of: condition) { _ in
                if trigger == .onCondition && condition {
                    feedback()
                }
            }
    }
}

extension View {
    func hapticFeedback(
        _ feedback: @escaping () -> Void,
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        modifier(HapticFeedbackModifier(feedback: feedback, trigger: trigger, condition: condition))
    }
    
    func deviceHapticFeedback(
        for deviceType: HapticFeedback.DeviceFeedback,
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        hapticFeedback({
            HapticFeedback.deviceFeedback(for: deviceType)
        }, trigger: trigger, condition: condition)
    }
    
    // MARK: - Enhanced Context-Specific Haptic Feedback
    
    func contextHapticFeedback(
        for context: String,
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        hapticFeedback({
            HapticFeedback.contextAwareFeedback(for: context)
        }, trigger: trigger, condition: condition)
    }
    
    func interactionHapticFeedback(
        for interaction: String,
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        hapticFeedback({
            HapticFeedback.interactionFeedback(for: interaction)
        }, trigger: trigger, condition: condition)
    }
    
    // MARK: - Enhanced Device-Specific Haptic Feedback
    
    func deviceActivationHaptic(
        for deviceType: RingDevice.DeviceType,
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        hapticFeedback({
            HapticFeedback.deviceActivation(for: deviceType)
        }, trigger: trigger, condition: condition)
    }
    
    func deviceStatusHaptic(
        for status: RingDevice.DeviceStatus,
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        hapticFeedback({
            HapticFeedback.deviceStatusChange(status: status)
        }, trigger: trigger, condition: condition)
    }
    
    // MARK: - Enhanced CarPlay-Specific Haptic Feedback
    
    func carPlayHapticFeedback(
        _ feedback: @escaping () -> Void,
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        hapticFeedback(feedback, trigger: trigger, condition: condition)
    }
    
    func carPlayNavigationHaptic(
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        hapticFeedback({
            HapticFeedback.carPlayNavigation()
        }, trigger: trigger, condition: condition)
    }
    
    func carPlaySelectionHaptic(
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        hapticFeedback({
            HapticFeedback.carPlaySelection()
        }, trigger: trigger, condition: condition)
    }
    
    func carPlayEmergencyHaptic(
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        hapticFeedback({
            HapticFeedback.carPlayEmergency()
        }, trigger: trigger, condition: condition)
    }
    
    // MARK: - Enhanced Performance-Aware Haptic Feedback
    
    func performanceAwareHaptic(
        _ feedback: @escaping () -> Void,
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        hapticFeedback({
            HapticFeedback.performanceAwareFeedback(feedback)
        }, trigger: trigger, condition: condition)
    }
    
    func batteryAwareHaptic(
        _ feedback: @escaping () -> Void,
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        hapticFeedback({
            HapticFeedback.batteryAwareFeedback(feedback)
        }, trigger: trigger, condition: condition)
    }
    
    func accessibilityAwareHaptic(
        for action: String,
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        hapticFeedback({
            HapticFeedback.accessibilityFeedback(for: action)
        }, trigger: trigger, condition: condition)
    }
    
    // MARK: - Enhanced Multi-Pattern Haptic Feedback
    
    func multiPatternHaptic(
        patterns: [HapticFeedback.DeviceFeedback],
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        hapticFeedback({
            HapticFeedback.multiPatternFeedback(patterns: patterns)
        }, trigger: trigger, condition: condition)
    }
    
    func sequenceHaptic(
        patterns: [HapticFeedback.DeviceFeedback],
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        hapticFeedback({
            HapticFeedback.sequenceFeedback(patterns: patterns)
        }, trigger: trigger, condition: condition)
    }
    
    // MARK: - Enhanced Coordinated Haptic Feedback
    
    func coordinatedHaptic(
        pattern: HapticFeedback.DeviceFeedback,
        animation: Animation = .easeInOut(duration: 0.3),
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        hapticFeedback({
            HapticFeedback.coordinatedFeedback(pattern: pattern, animation: animation)
        }, trigger: trigger, condition: condition)
    }
    
    func synchronizedHaptic(
        pattern: HapticFeedback.DeviceFeedback,
        completion: @escaping () -> Void,
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        hapticFeedback({
            HapticFeedback.synchronizedFeedback(pattern: pattern, completion: completion)
        }, trigger: trigger, condition: condition)
    }
    
    // MARK: - Enhanced Conditional Haptic Feedback
    
    func conditionalHaptic(
        _ feedback: @escaping () -> Void,
        when condition: Bool,
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap
    ) -> some View {
        hapticFeedback(feedback, trigger: trigger, condition: condition)
    }
    
    func hapticWhen(_ condition: Bool, _ feedback: @escaping () -> Void) -> some View {
        conditionalHaptic(feedback, when: condition)
    }
    
    func hapticIf(_ condition: Bool, _ feedback: @escaping () -> Void) -> some View {
        conditionalHaptic(feedback, when: condition)
    }
    
    // MARK: - Enhanced Animation-Coordinated Haptic Feedback
    
    func animatedHaptic(
        _ feedback: @escaping () -> Void,
        animation: Animation = .easeInOut(duration: 0.3),
        trigger: HapticFeedbackModifier.HapticTrigger = .onTap,
        condition: Bool = true
    ) -> some View {
        hapticFeedback({
            withAnimation(animation) {
                feedback()
            }
        }, trigger: trigger, condition: condition)
    }
    
    func hapticWithAnimation(
        _ feedback: @escaping () -> Void,
        animation: Animation = .easeInOut(duration: 0.3)
    ) -> some View {
        animatedHaptic(feedback, animation: animation)
    }
}