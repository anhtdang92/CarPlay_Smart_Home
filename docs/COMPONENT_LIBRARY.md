# 🧩 Component Library

> **Complete reference for all UI components in CarPlay Smart Home**

This library documents every component, their props, usage patterns, and implementation details for building consistent and accessible interfaces.

---

## 🎨 **Design Components**

### 🌊 LiquidGlassMaterial

The foundation glass morphism component that creates depth and elegance.

```swift
struct LiquidGlassMaterial: View {
    let intensity: Double        // 0.0 - 1.0 glass opacity
    let tint: Color             // Color tint for context
    let cornerRadius: CGFloat   // Corner rounding
}
```

**Usage:**
```swift
LiquidGlassMaterial(
    intensity: 0.6,
    tint: .accentBlue,
    cornerRadius: 16
)
```

**Guidelines:**
- Use `intensity: 0.4-0.6` for background elements
- Use `intensity: 0.7-0.8` for interactive elements  
- Use `intensity: 0.9-1.0` for focused/modal states

---

### 🎯 LiquidGlassCard

Reusable container with glass effects and content support.

```swift
struct LiquidGlassCard<Content: View>: View {
    let tint: Color
    let cornerRadius: CGFloat
    let content: () -> Content
}
```

**Usage:**
```swift
LiquidGlassCard(tint: .accentGreen, cornerRadius: 20) {
    VStack {
        Text("Device Status")
        StatusIndicator()
    }
}
```

**Features:**
- Automatic elevation levels
- Content padding optimization
- Accessibility container support

---

## 🎮 **Interactive Components**

### 🚀 AppleButtonStyle

Premium button system with four variants and multiple sizes.

```swift
struct AppleButtonStyle: ButtonStyle {
    let variant: AppleButtonVariant  // primary, secondary, tertiary, destructive
    let size: AppleButtonSize        // small, medium, large, extraLarge
}
```

**Variants:**

| Variant | Appearance | Usage |
|---------|------------|-------|
| `primary` | Filled with accent color | Main actions, confirmations |
| `secondary` | Outlined with accent color | Secondary actions |
| `tertiary` | Text only with accent color | Subtle actions, navigation |
| `destructive` | Red accent for dangerous actions | Delete, emergency |

**Sizes:**

| Size | Height | Padding | Usage |
|------|--------|---------|-------|
| `small` | 32pt | 12pt | Dense interfaces, secondary actions |
| `medium` | 44pt | 16pt | Standard touch targets |
| `large` | 56pt | 20pt | CarPlay primary actions |
| `extraLarge` | 72pt | 24pt | CarPlay emergency buttons |

**Implementation:**
```swift
Button("Turn On") {
    device.toggle()
}
.buttonStyle(AppleButtonStyle(variant: .primary, size: .large))
```

---

### 🎛️ FuturisticToggle

Advanced toggle with glow effects and smooth animations.

```swift
struct FuturisticToggle: View {
    @Binding var isOn: Bool
    let label: String
    let accentColor: Color
}
```

**Features:**
- Smooth spring physics animation
- Glow effect when active
- Haptic feedback integration
- Accessibility support with VoiceOver

**Usage:**
```swift
FuturisticToggle(
    isOn: $device.isActive,
    label: "Security Camera",
    accentColor: .accentBlue
)
```

---

## 📱 **Layout Components**

### 🏠 StatusDashboard

System overview component with animated metrics.

```swift
struct StatusDashboard: View {
    let metrics: [DashboardMetric]
    let healthScore: Double
}

struct DashboardMetric {
    let title: String
    let value: String
    let trend: TrendDirection
    let color: Color
}
```

**Features:**
- Staggered animation loading
- Color-coded health indicators
- Real-time metric updates
- Accessibility-optimized layout

**Usage:**
```swift
StatusDashboard(
    metrics: [
        DashboardMetric(title: "Online Devices", value: "12", trend: .up, color: .green),
        DashboardMetric(title: "Battery Health", value: "94%", trend: .stable, color: .green)
    ],
    healthScore: 0.94
)
```

