import Foundation
import UIKit


struct InterpretationResult: Identifiable, Equatable {
    let id = UUID()
    var graphType: GraphType
    var title: String
    var xAxis: AxisInfo?
    var yAxis: AxisInfo?
    var dataLines: [DataLine]
    var intersections: [IntersectionPoint]
    var overallTrend: TrendType
    var confidence: Double 
    var warnings: [String]
    var explanations: [ExplanationStep]
    var capturedImage: UIImage?
    var timestamp: Date
    
    static func == (lhs: InterpretationResult, rhs: InterpretationResult) -> Bool {
        lhs.id == rhs.id
    }
    
    var isReliable: Bool { confidence >= 0.7 }
    var isLowConfidence: Bool { confidence < 0.5 }
    
    var confidenceDescription: String {
        switch confidence {
        case 0.9...: return "Very High Confidence"
        case 0.7..<0.9: return "High Confidence"
        case 0.5..<0.7: return "Moderate Confidence"
        case 0.3..<0.5: return "Low Confidence"
        default: return "Very Low Confidence"
        }
    }
    
    var summary: String {
        var parts: [String] = []
        parts.append("This is a \(graphType.rawValue).")
        
        if let xAxis = xAxis {
            parts.append(xAxis.description + ".")
        }
        if let yAxis = yAxis {
            parts.append(yAxis.description + ".")
        }
        
        parts.append("The overall trend is \(overallTrend.description.lowercased()).")
        
        if !intersections.isEmpty {
            parts.append("There are \(intersections.count) intersection point(s).")
        }
        
        return parts.joined(separator: " ")
    }
}


struct DataLine: Identifiable, Equatable {
    let id = UUID()
    var label: String?
    var color: String?
    var points: [DataPoint]
    var segments: [LineSegment]
    var trend: TrendType
    var averageSlope: SlopeClassification
    
    var description: String {
        var desc = label ?? "A line"
        desc += " shows \(trend.description.lowercased())"
        desc += " with \(averageSlope.description.lowercased())"
        return desc
    }
}


struct ExplanationStep: Identifiable, Equatable {
    let id = UUID()
    var order: Int
    var title: String
    var description: String
    var region: CGRect? 
    var trend: TrendType?
    var hapticPattern: HapticPattern
    
    enum HapticPattern: String, Equatable {
        case none
        case rising     
        case falling     
        case steady      
        case intersection 
        case attention   
        case success    
    }
}


struct GraphRegion: Identifiable {
    let id = UUID()
    var name: String
    var bounds: CGRect
    var type: RegionType
    var explanation: String
    var hapticPattern: ExplanationStep.HapticPattern
    
    enum RegionType {
        case xAxis
        case yAxis
        case title
        case legend
        case dataLine
        case dataPoint
        case intersection
        case gridArea
    }
}


struct DemoGraph: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var image: String 
    var precomputedResult: InterpretationResult
    var difficulty: Difficulty
    
    enum Difficulty: String, CaseIterable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
    }
}

