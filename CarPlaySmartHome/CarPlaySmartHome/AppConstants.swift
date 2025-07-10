import Foundation
import SwiftUI

// MARK: - App Constants

enum AppConstants {
    
    // MARK: - Animation Constants
    
    enum Animation {
        // Duration Constants
        static let quickDuration: TimeInterval = 0.2
        static let standardDuration: TimeInterval = 0.3
        static let slowDuration: TimeInterval = 0.5
        static let extraSlowDuration: TimeInterval = 1.0
        
        // Spring Animation Constants
        static let springResponse: Double = 0.6
        static let springDamping: Double = 0.8
        static let bouncySpringResponse: Double = 0.4
        static let bouncySpringDamping: Double = 0.7
        
        // Rotation and Movement
        static let fullRotation: Double = 360.0
        static let halfRotation: Double = 180.0
        static let quarterRotation: Double = 90.0
        
        // Scale Effects
        static let scalePressed: CGFloat = 0.95
        static let scaleHover: CGFloat = 1.05
        static let scaleExpanded: CGFloat = 1.2
        
        // Delays
        static let shortDelay: TimeInterval = 0.1
        static let mediumDelay: TimeInterval = 0.3
        static let longDelay: TimeInterval = 0.5
    }
    
    // MARK: - Layout Constants
    
    enum Layout {
        // Spacing
        static let extraSmallSpacing: CGFloat = 4
        static let smallSpacing: CGFloat = 8
        static let mediumSpacing: CGFloat = 16
        static let largeSpacing: CGFloat = 24
        static let extraLargeSpacing: CGFloat = 32
        
        // Padding
        static let smallPadding: CGFloat = 8
        static let mediumPadding: CGFloat = 16
        static let largePadding: CGFloat = 24
        static let extraLargePadding: CGFloat = 32
        
        // Corner Radius
        static let smallCornerRadius: CGFloat = 8
        static let mediumCornerRadius: CGFloat = 16
        static let largeCornerRadius: CGFloat = 24
        static let extraLargeCornerRadius: CGFloat = 32
        
        // Border Width
        static let thinBorder: CGFloat = 0.5
        static let standardBorder: CGFloat = 1.0
        static let thickBorder: CGFloat = 2.0
        
        // Grid Layout
        static let gridColumns: Int = 2
        static let maxGridColumns: Int = 3
        static let gridSpacing: CGFloat = 16
        
        // Device Card Dimensions
        static let deviceCardWidth: CGFloat = 160
        static let deviceCardHeight: CGFloat = 200
        static let deviceIconSize: CGFloat = 60
        static let deviceIconLargeSize: CGFloat = 80
        
        // Button Dimensions
        static let standardButtonHeight: CGFloat = 44
        static let largeButtonHeight: CGFloat = 56
        static let toggleWidth: CGFloat = 60
        static let toggleHeight: CGFloat = 30
        static let toggleThumbSize: CGFloat = 26
    }
    
    // MARK: - Visual Effects Constants
    
    enum VisualEffects {
        // Opacity Values
        static let lowOpacity: Double = 0.1
        static let mediumOpacity: Double = 0.3
        static let highOpacity: Double = 0.6
        static let nearFullOpacity: Double = 0.8
        
        // Blur Radius
        static let lightBlur: CGFloat = 10
        static let mediumBlur: CGFloat = 20
        static let heavyBlur: CGFloat = 30
        static let extraHeavyBlur: CGFloat = 40
        
        // Shadow Constants
        static let lightShadowRadius: CGFloat = 8
        static let mediumShadowRadius: CGFloat = 15
        static let heavyShadowRadius: CGFloat = 20
        static let extraHeavyShadowRadius: CGFloat = 30
        
        static let shadowOpacity: Double = 0.1
        static let darkShadowOpacity: Double = 0.3
        
        // Glow Effects
        static let glowRadiusSmall: CGFloat = 15
        static let glowRadiusMedium: CGFloat = 20
        static let glowRadiusLarge: CGFloat = 30
    }
    
    // MARK: - Device Constants
    
    enum Device {
        // Status Update Intervals
        static let statusUpdateInterval: TimeInterval = 30.0
        static let realTimeUpdateInterval: TimeInterval = 5.0
        static let backgroundUpdateInterval: TimeInterval = 300.0 // 5 minutes
        
