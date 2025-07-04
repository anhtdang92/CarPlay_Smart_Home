import SwiftUI

// MARK: - Ultra Add Device View
struct UltraAddDeviceView: View {
    @ObservedObject var smartHomeManager: SmartHomeManager
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    @State private var animateContent = false
    @State private var showScanning = false
    @State private var selectedCategory: DeviceCategory = .lights
    @State private var deviceName = ""
    @State private var scanningProgress = 0.0
    @State private var discoveredDevices: [DiscoveredDevice] = []
    
    private let steps = ["Category", "Discovery", "Setup", "Complete"]
    
    var body: some View {
        ZStack {
            // Ultra background
            UltraModernBackground()
            
            VStack(spacing: 0) {
                // Ultra header
                UltraAddDeviceHeader(
                    currentStep: currentStep,
                    steps: steps,
                    dismiss: dismiss
                )
                .offset(y: animateContent ? 0 : -50)
                .opacity(animateContent ? 1 : 0)
                
                // Ultra content
                UltraAddDeviceContent(
                    currentStep: $currentStep,
                    selectedCategory: $selectedCategory,
                    deviceName: $deviceName,
                    scanningProgress: $scanningProgress,
                    discoveredDevices: $discoveredDevices,
                    smartHomeManager: smartHomeManager,
                    showScanning: $showScanning
                )
                .offset(y: animateContent ? 0 : 50)
                .opacity(animateContent ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 1.2, dampingFraction: 0.8).delay(0.3)) {
                animateContent = true
            }
        }
    }
}

// MARK: - Discovered Device Model
struct DiscoveredDevice: Identifiable {
    let id = UUID()
    let name: String
    let category: DeviceCategory
    let signalStrength: Int
    let isCompatible: Bool
    var isSelected = false
}

// MARK: - Ultra Add Device Header
struct UltraAddDeviceHeader: View {
    let currentStep: Int
    let steps: [String]
    let dismiss: DismissAction
    @State private var animateProgress = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xl) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 44, height: 44)
                        )
                }
                
                Spacer()
                
                Text("Add Device")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Progress indicator
                ZStack {
                    Circle()
                        .stroke(.white.opacity(0.3), lineWidth: 4)
                        .frame(width: 44, height: 44)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            LinearGradient(
                                colors: [.blue, .purple, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 44, height: 44)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.0), value: progress)
                    
                    Text("\(currentStep + 1)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            // Step indicators
            HStack(spacing: RingDesignSystem.Spacing.md) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    VStack(spacing: RingDesignSystem.Spacing.xs) {
                        ZStack {
                            Circle()
                                .fill(index <= currentStep ? .blue : .white.opacity(0.3))
                                .frame(width: 40, height: 40)
                                .scaleEffect(animateProgress ? 1.1 : 1.0)
                            
                            if index < currentStep {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            } else {
                                Text("\(index + 1)")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(index <= currentStep ? .white : .white.opacity(0.6))
                            }
                        }
                        
                        Text(step)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(index <= currentStep ? .white : .white.opacity(0.6))
                    }
                }
            }
        }
        .padding(RingDesignSystem.Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xxl)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xxl)
                        .stroke(.white.opacity(0.2), lineWidth: 2)
                )
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                animateProgress = true
            }
        }
    }
    
    private var progress: Double {
        Double(currentStep + 1) / Double(steps.count)
    }
}

