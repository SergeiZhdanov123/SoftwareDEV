import SwiftUI

struct DemoModeView: View {
    @EnvironmentObject var accessibilityManager: AccessibilityManager
    @EnvironmentObject var graphAnalyzer: GraphAnalyzer
    
    @State private var selectedDemo: DemoGraphData?
    @State private var showingResults = false
    @State private var showingQRCode = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    demoHeader
                    

                    quickModeSwitcher
                    

                    demoGraphsSection


                    qrCodeSection
                }
                .padding()
            }
            .navigationTitle("Demo Mode")
            .sheet(isPresented: $showingResults) {
                if let demo = selectedDemo {
                    ResultsView(result: demo.result)
                }
            }
            .sheet(isPresented: $showingQRCode) {
                QRCodeSheet()
            }
        }
        .onAppear {
            accessibilityManager.preferences.isDemoMode = true
        }
    }
    

    private var demoHeader: some View {
        VStack(spacing: 12) {
            Image(systemName: "play.rectangle.fill")
                .font(.system(size: 50))
                .foregroundColor(AccessibleColors.primary)
            
            Text("TSA Judge Demo")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Experience StatSense accessibility features with preloaded sample graphs. No setup required.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    

    private var quickModeSwitcher: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Mode Switch")
                .font(.headline)
            
            HStack(spacing: 12) {
                ForEach(AccessibilityMode.allCases) { mode in
                    Button(action: { accessibilityManager.setMode(mode) }) {
                        VStack(spacing: 8) {
                            Image(systemName: mode.icon)
                                .font(.title2)
                            Text(mode.rawValue)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            accessibilityManager.preferences.primaryMode == mode
                                ? AccessibleColors.primary.opacity(0.2)
                                : Color(.systemGray6)
                        )
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    accessibilityManager.preferences.primaryMode == mode
                                        ? AccessibleColors.primary
                                        : Color.clear,
                                    lineWidth: 2
                                )
                        )
                    }
                    .foregroundColor(
                        accessibilityManager.preferences.primaryMode == mode
                            ? AccessibleColors.primary
                            : .primary
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
    

    private var demoGraphsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sample Graphs")
                .font(.headline)
            
            ForEach(DemoGraphData.samples) { demo in
                DemoGraphCard(demo: demo) {
                    selectedDemo = demo
                    showingResults = true
                    accessibilityManager.speak("Loading \(demo.name)")
                }
            }
        }
    }
    

    private var qrCodeSection: some View {
        Button(action: { showingQRCode = true }) {
            HStack {
                Image(systemName: "qrcode")
                    .font(.title)
                
                VStack(alignment: .leading) {
                    Text("Show Demo QR Code")
                        .font(.headline)
                    Text("Scan to view project explanation")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .padding()
            .background(AccessibleColors.primary.opacity(0.1))
            .cornerRadius(12)
        }
        .foregroundColor(.primary)
    }
}


struct DemoGraphCard: View {
    let demo: DemoGraphData
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {

                Image(systemName: demo.result.graphType.icon)
                    .font(.system(size: 40))
                    .foregroundColor(AccessibleColors.primary)
                    .frame(width: 70, height: 70)
                    .background(AccessibleColors.primary.opacity(0.1))
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(demo.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(demo.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack {
                        TrendIconView(trend: demo.result.overallTrend, size: 16)
                        Text(demo.difficulty.rawValue)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(difficultyColor.opacity(0.2))
                            .foregroundColor(difficultyColor)
                            .cornerRadius(4)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5)
        }
        .accessibilityLabel("\(demo.name). \(demo.description). Difficulty: \(demo.difficulty.rawValue)")
    }
    
    private var difficultyColor: Color {
        switch demo.difficulty {
        case .beginner: return AccessibleColors.success
        case .intermediate: return AccessibleColors.warning
        case .advanced: return AccessibleColors.error
        }
    }
}

