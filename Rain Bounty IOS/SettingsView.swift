//
//  SettingsView.swift
//  Rain Bounty IOS
//
//  Created by Surya Swaminathan on 2/17/25.
//
import SwiftUI

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
