import Foundation
import UIKit
import Vision
import CoreImage


@MainActor
class GraphAnalyzer: ObservableObject {
    @Published var isAnalyzing = false
    @Published var currentResult: InterpretationResult?
    @Published var analysisProgress: Double = 0.0
    @Published var errorMessage: String?
    
    private let imageAnalyzer = ImageAnalyzer()
    private let explanationEngine = ExplanationEngine()
    

    func analyzeImage(_ image: UIImage) async -> InterpretationResult? {
        isAnalyzing = true
        analysisProgress = 0.0
        errorMessage = nil
        
        defer { isAnalyzing = false }
        
        do {

            analysisProgress = 0.1
            guard let processedImage = preprocessImage(image) else {
                throw AnalysisError.preprocessingFailed
            }
            
 
            analysisProgress = 0.2
            let graphType = await detectGraphType(processedImage)
            
     
            analysisProgress = 0.4
            let (xAxis, yAxis) = await detectAxes(processedImage)
            
      
            analysisProgress = 0.6
            let dataLines = await extractDataLines(processedImage, graphType: graphType)
            

            analysisProgress = 0.7
            let intersections = findIntersections(dataLines)
            
 
            analysisProgress = 0.8
            let overallTrend = calculateOverallTrend(dataLines)
            

            analysisProgress = 0.9
            let (explanations, confidence, warnings) = explanationEngine.generateExplanations(
                graphType: graphType,
                xAxis: xAxis,
                yAxis: yAxis,
                dataLines: dataLines,
                intersections: intersections,
                trend: overallTrend
            )
            
            analysisProgress = 1.0
            
            let result = InterpretationResult(
                graphType: graphType,
                title: "Analyzed Graph",
                xAxis: xAxis,
                yAxis: yAxis,
                dataLines: dataLines,
                intersections: intersections,
                overallTrend: overallTrend,
                confidence: confidence,
                warnings: warnings,
                explanations: explanations,
                capturedImage: image,
                timestamp: Date()
            )
            
            currentResult = result
            return result
            
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
    

    private func preprocessImage(_ image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        let context = CIContext()
        

        guard let contrastFilter = CIFilter(name: "CIColorControls") else { return image }
        contrastFilter.setValue(ciImage, forKey: kCIInputImageKey)
        contrastFilter.setValue(1.2, forKey: kCIInputContrastKey)
        
        guard let outputImage = contrastFilter.outputImage,
              let processedCGImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        
        return UIImage(cgImage: processedCGImage)
    }
    

    private func detectGraphType(_ image: UIImage) async -> GraphType {
        guard let cgImage = image.cgImage else { return .unknown }
        
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
            
            if let observations = request.results {
                let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ").lowercased()
                
               
                if text.contains("bar") || text.contains("histogram") {
                    return .barChart
                } else if text.contains("scatter") || text.contains("plot") {
                    return .scatterPlot
                } else if text.contains("pie") {
                    return .pieChart
                }
            }
        } catch {
            print("Text recognition failed: \(error)")
        }
        
       
        return .lineGraph
    }
    

    private func detectAxes(_ image: UIImage) async -> (AxisInfo?, AxisInfo?) {
        guard let cgImage = image.cgImage else { return (nil, nil) }
        
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
            
            var xAxisLabel = "X-Axis"
            var yAxisLabel = "Y-Axis"
            var foundNumbers: [Double] = []
            
            if let observations = request.results {
                for observation in observations {
                    if let text = observation.topCandidates(1).first?.string {

                        if let number = Double(text.replacingOccurrences(of: ",", with: "")) {
                            foundNumbers.append(number)
                        }
                        
                   
                        let box = observation.boundingBox
                        if box.minY < 0.15 { 
                            xAxisLabel = text
                        } else if box.minX < 0.15 { 
                            yAxisLabel = text
                        }
                    }
                }
            }
            
            let sortedNumbers = foundNumbers.sorted()
            let minVal = sortedNumbers.first ?? 0
            let maxVal = sortedNumbers.last ?? 100
            
            let xAxis = AxisInfo(label: xAxisLabel, minValue: minVal, maxValue: maxVal, scale: "linear")
            let yAxis = AxisInfo(label: yAxisLabel, minValue: minVal, maxValue: maxVal, scale: "linear")
            
            return (xAxis, yAxis)
        } catch {
            print("Axis detection failed: \(error)")
            return (nil, nil)
        }
    }
}

