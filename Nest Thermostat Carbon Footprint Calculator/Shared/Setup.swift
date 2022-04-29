//
//  Setup.swift
//  Nest Thermostat Carbon Footprint Calculator
//
//  Created by Reid Fleishman on 4/28/22.
//

import SwiftUI

struct Setup: View {
    @State private var electricityCost = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to the Nest Thermostat Carbon Footprint app!  We will ask you some questions about your cooling and heating systems in order to obtain accurate usage data.\n\nFirst, how much do you pay for electricity?")
                
                HStack {
                    TextField("Electricity Cost", text: $electricityCost)
                        .keyboardType(.decimalPad)
                    
                    Text("cents/kWh")
                }.textFieldStyle()
                
                Text("\n\nNow, we need to learn a little more about your cooling and heating systems.  If your home does not have cooling or heating, then ")
            }
            .padding(.horizontal)
        }
        
        
        
    }
}

struct Setup_Previews: PreviewProvider {
    static var previews: some View {
        Setup()
    }
}
