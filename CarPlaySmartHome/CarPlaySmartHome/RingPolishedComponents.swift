import SwiftUI
import Charts

// MARK: - Premium Card Components

struct PremiumCard<Content: View>: View {
    let content: Content
    let style: CardStyle
    @State private var isPressed = false
    @State private var isHovered = false
    
    enum CardStyle {
        case elevated, glass, gradient, minimal
        
        var shadowRadius: CGFloat {
            switch self {
            case .elevated: return 12
            case .glass: return 8
            case .gradient: return 16
            case .minimal: return 4
            }
        }
        
        var shadowOpacity: Double {
            switch self {
            case .elevated: return 0.15
            case .glass: return 0.1
            case .gradient: return 0.2
            case .minimal: return 0.08
            }
        }
    }
    
    init(style: CardStyle = .elevated, @ViewBuilder content: () -> Content) {
        self.style = style
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(RingDesignSystem.Spacing.lg)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.xl))
            .shadow(
                color: RingDesignSystem.Colors.ringBlue.opacity(style.shadowOpacity),
                radius: style.shadowRadius + (isHovered ? 4 : 0),
                x: 0,
                y: (style.shadowRadius / 2) + (isHovered ? 2 : 0)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(RingDesignSystem.Animations.quick, value: isPressed)
            .animation(RingDesignSystem.Animations.gentle, value: isHovered)
            .onTapGesture {
                withAnimation(RingDesignSystem.Animations.quick) {
                    isPressed = true
                }
                RingDesignSystem.Haptics.light()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(RingDesignSystem.Animations.quick) {
                        isPressed = false
                    }
                }
            }
            .onHover { hovering in
                isHovered = hovering
            }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .elevated:
            RingDesignSystem.Colors.Fill.primary
        case .glass:
            RingDesignSystem.Colors.Fill.secondary
                .opacity(0.8)
        case .gradient:
            LinearGradient(
                colors: [
                    RingDesignSystem.Colors.ringBlue.opacity(0.1),
                    RingDesignSystem.Colors.ringBlue.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .minimal:
            RingDesignSystem.Colors.Fill.secondary
        }
    }
}

// MARK: - Advanced Status Indicators

struct AdvancedStatusIndicator: View {
    let status: DeviceStatus
    let size: Size
    let showLabel: Bool
    @State private var isPulsing = false
    
    enum Size {
        case small, medium, large
        
        var diameter: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 12
            case .large: return 16
            }
        }
        
        var pulseScale: CGFloat {
            switch self {
            case .small: return 1.5
            case .medium: return 1.8
            case .large: return 2.2
            }
        }
    }
    
    var body: some View {
        HStack(spacing: RingDesignSystem.Spacing.xs) {
            ZStack {
                // Pulse effect for active states
                if status == .motion || status == .recording {
                    Circle()
                        .fill(status.color.opacity(0.3))
                        .frame(width: size.diameter * size.pulseScale, height: size.diameter * size.pulseScale)
                        .scaleEffect(isPulsing ? 1.0 : 0.5)
                        .opacity(isPulsing ? 0.0 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: isPulsing
                        )
                }
                
                // Main indicator
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [status.color, status.color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size.diameter, height: size.diameter)
                    .shadow(color: status.color.opacity(0.3), radius: 2, x: 0, y: 1)
            }
            .onAppear {
                if status == .motion || status == .recording {
                    isPulsing = true
                }
            }
            
            if showLabel {
                Text(status.description)
                    .font(RingDesignSystem.Typography.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(status.color)
            }
        }
    }
}

// MARK: - Sophisticated Progress Indicators

struct CircularProgressView: View {
    let progress: Double
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color
    let showPercentage: Bool
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    LinearGradient(
                        colors: [color, color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(RingDesignSystem.Animations.smooth, value: animatedProgress)
            
            if showPercentage {
                Text("\(Int(progress * 100))%")
                    .font(RingDesignSystem.Typography.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            }
        }
        .onAppear {
            animatedProgress = progress
        }
        .onChange(of: progress) { newValue in
            animatedProgress = newValue
        }
    }
}

struct LinearProgressView: View {
    let progress: Double
    let height: CGFloat
    let color: Color
    let showLabel: Bool
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xs) {
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(color.opacity(0.2))
                    .frame(height: height)
                
                // Progress bar
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: animatedProgress * UIScreen.main.bounds.width * 0.8, height: height)
                    .animation(RingDesignSystem.Animations.smooth, value: animatedProgress)
            }
            
            if showLabel {
                HStack {
                    Text("Progress")
                        .font(RingDesignSystem.Typography.caption1)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(progress * 100))%")
                        .font(RingDesignSystem.Typography.caption1)
                        .fontWeight(.medium)
                        .foregroundColor(color)
                }
            }
        }
        .onAppear {
            animatedProgress = progress
        }
        .onChange(of: progress) { newValue in
            animatedProgress = newValue
        }
    }
}

