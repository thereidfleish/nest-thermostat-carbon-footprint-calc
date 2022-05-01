//
//  Setup.swift
//  Nest Thermostat Carbon Footprint Calculator
//
//  Created by Reid Fleishman on 4/28/22.
//

import SwiftUI

struct Setup: View {
    @EnvironmentObject private var nc: NetworkController
    @State private var electricityCostInput: String
    
    
    init() {
        // Load any existing home configuration from the User Defaults and extract the electricity usage
        let homeConfig = Helpers.loadHomeConfig()
        
        electricityCostInput = homeConfig.electricityRate == 0 ? "" : String(homeConfig.electricityRate)
        
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Welcome to the Nest Thermostat Carbon Footprint app!  We will ask you some questions about your cooling and heating systems in order to obtain accurate usage data.\n\nFirst, how much do you pay for electricity?")
                    
                    HStack {
                        TextField("Electricity Cost", text: $electricityCostInput)
                            .keyboardType(.decimalPad)
                            .onChange(of: electricityCostInput) { newValue in
                                nc.userData.homeConfig.electricityRate = Double(electricityCostInput) ?? 0
                                
                                // Save changes
                                Helpers.saveHomeConfig(homeConfig: nc.userData.homeConfig)
                                
                            }
                        
                        Text("$/kWh")
                    }.textFieldStyle()
                    
                    Text("\n\nNow, we need to learn a little more about your cooling and heating systems.")
                    
                    NavigationLink(destination: CoolingSetup()) {
                        Text("Configure Cooling")
                            .buttonBlueStyle()
                    }/*.opacity(nc.userData.homeConfig.cooling.type == .none ? 0.5 : 1)
                      .disabled(nc.userData.homeConfig.cooling.type == .none)*/
                    
                    //                    Button(action: {
                    //                        if nc.userData.homeConfig.cooling.type == .none {
                    //                            nc.userData.homeConfig.cooling.type = .unknown
                    //                        } else {
                    //                            nc.userData.homeConfig.cooling.type = .none
                    //                        }
                    //
                    //                    }, label: {
                    //                        Text(nc.userData.homeConfig.cooling.type == .none ? "Nevermind, my house does use cooling" : "My house does not use cooling")
                    //                            .foregroundColor(.blue)
                    //                    })
                    
                    
                    NavigationLink(destination: HeatingSetup()) {
                        Text("Configure Heating")
                            .buttonRedStyle()
                    }/*.opacity(nc.userData.heating.type == .none ? 0.5 : 1)
                      .disabled(nc.userData.heating.type == .none)*/
                    
                    //                    Button(action: {
                    //                        if nc.userData.heating.type == .none {
                    //                            nc.userData.heating.type = .unknown
                    //                        } else {
                    //                            nc.userData.heating.type = .none
                    //                        }
                    //                    }, label: {
                    //                        Text(nc.userData.heating.type == .none ? "Nevermind, my house does use heating" : "My house does not use heating")
                    //                            .foregroundColor(.red)
                    //                    })
                }
                .padding(.horizontal)
            }.navigationTitle("Setup")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Next") {
                            nc.newUser = false
                        }/*.disabled(nc.userData.homeConfig.cooling.type == .unknown || nc.userData.homeConfig.heating.type == .unknown)*/
                    }
                }
        }
    }
}

//struct Setup_Previews: PreviewProvider {
//    static var previews: some View {
//        Setup()
//    }
//}
