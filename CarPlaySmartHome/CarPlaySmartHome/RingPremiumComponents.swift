import SwiftUI

// MARK: - Premium Filter Chip

@available(iOS 15.0, *)
struct PremiumFilterChip: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: RingDesignSystem.Spacing.xs) {
                // Icon with glow effect
                Image(systemName: icon)
                    .font(RingDesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : color)
                    .glowEffect(color: color, intensity: isSelected ? 0.8 : 0.3)
                
                // Title
                Text(title)
                    .font(RingDesignSystem.Typography.caption1)
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .white : RingDesignSystem.Colors.Foreground.primary)
                
                // Count badge
                Text("\(count)")
                    .font(RingDesignSystem.Typography.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(isSelected ? color.opacity(0.9) : color)
                    .padding(.horizontal, RingDesignSystem.Spacing.xs)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(isSelected ? .white.opacity(0.2) : color.opacity(0.15))
                            .overlay(
                                Capsule()
                                    .stroke(isSelected ? .white.opacity(0.3) : color.opacity(0.3), lineWidth: 0.5)
                            )
                    )
            }
            .padding(.horizontal, RingDesignSystem.Spacing.md)
            .padding(.vertical, RingDesignSystem.Spacing.sm)
            .background(
                Capsule()
                    .fill(isSelected ? 
                          RingAdvancedDesign.Gradients.deviceGradient(for: deviceTypeFromColor(color)) :
                          .ultraThinMaterial
                    )
                    .overlay(
                        Capsule()
                            .fill(isSelected ? Color.clear : color.opacity(0.1))
                    )
                    .overlay(
                        Capsule()
                            .stroke(
                                LinearGradient(
                                    colors: isSelected ? [
                                        Color.white.opacity(0.4),
                                        Color.white.opacity(0.1)
                                    ] : [
                                        color.opacity(0.4),
                                        color.opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: isSelected ? color.opacity(0.4) : .clear,
                        radius: isSelected ? 8 : 0,
                        x: 0,
                        y: isSelected ? 4 : 0
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(RingAdvancedDesign.Animations.bouncySpring, value: isPressed)
        .animation(RingAdvancedDesign.Animations.smoothSpring, value: isSelected)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
    
    private func deviceTypeFromColor(_ color: Color) -> DeviceType {
        // Simple mapping for demonstration - in real app you'd pass the actual device type
        if color == RingDesignSystem.Colors.ringBlue { return .camera }
        if color == RingDesignSystem.Colors.ringOrange { return .doorbell }
        if color == RingDesignSystem.Colors.ringGreen { return .motionSensor }
        if color == RingDesignSystem.Colors.ringYellow { return .floodlight }
        if color == RingDesignSystem.Colors.ringPurple { return .chime }
        return .camera
    }
}

// MARK: - Premium Device Section

@available(iOS 15.0, *)
struct PremiumDeviceSection: View {
    let deviceType: DeviceType
    let devices: [SmartDevice]
    let smartHomeManager: SmartHomeManager
    
    @State private var isExpanded = true
    @State private var animateHeader = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            // Enhanced Section Header
            sectionHeader
            
            // Device Cards
            if isExpanded {
                LazyVStack(spacing: RingDesignSystem.Spacing.sm) {
                    ForEach(devices.indices, id: \.self) { index in
                        PremiumDeviceCard(
                            device: devices[index],
                            smartHomeManager: smartHomeManager
                        )
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity).animation(
                                RingAdvancedDesign.Animations.gentleSpring.delay(Double(index) * 0.1)
                            ),
                            removal: .scale.combined(with: .opacity)
                        ))
                    }
                }
            }
        }
        .padding(.vertical, RingDesignSystem.Spacing.sm)
        .onAppear {
            withAnimation(RingAdvancedDesign.Animations.gentleSpring.delay(0.3)) {
                animateHeader = true
            }
        }
    }
    
    private var sectionHeader: some View {
        Button {
            withAnimation(RingAdvancedDesign.Animations.smoothSpring) {
                isExpanded.toggle()
                RingDesignSystem.Haptics.light()
            }
        } label: {
            HStack(spacing: RingDesignSystem.Spacing.md) {
                // Device type icon with gradient background
                ZStack {
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                        .fill(RingAdvancedDesign.Gradients.deviceGradient(for: deviceType))
                        .frame(width: 44, height: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.md)
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.white.opacity(0.3),
                                            Color.clear
                                        ],
                                        center: .topLeading,
                                        startRadius: 0,
                                        endRadius: 22
                                    )
                                )
                        )
                    
                    Image(systemName: deviceType.iconName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                }
                .glowEffect(color: deviceType.accentColor, intensity: 0.6)
                .scaleEffect(animateHeader ? 1.0 : 0.8)
                .animation(RingAdvancedDesign.Animations.bouncySpring, value: animateHeader)
                
                // Section info
                VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.xs) {
                    HStack {
                        Text("\(deviceType.rawValue.capitalized)s")
                            .font(RingDesignSystem.Typography.headline)
                            .fontWeight(.bold)
                            .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                        
                        Spacer()
                        
                        // Expand/collapse indicator
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(RingDesignSystem.Typography.caption1)
                            .fontWeight(.medium)
                            .foregroundColor(deviceType.accentColor)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                    
                    HStack(spacing: RingDesignSystem.Spacing.sm) {
                        // Device count
                        HStack(spacing: RingDesignSystem.Spacing.xs) {
                            Image(systemName: "number")
                                .font(RingDesignSystem.Typography.caption2)
                                .foregroundColor(deviceType.accentColor)
                            
                            Text("\(devices.count) device\(devices.count == 1 ? "" : "s")")
                                .font(RingDesignSystem.Typography.caption1)
                                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                        }
                        
                        // Online status
                        let onlineCount = devices.filter { $0.status == .on }.count
                        HStack(spacing: RingDesignSystem.Spacing.xs) {
                            Circle()
                                .fill(onlineCount > 0 ? RingDesignSystem.Colors.ringGreen : RingDesignSystem.Colors.Foreground.tertiary)
                                .frame(width: 6, height: 6)
                            
                            Text("\(onlineCount) online")
                                .font(RingDesignSystem.Typography.caption1)
                                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                        }
                        
                        Spacer()
                    }
                }
            }
            .padding(RingDesignSystem.Spacing.md)
            .advancedLiquidGlass(
                intensity: .thin,
                cornerRadius: RingDesignSystem.CornerRadius.lg,
                showBorder: true
            )
            .gradientBorder(
                gradient: LinearGradient(
                    colors: [
                        deviceType.accentColor.opacity(0.5),
                        deviceType.accentColor.opacity(0.2),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                width: 1,
                cornerRadius: RingDesignSystem.CornerRadius.lg
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Enhanced Hero Section

@available(iOS 15.0, *)
struct EnhancedHeroSection: View {
    @State private var animateRings = false
    @State private var animateIcon = false
    @State private var animateText = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xl) {
            // Animated Ring Logo with multiple layers
            ZStack {
                // Outer glow ring
                Circle()
                    .stroke(
                        RingDesignSystem.Colors.ringBlue.opacity(0.3),
                        lineWidth: 2
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(animateRings ? 1.2 : 1.0)
                    .opacity(animateRings ? 0.5 : 0.8)
                
                // Middle ring
                Circle()
                    .stroke(
                        RingAdvancedDesign.Gradients.heroGradient,
                        lineWidth: 6
                    )
                    .frame(width: 160, height: 160)
                    .overlay(
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        RingDesignSystem.Colors.ringBlue.opacity(0.1),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 80
                                )
                            )
                    )
                
                // Inner glowing circle
                Circle()
                    .fill(RingAdvancedDesign.Gradients.heroGradient)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.white.opacity(0.4),
                                        Color.clear
                                    ],
                                    center: .topLeading,
                                    startRadius: 0,
                                    endRadius: 60
                                )
                            )
                    )
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                
                // Central icon
                Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                    .font(.system(size: 48, weight: .medium))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    .scaleEffect(animateIcon ? 1.2 : 1.0)
                    .rotationEffect(.degrees(animateIcon ? 5 : -5))
                
                // Floating particles
                ForEach(0..<6, id: \.self) { index in
                    Circle()
                        .fill(RingDesignSystem.Colors.ringBlue.opacity(0.6))
                        .frame(width: 4, height: 4)
                        .offset(
                            x: cos(Double(index) * .pi / 3) * 100,
                            y: sin(Double(index) * .pi / 3) * 100
                        )
                        .scaleEffect(animateRings ? 1.5 : 0.5)
                        .opacity(animateRings ? 0.8 : 0.3)
                        .animation(
                            RingAdvancedDesign.Animations.gentleSpring.delay(Double(index) * 0.1),
                            value: animateRings
                        )
                }
            }
            .onAppear {
                withAnimation(RingAdvancedDesign.Animations.breatheAnimation) {
                    animateRings = true
                }
                withAnimation(RingAdvancedDesign.Animations.pulseAnimation) {
                    animateIcon = true
                }
            }
            
            // Enhanced text with staggered animation
            VStack(spacing: RingDesignSystem.Spacing.md) {
                Text("Ring Smart Home")
                    .font(RingDesignSystem.Typography.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                RingDesignSystem.Colors.Foreground.primary,
                                RingDesignSystem.Colors.ringBlue
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .opacity(animateText ? 1 : 0)
                    .offset(y: animateText ? 0 : 20)
                
                Text("Experience seamless home security control from your car with CarPlay integration and professional-grade monitoring")
                    .font(RingDesignSystem.Typography.body)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .opacity(animateText ? 1 : 0)
                    .offset(y: animateText ? 0 : 30)
            }
            .onAppear {
                withAnimation(RingAdvancedDesign.Animations.gentleSpring.delay(0.8)) {
                    animateText = true
                }
            }
        }
    }
}

