//
//  Setup.swift
//  Nest Thermostat Carbon Footprint Calculator
//
//  Created by Reid Fleishman on 4/28/22.
//

import SwiftUI

struct Setup: View {
    @EnvironmentObject private var nc: NetworkController
    @State private var electricityCost = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to the Nest Thermostat Carbon Footprint app!  We will ask you some questions about your cooling and heating systems in order to obtain accurate usage data.\n\nFirst, how much do you pay for electricity?")
                
                HStack {
                    TextField("Electricity Cost", text: $electricityCost)
                        .keyboardType(.decimalPad)
                    
                    Text("$/kWh")
                }.textFieldStyle()
                
                Text("\n\nNow, we need to learn a little more about your cooling and heating systems.")
                
                NavigationLink(destination: CoolingSetup()) {
                    Text("Configure Cooling")
                        .buttonBlueStyle()
                }.opacity(nc.userData.cooling.type == .none ? 0.5 : 1)
                    .disabled(nc.userData.cooling.type == .none)
                
                Button(action: {
                    if nc.userData.cooling.type == .none {
                        nc.userData.cooling.type = .unknown
                    } else {
                        nc.userData.cooling.type = .none
                    }
                    //nc.userData.cooling.type == .none ? nc.userData.cooling.type = .unknown : nc.userData.cooling.type = .none
                }, label: {
                    Text(nc.userData.cooling.type == .none ? "Nevermind, my house does use cooling" : "My house does not use cooling")
                        .foregroundColor(.blue)
                })
                
                
                
                Button(action: {
                    nc.userData.heating.type = .none
                }, label: {
                    Text("Configure Heating")
                        .buttonRedStyle()
                })
                .padding(.top)
                
                Button(action: {
                    
                }, label: {
                    Text("My house does not use heating")
                        .foregroundColor(.red)
                })
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
