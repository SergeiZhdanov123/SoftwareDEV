import Foundation


struct DemoGraphData: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let difficulty: DemoGraph.Difficulty
    let result: InterpretationResult
    
    
    static let samples: [DemoGraphData] = [
        linearIncreasing,
        linearDecreasing,
        twoLineIntersection,
        fluctuatingData,
        exponentialGrowth
    ]
    
    
    static let linearIncreasing = DemoGraphData(
        name: "Linear Increase",
        description: "A simple line graph showing steady growth over time",
        difficulty: .beginner,
        result: InterpretationResult(
            graphType: .lineGraph,
            title: "Linear Increase Demo",
            xAxis: AxisInfo(label: "Time (months)", minValue: 0, maxValue: 12, scale: "linear", unit: "months"),
            yAxis: AxisInfo(label: "Sales ($)", minValue: 0, maxValue: 1000, scale: "linear", unit: "dollars"),
            dataLines: [
                DataLine(
                    label: "Monthly Sales",
                    color: "blue",
                    points: (0..<12).map { DataPoint(x: Double($0), y: Double($0 * 80 + 50)) },
                    segments: [],
                    trend: .increasing,
                    averageSlope: .moderatePositive
                )
            ],
            intersections: [],
            overallTrend: .increasing,
            confidence: 0.95,
            warnings: [],
            explanations: [
                ExplanationStep(order: 1, title: "Graph Type", description: "This is a line graph.", region: nil, trend: nil, hapticPattern: .steady),
                ExplanationStep(order: 2, title: "Horizontal Axis", description: "The X-axis shows Time from 0 to 12 months.", region: nil, trend: nil, hapticPattern: .steady),
                ExplanationStep(order: 3, title: "Vertical Axis", description: "The Y-axis shows Sales from $0 to $1000.", region: nil, trend: nil, hapticPattern: .steady),
                ExplanationStep(order: 4, title: "Data Trend", description: "The graph shows a linear increase. As time increases, sales increase at a constant rate.", region: nil, trend: .increasing, hapticPattern: .rising),
                ExplanationStep(order: 5, title: "Slope", description: "The slope is positive and moderate, indicating steady growth.", region: nil, trend: nil, hapticPattern: .rising),
                ExplanationStep(order: 6, title: "Key Insight", description: "Sales grow by approximately $80 each month.", region: nil, trend: nil, hapticPattern: .success)
            ],
            capturedImage: nil,
            timestamp: Date()
        )
    )
    
    
    static let linearDecreasing = DemoGraphData(
        name: "Linear Decrease",
        description: "A line graph showing declining values",
        difficulty: .beginner,
        result: InterpretationResult(
            graphType: .lineGraph,
            title: "Linear Decrease Demo",
            xAxis: AxisInfo(label: "Days", minValue: 0, maxValue: 30, scale: "linear", unit: "days"),
            yAxis: AxisInfo(label: "Inventory", minValue: 0, maxValue: 500, scale: "linear", unit: "units"),
            dataLines: [
                DataLine(
                    label: "Stock Level",
                    color: "red",
                    points: (0..<30).map { DataPoint(x: Double($0), y: Double(500 - $0 * 15)) },
                    segments: [],
                    trend: .decreasing,
                    averageSlope: .moderateNegative
                )
            ],
            intersections: [],
            overallTrend: .decreasing,
            confidence: 0.92,
            warnings: [],
            explanations: [
                ExplanationStep(order: 1, title: "Graph Type", description: "This is a line graph.", region: nil, trend: nil, hapticPattern: .steady),
                ExplanationStep(order: 2, title: "Data Trend", description: "The graph shows a linear decrease. Values are falling steadily.", region: nil, trend: .decreasing, hapticPattern: .falling),
                ExplanationStep(order: 3, title: "Slope", description: "The slope is negative and moderate, indicating steady decline.", region: nil, trend: nil, hapticPattern: .falling),
                ExplanationStep(order: 4, title: "Key Insight", description: "Inventory decreases by about 15 units per day.", region: nil, trend: nil, hapticPattern: .success)
            ],
            capturedImage: nil,
            timestamp: Date()
        )
    )
    

    static let twoLineIntersection = DemoGraphData(
        name: "Supply & Demand",
        description: "Two lines crossing to show equilibrium point",
        difficulty: .intermediate,
        result: InterpretationResult(
            graphType: .lineGraph,
            title: "Supply and Demand Demo",
            xAxis: AxisInfo(label: "Quantity", minValue: 0, maxValue: 100, scale: "linear", unit: "units"),
            yAxis: AxisInfo(label: "Price ($)", minValue: 0, maxValue: 100, scale: "linear", unit: "dollars"),
            dataLines: [
                DataLine(label: "Supply", color: "blue", points: [], segments: [], trend: .increasing, averageSlope: .moderatePositive),
                DataLine(label: "Demand", color: "red", points: [], segments: [], trend: .decreasing, averageSlope: .moderateNegative)
            ],
            intersections: [
                IntersectionPoint(point: DataPoint(x: 50, y: 50), line1Index: 0, line2Index: 1)
            ],
            overallTrend: .constant,
            confidence: 0.88,
            warnings: [],
            explanations: [
                ExplanationStep(order: 1, title: "Graph Type", description: "This is a line graph with two lines.", region: nil, trend: nil, hapticPattern: .steady),
                ExplanationStep(order: 2, title: "Supply Line", description: "The blue line shows supply. As quantity increases, price increases.", region: nil, trend: .increasing, hapticPattern: .rising),
                ExplanationStep(order: 3, title: "Demand Line", description: "The red line shows demand. As quantity increases, price decreases.", region: nil, trend: .decreasing, hapticPattern: .falling),
                ExplanationStep(order: 4, title: "Intersection", description: "The lines intersect near quantity 50, price $50. This is the equilibrium point.", region: nil, trend: nil, hapticPattern: .intersection),
                ExplanationStep(order: 5, title: "Key Insight", description: "At equilibrium, supply equals demand at 50 units and $50 price.", region: nil, trend: nil, hapticPattern: .success)
            ],
            capturedImage: nil,
            timestamp: Date()
        )
    )
    

    static let fluctuatingData = DemoGraphData(
        name: "Stock Prices",
        description: "Data with ups and downs showing volatility",
        difficulty: .intermediate,
        result: InterpretationResult(
            graphType: .lineGraph,
            title: "Stock Price Demo",
            xAxis: AxisInfo(label: "Trading Days", minValue: 0, maxValue: 20, scale: "linear", unit: "days"),
            yAxis: AxisInfo(label: "Price ($)", minValue: 90, maxValue: 110, scale: "linear", unit: "dollars"),
            dataLines: [
                DataLine(label: "Stock Price", color: "green", points: [], segments: [], trend: .fluctuating, averageSlope: .flat)
            ],
            intersections: [],
            overallTrend: .fluctuating,
            confidence: 0.85,
            warnings: ["Data shows significant volatility"],
            explanations: [
                ExplanationStep(order: 1, title: "Graph Type", description: "This is a line graph showing stock prices.", region: nil, trend: nil, hapticPattern: .steady),
                ExplanationStep(order: 2, title: "Data Pattern", description: "The graph shows fluctuating values. Prices move up and down repeatedly.", region: nil, trend: .fluctuating, hapticPattern: .steady),
                ExplanationStep(order: 3, title: "Volatility", description: "Prices vary between $90 and $110, showing moderate volatility.", region: nil, trend: nil, hapticPattern: .attention),
                ExplanationStep(order: 4, title: "Key Insight", description: "Despite fluctuations, the overall trend is relatively flat.", region: nil, trend: nil, hapticPattern: .success)
            ],
            capturedImage: nil,
            timestamp: Date()
        )
    )
    
    static let exponentialGrowth = DemoGraphData(
        name: "Exponential Growth",
        description: "Rapidly accelerating values over time",
        difficulty: .advanced,
        result: InterpretationResult(
            graphType: .lineGraph,
            title: "Exponential Growth Demo",
            xAxis: AxisInfo(label: "Time (years)", minValue: 0, maxValue: 10, scale: "linear", unit: "years"),
            yAxis: AxisInfo(label: "Population", minValue: 0, maxValue: 1000, scale: "linear", unit: "individuals"),
            dataLines: [
                DataLine(label: "Population", color: "purple", points: [], segments: [], trend: .exponential, averageSlope: .steepPositive)
            ],
            intersections: [],
            overallTrend: .exponential,
            confidence: 0.90,
            warnings: [],
            explanations: [
                ExplanationStep(order: 1, title: "Graph Type", description: "This is a line graph showing exponential growth.", region: nil, trend: nil, hapticPattern: .steady),
                ExplanationStep(order: 2, title: "Growth Pattern", description: "Values grow slowly at first, then accelerate rapidly.", region: nil, trend: .exponential, hapticPattern: .rising),
                ExplanationStep(order: 3, title: "Slope", description: "The slope becomes increasingly steep as time progresses.", region: nil, trend: nil, hapticPattern: .rising),
                ExplanationStep(order: 4, title: "Key Insight", description: "This is exponential growth. Each period, growth rate increases.", region: nil, trend: nil, hapticPattern: .success)
            ],
            capturedImage: nil,
            timestamp: Date()
        )
    )
}

