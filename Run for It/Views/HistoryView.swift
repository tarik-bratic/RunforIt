//
//  HistoryView.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-13.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        VStack {
            Text("History")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Your past runs will appear here")
                .foregroundColor(.gray)
                .padding()
            
            Spacer()
        }
    }
}