// MARK: - Ultra Add Device Content
struct UltraAddDeviceContent: View {
    @Binding var currentStep: Int
    @Binding var selectedCategory: DeviceCategory
    @Binding var deviceName: String
    @Binding var scanningProgress: Double
    @Binding var discoveredDevices: [DiscoveredDevice]
    @ObservedObject var smartHomeManager: SmartHomeManager
    @Binding var showScanning: Bool
    @State private var animateStep = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xl) {
            switch currentStep {
            case 0:
                UltraCategorySelection(
                    selectedCategory: $selectedCategory,
                    onNext: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            currentStep = 1
                        }
                    }
                )
            case 1:
                UltraDeviceDiscovery(
                    selectedCategory: selectedCategory,
                    scanningProgress: $scanningProgress,
                    discoveredDevices: $discoveredDevices,
                    showScanning: $showScanning,
                    onNext: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            currentStep = 2
                        }
                    }
                )
            case 2:
                UltraDeviceSetup(
                    selectedCategory: selectedCategory,
                    deviceName: $deviceName,
                    discoveredDevices: discoveredDevices,
                    onNext: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            currentStep = 3
                        }
                    }
                )
            case 3:
                UltraDeviceComplete(
                    deviceName: deviceName,
                    selectedCategory: selectedCategory,
                    smartHomeManager: smartHomeManager
                )
            default:
                EmptyView()
            }
        }
        .padding(RingDesignSystem.Spacing.xl)
        .onChange(of: currentStep) { _ in
            animateStep = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    animateStep = true
                }
            }
        }
        .onAppear {
            animateStep = true
        }
    }
}

// MARK: - Ultra Category Selection
struct UltraCategorySelection: View {
    @Binding var selectedCategory: DeviceCategory
    let onNext: () -> Void
    @State private var animateCategories = false
    
    private let categories: [DeviceCategory] = [.lights, .sensors, .cameras, .thermostats]
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xl) {
            Text("Select Device Type")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .offset(y: animateCategories ? 0 : -30)
                .opacity(animateCategories ? 1 : 0)
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: RingDesignSystem.Spacing.lg), count: 2),
                spacing: RingDesignSystem.Spacing.lg
            ) {
                ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                    UltraCategoryCard(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedCategory = category
                        }
                        HapticFeedback.impact(style: .light)
                    }
                    .offset(y: animateCategories ? 0 : 50)
                    .opacity(animateCategories ? 1 : 0)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.8)
                        .delay(Double(index) * 0.1),
                        value: animateCategories
                    )
                }
            }
            
            UltraNextButton(
                title: "Continue",
                isEnabled: true,
                action: onNext
            )
            .offset(y: animateCategories ? 0 : 30)
            .opacity(animateCategories ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
                animateCategories = true
            }
        }
    }
}

struct UltraCategoryCard: View {
    let category: DeviceCategory
    let isSelected: Bool
    let action: () -> Void
    @State private var animate = false
    @State private var glow = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: RingDesignSystem.Spacing.lg) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: isSelected ? 
                                    [category.color, category.color.opacity(0.3)] :
                                    [.white.opacity(0.1), .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 60
                            )
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(animate ? 1.1 : 1.0)
                        .shadow(
                            color: isSelected ? 
                                category.color.opacity(glow ? 0.8 : 0.4) : 
                                .clear,
                            radius: glow ? 25 : 15,
                            x: 0,
                            y: glow ? 15 : 8
                        )
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                        .rotationEffect(.degrees(animate ? 360 : 0))
                }
                
                Text(category.displayName)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(RingDesignSystem.Spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xl)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xl)
                            .stroke(
                                isSelected ? 
                                    category.color.opacity(glow ? 0.8 : 0.5) : 
                                    .white.opacity(0.2),
                                lineWidth: glow ? 3 : 2
                            )
                    )
            )
            .scaleEffect(animate ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                animate = pressing
            }
        }, perform: {})
        .onAppear {
            if isSelected {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    glow = true
                }
            }
        }
        .onChange(of: isSelected) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    glow = true
                }
            } else {
                glow = false
            }
        }
    }
}

