//
//  RunningStatView.swift
//  Run for It
//
//  Created by Tarik Bratic on 2024-12-14.
//

import SwiftUI

struct RunningStatView: View {
    @ObservedObject var viewModel = RunViewModel()
    @State private var isPaused = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        TabView {
            VStack(spacing: 30) {
                //Tid
                Text(viewModel.duration)
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .padding(.top, 40)
                
                //Kilometer
                Text(viewModel.distance)
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                
                // Temp
                HStack {
                    // Aktuell temp
                    VStack {
                        Text("Aktuellt temp")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text(viewModel.speed)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    // Medel
                    VStack {
                        Text("Medeltempo")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("0:00")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 80)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Fortsätt eller stop
                if isPaused {
                    HStack(spacing: 20) {
                        // Fortsättt
                        Button(action: {
                            isPaused = false
                            viewModel.startRun()
                        }) {
                            Text("Fortsätt")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .frame(width: 120, height: 50)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        
                        // Stopp
                        Button(action: {
                            viewModel.stopRun()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Stopp")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 120, height: 50)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                    }
                } else {
                    // Paus
                    Button(action: {
                        isPaused = true
                        viewModel.pauseRun()
                    }) {
                        Text("Paus")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 120, height: 50)
                            .background(Color.yellow)
                            .cornerRadius(10)
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6).ignoresSafeArea())
            
            // Kartvy
            CustomMapView(
                routeCoordinates: $viewModel.routeCoordinates,
                region: $viewModel.region)
            .edgesIgnoringSafeArea(.all)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.startRun()
        }
        .onDisappear {
            viewModel.stopRun()
        }
    }
}

#Preview {
    RunningStatView()
}
