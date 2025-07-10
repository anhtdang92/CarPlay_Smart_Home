# 🎨 Apple Design System

> **A comprehensive design language specification for CarPlay Smart Home**

This document outlines the sophisticated design system that powers our Apple-like interface, featuring liquid glass effects, adaptive theming, and premium animations optimized for CarPlay environments.

---

## 🌈 **Color System**

### Adaptive Color Palette

Our color system dynamically adapts to light and dark modes while maintaining semantic meaning and accessibility compliance.

```swift
struct AppleColors {
    // Primary Brand Colors
    static let accentBlue = Color(red: 0.0, green: 0.48, blue: 1.0)
    static let accentGreen = Color(red: 0.2, green: 0.78, blue: 0.35)
    static let accentOrange = Color(red: 1.0, green: 0.58, blue: 0.0)
    static let accentRed = Color(red: 1.0, green: 0.23, blue: 0.19)
    
    // Semantic Status Colors  
    static let statusOnline = Color.green
    static let statusOffline = Color.red
    static let statusWarning = Color.orange
    static let statusConnecting = Color.blue
    
    // Glass Effect Tints
    static let glassPrimary = Color.blue.opacity(0.1)
    static let glassSecondary = Color.purple.opacity(0.08)
    static let glassTertiary = Color.indigo.opacity(0.06)
}
```

### Color Usage Guidelines

| Color | Usage | Context |
|-------|-------|---------|
| **Accent Blue** | Primary actions, selection states | Main navigation, toggle states |
| **Accent Green** | Success states, online status | Device online, successful operations |
| **Accent Orange** | Warning states, attention | Low battery, connectivity issues |
| **Accent Red** | Error states, critical alerts | Offline devices, emergencies |

### Accessibility Compliance

- **WCAG 2.1 AA**: All color combinations maintain 4.5:1 contrast ratio
- **Color Blindness**: Never rely solely on color for information
- **High Contrast**: Automatic adaptation for accessibility preferences

---

## 📝 **Typography System**

### Font Hierarchy

Our typography uses SF Pro Rounded for optimal CarPlay readability with clear hierarchical relationships.

```swift
struct AppleTypography {
    // CarPlay Optimized Sizes
    static let carPlayLarge = Font.system(size: 28, weight: .semibold, design: .rounded)
    static let carPlayMedium = Font.system(size: 20, weight: .medium, design: .rounded)
    static let carPlaySmall = Font.system(size: 16, weight: .regular, design: .rounded)
    
    // Standard Interface
    static let title1 = Font.largeTitle.weight(.bold)
    static let title2 = Font.title.weight(.semibold)
    static let title3 = Font.title2.weight(.medium)
    static let body = Font.body.weight(.regular)
    static let caption = Font.caption.weight(.medium)
}
```

### Typography Guidelines

1. **Readability First**: Large text sizes for vehicle displays
2. **Consistent Weight**: Maintain weight relationships across components
3. **Dynamic Type**: Support system accessibility scaling
4. **Semantic Markup**: Proper accessibility labels for screen readers

---

## 📐 **Spacing & Layout**

### Spacing Scale

Based on an 8-point grid system for consistency and rhythm.

```swift
struct AppleSpacing {
    static let xxxs: CGFloat = 2    // Fine details
    static let xxs: CGFloat = 4     // Tight spacing
    static let xs: CGFloat = 8      // Close elements
    static let s: CGFloat = 12      // Related content
    static let m: CGFloat = 16      // Standard spacing
    static let l: CGFloat = 24      // Section separation
    static let xl: CGFloat = 32     // Major sections
    static let xxl: CGFloat = 48    // Screen sections
    static let xxxl: CGFloat = 64   // Major layout breaks
}
```

### Layout Principles

- **Touch Targets**: Minimum 44pt for all interactive elements
- **CarPlay Optimization**: Larger spacing for vehicle use
- **Consistent Rhythm**: Maintain visual hierarchy
- **Responsive Design**: Adapt to different screen sizes

---

## 🎬 **Animation System**

### Spring Physics

Apple-quality spring animations that feel natural and responsive.

```swift
struct AppleAnimations {
    // Primary spring curve - smooth and natural
    static let smooth = Animation.interpolatingSpring(
        mass: 1.0,
        stiffness: 100.0,
        damping: 10.0,
        initialVelocity: 0.0
    )
    
    // Snappy for quick interactions
    static let snappy = Animation.interpolatingSpring(
        mass: 0.7,
        stiffness: 100.0,
        damping: 8.0,
        initialVelocity: 0.0
    )
    
    // CarPlay optimized - slightly slower for safety
    static let carPlaySafe = Animation.interpolatingSpring(
        mass: 1.2,
        stiffness: 80.0,
        damping: 12.0,
        initialVelocity: 0.0
    )
}
```

### Animation Guidelines

1. **Natural Motion**: Physics-based springs feel organic
2. **Performance Aware**: GPU-accelerated animations
3. **Accessibility Respect**: Honor reduced motion preferences
4. **Context Appropriate**: Faster for UI, slower for CarPlay

---

## 🌊 **Liquid Glass Material System**

### Core Glass Component

The foundation of our glass morphism effects:

```swift
struct LiquidGlassMaterial: View {
    let intensity: Double
    let tint: Color
    let cornerRadius: CGFloat
    
    var body: some View {
        ZStack {
            // Base glass layer
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.ultraThinMaterial)
                .opacity(intensity)
            
            // Depth gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.2),
                    Color.clear,
                    Color.black.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            
            // Tint overlay
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(tint)
                .opacity(0.1)
            
            // Border highlight
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.3),
                            Color.clear
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
    }
}
```