// MARK: - Premium Empty State View

@available(iOS 15.0, *)
struct PremiumEmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    @State private var animateIcon = false
    @State private var animateContent = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xl) {
            // Animated icon with glow
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                RingDesignSystem.Colors.ringBlue.opacity(0.2),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 30,
                            endRadius: 80
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateIcon ? 1.2 : 1.0)
                    .opacity(animateIcon ? 0.8 : 0.4)
                
                Image(systemName: icon)
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
                    .scaleEffect(animateIcon ? 1.1 : 0.9)
            }
            .onAppear {
                withAnimation(RingAdvancedDesign.Animations.breatheAnimation) {
                    animateIcon = true
                }
            }
            
            // Content
            VStack(spacing: RingDesignSystem.Spacing.md) {
                Text(title)
                    .font(RingDesignSystem.Typography.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 20)
                
                Text(subtitle)
                    .font(RingDesignSystem.Typography.body)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 30)
                
                if let actionTitle = actionTitle, let action = action {
                    Button(actionTitle) {
                        action()
                        RingDesignSystem.Haptics.medium()
                    }
                    .ringButton(style: .secondary, size: .medium)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 40)
                }
            }
            .onAppear {
                withAnimation(RingAdvancedDesign.Animations.gentleSpring.delay(0.5)) {
                    animateContent = true
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(RingDesignSystem.Spacing.xl)
    }
}