// MARK: - Ultra Device Discovery
struct UltraDeviceDiscovery: View {
    let selectedCategory: DeviceCategory
    @Binding var scanningProgress: Double
    @Binding var discoveredDevices: [DiscoveredDevice]
    @Binding var showScanning: Bool
    let onNext: () -> Void
    @State private var animateScanning = false
    @State private var pulseScan = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xl) {
            Text("Discovering Devices")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .offset(y: animateScanning ? 0 : -30)
                .opacity(animateScanning ? 1 : 0)
            
            // Scanning animation
            ZStack {
                Circle()
                    .stroke(.white.opacity(0.3), lineWidth: 8)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: scanningProgress)
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: scanningProgress)
                
                VStack(spacing: RingDesignSystem.Spacing.md) {
                    ZStack {
                        Circle()
                            .fill(selectedCategory.color.opacity(0.3))
                            .frame(width: 100, height: 100)
                            .scaleEffect(pulseScan ? 1.3 : 1.0)
                        
                        Image(systemName: selectedCategory.icon)
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(selectedCategory.color)
                            .rotationEffect(.degrees(animateScanning ? 360 : 0))
                    }
                    
                    Text("\(Int(scanningProgress * 100))%")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Scanning for \(selectedCategory.displayName.lowercased())...")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            // Discovered devices
            if !discoveredDevices.isEmpty {
                VStack(spacing: RingDesignSystem.Spacing.lg) {
                    Text("Found \(discoveredDevices.count) device(s)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    ForEach(Array(discoveredDevices.enumerated()), id: \.offset) { index, device in
                        UltraDiscoveredDeviceCard(
                            device: device,
                            onSelect: {
                                discoveredDevices[index].isSelected.toggle()
                            }
                        )
                        .offset(y: animateScanning ? 0 : 30)
                        .opacity(animateScanning ? 1 : 0)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.8)
                            .delay(Double(index) * 0.1),
                            value: animateScanning
                        )
                    }
                }
            }
            
            UltraNextButton(
                title: "Continue",
                isEnabled: !discoveredDevices.isEmpty,
                action: onNext
            )
            .offset(y: animateScanning ? 0 : 30)
            .opacity(animateScanning ? 1 : 0)
        }
        .onAppear {
            startScanning()
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
                animateScanning = true
            }
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                pulseScan = true
            }
            withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
                animateScanning = true
            }
        }
    }
    
    private func startScanning() {
        showScanning = true
        
        // Simulate scanning progress
        withAnimation(.easeInOut(duration: 3.0)) {
            scanningProgress = 1.0
        }
        
        // Simulate device discovery
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            discoveredDevices = [
                DiscoveredDevice(
                    name: "Smart Light 1",
                    category: selectedCategory,
                    signalStrength: 85,
                    isCompatible: true
                ),
                DiscoveredDevice(
                    name: "Smart Light 2",
                    category: selectedCategory,
                    signalStrength: 72,
                    isCompatible: true
                )
            ]
        }
    }
}

struct UltraDiscoveredDeviceCard: View {
    let device: DiscoveredDevice
    let onSelect: () -> Void
    @State private var animate = false
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: RingDesignSystem.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(device.isCompatible ? .green.opacity(0.3) : .red.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .scaleEffect(animate ? 1.1 : 1.0)
                    
                    Image(systemName: device.category.icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(device.isCompatible ? .green : .red)
                        .rotationEffect(.degrees(animate ? 360 : 0))
                }
                
                VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.xs) {
                    Text(device.name)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    HStack(spacing: RingDesignSystem.Spacing.sm) {
                        Image(systemName: "wifi")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("\(device.signalStrength)%")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        
                        if device.isCompatible {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.green)
                        }
                    }
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(device.isSelected ? .blue : .clear)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(device.isSelected ? .blue : .white.opacity(0.5), lineWidth: 2)
                        )
                    
                    if device.isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(RingDesignSystem.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                            .stroke(
                                device.isSelected ? .blue.opacity(0.6) : .white.opacity(0.2),
                                lineWidth: device.isSelected ? 3 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

// MARK: - Ultra Device Setup
struct UltraDeviceSetup: View {
    let selectedCategory: DeviceCategory
    @Binding var deviceName: String
    let discoveredDevices: [DiscoveredDevice]
    let onNext: () -> Void
    @State private var animateSetup = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xl) {
            Text("Device Setup")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .offset(y: animateSetup ? 0 : -30)
                .opacity(animateSetup ? 1 : 0)
            
            VStack(spacing: RingDesignSystem.Spacing.lg) {
                Text("Name Your Device")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                UltraTextField(
                    text: $deviceName,
                    placeholder: "Enter device name...",
                    icon: "pencil"
                )
                .offset(y: animateSetup ? 0 : 30)
                .opacity(animateSetup ? 1 : 0)
                
                if !discoveredDevices.isEmpty {
                    Text("Selected Devices")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .offset(y: animateSetup ? 0 : 30)
                        .opacity(animateSetup ? 1 : 0)
                    
                    ForEach(discoveredDevices.filter { $0.isSelected }) { device in
                        UltraSelectedDeviceCard(device: device)
                            .offset(y: animateSetup ? 0 : 30)
                            .opacity(animateSetup ? 1 : 0)
                    }
                }
            }
            
            UltraNextButton(
                title: "Add Device",
                isEnabled: !deviceName.isEmpty,
                action: onNext
            )
            .offset(y: animateSetup ? 0 : 30)
            .opacity(animateSetup ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
                animateSetup = true
            }
        }
    }
}

