import Foundation
import UIKit

class DeepSeekService {
    private var apiKey: String {
        guard let key = Bundle.main.infoDictionary?["DeepSeekAPIKey"] as? String, !key.isEmpty else {
            print("WARNING: DeepSeekAPIKey not found in Info.plist!")
            return ""
        }
        return key
    }
    private let url = URL(string: "https://api.deepseek.com/chat/completions")!
    
    // Note: DeepSeek doesn't natively support full image/vision analysis via API in the same way OpenAI does currently.
    // However, they *do* support textual analysis. So we use Apple Vision to extract the text & contours,
    // and feed that text to DeepSeek to generate the complex ExplanationSteps and interpretation JSON.
    func analyzeGraphData(textFromImage: String, axisX: String, axisY: String, detectedContours: String) async throws -> InterpretationResult {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = """
        You are a highly skilled graph analysis engine for a mobile app. 
        I have run local Apple Computer Vision over an image of a graph and extracted the following data:
        
        Extracted Text (OCR): \(textFromImage)
        Detected X-Axis Labels: \(axisX)
        Detected Y-Axis Labels: \(axisY)
        Detected Line/Contour points: \(detectedContours)
        
        Analyze this data and return the result EXACTLY as a JSON object matching this Swift Codable structure:
        {
          "graphType": "Line Graph" | "Bar Chart" | "Scatter Plot" | "Pie Chart" | "Diagram" | "Whiteboard" | "Unknown",
          "title": "String",
          "xAxis": { "label": "String", "minValue": Float, "maxValue": Float, "scale": "String" }, // or null
          "yAxis": { "label": "String", "minValue": Float, "maxValue": Float, "scale": "String" }, // or null
          "dataLines": [{
            "label": "String",
            "points": [{ "x": Float, "y": Float }],
            "segments": [{
              "startPoint": { "x": Float, "y": Float },
              "endPoint": { "x": Float, "y": Float },
              "trend": "Increasing" | "Decreasing" | "Constant" | "Fluctuating" | "Exponential" | "Logarithmic",
              "slope": "Steep Positive" | "Moderate Positive" | "Gentle Positive" | "Flat" | "Gentle Negative" | "Moderate Negative" | "Steep Negative"
            }],
            "trend": "Increasing" | "Decreasing" | "Constant" | "Fluctuating" | "Exponential" | "Logarithmic",
            "averageSlope": "Steep Positive" | "Moderate Positive" | "Gentle Positive" | "Flat" | "Gentle Negative" | "Moderate Negative" | "Steep Negative"
          }],
          "intersections": [],
          "overallTrend": "Increasing" | "Decreasing" | "Constant" | "Fluctuating" | "Exponential" | "Logarithmic",
          "confidence": 0.0 to 1.0,
          "warnings": ["String"],
          "explanations": [{
            "order": Int,
            "title": "String",
            "description": "String",
            "trend": "Increasing" | "Decreasing" | "Constant" | "Fluctuating" | "Exponential" | "Logarithmic" | null,
            "hapticPattern": "none" | "rising" | "falling" | "steady" | "intersection" | "attention" | "success"
          }],
          "timestamp": \(Date().timeIntervalSinceReferenceDate)
        }
        
        Return ONLY valid JSON.
        """
        
        let parameters: [String: Any] = [
            "model": "deepseek-chat", // standard DeepSeek v3
            "messages": [
                ["role": "system", "content": "You are a specialized JSON-outputting data analysis AI."],
                ["role": "user", "content": prompt]
            ],
            "response_format": ["type": "json_object"]
        ]
        
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 402 {
            throw NSError(domain: "DeepSeek", code: 402, userInfo: [NSLocalizedDescriptionKey: "Insufficient Balance or Unpaid API Key."])
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorString = String(data: data, encoding: .utf8) ?? "Unknown Error"
            print("API Error: \(errorString)")
            throw URLError(.badServerResponse)
        }
        
        let jsonResponse = try JSONDecoder().decode(DeepSeekResponse.self, from: data)
        let jsonContent = jsonResponse.choices.first?.message.content ?? "{}"
        
        // DeepSeek might wrap it in ```json ... ``` despite response_format. Strip it if so.
        let cleanedJSON = jsonContent
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            
        let resultData = cleanedJSON.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .deferredToDate
        let result = try decoder.decode(InterpretationResult.self, from: resultData)
        
        return result
    }
}

struct DeepSeekResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let content: String
    }
}
