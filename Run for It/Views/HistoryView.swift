//
//  HistoryView.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-13.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var runViewModel: RunViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(runViewModel.runHistory) { run in
                        NavigationLink(destination: HistoryDetailView(run: run)) {
                            HistoryCard(run: run)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 10)
                }
                .padding(.top)
            }
            .navigationTitle("Previous Runs")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

/// A reuseable card view for displaying run history
struct HistoryCard: View {
    let run: Run
    
    var body: some View {
        VStack(spacing: 10) {
            // Date and time
            HStack {
                Text("\(run.date.formatted(date: .long, time: .omitted))")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                
                Spacer()
                
                Text("\(run.date.formatted(date: .omitted, time: .shortened))")
                    .foregroundColor(.white)
            }
            
            // Duration and distance stats
            HStack(spacing: 20) {
                StatText(label: "Duration", value: run.duration)
                StatText(label: "Distance", value: run.distance)
            }
            
            // Instruction Text
            Text("(tap to view in detail)")
                .foregroundColor(.white)
                .opacity(0.2)
                .italic()
        }
        .padding()
        .frame(maxHeight: 115)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.gray, Color.gray.opacity(0.5)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
    }
}

/// A reusable component for stat text
struct StatText: View {
    let label: String
    let value: String
    
    var body: some View {
        Text("\(label): \(value)")
            .foregroundColor(.white)
            .font(.system(size: 20))
            .italic()
    }
}
