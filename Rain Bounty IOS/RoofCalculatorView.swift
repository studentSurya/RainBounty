//
//  RoofCalculatorView.swift
//  Rain Bounty IOS
//
//  Created by Surya Swaminathan on 2/17/25.
//
import SwiftUI

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
                    Text("Square Footage").tag(true)
                    Text("Length by Width").tag(false)
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
