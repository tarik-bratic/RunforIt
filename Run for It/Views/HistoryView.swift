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
                LazyVStack {
                    ForEach(runViewModel.runHistory) { run in
                        NavigationLink(destination: HistoryDetailView(run: run)) {
                            VStack(spacing: 10) {
                                // Date Container
                                HStack {
                                    // Date
                                    Text("\(run.date.formatted(date: .long, time: .omitted))")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .font(.system(size: 18))
                                    
                                    Spacer()
                                    
                                    // Time
                                    Text("\(run.date.formatted(date: .omitted, time: .shortened))")
                                        .foregroundColor(.white)
                                }
                                
                                // Stat Container
                                HStack(spacing: 20) {
                                    Text("Duration: \(run.duration)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .italic()
                                    Text("Distance: \(run.distance)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .italic()
                                }
                                
                                // Text Container
                                Text("(tap to view in detail)")
                                    .foregroundColor(.white)
                                    .opacity(0.2)
                                    .italic()
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 115)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color.gray, Color.gray.opacity(0.5)]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ))
                            )
                        }
                    }
                    .padding(.bottom, 10)
                }
                .padding()
            }
            .navigationTitle("Previous Runs")
        }
    }
}

//#Preview {
//    HistoryView()
//        .environmentObject({
//            let viewModel = RunViewModel()
//            viewModel.runHistory = Run.sampleData() // Add temporary data
//            return viewModel
//        }())
//}
