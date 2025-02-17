//
//  ContentView.swift
//  Rain Bounty IOS
//
//  Created by Surya Swaminathan on 2/16/25.
//

import SwiftUI

class HomeSettings: ObservableObject {
    @Published var roofAreaInt: Int = 0
}

struct ContentView: View {
    
    @StateObject var gblHomeSettings = HomeSettings()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello, World!")
            }
            .navigationBarItems(
                trailing: NavigationLink(
                    destination:
                        SettingsView()
                        .environmentObject(gblHomeSettings),
                    label: {
                        Image(systemName: "gear")
                    }
                )
            )
        }
    }
}
struct SettingsView: View {
    @EnvironmentObject var gblHomeSettings: HomeSettings
    
    @AppStorage("uiStateWaterTankSizeStr") var uiStateWaterTankSizeStr: String = ""
    @AppStorage("uiStateWaterCostUsdStr") var uiStateWaterCostUsdStr: String = ""
    
    @AppStorage("roofAreaInt") var roofAreaInt: Int = 0
    @AppStorage("gardenAreaInt") var gardenAreaInt: Int = 0
    @AppStorage("waterTankSizeInt") var waterTankSizeInt: Int = 100
    @AppStorage("waterCostUsdDouble") var waterCostUsdDouble: Double = 2.38

