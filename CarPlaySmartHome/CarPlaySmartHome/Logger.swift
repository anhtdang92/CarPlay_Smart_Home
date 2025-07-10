import Foundation
import os.log

// MARK: - Advanced Logging System

final class Logger {
    static let shared = Logger()
    
    private let subsystem = Bundle.main.bundleIdentifier ?? "CarPlaySmartHome"
    
    // MARK: - Log Categories
    
    private lazy var analyticsLogger = OSLog(subsystem: subsystem, category: "Analytics")
    private lazy var apiLogger = OSLog(subsystem: subsystem, category: "API")
    private lazy var authLogger = OSLog(subsystem: subsystem, category: "Authentication")
    private lazy var deviceLogger = OSLog(subsystem: subsystem, category: "Device")
    private lazy var errorLogger = OSLog(subsystem: subsystem, category: "Error")
    private lazy var performanceLogger = OSLog(subsystem: subsystem, category: "Performance")
    private lazy var uiLogger = OSLog(subsystem: subsystem, category: "UI")
    private lazy var systemLogger = OSLog(subsystem: subsystem, category: "System")
    
    private init() {}
    
    // MARK: - Logging Methods
    
    enum LogLevel {
        case debug
        case info
        case warning
        case error
        case critical
        
        var osLogType: OSLogType {
            switch self {
            case .debug: return .debug
            case .info: return .info
            case .warning: return .default
            case .error: return .error
            case .critical: return .fault
            }
        }
        
        var emoji: String {
            switch self {
            case .debug: return "🔧"
            case .info: return "ℹ️"
            case .warning: return "⚠️"
            case .error: return "❌"
            case .critical: return "🚨"
            }
        }
    }
    
    enum Category {
        case analytics
        case api
        case authentication
        case device
        case error
        case performance
        case ui
        case system
        
        var logger: OSLog {
            switch self {
            case .analytics: return Logger.shared.analyticsLogger
            case .api: return Logger.shared.apiLogger
            case .authentication: return Logger.shared.authLogger
            case .device: return Logger.shared.deviceLogger
            case .error: return Logger.shared.errorLogger
            case .performance: return Logger.shared.performanceLogger
            case .ui: return Logger.shared.uiLogger
            case .system: return Logger.shared.systemLogger
            }
        }
    }
    
    // MARK: - Public Logging Interface
    
    func log(_ message: String, level: LogLevel = .info, category: Category = .system, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let formattedMessage = "\(level.emoji) [\(fileName):\(line)] \(function) - \(message)"
        
        os_log("%{public}@", log: category.logger, type: level.osLogType, formattedMessage)
        
        // Debug mode console output
        #if DEBUG
        print(formattedMessage)
        #endif
    }
    
    // MARK: - Convenience Methods
    
    func debug(_ message: String, category: Category = .system, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, category: category, file: file, function: function, line: line)
    }
    
    func info(_ message: String, category: Category = .system, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, category: category, file: file, function: function, line: line)
    }
    
    func warning(_ message: String, category: Category = .system, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, category: category, file: file, function: function, line: line)
    }
    
    func error(_ message: String, category: Category = .error, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, category: category, file: file, function: function, line: line)
    }
    
    func critical(_ message: String, category: Category = .error, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .critical, category: category, file: file, function: function, line: line)
    }
    
    // MARK: - Specialized Logging Methods
    
    func logAPI(_ message: String, endpoint: String? = nil, responseTime: TimeInterval? = nil) {
        var logMessage = message
        if let endpoint = endpoint {
            logMessage += " [Endpoint: \(endpoint)]"
        }
        if let responseTime = responseTime {
            logMessage += " [Response Time: \(String(format: "%.3f", responseTime))s]"
        }
        log(logMessage, level: .info, category: .api)
    }
    
    func logPerformance(_ operation: String, duration: TimeInterval, details: String? = nil) {
        var message = "\(operation) completed in \(String(format: "%.3f", duration))s"
        if let details = details {
            message += " - \(details)"
        }
        log(message, level: .info, category: .performance)
    }
    
    func logUserAction(_ action: String, context: String? = nil) {
        var message = "User Action: \(action)"
        if let context = context {
            message += " [Context: \(context)]"
        }
        log(message, level: .info, category: .analytics)
    }
    
    func logDeviceOperation(_ deviceId: String, operation: String, success: Bool, error: Error? = nil) {
        let status = success ? "SUCCESS" : "FAILED"
        var message = "Device Operation [\(deviceId)]: \(operation) - \(status)"
        
        if let error = error {
            message += " [Error: \(error.localizedDescription)]"
        }
        
        log(message, level: success ? .info : .error, category: .device)
    }
    
    func logAuthentication(_ event: String, success: Bool, details: String? = nil) {
        let status = success ? "SUCCESS" : "FAILED"
        var message = "Authentication: \(event) - \(status)"
        
        if let details = details {
            message += " [\(details)]"
        }
        
        log(message, level: success ? .info : .warning, category: .authentication)
    }
    
    // MARK: - Error Tracking
    
    func logError(_ error: Error, context: String, additionalInfo: [String: Any]? = nil) {
        var message = "Error in \(context): \(error.localizedDescription)"
        
        if let additionalInfo = additionalInfo {
            let infoString = additionalInfo.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
            message += " [Additional Info: \(infoString)]"
        }
        
        log(message, level: .error, category: .error)
    }
    
    // MARK: - Memory and Performance Tracking
    
    func logMemoryWarning() {
        let memoryUsage = getMemoryUsage()
        warning("Memory warning received. Current usage: \(String(format: "%.1f", memoryUsage))MB", category: .performance)
    }
    
    private func getMemoryUsage() -> Double {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            return Double(info.resident_size) / 1024.0 / 1024.0 // Convert to MB
        } else {
            return 0.0
        }
    }
}

// MARK: - Global Convenience Functions

func logDebug(_ message: String, category: Logger.Category = .system, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.shared.debug(message, category: category, file: file, function: function, line: line)
}

func logInfo(_ message: String, category: Logger.Category = .system, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.shared.info(message, category: category, file: file, function: function, line: line)
}

func logWarning(_ message: String, category: Logger.Category = .system, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.shared.warning(message, category: category, file: file, function: function, line: line)
}

func logError(_ message: String, category: Logger.Category = .error, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.shared.error(message, category: category, file: file, function: function, line: line)
}

func logCritical(_ message: String, category: Logger.Category = .error, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.shared.critical(message, category: category, file: file, function: function, line: line)
}