// MARK: - Premium Loading States

struct PremiumLoadingView: View {
    let title: String
    let subtitle: String
    let progress: Double
    @State private var rotationAngle = 0.0
    @State private var pulseScale = 1.0
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        VStack(spacing: RingDesignSystem.Spacing.xl) {
            // Animated logo with multiple effects
            ZStack {
                // Outer ring
                Circle()
                    .stroke(RingDesignSystem.Colors.ringBlue.opacity(0.1), lineWidth: 3)
                    .frame(width: 100, height: 100)
                
                // Progress ring
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [
                                RingDesignSystem.Colors.ringBlue,
                                RingDesignSystem.Colors.ringBlue.opacity(0.6)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                    .animation(RingDesignSystem.Animations.smooth, value: progress)
                
                // Rotating inner circle
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                RingDesignSystem.Colors.ringBlue.opacity(0.2),
                                RingDesignSystem.Colors.ringBlue.opacity(0.05)
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 40
                        )
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(rotationAngle))
                    .animation(
                        Animation.linear(duration: 8)
                            .repeatForever(autoreverses: false),
                        value: rotationAngle
                    )
                
                // Center icon
                Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(RingDesignSystem.Colors.ringBlue)
                    .scaleEffect(pulseScale)
                    .animation(
                        Animation.easeInOut(duration: 2)
                            .repeatForever(autoreverses: true),
                        value: pulseScale
                    )
            }
            .onAppear {
                rotationAngle = 360
                pulseScale = 1.1
            }
            
            VStack(spacing: RingDesignSystem.Spacing.md) {
                Text(title)
                    .font(RingDesignSystem.Typography.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                
                Text(subtitle)
                    .font(RingDesignSystem.Typography.subheadline)
                    .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    .multilineTextAlignment(.center)
                
                // Shimmer progress bar
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(RingDesignSystem.Colors.ringBlue.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    RingDesignSystem.Colors.ringBlue.opacity(0.6),
                                    Color.clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 60, height: 8)
                        .offset(x: shimmerOffset)
                        .animation(
                            Animation.linear(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: shimmerOffset
                        )
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, RingDesignSystem.Spacing.xl)
            }
        }
        .padding(RingDesignSystem.Spacing.xl)
        .liquidGlass(cornerRadius: RingDesignSystem.CornerRadius.xl)
        .onAppear {
            shimmerOffset = 200
        }
    }
}

// MARK: - Advanced Data Visualization

struct AdvancedChartCard: View {
    let title: String
    let data: [ChartDataPoint]
    let chartType: ChartType
    @State private var selectedPoint: ChartDataPoint?
    
    enum ChartType {
        case line, area, bar, donut
    }
    
    var body: some View {
        PremiumCard(style: .elevated) {
            VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.lg) {
                HStack {
                    Text(title)
                        .font(RingDesignSystem.Typography.headline)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                    
                    Spacer()
                    
                    if let selectedPoint = selectedPoint {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(selectedPoint.label)
                                .font(RingDesignSystem.Typography.caption1)
                                .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                            
                            Text("\(Int(selectedPoint.value))")
                                .font(RingDesignSystem.Typography.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(RingDesignSystem.Colors.ringBlue)
                        }
                        .padding(.horizontal, RingDesignSystem.Spacing.sm)
                        .padding(.vertical, RingDesignSystem.Spacing.xs)
                        .background(
                            RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.sm)
                                .fill(RingDesignSystem.Colors.ringBlue.opacity(0.1))
                        )
                    }
                }
                
                Chart {
                    ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                        switch chartType {
                        case .line:
                            LineMark(
                                x: .value("Time", point.label),
                                y: .value("Value", point.value)
                            )
                            .foregroundStyle(RingDesignSystem.Colors.ringBlue)
                            .lineStyle(StrokeStyle(lineWidth: 3))
                            
                            PointMark(
                                x: .value("Time", point.label),
                                y: .value("Value", point.value)
                            )
                            .foregroundStyle(RingDesignSystem.Colors.ringBlue)
                            .symbolSize(selectedPoint?.label == point.label ? 20 : 12)
                            
                        case .area:
                            AreaMark(
                                x: .value("Time", point.label),
                                y: .value("Value", point.value)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        RingDesignSystem.Colors.ringBlue.opacity(0.3),
                                        RingDesignSystem.Colors.ringBlue.opacity(0.1)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            
                        case .bar:
                            BarMark(
                                x: .value("Time", point.label),
                                y: .value("Value", point.value)
                            )
                            .foregroundStyle(RingDesignSystem.Colors.ringBlue)
                            
                        case .donut:
                            SectorMark(
                                angle: .value("Value", point.value),
                                innerRadius: .ratio(0.6),
                                angularInset: 2
                            )
                            .foregroundStyle(by: .value("Category", point.label))
                        }
                    }
                }
                .frame(height: 200)
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
                .chartXAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                    }
                }
                .chartOverlay { proxy in
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let location = value.location
                                    if let point = proxy.value(atX: location.x, as: String.self) {
                                        selectedPoint = data.first { $0.label == point }
                                    }
                                }
                                .onEnded { _ in
                                    selectedPoint = nil
                                }
                        )
                }
            }
        }
    }
}

