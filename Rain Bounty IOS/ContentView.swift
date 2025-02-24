//
//  ContentView.swift
//  Rain Bounty IOS
//
//  Created by Surya Swaminathan on 2/16/25.
//

import SwiftUI
import CoreLocation

class HomeSettings: ObservableObject {
    @Published var roofAreaInt: Int = 0
}

struct ContentView: View {
    
    @StateObject var gblHomeSettings = HomeSettings()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: HistoricalRainHarvestView()) {
                        Text("Historical Rain Harvest")
                            .frame(width: 150, height: 150)
                            .font(.title)
                            .bold(true)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(7)
                    NavigationLink(destination: Text("Forecasted Rain Harvest View")) {
                        Text("Forecasted Rain Harvest")
                            .frame(width: 150, height: 150)
                            .font(.title)
                            .bold(true)
                            .foregroundColor(.white)
                            .background(.green)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(7)
                }
                HStack {
                    NavigationLink(destination: Text("Learn more about Rain Harvest View")) {
                        Text("Learn \nMore")
                            .frame(width: 150, height: 150)
                            .font(.title)
                            .bold(true)
                            .foregroundColor(.white)
                            .background(.orange)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(7)
                    NavigationLink(destination: Text("Local Rain Harvest Resources")) {
                        Text("Local Rain Harvest Resources")
                            .frame(width: 150, height: 150)
                            .font(.title)
                            .bold(true)
                            .foregroundColor(.white)
                            .background(.cyan)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(7)
                }
            }
            .navigationBarItems(
                trailing: NavigationLink(
                    destination:
                        SettingsView()
                        .environmentObject(gblHomeSettings)) {
                            Image(systemName: "gear")
                                .frame(width: 50, height: 50)
                        }
            )
            
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
}



#Preview {
    ContentView()
}
