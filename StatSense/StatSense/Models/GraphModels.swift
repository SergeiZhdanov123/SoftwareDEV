import Foundation
import CoreGraphics


enum GraphType: String, CaseIterable, Identifiable {
    case lineGraph = "Line Graph"
    case barChart = "Bar Chart"
    case scatterPlot = "Scatter Plot"
    case pieChart = "Pie Chart"
    case diagram = "Diagram"
    case whiteboard = "Whiteboard"
    case unknown = "Unknown"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .lineGraph: return "chart.line.uptrend.xyaxis"
        case .barChart: return "chart.bar.fill"
        case .scatterPlot: return "chart.dots.scatter"
        case .pieChart: return "chart.pie.fill"
        case .diagram: return "rectangle.3.group"
        case .whiteboard: return "rectangle.on.rectangle"
        case .unknown: return "questionmark.circle"
        }
    }
}


enum TrendType: String, CaseIterable {
    case increasing = "Increasing"
    case decreasing = "Decreasing"
    case constant = "Constant"
    case fluctuating = "Fluctuating"
    case exponential = "Exponential"
    case logarithmic = "Logarithmic"
    
    var icon: String {
        switch self {
        case .increasing: return "↑"
        case .decreasing: return "↓"
        case .constant: return "↔"
        case .fluctuating: return "↕"
        case .exponential: return "⤴"
        case .logarithmic: return "⤵"
        }
    }
    
    var description: String {
        switch self {
        case .increasing: return "Values are rising"
        case .decreasing: return "Values are falling"
        case .constant: return "Values remain stable"
        case .fluctuating: return "Values vary up and down"
        case .exponential: return "Values grow rapidly"
        case .logarithmic: return "Growth rate is slowing"
        }
    }
}


enum SlopeClassification: String {
    case steepPositive = "Steep Positive"
    case moderatePositive = "Moderate Positive"
    case gentlePositive = "Gentle Positive"
    case flat = "Flat"
    case gentleNegative = "Gentle Negative"
    case moderateNegative = "Moderate Negative"
    case steepNegative = "Steep Negative"
    
    var description: String {
        switch self {
        case .steepPositive: return "The slope is positive and steep"
        case .moderatePositive: return "The slope is positive with moderate incline"
        case .gentlePositive: return "The slope is positive but gentle"
        case .flat: return "The line is approximately horizontal"
        case .gentleNegative: return "The slope is negative but gentle"
        case .moderateNegative: return "The slope is negative with moderate decline"
        case .steepNegative: return "The slope is negative and steep"
        }
    }
    
    static func from(angle: Double) -> SlopeClassification {
        let degrees = angle * 180 / .pi
        switch degrees {
        case 60...: return .steepPositive
        case 30..<60: return .moderatePositive
        case 5..<30: return .gentlePositive
        case -5..<5: return .flat
        case -30..<(-5): return .gentleNegative
        case -60..<(-30): return .moderateNegative
        default: return .steepNegative
        }
    }
}


struct DataPoint: Identifiable, Equatable {
    let id = UUID()
    var x: Double
    var y: Double
    var label: String?
    
    var cgPoint: CGPoint {
        CGPoint(x: x, y: y)
    }
}


struct AxisInfo: Equatable {
    var label: String
    var minValue: Double
    var maxValue: Double
    var scale: String
    var unit: String?
    
    var range: Double { maxValue - minValue }
    
    var description: String {
        var desc = "\(label) axis ranges from \(formatValue(minValue)) to \(formatValue(maxValue))"
        if let unit = unit {
            desc += " \(unit)"
        }
        return desc
    }
    
    private func formatValue(_ value: Double) -> String {
        if value == floor(value) {
            return String(format: "%.0f", value)
        }
        return String(format: "%.2f", value)
    }
}


struct LineSegment: Identifiable, Equatable {
    let id = UUID()
    var startPoint: DataPoint
    var endPoint: DataPoint
    var trend: TrendType
    var slope: SlopeClassification
    
    var description: String {
        "From (\(startPoint.x), \(startPoint.y)) to (\(endPoint.x), \(endPoint.y)): \(slope.description)"
    }
}

struct IntersectionPoint: Identifiable, Equatable {
    let id = UUID()
    var point: DataPoint
    var line1Index: Int
    var line2Index: Int
    
    var description: String {
        "Lines intersect at approximately x = \(String(format: "%.1f", point.x)), y = \(String(format: "%.1f", point.y))"
    }
}

