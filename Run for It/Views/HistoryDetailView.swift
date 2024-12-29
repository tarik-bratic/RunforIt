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
                // Duration Stat Container
                VStack(spacing: 10) {
                    Text("\(run.duration)")
                        .font(.system(size: 48, weight: .bold))
                        .textCase(.uppercase)
                    Text("DURATION")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                // Distance / Speed Container
                HStack(spacing: 20) {
                    // Distance
                    VStack(spacing: 10) {
                        Text("\(run.distance) km")
                            .font(.system(size: 36, weight: .bold))
                            .textCase(.uppercase)
                        Text("DISTANCE")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: 175, maxHeight: .infinity)
                    
                    Divider()
                    
                    // Avg Speed
                    VStack(spacing: 10) {
                        Text("\(run.averageSpeed)")
                            .font(.system(size: 36, weight: .bold))
                            .textCase(.uppercase)
                        Text("AVG. TEMPO")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: 175, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: 150)
                
                Image(uiImage: run.screenshot)
                    .resizable()
                    .scaledToFit()
            }
            .padding().padding(.top, 30)
        }
        .navigationTitle("Detailed View")
    }
}

//#Preview {
//    HistoryDetailView(run: Run.sampleData())
//}
