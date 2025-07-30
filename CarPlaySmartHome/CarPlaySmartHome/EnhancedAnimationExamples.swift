import SwiftUI

// MARK: - Enhanced Animation Examples

struct EnhancedAnimationExamples: View {
    @State private var isAnimating = false
    @State private var selectedAnimation = "energyField"
    @State private var showPerformanceMonitor = false
    
    let animations = [
        "energyField", "particleSystem", "liquidMorph", "magneticPull",
        "holographic", "neuralNetwork", "quantumState", "elasticBounce",
        "smoothMorph", "quickResponse", "gentleFloat", "breathing",
        "pulse", "shimmer", "floating", "morphing", "scale", "fade"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppleDesignSystem.Spacing.lg) {
                // Performance Monitor
                performanceMonitorSection
                
                // Animation Examples
                animationExamplesSection
                
                // Device-Specific Animations
                deviceAnimationsSection
                
                // Interactive Animations
                interactiveAnimationsSection
                
                // CarPlay-Specific Animations
                carPlayAnimationsSection
                
                // Emergency Animations
                emergencyAnimationsSection
                
                // Loading Animations
                loadingAnimationsSection
                
                // Success/Error Animations
                successErrorAnimationsSection
                
                // Transition Animations
                transitionAnimationsSection
                
                // Ambient Animations
                ambientAnimationsSection
                
                // Multi-Effect Animations
                multiEffectAnimationsSection
                
                // Context-Aware Animations
                contextAwareAnimationsSection
            }
            .padding()
        }
        .onAppear {
            startPerformanceMonitoring()
        }
    }
    
    // MARK: - Performance Monitor Section
    
    private var performanceMonitorSection: some View {
        VStack(spacing: AppleDesignSystem.Spacing.md) {
            Text("Performance Monitor")
                .font(AppleDesignSystem.Typography.title2)
                .foregroundColor(.primary)
            
            if showPerformanceMonitor {
                let report = AppleDesignSystem.AnimationPerformanceMonitor.getPerformanceReport()
                
                VStack(spacing: AppleDesignSystem.Spacing.sm) {
                    HStack {
                        Text("Frame Rate:")
                        Spacer()
                        Text("\(Int(report.currentFrameRate)) FPS")
                            .foregroundColor(report.isPerformanceOptimal ? .green : .orange)
                    }
                    
                    HStack {
                        Text("Complexity:")
                        Spacer()
                        Text("\(String(describing: report.complexityLevel))")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Active Animations:")
                        Spacer()
                        Text("\(report.activeAnimations)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Battery Level:")
                        Spacer()
                        Text("\(Int(report.batteryLevel * 100))%")
                            .foregroundColor(report.batteryLevel < 0.2 ? .red : .green)
                    }
                }
                .padding()
                .liquidGlassCard(elevation: .medium, cornerRadius: 12)
            }
            
            Button("Toggle Performance Monitor") {
                withAnimation(AppleDesignSystem.Animations.snappy) {
                    showPerformanceMonitor.toggle()
                }
            }
            .buttonStyle(AppleButtonStyle(style: .secondary, size: .medium))
        }
    }
    
    // MARK: - Animation Examples Section
    
    private var animationExamplesSection: some View {
        VStack(spacing: AppleDesignSystem.Spacing.md) {
            Text("Animation Examples")
                .font(AppleDesignSystem.Typography.title2)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppleDesignSystem.Spacing.md) {
                ForEach(animations, id: \.self) { animation in
                    animationExampleCard(animation: animation)
                }
            }
        }
    }
    
    private func animationExampleCard(animation: String) -> some View {
        VStack(spacing: AppleDesignSystem.Spacing.sm) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .applyAnimation(animation)
                .withPerformanceTracking()
                .hapticFeedback({
                    HapticFeedback.interactionFeedback(for: "tap")
                })
            
            Text(animation.capitalized)
                .font(AppleDesignSystem.Typography.caption1)
                .foregroundColor(.secondary)
        }
        .padding()
        .liquidGlassCard(elevation: .low, cornerRadius: 12)
        .onTapGesture {
            withAnimation(AppleDesignSystem.Animations.snappy) {
                selectedAnimation = animation
            }
            HapticFeedback.cardTap()
        }
    }
    
    // MARK: - Device Animations Section
    
    private var deviceAnimationsSection: some View {
        VStack(spacing: AppleDesignSystem.Spacing.md) {
            Text("Device-Specific Animations")
                .font(AppleDesignSystem.Typography.title2)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppleDesignSystem.Spacing.md) {
                deviceAnimationCard(deviceType: .camera, icon: "camera.fill")
                deviceAnimationCard(deviceType: .doorbell, icon: "bell.fill")
                deviceAnimationCard(deviceType: .sensor, icon: "sensor.fill")
                deviceAnimationCard(deviceType: .light, icon: "lightbulb.fill")
                deviceAnimationCard(deviceType: .lock, icon: "lock.fill")
                deviceAnimationCard(deviceType: .alarm, icon: "alarm.fill")
            }
        }
    }
    
    private func deviceAnimationCard(deviceType: RingDevice.DeviceType, icon: String) -> some View {
        VStack(spacing: AppleDesignSystem.Spacing.sm) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .deviceAnimation(for: deviceType)
                .withPerformanceTracking()
                .deviceActivationHaptic(for: deviceType)
            
            Text(deviceType.rawValue.capitalized)
                .font(AppleDesignSystem.Typography.caption1)
                .foregroundColor(.secondary)
        }
        .padding()
        .liquidGlassCard(elevation: .low, cornerRadius: 12)
    }
    
    // MARK: - Interactive Animations Section
    
    private var interactiveAnimationsSection: some View {
        VStack(spacing: AppleDesignSystem.Spacing.md) {
            Text("Interactive Animations")
                .font(AppleDesignSystem.Typography.title2)
                .foregroundColor(.primary)
            
            HStack(spacing: AppleDesignSystem.Spacing.md) {
                interactiveButton("Press", .interactivePress())
                interactiveButton("Hover", .interactiveHover())
                interactiveButton("Long Press", .interactiveLongPress())
            }
        }
    }
    
    private func interactiveButton(_ title: String, _ animation: some View) -> some View {
        VStack(spacing: AppleDesignSystem.Spacing.sm) {
            Circle()
                .fill(.blue)
                .frame(width: 50, height: 50)
                .modifier(animation)
                .withPerformanceTracking()
                .interactionHapticFeedback(for: "tap")
            
            Text(title)
                .font(AppleDesignSystem.Typography.caption1)
                .foregroundColor(.secondary)
        }
        .padding()
        .liquidGlassCard(elevation: .low, cornerRadius: 12)
    }
    
    // MARK: - CarPlay Animations Section
    
    private var carPlayAnimationsSection: some View {
        VStack(spacing: AppleDesignSystem.Spacing.md) {
            Text("CarPlay-Specific Animations")
                .font(AppleDesignSystem.Typography.title2)
                .foregroundColor(.primary)
            
            HStack(spacing: AppleDesignSystem.Spacing.md) {
                carPlayButton("Optimized", .carPlayOptimized())
                carPlayButton("Quick", .carPlayQuick())
                carPlayButton("Gentle", .carPlayGentle())
            }
        }
    }
    
    private func carPlayButton(_ title: String, _ animation: some View) -> some View {
        VStack(spacing: AppleDesignSystem.Spacing.sm) {
            Circle()
                .fill(.green)
                .frame(width: 50, height: 50)
                .modifier(animation)
                .withPerformanceTracking()
                .carPlayHapticFeedback({
                    HapticFeedback.carPlayButtonPress()
                })
            
            Text(title)
                .font(AppleDesignSystem.Typography.caption1)
                .foregroundColor(.secondary)
        }
        .padding()
        .liquidGlassCard(elevation: .low, cornerRadius: 12)
    }
    
    // MARK: - Emergency Animations Section
    
    private var emergencyAnimationsSection: some View {
        VStack(spacing: AppleDesignSystem.Spacing.md) {
            Text("Emergency Animations")
                .font(AppleDesignSystem.Typography.title2)
                .foregroundColor(.primary)
            
            HStack(spacing: AppleDesignSystem.Spacing.md) {
                emergencyButton("Emergency", .emergencyAnimation())
                emergencyButton("Alert", .alertAnimation())
            }
        }
    }
    
    private func emergencyButton(_ title: String, _ animation: some View) -> some View {
        VStack(spacing: AppleDesignSystem.Spacing.sm) {
            Circle()
                .fill(.red)
                .frame(width: 60, height: 60)
                .modifier(animation)
                .withPerformanceTracking()
                .carPlayEmergencyHaptic()
            
            Text(title)
                .font(AppleDesignSystem.Typography.caption1)
                .foregroundColor(.secondary)
        }
        .padding()
        .liquidGlassCard(elevation: .low, cornerRadius: 12)
    }
    
    // MARK: - Loading Animations Section
    
    private var loadingAnimationsSection: some View {
        VStack(spacing: AppleDesignSystem.Spacing.md) {
            Text("Loading Animations")
                .font(AppleDesignSystem.Typography.title2)
                .foregroundColor(.primary)
            
            HStack(spacing: AppleDesignSystem.Spacing.md) {
                loadingButton("Loading", .loadingAnimation())
                loadingButton("Progress", .progressAnimation())
            }
        }
    }
    
    private func loadingButton(_ title: String, _ animation: some View) -> some View {
        VStack(spacing: AppleDesignSystem.Spacing.sm) {
            Circle()
                .fill(.orange)
                .frame(width: 50, height: 50)
                .modifier(animation)
                .withPerformanceTracking()
                .contextHapticFeedback(for: "loading")
            
            Text(title)
                .font(AppleDesignSystem.Typography.caption1)
                .foregroundColor(.secondary)
        }
        .padding()
        .liquidGlassCard(elevation: .low, cornerRadius: 12)
    }
    
    // MARK: - Success/Error Animations Section
    
    private var successErrorAnimationsSection: some View {
        VStack(spacing: AppleDesignSystem.Spacing.md) {
            Text("Success/Error Animations")
                .font(AppleDesignSystem.Typography.title2)
                .foregroundColor(.primary)
            
            HStack(spacing: AppleDesignSystem.Spacing.md) {
                statusButton("Success", .successAnimation(), .green)
                statusButton("Error", .errorAnimation(), .red)
            }
        }
    }
    
    private func statusButton(_ title: String, _ animation: some View, _ color: Color) -> some View {
        VStack(spacing: AppleDesignSystem.Spacing.sm) {
            Circle()
                .fill(color)
                .frame(width: 50, height: 50)
                .modifier(animation)
                .withPerformanceTracking()
                .contextHapticFeedback(for: title.lowercased())
            
            Text(title)
                .font(AppleDesignSystem.Typography.caption1)
                .foregroundColor(.secondary)
        }
        .padding()
        .liquidGlassCard(elevation: .low, cornerRadius: 12)
    }
    
    // MARK: - Transition Animations Section
    
    private var transitionAnimationsSection: some View {
        VStack(spacing: AppleDesignSystem.Spacing.md) {
            Text("Transition Animations")
                .font(AppleDesignSystem.Typography.title2)
                .foregroundColor(.primary)
            
            HStack(spacing: AppleDesignSystem.Spacing.md) {
                transitionButton("Smooth", .smoothTransition())
                transitionButton("Quick", .quickTransition())
            }
        }
    }
    
    private func transitionButton(_ title: String, _ animation: some View) -> some View {
        VStack(spacing: AppleDesignSystem.Spacing.sm) {
            Circle()
                .fill(.purple)
                .frame(width: 50, height: 50)
                .modifier(animation)
                .withPerformanceTracking()
                .contextHapticFeedback(for: "transition")
            
            Text(title)
                .font(AppleDesignSystem.Typography.caption1)
                .foregroundColor(.secondary)
        }
        .padding()
        .liquidGlassCard(elevation: .low, cornerRadius: 12)
    }
    
    // MARK: - Ambient Animations Section
    
    private var ambientAnimationsSection: some View {
        VStack(spacing: AppleDesignSystem.Spacing.md) {
            Text("Ambient Animations")
                .font(AppleDesignSystem.Typography.title2)
                .foregroundColor(.primary)
            
            HStack(spacing: AppleDesignSystem.Spacing.md) {
                ambientButton("Ambient", .ambientAnimation())
                ambientButton("Breathing", .breathingAnimation())
            }
        }
    }
    
    private func ambientButton(_ title: String, _ animation: some View) -> some View {
        VStack(spacing: AppleDesignSystem.Spacing.sm) {
            Circle()
                .fill(.teal)
                .frame(width: 50, height: 50)
                .modifier(animation)
                .withPerformanceTracking()
                .contextHapticFeedback(for: "ambient")
            
            Text(title)
                .font(AppleDesignSystem.Typography.caption1)
                .foregroundColor(.secondary)
        }
        .padding()
        .liquidGlassCard(elevation: .low, cornerRadius: 12)
    }
    
    // MARK: - Multi-Effect Animations Section
    
    private var multiEffectAnimationsSection: some View {
        VStack(spacing: AppleDesignSystem.Spacing.md) {
            Text("Multi-Effect Animations")
                .font(AppleDesignSystem.Typography.title2)
                .foregroundColor(.primary)
            
            HStack(spacing: AppleDesignSystem.Spacing.md) {
                multiEffectButton("Multi", .multiEffectAnimation())
                multiEffectButton("Premium", .premiumAnimation())
            }
        }
    }
    
    private func multiEffectButton(_ title: String, _ animation: some View) -> some View {
        VStack(spacing: AppleDesignSystem.Spacing.sm) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple, .pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .modifier(animation)
                .withPerformanceTracking()
                .multiPatternHaptic(patterns: [.success, .notification, .completion])
            
            Text(title)
                .font(AppleDesignSystem.Typography.caption1)
                .foregroundColor(.secondary)
        }
        .padding()
        .liquidGlassCard(elevation: .low, cornerRadius: 12)
    }
    
    // MARK: - Context-Aware Animations Section
    
    private var contextAwareAnimationsSection: some View {
        VStack(spacing: AppleDesignSystem.Spacing.md) {
            Text("Context-Aware Animations")
                .font(AppleDesignSystem.Typography.title2)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppleDesignSystem.Spacing.md) {
                contextButton("Device", "device")
                contextButton("Status", "status")
                contextButton("Interaction", "interaction")
                contextButton("Emergency", "emergency")
                contextButton("Loading", "loading")
                contextButton("Success", "success")
                contextButton("Error", "error")
                contextButton("Ambient", "ambient")
            }
        }
    }
    
    private func contextButton(_ title: String, _ context: String) -> some View {
        VStack(spacing: AppleDesignSystem.Spacing.sm) {
            Circle()
                .fill(.indigo)
                .frame(width: 50, height: 50)
                .contextAwareAnimation(for: context)
                .withPerformanceTracking()
                .contextHapticFeedback(for: context)
            
            Text(title)
                .font(AppleDesignSystem.Typography.caption1)
                .foregroundColor(.secondary)
        }
        .padding()
        .liquidGlassCard(elevation: .low, cornerRadius: 12)
    }
    
    // MARK: - Helper Methods
    
    private func startPerformanceMonitoring() {
        AppleDesignSystem.AnimationPerformanceMonitor.startMonitoring()
        AppleDesignSystem.AnimationPerformanceMonitor.setBatteryLevel(0.8)
        AppleDesignSystem.AnimationPerformanceMonitor.setReduceMotionEnabled(false)
    }
}

// MARK: - Animation Extension Helper

extension View {
    func applyAnimation(_ animationName: String) -> some View {
        switch animationName {
        case "energyField":
            return self.energyField()
        case "particleSystem":
            return self.particleSystem()
        case "liquidMorph":
            return self.liquidMorph()
        case "magneticPull":
            return self.magneticPull()
        case "holographic":
            return self.holographic()
        case "neuralNetwork":
            return self.neuralNetwork()
        case "quantumState":
            return self.quantumState()
        case "elasticBounce":
            return self.elasticBounce()
        case "smoothMorph":
            return self.smoothMorph()
        case "quickResponse":
            return self.quickResponse()
        case "gentleFloat":
            return self.gentleFloat()
        case "breathing":
            return self.breathing()
        case "pulse":
            return self.pulse()
        case "shimmer":
            return self.shimmer()
        case "floating":
            return self.floating()
        case "morphing":
            return self.morphing()
        case "scale":
            return self.scale()
        case "fade":
            return self.fade()
        default:
            return self.gentleFloat()
        }
    }
}

#Preview {
    EnhancedAnimationExamples()
}