---

### 🔧 ModernDeviceCard

Premium device representation with status rings and actions.

```swift
struct ModernDeviceCard: View {
    let device: RingDevice
    let isExpanded: Bool
    let onToggle: () -> Void
    let onExpand: () -> Void
}
```

**Features:**
- Animated status ring showing device health
- Expandable quick actions panel
- Battery indicators for applicable devices
- 3D gradient device icons
- Haptic feedback for interactions

**Status Ring Colors:**
- 🟢 Green (90-100%): Excellent health
- 🟡 Yellow (70-89%): Good health  
- 🟠 Orange (50-69%): Fair health
- 🔴 Red (0-49%): Poor health

**Usage:**
```swift
ModernDeviceCard(
    device: cameraDevice,
    isExpanded: expandedDeviceId == device.id,
    onToggle: { device.toggle() },
    onExpand: { expandedDeviceId = device.id }
)
```

---

### 📊 ModernDeviceGrid

Grid layout with staggered animations for device cards.

```swift
struct ModernDeviceGrid: View {
    let devices: [RingDevice]
    let columns: [GridItem]
    @Binding var expandedDeviceId: String?
}
```

**Features:**
- 2-column layout optimized for CarPlay
- Staggered entrance animations
- Smooth expand/collapse transitions
- Smart spacing for touch targets

**Animation Timing:**
- Base delay: 0.1 seconds
- Stagger increment: 0.05 seconds per item
- Spring animation with `smooth` curve

---

## 🚗 **CarPlay Components**

### 🧭 CarPlayNavigation

Consistent navigation header for all CarPlay views.

```swift
struct CarPlayNavigation: View {
    let title: String
    let subtitle: String?
    let emergencyAction: (() -> Void)?
}
```

**Features:**
- Dynamic color theming
- Always-visible emergency button
- Large touch targets (minimum 44pt)
- Accessibility-optimized layout

**Usage:**
```swift
CarPlayNavigation(
    title: "Smart Home",
    subtitle: "12 devices online",
    emergencyAction: { emergencyManager.callPolice() }
)
```

---

### 🎯 FloatingActionButton

Prominent action button with pulse effects.

```swift
struct FloatingActionButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
}
```

**Features:**
- Continuous pulse animation when critical
- Scale animation on press
- Shadow effects for depth
- Large 56pt minimum touch target

**Usage:**
```swift
FloatingActionButton(
    icon: "shield.lefthalf.filled",
    color: .accentRed,
    action: { securityManager.toggleArmed() }
)
```

---

## 🎨 **Utility Components**

### 📶 DeviceStatusIndicator

Visual status representation for device health.

```swift
struct DeviceStatusIndicator: View {
    let status: DeviceConnectionStatus
    let showLabel: Bool
}

enum DeviceConnectionStatus {
    case online, offline, connecting, warning
}
```

**Status Colors:**
- 🟢 Online: Green with pulse effect
- 🔴 Offline: Red, static
- 🔵 Connecting: Blue with rotation animation
- 🟡 Warning: Orange with gentle pulse

---

### 🔋 BatteryIndicator

Smart battery level display with health predictions.

```swift
struct BatteryIndicator: View {
    let level: Double      // 0.0 - 1.0
    let isCharging: Bool
    let showPercentage: Bool
}
```

**Features:**
- Color-coded based on level (green > yellow > red)
- Charging animation when plugged in
- Low battery warnings
- Accessibility announcements

---

### 📱 LoadingSkeleton

Professional loading states while content loads.

```swift
struct LoadingSkeleton: View {
    let shape: SkeletonShape    // rectangle, circle, text
    let height: CGFloat
    let cornerRadius: CGFloat
}
```

**Animation:**
- Shimmer effect with gradient mask
- Smooth continuous animation
- Respects reduced motion preferences
- Accessibility-friendly loading announcements

---

## 🎭 **Animation Patterns**

### Entrance Animations