struct UltraTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    @State private var isFocused = false
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: RingDesignSystem.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))
                .rotationEffect(.degrees(animate ? 360 : 0))
            
            TextField(placeholder, text: $text)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .textFieldStyle(PlainTextFieldStyle())
                .onTapGesture {
                    isFocused = true
                }
        }
        .padding(RingDesignSystem.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                        .stroke(
                            isFocused ? .blue.opacity(0.6) : .white.opacity(0.3),
                            lineWidth: isFocused ? 3 : 2
                        )
                )
        )
        .scaleEffect(animate ? 1.02 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

struct UltraSelectedDeviceCard: View {
    let device: DiscoveredDevice
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: RingDesignSystem.Spacing.md) {
            ZStack {
                Circle()
                    .fill(.green.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .scaleEffect(animate ? 1.1 : 1.0)
                
                Image(systemName: device.category.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.green)
                    .rotationEffect(.degrees(animate ? 360 : 0))
            }
            
            VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.xs) {
                Text(device.name)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Ready to add")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.green)
        }
        .padding(RingDesignSystem.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                        .stroke(.green.opacity(0.5), lineWidth: 2)
                )
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

// MARK: - Ultra Device Complete
struct UltraDeviceComplete: View {
    let deviceName: String
    let selectedCategory: DeviceCategory
    @ObservedObject var smartHomeManager: SmartHomeManager
    @State private var animateComplete = false
    @State private var showConfetti = false
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xl) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.green, .green.opacity(0.3)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .scaleEffect(animateComplete ? 1.2 : 1.0)
                    .shadow(color: .green.opacity(0.6), radius: 30, x: 0, y: 15)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(animateComplete ? 1.0 : 0.5)
            }
            
            VStack(spacing: RingDesignSystem.Spacing.lg) {
                Text("Device Added!")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("\(deviceName) has been successfully added to your smart home.")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                Text("You can now control it from the main dashboard.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            
            UltraNextButton(
                title: "Done",
                isEnabled: true,
                action: {
                    // Add device to smart home manager
                    let newDevice = RingDevice(
                        id: UUID().uuidString,
                        name: deviceName,
                        category: selectedCategory,
                        status: .online,
                        isOn: false
                    )
                    smartHomeManager.addDevice(newDevice)
                }
            )
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
                animateComplete = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showConfetti = true
            }
        }
    }
}

// MARK: - Ultra Next Button
struct UltraNextButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    @State private var animate = false
    @State private var glow = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: RingDesignSystem.Spacing.md) {
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(animate ? 360 : 0))
            }
            .padding(.horizontal, RingDesignSystem.Spacing.xl)
            .padding(.vertical, RingDesignSystem.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                    .fill(
                        isEnabled ? 
                            LinearGradient(
                                colors: [.blue, .purple, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            ) :
                            LinearGradient(
                                colors: [.gray, .gray.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                    )
                    .shadow(
                        color: isEnabled ? 
                            .blue.opacity(glow ? 0.6 : 0.3) : 
                            .clear,
                        radius: glow ? 20 : 10,
                        x: 0,
                        y: glow ? 10 : 5
                    )
            )
            .scaleEffect(animate ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                animate = pressing
            }
        }, perform: {})
        .onAppear {
            if isEnabled {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    glow = true
                }
            }
        }
        .onChange(of: isEnabled) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    glow = true
                }
            } else {
                glow = false
            }
        }
    }
}

#Preview {
    UltraAddDeviceView(smartHomeManager: SmartHomeManager.shared)
        .preferredColorScheme(.dark)
} 