        // Timeouts
        static let connectionTimeout: TimeInterval = 10.0
        static let operationTimeout: TimeInterval = 30.0
        
        // Limits
        static let maxDevicesPerGroup: Int = 20
        static let maxAutomationRules: Int = 50
        static let maxRecentAlerts: Int = 100
        
        // Siren Duration
        static let defaultSirenDuration: TimeInterval = 30.0
        static let maxSirenDuration: TimeInterval = 300.0 // 5 minutes
        
        // Battery Thresholds
        static let lowBatteryThreshold: Int = 20
        static let criticalBatteryThreshold: Int = 10
    }
    
    // MARK: - Performance Constants
    
    enum Performance {
        // Memory Thresholds (in MB)
        static let memoryWarningThreshold: Double = 200.0
        static let memoryCriticalThreshold: Double = 400.0
        
        // Response Time Thresholds (in seconds)
        static let fastResponseThreshold: TimeInterval = 1.0
        static let slowResponseThreshold: TimeInterval = 5.0
        
        // Cache Settings
        static let maxCacheSize: Int = 100
        static let cacheExpirationTime: TimeInterval = 3600.0 // 1 hour
        
        // Concurrent Operations
        static let maxConcurrentOperations: Int = 5
        static let maxConcurrentDownloads: Int = 3
    }
    
    // MARK: - API Constants
    
    enum API {
        // Rate Limiting
        static let maxRequestsPerMinute: Int = 60
        static let requestCooldownPeriod: TimeInterval = 1.0
        
        // Retry Configuration
        static let maxRetryAttempts: Int = 3
        static let retryBackoffMultiplier: Double = 2.0
        static let initialRetryDelay: TimeInterval = 1.0
        
        // Stream Quality
        enum StreamQuality {
            static let lowBitrate: Int = 500_000
            static let standardBitrate: Int = 1_500_000
            static let highBitrate: Int = 3_000_000
            static let ultraBitrate: Int = 6_000_000
        }
    }
    
    // MARK: - Analytics Constants
    
    enum Analytics {
        // Session Tracking
        static let maxSessionDuration: TimeInterval = 3600.0 // 1 hour
        static let sessionTimeoutPeriod: TimeInterval = 300.0 // 5 minutes
        
        // Event Limits
        static let maxEventsPerSession: Int = 1000
        static let maxCustomProperties: Int = 20
        
        // Batch Settings
        static let eventBatchSize: Int = 50
        static let maxBatchWaitTime: TimeInterval = 30.0
    }
    
    // MARK: - Accessibility Constants
    
    enum Accessibility {
        // Font Size Multipliers
        static let smallFontMultiplier: CGFloat = 0.8
        static let largeFontMultiplier: CGFloat = 1.2
        static let extraLargeFontMultiplier: CGFloat = 1.5
        
        // Touch Target Sizes
        static let minimumTouchTarget: CGFloat = 44.0
        static let recommendedTouchTarget: CGFloat = 48.0
        
        // Animation Preferences
        static let reducedMotionScale: Double = 0.2
        static let standardMotionScale: Double = 1.0
    }
    
    // MARK: - Premium Features Constants
    
    enum Premium {
        // Floating Elements
        static let maxFloatingElements: Int = 8
        static let maxFloatingOrbs: Int = 6
        static let floatingElementSize: ClosedRange<CGFloat> = 20...60
        static let floatingOrbSize: ClosedRange<CGFloat> = 10...30
        
        // Particle System
        static let maxParticles: Int = 50
        static let particleLifetime: TimeInterval = 3.0
        
        // Chart Configuration
        static let maxChartDataPoints: Int = 30
        static let chartBarMaxHeight: CGFloat = 120
        static let chartBarWidth: CGFloat = 24
        
        // Premium Animation Cycles
        static let morphingDuration: TimeInterval = 8.0
        static let glowCycleDuration: TimeInterval = 3.0
        static let rotationCycleDuration: TimeInterval = 6.0
    }
    
    // MARK: - Color Constants
    
