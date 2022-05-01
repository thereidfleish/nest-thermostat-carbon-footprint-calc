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
    
    @State private var range: RangeType = .week
    @State private var emissionsType: EmissionsType = .co2_e
    
    var graphRangeText: String {
        switch range {
        case .decade:
            return "Yearly"
        case .year:
            return "Monthly"
        case .month:
            return "Daily"
        case .week:
            return "Daily"
        case .day:
            return "Hourly"
        case .custom:
            return "Custom"
        }
    }
    
    var graphEmissionsText: String {
        switch emissionsType {
        case .duration:
            return "Hours"
        case .fanKwh:
            return "Fan kWh"
        case .compressorKwh:
            return "Compressor kWh"
        case .totalkWh:
            return "Total kWh"
        case .oilGallons:
            return "Gallons of Oil"
        case .co2_e:
            return "CO2-e"
        case .totalMoney:
            return "Cost"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("\(Helpers.computeWelcome()) \(Helpers.firstName(name: nc.userData.display_name))!")
                    .largeTitleStyle()
                
                HStack {
                    Text(graphRangeText + " emissions (CO2-e)")
                        .largeTitleStyle()
                    
                    Menu {
                        Button(action: {
                            withAnimation {
                                range = .year
                            }
                            
                        }, label: {
                            Text("This year")
                        })
                        Button(action: {
                            withAnimation {
                                range = .month
                            }
                        }, label: {
                            Text("This month")
                        })
                        Button(action: {
                            withAnimation {
                                range = .week
                            }
                        }, label: {
                            Text("This week")
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
                            Text("kWh")
                        })
                        Button(action: {
                            withAnimation {
                                emissionsType = .duration
                            }
                        }, label: {
                            Text("Total Duration (hrs)")
                        })
                        Button(action: {
                            withAnimation {
                                emissionsType = .oilGallons
                            }
                        }, label: {
                            Text("Gallons of Oil")
                        })
                        Button(action: {
                            withAnimation {
                                emissionsType = .co2_e
                            }
                        }, label: {
                            Text("CO2-e Emissions")
                        })
                        Button(action: {
                            withAnimation {
                                emissionsType = .totalMoney
                            }
                        }, label: {
                            Text("Cost")
                        })
                    } label: {
                        Image(systemName: "leaf.fill")
                    }

                }
                
                BarChartView(coolingData: GenerateRandomDates().coolingDates, heatingData: GenerateRandomDates().heatingDates, range: range, emissionsType: emissionsType, color: .blue)
                    .frame(height: 300)
                
//                Text("Today's Stats")
//                    .largeTitleStyle()
                
                //BarChartView(data: testData, color: .blue)
            }
            .padding(.horizontal)
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