```swift
// Staggered grid loading
ForEach(Array(devices.enumerated()), id: \.element.id) { index, device in
    ModernDeviceCard(device: device)
        .transition(.asymmetric(
            insertion: .scale.combined(with: .opacity),
            removal: .opacity
        ))
        .animation(
            .smooth.delay(Double(index) * 0.05),
            value: devices
        )
}
```

### State Change Animations

```swift
// Toggle state with spring physics
@State private var isToggled = false

Circle()
    .fill(isToggled ? Color.green : Color.gray)
    .scaleEffect(isToggled ? 1.1 : 1.0)
    .animation(.smooth, value: isToggled)
```

---

## ♿ **Accessibility Implementation**

### VoiceOver Support

```swift
// Semantic accessibility labels
ModernDeviceCard(device: device)
    .accessibilityLabel("Security Camera, \(device.name)")
    .accessibilityHint("Double tap to toggle camera")
    .accessibilityValue(device.isOn ? "On" : "Off")
    .accessibilityAddTraits(device.isOn ? .isSelected : [])
```

### Touch Target Optimization

```swift
// Minimum 44pt touch targets
Button(action: toggle) {
    Image(systemName: "power")
}
.frame(minWidth: 44, minHeight: 44)
.contentShape(Rectangle()) // Expand touch area
```

### Dynamic Type Support

```swift
// Responsive typography
Text(device.name)
    .font(.title2)
    .minimumScaleFactor(0.8) // Prevent text clipping
    .lineLimit(2) // Allow wrapping for long names
```

---

## 🔧 **Implementation Best Practices**

### Component Composition

```swift
// ✅ Good - composable and reusable
struct DeviceControlPanel: View {
    let device: RingDevice
    
    var body: some View {
        LiquidGlassCard(tint: .accentBlue) {
            VStack(spacing: AppleSpacing.m) {
                DeviceStatusIndicator(status: device.connectionStatus)
                BatteryIndicator(level: device.batteryLevel)
                
                Button("Toggle") { device.toggle() }
                    .buttonStyle(AppleButtonStyle(variant: .primary, size: .medium))
            }
        }
    }
}
```

### State Management

```swift
// ✅ Good - clear state ownership
struct DeviceGrid: View {
    @StateObject private var viewModel = DeviceGridViewModel()
    @State private var expandedDeviceId: String?
    
    var body: some View {
        ModernDeviceGrid(
            devices: viewModel.devices,
            expandedDeviceId: $expandedDeviceId
        )
        .onAppear { viewModel.loadDevices() }
    }
}
```

### Performance Optimization

```swift
// ✅ Good - lazy loading and efficient updates
LazyVGrid(columns: columns, spacing: AppleSpacing.m) {
    ForEach(devices) { device in
        ModernDeviceCard(device: device)
            .id(device.id) // Stable identity for animations
    }
}
```

---

## 📋 **Testing Guidelines**

### Unit Testing Components

```swift
// Test component behavior
func testDeviceCardToggle() {
    let device = MockRingDevice(isOn: false)
    let card = ModernDeviceCard(device: device) { 
        device.toggle() 
    }
    
    // Simulate tap
    card.onToggle()
    XCTAssertTrue(device.isOn)
}
```

### Accessibility Testing

```swift
// Test VoiceOver accessibility
func testDeviceCardAccessibility() {
    let card = ModernDeviceCard(device: mockDevice)
    
    XCTAssertNotNil(card.accessibilityLabel)
    XCTAssertNotNil(card.accessibilityHint)
    XCTAssertTrue(card.isAccessibilityElement)
}
```

---

## 🔗 **Related Documentation**

- **[Apple Design System](APPLE_DESIGN_SYSTEM.md)**: Design tokens and system overview
- **[CarPlay Optimization](CARPLAY_OPTIMIZATION.md)**: Vehicle-specific considerations
- **[Performance Guide](PERFORMANCE.md)**: Animation and rendering optimization
- **[Accessibility Guide](ACCESSIBILITY.md)**: Inclusive design implementation

---

*These components form the building blocks of our premium CarPlay interface, each designed for maximum usability, accessibility, and visual appeal.*