    enum Colors {
        // System Colors (SwiftUI Color extensions)
        static let primaryBlue = Color(red: 0.0, green: 0.478, blue: 1.0)
        static let primaryPurple = Color(red: 0.686, green: 0.322, blue: 0.871)
        static let primaryGreen = Color(red: 0.298, green: 0.851, blue: 0.392)
        static let primaryOrange = Color(red: 1.0, green: 0.584, blue: 0.0)
        static let primaryRed = Color(red: 1.0, green: 0.231, blue: 0.188)
        
        // Status Colors
        static let successColor = primaryGreen
        static let warningColor = primaryOrange
        static let errorColor = primaryRed
        static let infoColor = primaryBlue
        
        // Gradient Stops
        static let gradientOpacityHigh: Double = 0.8
        static let gradientOpacityMedium: Double = 0.6
        static let gradientOpacityLow: Double = 0.4
    }
    
    // MARK: - Haptic Feedback Constants
    
    enum Haptics {
        // Feedback Intensities
        static let lightImpactStyle: UIImpactFeedbackGenerator.FeedbackStyle = .light
        static let mediumImpactStyle: UIImpactFeedbackGenerator.FeedbackStyle = .medium
        static let heavyImpactStyle: UIImpactFeedbackGenerator.FeedbackStyle = .heavy
        
        // Notification Types
        static let successNotification: UINotificationFeedbackGenerator.FeedbackType = .success
        static let warningNotification: UINotificationFeedbackGenerator.FeedbackType = .warning
        static let errorNotification: UINotificationFeedbackGenerator.FeedbackType = .error
    }
    
    // MARK: - File and Storage Constants
    
    enum Storage {
        // UserDefaults Keys
        static let notificationPreferencesKey = "notificationPreferences"
        static let localBackupKey = "localBackup"
        static let themePreferenceKey = "themePreference"
        static let lastSyncKey = "lastSyncTimestamp"
        
        // File Names
        static let backupFileName = "SmartHomeBackup"
        static let logFileName = "app_logs"
        static let crashLogFileName = "crash_reports"
        
        // File Extensions
        static let backupFileExtension = "json"
        static let logFileExtension = "log"
    }
    
    // MARK: - Version and Compatibility
    
    enum Version {
        static let currentAppVersion = "1.0.0"
        static let minimumSupportedVersion = "1.0.0"
        static let apiVersion = "v1"
        
        // Feature Flags
        static let premiumFeaturesEnabled = true
        static let analyticsEnabled = true
        static let crashReportingEnabled = true
        static let debugModeEnabled = true
    }
}

// MARK: - Convenience Extensions

extension Animation {
    static let quickSpring = Animation.spring(
        response: AppConstants.Animation.springResponse,
        dampingFraction: AppConstants.Animation.springDamping
    )
    
    static let bouncySpring = Animation.spring(
        response: AppConstants.Animation.bouncySpringResponse,
        dampingFraction: AppConstants.Animation.bouncySpringDamping
    )
    
    static let gentle = Animation.easeInOut(duration: AppConstants.Animation.standardDuration)
    static let quick = Animation.easeInOut(duration: AppConstants.Animation.quickDuration)
    static let slow = Animation.easeInOut(duration: AppConstants.Animation.slowDuration)
}

extension Color {
    static let premiumBlue = AppConstants.Colors.primaryBlue
    static let premiumPurple = AppConstants.Colors.primaryPurple
    static let premiumGreen = AppConstants.Colors.primaryGreen
    static let premiumOrange = AppConstants.Colors.primaryOrange
    static let premiumRed = AppConstants.Colors.primaryRed
}

extension CGFloat {
    static let smallSpacing = AppConstants.Layout.smallSpacing
    static let mediumSpacing = AppConstants.Layout.mediumSpacing
    static let largeSpacing = AppConstants.Layout.largeSpacing
    
    static let smallPadding = AppConstants.Layout.smallPadding
    static let mediumPadding = AppConstants.Layout.mediumPadding
    static let largePadding = AppConstants.Layout.largePadding
    
    static let smallRadius = AppConstants.Layout.smallCornerRadius
    static let mediumRadius = AppConstants.Layout.mediumCornerRadius
    static let largeRadius = AppConstants.Layout.largeCornerRadius
}