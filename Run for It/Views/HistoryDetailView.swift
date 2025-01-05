//
//  HistoryDetailView.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-29.
//

import SwiftUI

struct HistoryDetailView: View {
    let run: Run
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Duration Stat
                StatsView(value: run.duration, label: "DURATION", fontSize: 48)
                
                Divider()
                
                // Distance & Avg. Tempo
                HStack(spacing: 20) {
                    // Distance
                    StatsView(value: run.distance, label: "DISTANCE", fontSize: 36)
                    .frame(maxWidth: 175)
                    
                    Divider()
                    
                    // Avg Speed
                    StatsView(value: run.averageSpeed, label: "AVG. TEMPO", fontSize: 36)
                    .frame(maxWidth: 175)
                }
                .frame(maxHeight: 150)
                
                // Screenshot Image
                Image(uiImage: run.screenshot)
                    .resizable()
                    .scaledToFit()
            }
            .padding(.horizontal)
            .padding(.top, 30)
        }
        .navigationTitle("Detailed View")
    }
}

/// A reusable component for displaying stats
struct StatsView: View {
    let value: String
    let label: String
    let fontSize: CGFloat
    
    var body: some View {
        VStack(spacing: 10) {
            Text(value)
                .font(.system(size: fontSize, weight: .bold))
                .textCase(.uppercase)
            Text(label)
                .font(.title3)
                .foregroundColor(.gray)
        }
    }
}
