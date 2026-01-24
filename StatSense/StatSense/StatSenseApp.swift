import SwiftUI

@main
struct StatSenseApp: App {
    @StateObject private var accessibilityManager = AccessibilityManager()
    @StateObject private var graphAnalyzer = GraphAnalyzer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(accessibilityManager)
                .environmentObject(graphAnalyzer)
        }
    }
}

