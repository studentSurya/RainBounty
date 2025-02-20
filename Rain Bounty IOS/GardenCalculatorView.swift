//
//  GardenCalculatorView.swift
//  Rain Bounty IOS
//
//  Created by Surya Swaminathan on 2/17/25.
//

import SwiftUI

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
