import Foundation
import SwiftUI


enum AccessibilityMode: String, CaseIterable, Identifiable {
    case audio = "Audio"
    case visual = "Visual"
    case haptic = "Haptic"
    case combined = "Combined"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .audio: return "speaker.wave.3.fill"
        case .visual: return "eye.fill"
        case .haptic: return "hand.tap.fill"
        case .combined: return "square.stack.3d.up.fill"
        }
    }
    
    var description: String {
        switch self {
        case .audio: return "Voice descriptions of graphs"
        case .visual: return "High-contrast visual display"
        case .haptic: return "Vibration patterns for trends"
        case .combined: return "All accessibility modes together"
        }
    }
}


struct SpeechSettings: Equatable {
    var rate: Float = 0.5 
    var pitch: Float = 1.0 
    var volume: Float = 1.0 
    var voice: String = "en-US" 
    var autoPlay: Bool = true
    
    var rateDescription: String {
        switch rate {
        case 0.0..<0.3: return "Slow"
        case 0.3..<0.6: return "Normal"
        case 0.6..<0.8: return "Fast"
        default: return "Very Fast"
        }
    }
}

struct VisualSettings: Equatable {
    var fontSize: CGFloat = 24
    var useHighContrast: Bool = true
    var colorBlindMode: ColorBlindMode = .none
    var showTrendIcons: Bool = true
    var showConfidenceIndicator: Bool = true
    var animationsEnabled: Bool = true
    
    enum ColorBlindMode: String, CaseIterable, Identifiable {
        case none = "Standard"
        case protanopia = "Protanopia"
        case deuteranopia = "Deuteranopia"
        case tritanopia = "Tritanopia"
        case monochrome = "Monochrome"
        
        var id: String { rawValue }
    }
}


struct HapticSettings: Equatable {
    var intensity: Float = 0.8 
    var enabled: Bool = true
    var patternDuration: Double = 0.5
    var feedbackOnTap: Bool = true
    
    var intensityDescription: String {
        switch intensity {
        case 0.0..<0.3: return "Gentle"
        case 0.3..<0.7: return "Medium"
        default: return "Strong"
        }
    }
}


struct UserPreferences: Equatable {
    var primaryMode: AccessibilityMode = .combined
    var speechSettings: SpeechSettings = SpeechSettings()
    var visualSettings: VisualSettings = VisualSettings()
    var hapticSettings: HapticSettings = HapticSettings()
    var showOnboarding: Bool = true
    var isDemoMode: Bool = false
    var autoCapture: Bool = false
    var saveHistory: Bool = true
}


struct AccessibleColors {

    static let primary = Color(red: 0.0, green: 0.45, blue: 0.7)     
    static let secondary = Color(red: 0.9, green: 0.6, blue: 0.0)     
    static let tertiary = Color(red: 0.0, green: 0.6, blue: 0.5)      
    static let quaternary = Color(red: 0.8, green: 0.4, blue: 0.0)    
    
    static let success = Color(red: 0.0, green: 0.6, blue: 0.4)       
    static let warning = Color(red: 0.95, green: 0.77, blue: 0.06)    
    static let error = Color(red: 0.8, green: 0.2, blue: 0.2)         
    
    static let highContrastBackground = Color.black
    static let highContrastText = Color.white
    static let highContrastAccent = Color.yellow
    
    static func trendColor(for trend: TrendType) -> Color {
        switch trend {
        case .increasing: return success
        case .decreasing: return error
        case .constant: return primary
        case .fluctuating: return warning
        case .exponential: return tertiary
        case .logarithmic: return secondary
        }
    }
}

