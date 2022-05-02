//
//  Heating.swift
//  Nest Thermostat Carbon Footprint Calculator
//
//  Created by Angelica on 4/30/22.
//

//Notes
//Kind of oil fuel oil
//Gallons per hour

import SwiftUI

struct HeatingSetup: View {
    @EnvironmentObject private var nc: NetworkController
    @State private var oilPrice: String
    @State private var oilGPHInput: String
    @State private var otherAmps: String
    @State private var otherVolts: String
    
    init() {
        // Load any existing home configuration from the User Defaults and extract the params
        let homeConfig = Helpers.loadHomeConfig()
        
        oilPrice = homeConfig.heating.oilPrice == 0 ? "" : String(homeConfig.heating.oilPrice)
        
        oilGPHInput = homeConfig.heating.oilGPH == 0 ? "" : String(homeConfig.heating.oilGPH)
        print("sarah")
        
        otherAmps = homeConfig.heating.otherElectricalAmps == 0 ? "" : String(homeConfig.heating.otherElectricalAmps)
        
        otherVolts = homeConfig.heating.otherElectricalVoltage == 0 ? "" : String(homeConfig.heating.otherElectricalVoltage)
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text("First, an easy question: How much do you pay per gallon of oil?")
                    
                    HStack {
                        TextField("Oil Price", text: $oilPrice)
                            .keyboardType(.decimalPad)
                            .onChange(of: otherAmps) {newValue in
                                nc.userData.homeConfig.heating.oilPrice = Double(oilPrice) ?? 0
                                
                                // Save changes
                                Helpers.saveHomeConfig(homeConfig: nc.userData.homeConfig)
                            }
                        
                        Text("$/Gal")
                    }.textFieldStyle()
                    
                    Text("If you have central heating, please go to your boiler room.  This is usually in your basement.  First, we want to find your oil boiler.  Look for a large box with a large metal pipe coming out the back or top, and many smaller pipes coming in and out.  Find the label on that unit.")
                    
                    Text("How many gallons per hour (GPH) does your boiler consume?  If there is a range, choose a value in the middle.")
                        .padding(.top)
                    
                    HStack {
                        TextField("Boiler GPH", text: $oilGPHInput)
                            .keyboardType(.decimalPad)
                            .onChange(of: otherAmps) {newValue in
                                nc.userData.homeConfig.heating.oilGPH = Double(oilGPHInput) ?? 0
                                
                                // Save changes
                                Helpers.saveHomeConfig(homeConfig: nc.userData.homeConfig)
                            }
                        
                        Text("GPH")
                    }.textFieldStyle()
                    
                    Text("Now, we want to find your oil motor and burner.  Look for a small unit (or a combination of small units) sticking out of your boiler; the brands are often Beckett.  Look for labels on these units and add up the total amps and volts used for each unit.")
                    
                    HStack {
                        TextField("Motor and Burner Amps", text: $otherAmps)
                            .keyboardType(.decimalPad)
                            .onChange(of: otherAmps) {newValue in
                                nc.userData.homeConfig.heating.otherElectricalAmps = Double(otherAmps) ?? 0
                                
                                // Save changes
                                Helpers.saveHomeConfig(homeConfig: nc.userData.homeConfig)
                            }
                        
                        Text("amps")
                    }.textFieldStyle()
                    
                    HStack {
                        TextField("Motor and Burner Volts", text: $otherVolts)
                            .keyboardType(.decimalPad)
                            .onChange(of: otherVolts) { newValue in
                                nc.userData.homeConfig.heating.otherElectricalVoltage = Double(otherVolts) ?? 0
                                
                                // Save changes
                                Helpers.saveHomeConfig(homeConfig: nc.userData.homeConfig)
                            }
                        
                        Text("volts")
                    }.textFieldStyle()
                    
                    
                    
                    
                    Text("Your boiler uses \(nc.userData.homeConfig.heating.otherElectricalWattage) watts.")
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    
                    
                    
                }
            }
            .padding(.horizontal)
        }
    }
}