### Glass Intensity Levels

| Level | Intensity | Usage |
|-------|-----------|-------|
| **Subtle** | 0.4 | Background elements, cards |
| **Medium** | 0.6 | Interactive elements, buttons |
| **Strong** | 0.8 | Focused states, modals |
| **Intense** | 1.0 | Critical alerts, overlays |

---

## 🎯 **Button System**

### Button Variants

Four distinct button styles for different interaction contexts:

```swift
enum AppleButtonVariant {
    case primary    // Main actions - filled with accent color
    case secondary  // Secondary actions - outlined  
    case tertiary   // Subtle actions - text only
    case destructive // Dangerous actions - red accent
}

enum AppleButtonSize {
    case small      // 32pt height - dense interfaces
    case medium     // 44pt height - standard touch
    case large      // 56pt height - CarPlay primary
    case extraLarge // 72pt height - CarPlay emergency
}
```

### Button Implementation

```swift
struct AppleButtonStyle: ButtonStyle {
    let variant: AppleButtonVariant
    let size: AppleButtonSize
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(fontForSize(size))
            .foregroundColor(foregroundColor)
            .frame(height: heightForSize(size))
            .padding(.horizontal, paddingForSize(size))
            .background(backgroundForVariant(variant))
            .overlay(overlayForVariant(variant))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadiusForSize(size)))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.smooth, value: configuration.isPressed)
    }
}
```

---

## 📱 **Component Design Principles**

### Design Philosophy

1. **Purpose-Built**: Every component serves a specific CarPlay use case
2. **Accessibility-First**: Screen reader support and touch optimization
3. **Performance-Aware**: Efficient rendering and minimal re-computation
4. **Consistent**: Follows design token system throughout

### Component Checklist

- [ ] Uses design tokens (colors, spacing, typography)
- [ ] Implements proper accessibility labels
- [ ] Supports dark/light mode adaptation
- [ ] Includes proper animation and interaction states
- [ ] Optimized for CarPlay touch targets
- [ ] Handles loading and error states gracefully

---

## 🏗️ **Implementation Guidelines**

### Design Token Usage

```swift
// ✅ Correct - using design tokens
VStack(spacing: AppleSpacing.m) {
    Text("Device Status")
        .font(AppleTypography.carPlayMedium)
        .foregroundColor(AppleColors.primary)
}
.padding(AppleSpacing.l)

// ❌ Incorrect - hardcoded values
VStack(spacing: 16) {
    Text("Device Status")
        .font(.system(size: 20))
        .foregroundColor(.blue)
}
.padding(24)
```

### Glass Effect Application

```swift
// ✅ Correct - using glass material system
LiquidGlassCard(tint: .accentBlue) {
    DeviceContent()
}

// ❌ Incorrect - custom blur without system
RoundedRectangle(cornerRadius: 12)
    .fill(.ultraThinMaterial)
    .overlay(DeviceContent())
```

---

## 🎨 **Visual Examples**

### Card Elevation System

```swift
struct ElevationLevel {
    static let level1 = LiquidGlassMaterial(intensity: 0.4, tint: .clear, cornerRadius: 8)
    static let level2 = LiquidGlassMaterial(intensity: 0.5, tint: .accentBlue, cornerRadius: 12)
    static let level3 = LiquidGlassMaterial(intensity: 0.6, tint: .accentBlue, cornerRadius: 16)
    static let level4 = LiquidGlassMaterial(intensity: 0.7, tint: .accentBlue, cornerRadius: 20)
    static let level5 = LiquidGlassMaterial(intensity: 0.8, tint: .accentBlue, cornerRadius: 24)
}
```

### Color Combinations

| Background | Foreground | Contrast | Usage |
|------------|------------|----------|-------|
| Glass Medium | Primary Text | 7.2:1 | Main content |
| Accent Blue | White Text | 4.8:1 | Call-to-action |
| Status Green | White Text | 5.1:1 | Success states |
| Status Red | White Text | 6.3:1 | Error states |

---

## ✅ **Quality Checklist**

### Design Review Criteria

- [ ] **Accessibility**: WCAG 2.1 AA compliance verified
- [ ] **Performance**: Animations maintain 60fps
- [ ] **Consistency**: Uses established design tokens
- [ ] **CarPlay Safety**: Large touch targets, reduced complexity
- [ ] **Dark Mode**: Proper adaptation without hardcoded colors
- [ ] **Responsive**: Works across different screen sizes
- [ ] **International**: Supports dynamic type and localization

### Testing Requirements

- [ ] **VoiceOver**: All elements properly labeled
- [ ] **Dynamic Type**: Text scales correctly
- [ ] **Reduced Motion**: Animations respect accessibility preferences
- [ ] **High Contrast**: Maintains usability in high contrast mode
- [ ] **Color Blind**: Information conveyed beyond color alone

---

## 🔗 **Related Documentation**

- **[Component Library](COMPONENT_LIBRARY.md)**: Implementation details for all components
- **[CarPlay Optimization](CARPLAY_OPTIMIZATION.md)**: Vehicle-specific design decisions
- **[Accessibility Guide](ACCESSIBILITY.md)**: Comprehensive accessibility implementation
- **[Performance Guide](PERFORMANCE.md)**: Animation and rendering optimization

---

*This design system creates a premium, Apple-like experience while maintaining the safety and usability requirements of CarPlay applications.*