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
                HStack{
                    VStack{
                        Image("app-logo")
                            .frame(width: 50, height: 50)
                            .mask(Rectangle().fill(Color.white))
                            
                        Text("""
    Harvest the rains
    Reap the gains!
""")
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        .font(.title3)
                        .italic()
                        .fontWeight(.bold)
                    }
                }
                HStack {
                    NavigationLink(
                        destination: HistoricalRainHarvestView().navigationTitle("Historical Rain Harvest")) {
                        Text("Plan Your Tank Size")
                            .frame(width: 150, height: 150)
                            .font(.title2)
                            .bold(true)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(7)
                    NavigationLink(
                        destination: ForecastView().navigationTitle("Forecasted Rain Harvest")) {
                        Text("Plan Your Harvest")
                            .frame(width: 150, height: 150)
                            .font(.title2)
                            .bold(true)
                            .foregroundColor(.white)
                            .background(.mint)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(7)
                }
                HStack {
                    NavigationLink(
                        destination: LearnMoreView().navigationTitle("Learn More")
                    ) {
                        Text("Learn \nMore")
                            .frame(width: 150, height: 150)
                            .font(.title2)
                            .bold(true)
                            .foregroundColor(.white)
                            .background(.teal)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(7)
                    NavigationLink(
                        destination: FAQView().navigationTitle("FAQ")
                    ) {
                        Text("Frequently Asked \nQuestions")
                            .frame(width: 150, height: 150)
                            .font(.title2)
                            .bold(true)
                            .foregroundColor(.white)
                            .background(.cyan)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(7)
                }

                HStack {
                    Text("Weather data by [Open-Meteo.com](https://Open-Meteo.com)")
                        .font(.subheadline)
                        .italic()
                }
                .padding(.top, 50)
            }
            .navigationBarItems(
                leading: Text("Rain Bounty")
                    .font(.title2)
                    .bold(true)
                    .foregroundColor(.blue)
                    .padding(.leading, 130)
                    .padding(.top, 20)
                ,
                trailing: NavigationLink(
                    destination:
                        SettingsView()
                        .environmentObject(gblHomeSettings)) {
                            Image(systemName: "gear")
                                .frame(width: 50, height: 50)
                                .padding(.trailing, 10)
                                .padding(.top, 20)
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