// MARK: - Enhanced Status Card

@available(iOS 15.0, *)
struct EnhancedStatusCard: View {
    let title: String
    let value: String
    let trend: String?
    let icon: String
    let color: Color
    let isPositive: Bool?
    
    @State private var animateValue = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.md) {
            // Header
            HStack {
                Image(systemName: icon)
                    .font(RingDesignSystem.Typography.subheadline)
                    .foregroundColor(color)
                    .frame(width: 20)
                
                Text(title)
                    .font(RingDesignSystem.Typography.caption1)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                
                Spacer()
                
                if let trend = trend, let isPositive = isPositive {
                    HStack(spacing: RingDesignSystem.Spacing.xxs) {
                        Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                            .font(RingDesignSystem.Typography.caption2)
                            .foregroundColor(isPositive ? RingDesignSystem.Colors.ringGreen : RingDesignSystem.Colors.ringRed)
                        
                        Text(trend)
                            .font(RingDesignSystem.Typography.caption2)
                            .foregroundColor(isPositive ? RingDesignSystem.Colors.ringGreen : RingDesignSystem.Colors.ringRed)
                    }
                }
            }
            
            // Value
            Text(value)
                .font(RingDesignSystem.Typography.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
                .scaleEffect(animateValue ? 1.1 : 1.0)
                .animation(RingAdvancedDesign.Animations.bouncySpring, value: animateValue)
        }
        .padding(RingDesignSystem.Spacing.md)
        .advancedLiquidGlass(cornerRadius: RingDesignSystem.CornerRadius.md)
        .gradientBorder(
            gradient: LinearGradient(
                colors: [
                    color.opacity(0.5),
                    color.opacity(0.2),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            width: 1,
            cornerRadius: RingDesignSystem.CornerRadius.md
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animateValue = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    animateValue = false
                }
            }
        }
    }
}

// MARK: - Floating Action Button

@available(iOS 15.0, *)
struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var isFloating = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(RingAdvancedDesign.Gradients.heroGradient)
                        .overlay(
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.white.opacity(0.3),
                                            Color.clear
                                        ],
                                        center: .topLeading,
                                        startRadius: 0,
                                        endRadius: 28
                                    )
                                )
                        )
                )
                .shadow(color: RingDesignSystem.Colors.ringBlue.opacity(0.4), radius: 12, x: 0, y: 6)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .offset(y: isFloating ? -2 : 2)
        .animation(RingAdvancedDesign.Animations.bouncySpring, value: isPressed)
        .animation(RingAdvancedDesign.Animations.floatAnimation, value: isFloating)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
            RingDesignSystem.Haptics.light()
        }, perform: {})
        .onAppear {
            isFloating = true
        }
    }
}