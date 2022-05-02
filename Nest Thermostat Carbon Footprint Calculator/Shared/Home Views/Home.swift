//
//  Home.swift
//  Nest Thermostat Carbon Footprint Calculator
//
//  Created by Reid Fleishman on 4/28/22.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject private var nc: NetworkController
    let testData = [CoolingDataEvent(startTime: Date.randomBetween(start: Date.parse("2022-04-20"), end: Date.parse("2022-04-21")), endTime: Date.randomBetween(start: Date.parse("2022-04-22"), end: Date.parse("2022-04-23"))), CoolingDataEvent(startTime: Date.randomBetween(start: Date.parse("2022-04-23"), end: Date.parse("2022-04-24")), endTime: Date.randomBetween(start: Date.parse("2022-04-25"), end: Date.parse("2022-04-26")))]
    
    @State private var range: RangeType = .year
    @State private var emissionsType: EmissionsType = .co2_e
    
    var graphRangeText: String {
        switch range {
        case .decade:
            return "This Decade's"
        case .year:
            return "This Year's"
        case .month:
            return "This Month's"
        case .week:
            return "This Week's"
        case .day:
            return "Today's"
        case .custom:
            return "Custom"
        }
    }
    
    var graphEmissionsText: String {
        switch emissionsType {
        case .duration:
            return "Uptime (hrs)"
        case .fanKwh:
            return "Fan kWh"
        case .compressorKwh:
            return "Compressor kWh"
        case .totalkWh:
            return "Electricity Usage (kWh)"
        case .oilGallons:
            return "Oil Usage (gal)"
        case .co2_e:
            return "Emissions (kg-CO2e)"
        case .totalMoney:
            return "Cost ($)"
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("\(Helpers.computeWelcome()) \(Helpers.firstName(name: nc.userData.display_name))!")
                        .largeTitleStyle()
                    
                    HStack {
                        Text(graphRangeText + " " + graphEmissionsText)
                            .largeTitleStyle()
                        
                        Menu {
                            Button(action: {
                                withAnimation {
                                    range = .year
                                }
                                
                            }, label: {
                                Text("This Year")
                            })
                            Button(action: {
                                withAnimation {
                                    range = .month
                                }
                            }, label: {
                                Text("This Month")
                            })
                            Button(action: {
                                withAnimation {
                                    range = .week
                                }
                            }, label: {
                                Text("This Week")
                            })
                            Button(action: {
                                withAnimation {
                                    range = .day
                                }
                            }, label: {
                                Text("Today")
                            })
                        } label: {
                            Image(systemName: "calendar")
                        }
                        
                        Menu {
                            Button(action: {
                                withAnimation {
                                    emissionsType = .totalkWh
                                }
                                
                            }, label: {
                                Text("Electricity Usage (kWh)")
                            })
                            Button(action: {
                                withAnimation {
                                    emissionsType = .duration
                                }
                            }, label: {
                                Text("Uptime (hrs)")
                            })
                            Button(action: {
                                withAnimation {
                                    emissionsType = .oilGallons
                                }
                            }, label: {
                                Text("Oil Usage (gal)")
                            })
                            Button(action: {
                                withAnimation {
                                    emissionsType = .co2_e
                                }
                            }, label: {
                                Text("Emissions (kg-CO2e)")
                            })
                            Button(action: {
                                withAnimation {
                                    emissionsType = .totalMoney
                                }
                            }, label: {
                                Text("Cost ($)")
                            })
                        } label: {
                            Image(systemName: "leaf.fill")
                        }

                    }
                    
                    BarChartView(coolingData: GenerateRandomDates().coolingDates, heatingData: GenerateRandomDates().heatingDates, range: range, emissionsType: emissionsType)
                        .frame(height: 300)
                    
                    Text("Today's Suggestions")
                        .padding(.top, 50.0)
                        .largeTitleStyle()
                    
                    
                    VStack(alignment: .center) {
                            Text("Reduce heat by 1°F")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                            
                            HStack {
                                VStack {
                                    Image(systemName: "drop.fill")
                                        .foregroundColor(Color.white)
                                        .frame(width: 15)
                                    
                                    Text("0.74")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    
                                    Text("gal oil")
                                        .font(.caption)
                                        .foregroundColor(Color.white)
                                }
                                
                                VStack {
                                    Image(systemName: "cloud.fog.fill")
                                        .foregroundColor(Color.white)
                                        .frame(width: 15)
                                    
                                    Text("5")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    
                                    Text("kg-CO2e")
                                        .font(.caption)
                                        .foregroundColor(Color.white)
                                }
                                .padding(.horizontal)
                                
                                VStack {
                                    Image(systemName: "dollarsign.circle.fill")
                                        .foregroundColor(Color.white)
                                        .frame(width: 15)
                                    
                                    Text("3")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                    
                                    Text("$")
                                        .font(.caption)
                                        .foregroundColor(Color.white)
                                }

                            }
                            .padding(.top, 5)
                        }.navigationLinkStyle()
                    
                    
                    //BarChartView(data: testData, color: .blue)
                }
                .padding(.horizontal)
            }.navigationTitle("Home")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            nc.newUser = true
                        }, label: {
                            Image(systemName: "gearshape.fill")
                        })
                    }
                }
        }
        
    }
}

enum RangeType {
    case decade
    case year
    case month
    case week
    case day
    case custom
}

enum EmissionsType {
    case duration
    case fanKwh
    case compressorKwh
    case totalkWh
    case totalMoney
    case oilGallons
    case co2_e
}

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        Home()
//    }
//}