// MARK: - Sophisticated Action Buttons

struct PremiumActionButton: View {
    let title: String
    let icon: String
    let style: ButtonStyle
    let action: () -> Void
    @State private var isPressed = false
    @State private var isHovered = false
    
    enum ButtonStyle {
        case primary, secondary, danger, success
        
        var backgroundColor: Color {
            switch self {
            case .primary: return RingDesignSystem.Colors.ringBlue
            case .secondary: return RingDesignSystem.Colors.Fill.secondary
            case .danger: return RingDesignSystem.Colors.ringRed
            case .success: return RingDesignSystem.Colors.ringGreen
            }
        }
        
        var textColor: Color {
            switch self {
            case .primary, .danger, .success: return .white
            case .secondary: return RingDesignSystem.Colors.Foreground.primary
            }
        }
        
        var borderColor: Color {
            switch self {
            case .primary, .danger, .success: return Color.clear
            case .secondary: return RingDesignSystem.Colors.Separator.primary
            }
        }
    }
    
    var body: some View {
        Button(action: {
            action()
            RingDesignSystem.Haptics.medium()
        }) {
            HStack(spacing: RingDesignSystem.Spacing.sm) {
                Image(systemName: icon)
                    .font(.title3)
                
                Text(title)
                    .font(RingDesignSystem.Typography.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(style.textColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, RingDesignSystem.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                    .fill(
                        LinearGradient(
                            colors: [
                                style.backgroundColor,
                                style.backgroundColor.opacity(0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: RingDesignSystem.CornerRadius.lg)
                            .stroke(style.borderColor, lineWidth: 1)
                    )
            )
            .shadow(
                color: style.backgroundColor.opacity(0.3),
                radius: isHovered ? 8 : 4,
                x: 0,
                y: isHovered ? 4 : 2
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(RingDesignSystem.Animations.quick, value: isPressed)
        .animation(RingDesignSystem.Animations.gentle, value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Advanced Information Cards

struct InfoCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let icon: String
    let color: Color
    let trend: Trend?
    
    struct Trend {
        let value: String
        let direction: TrendDirection
        let color: Color
        
        enum TrendDirection {
            case up, down, neutral
        }
    }
    
    var body: some View {
        PremiumCard(style: .minimal) {
            HStack(spacing: RingDesignSystem.Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }
                
                // Content
                VStack(alignment: .leading, spacing: RingDesignSystem.Spacing.xs) {
                    Text(title)
                        .font(RingDesignSystem.Typography.subheadline)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.secondary)
                    
                    Text(value)
                        .font(RingDesignSystem.Typography.title1)
                        .fontWeight(.bold)
                        .foregroundColor(RingDesignSystem.Colors.Foreground.primary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(RingDesignSystem.Typography.caption1)
                            .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
                    }
                }
                
                Spacer()
                
                // Trend indicator
                if let trend = trend {
                    VStack(alignment: .trailing, spacing: 2) {
                        HStack(spacing: 2) {
                            Image(systemName: trend.direction == .up ? "arrow.up.right" : "arrow.down.right")
                                .font(.caption)
                                .foregroundColor(trend.color)
                            
                            Text(trend.value)
                                .font(RingDesignSystem.Typography.caption1)
                                .fontWeight(.medium)
                                .foregroundColor(trend.color)
                        }
                        
                        Text("vs last period")
                            .font(RingDesignSystem.Typography.caption2)
                            .foregroundColor(RingDesignSystem.Colors.Foreground.tertiary)
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Structures

struct ChartDataPoint {
    let label: String
    let value: Double
    let secondaryValue: Double?
    
    init(label: String, value: Double, secondaryValue: Double? = nil) {
        self.label = label
        self.value = value
        self.secondaryValue = secondaryValue
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: RingDesignSystem.Spacing.lg) {
        PremiumLoadingView(
            title: "Loading Devices",
            subtitle: "Connecting to Ring network...",
            progress: 0.7
        )
        
        PremiumActionButton(
            title: "Activate Siren",
            icon: "speaker.wave.3.fill",
            style: .danger
        ) {
            print("Siren activated")
        }
        
        InfoCard(
            title: "Motion Events",
            value: "127",
            subtitle: "This week",
            icon: "sensor.tag.radiowaves.forward.fill",
            color: RingDesignSystem.Colors.ringOrange,
            trend: InfoCard.Trend(
                value: "+12%",
                direction: .up,
                color: RingDesignSystem.Colors.ringGreen
            )
        )
    }
    .padding()
} 