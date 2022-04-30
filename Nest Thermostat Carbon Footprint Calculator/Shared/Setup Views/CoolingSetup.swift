//
//  CoolingSetup.swift
//  Nest Thermostat Carbon Footprint Calculator
//
//  Created by Reid Fleishman on 4/28/22.
//

import SwiftUI

struct CoolingSetup: View {
    @EnvironmentObject private var nc: NetworkController
    @State private var fanAmps = ""
    @State private var fanVolts = ""
    @State private var compressorAmps = ""
    @State private var compressorVolts = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text("If you have central A/C, please go to the fan unit of your A/C system.  This is often in your basement or attic.")
                    
                    Text("How many amps does your fan use?")
                        .padding(.top)
                    
                    HStack {
                        TextField("Fan Amps", text: $fanAmps)
                            .keyboardType(.decimalPad)
                            .onChange(of: fanAmps) { newValue in
                                nc.userData.cooling.fanWattage = (Double(fanAmps) ?? 0) * (Double(fanVolts) ?? 0)
                                print(nc.userData.cooling.fanWattage)
                            }
                        
                        Text("amps")
                    }.textFieldStyle()
                    
                    Text("How many volts does your fan use?  If you see either a range between 200 and 230, or see 208/230, choose 208 (unless you know for sure)")
                        .padding(.top)
                    
                    HStack {
                        TextField("Fan Volts", text: $fanVolts)
                            .keyboardType(.decimalPad)
                            .onChange(of: fanVolts) { newValue in
                                nc.userData.cooling.fanWattage = (Double(fanAmps) ?? 0) * (Double(fanVolts) ?? 0)
                                print(nc.userData.cooling.fanWattage)
                            }
                        
                        Text("volts")
                    }.textFieldStyle()
                    
                    Text("Your fan uses \(round(nc.userData.cooling.fanWattage!*100)/100.0) watts.")
                        .fontWeight(.bold)
                        .padding(.top)
                }
                
                Group {
                    Text("If you have central A/C, please go to the compressor unit of your A/C system.  This is often outside.")
                        .padding(.top)
                    
                    Text("How many amps does your compressor use?  If you see a \"minimum circuitry\" value, divide that in half.")
                        .padding(.top)
                    
                    HStack {
                        TextField("Compressor Amps", text: $compressorAmps)
                            .keyboardType(.decimalPad)
                            .onChange(of: compressorAmps) { newValue in
                                nc.userData.cooling.compressorWattage = (Double(compressorAmps) ?? 0) * (Double(compressorVolts) ?? 0)
                                print(nc.userData.cooling.compressorWattage)
                            }
                        
                        Text("amps")
                    }.textFieldStyle()
                    
                    Text("How many volts does your compressor use?  If you see either a range between 200 and 230, or see 208/230, choose 208 (unless you know for sure)")
                        .padding(.top)
                    
                    HStack {
                        TextField("Compressor Volts", text: $compressorVolts)
                            .keyboardType(.decimalPad)
                            .onChange(of: compressorVolts) { newValue in
                                nc.userData.cooling.compressorWattage = (Double(compressorAmps) ?? 0) * (Double(compressorVolts) ?? 0)
                                print(nc.userData.cooling.compressorWattage)
                            }
                        
                        Text("volts")
                    }.textFieldStyle()
                    
                    Text("Your compressor uses \(round(nc.userData.cooling.compressorWattage!*100)/100.0) watts.")
                        .fontWeight(.bold)
                        .padding(.top)
                }
                
                
            }
            .padding(.horizontal)
        }
        
    }
}

struct CoolingSetup_Previews: PreviewProvider {
    static var previews: some View {
        CoolingSetup()
    }
}