    var body: some View {
        Form{
            Section (header: Text("Home Info"),
                     footer: Text("This data allows us to simulate your rainfall based of your home and garden measurments."))
            {
                
                //Roof area settings navigation link
                NavigationLink(
                    destination:
                        RoofCalculatorView()
                        .environmentObject(gblHomeSettings),
                    label: {
                        HStack{
                            Text("Roof area")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(roofAreaInt) sqft")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                )
                
                //Garden area settings navigation link
                NavigationLink(
                    destination:
                        GardenCalculatorView(),
                    label: {
                        HStack{
                            Text("Garden area")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(gardenAreaInt) sqft")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                )
                
                //Water tank size
                HStack{
                    Text("Water Tank Size")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    TextField("", text: $uiStateWaterTankSizeStr)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100, height: nil, alignment: .trailing)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: uiStateWaterTankSizeStr) {
                            waterTankSizeInt = Int(uiStateWaterTankSizeStr) ?? 0
                        }
                    
                    Text(" gal")
                        .frame(width:40, height:nil, alignment: .trailing)
                }
            } //end-Section
            
            Section (header: Text("City / Municipal info"),
                     footer: Text("This data allows us to simulate your water costs and potential savings."))
                {
                
                //Water Cost settings
                HStack{
                    Text("Water Cost")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    TextField("", text: $uiStateWaterCostUsdStr)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100, height: nil, alignment: .trailing)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: uiStateWaterCostUsdStr) {
                            waterCostUsdDouble = Double(uiStateWaterCostUsdStr) ?? 0.0
                        }
                    
                    Text(" usd")
                        .frame(width:40, height:nil, alignment: .trailing)
                }
            }
        
        }
        .navigationTitle(Text("Settings"))
    }
}

struct RoofCalculatorView: View {
    @EnvironmentObject var gblHomeSettings: HomeSettings

    @AppStorage("uiStateRoofSizeToggleOn") var uiStateRoofSizeToggleOn: Bool = false
    @AppStorage("uiStateRoofSizeStr") var uiStateRoofSizeStr: String = ""
    @AppStorage("uiStateHouseLength") var uiStateHouseLength: String = ""
    @AppStorage("uiStateHouseWidth") var uiStateHouseWidth: String = ""
    
    @AppStorage("roofAreaInt") var roofAreaInt: Int = 0
    
    var body: some View {
        Form{
            Section (header: Text("Roof Size"), footer: Text("This data allows us to estimate your rainwater collection metrics based of your collection/roof area."))
            {
                //Toggle(isOn: $uiStateRoofSizeToggleOn, label: {Text("Enter Roof Area directly")})
                //    .onChange(of: uiStateRoofSizeToggleOn) {
                //        computeRoofArea()
                //    }
                
                Picker("Roof area options?", selection: $uiStateRoofSizeToggleOn)
                {
                    Text("Direct").tag(true)
                    Text("L x W ").tag(false)
                }
                .pickerStyle(.segmented)
                .onChange(of: uiStateRoofSizeToggleOn) {
                     computeRoofArea()
                }
                
                
                if(uiStateRoofSizeToggleOn)
                {
                    TextField("Enter your roof size here (sqft)", text: $uiStateRoofSizeStr)
                       .keyboardType(.numberPad)
                       .textFieldStyle(.roundedBorder)
                       .onChange(of: uiStateRoofSizeStr) {
                           computeRoofArea()
                       }
                }
                else {
                    TextField("Enter your house length here (ft)", text: $uiStateHouseLength)
                       .keyboardType(.numberPad)
                       .textFieldStyle(.roundedBorder)
                       .onChange(of: uiStateHouseLength) {
                           computeRoofArea()
                       }
                    
                    TextField("Enter your house width here (ft)", text: $uiStateHouseWidth)
                       .keyboardType(.numberPad)
                       .textFieldStyle(.roundedBorder)
                       .onChange(of: uiStateHouseWidth) {
                           computeRoofArea()
                       }
                    
                    
                    Text ("Roof area (sqft): \(roofAreaInt)")
                }

                
            }
        
        }
        .navigationTitle(Text("Roof area calculator"))
        
    }
    
    func computeRoofArea() {
        if(uiStateRoofSizeToggleOn) {
            roofAreaInt = Int(uiStateRoofSizeStr) ?? 0
        }
        else {
            roofAreaInt = (Int(uiStateHouseLength) ?? 0) * (Int(uiStateHouseWidth) ?? 0 )
        }
    }
}

struct GardenCalculatorView: View {
    @AppStorage("uiStateGardenSizeToggleOn") var uiStateGardenSizeToggleOn: Bool = false
    @AppStorage("uiStateGardenSizeStr") var uiStateGardenSizeStr: String = ""
    @AppStorage("uiStateGardenLength") var uiStateGardenLength: String = ""
    @AppStorage("uiStateGardenWidth") var uiStateGardenWidth: String = ""
    
    @AppStorage("gardenAreaInt") var gardenAreaInt: Int = 0
    
    var body: some View {
        Form{
            Section (header: Text("Garden Size"), footer: Text("This data allows us to estimate your garden/lawn irrigation needs based of your garden/lawn area."))
            {
               // Toggle(isOn: $uiStateGardenSizeToggleOn, label: {Text("Enter Garden Area directly")})
               //     .onChange(of: uiStateGardenSizeToggleOn) {
               //         computeGardenArea()
               //     }
                
                Picker("Garden area options?", selection: $uiStateGardenSizeToggleOn)
                {
                    Text("Direct").tag(true)
                    Text("L x W ").tag(false)
                }
                .pickerStyle(.segmented)
                .onChange(of: uiStateGardenSizeToggleOn) {
                     computeGardenArea()
                }
                
                if(uiStateGardenSizeToggleOn)
                {
                    TextField("Enter your garden size here (sqft)", text: $uiStateGardenSizeStr)
                       .keyboardType(.numberPad)
                       .textFieldStyle(.roundedBorder)
                       .onChange(of: uiStateGardenSizeStr) {
                           computeGardenArea()
                       }
                }
                else {
                    TextField("Enter your house length here (ft)", text: $uiStateGardenLength)
                       .keyboardType(.numberPad)
                       .textFieldStyle(.roundedBorder)
                       .onChange(of: uiStateGardenLength) {
                           computeGardenArea()
                       }
                    
                    TextField("Enter your house width here (ft)", text: $uiStateGardenWidth)
                       .keyboardType(.numberPad)
                       .textFieldStyle(.roundedBorder)
                       .onChange(of: uiStateGardenWidth) {
                           computeGardenArea()
                       }
                    
                    
                    Text ("Garden area (sqft): \(gardenAreaInt)")
                }

                
            }
        
        }
        .navigationTitle(Text("Garden area calculator"))
        
    }
    
    func computeGardenArea() {
        if(uiStateGardenSizeToggleOn) {
            gardenAreaInt = Int(uiStateGardenSizeStr) ?? 0
        }
        else {
            gardenAreaInt = (Int(uiStateGardenLength) ?? 0) * (Int(uiStateGardenWidth) ?? 0 )
        }
    }
}

#Preview {
    ContentView()
}
