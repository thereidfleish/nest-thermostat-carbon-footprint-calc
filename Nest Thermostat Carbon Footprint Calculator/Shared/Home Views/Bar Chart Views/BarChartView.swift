//
//  BarChartView.swift
//  Nest Thermostat Carbon Footprint Calculator
//
//  Created by Reid Fleishman on 4/29/22.
//

import SwiftUI

struct BarChartView: View {
    var coolingData: [CoolingDataEvent]
    var heatingData: [HeatingDataEvent]
    var range: RangeType
    var emissionsType: EmissionsType
    
    //    // This returns a list of 12 CoolingDataEvents (each event will represent the total for one month) for the past year
    //    var annualData: [MonthlyTotal] {
    //        var annualData: [MonthlyTotal] = []
    //        let currentMonth: Int = Calendar.current.dateComponents([.month], from: Date.now).month!
    //        var runCount = 0
    //        print(generateMods(currentMonth: currentMonth))
    //        for month in generateMods(currentMonth: currentMonth) {
    //            runCount += 1
    //            print(month)
    //            var currentMonthTotal: MonthlyTotal = MonthlyTotal()
    //            print("created monthly total with runCount = \(runCount)")
    //            for datum in data {
    //                if Calendar.current.dateComponents([.month], from: datum.endTime).month! == month {
    //                    currentMonthTotal.totalDuration += datum.totalDuration
    //                    currentMonthTotal.fankWhUsed += datum.fankWhUsed
    //                    currentMonthTotal.compressorkWhUsed += datum.compressorkWhUsed
    //                    currentMonthTotal.totalkWhUsed += datum.totalkWhUsed
    //                }
    //            }
    //            annualData.append(currentMonthTotal)
    //        }
    //        print("returned")
    //        return annualData
    //    }
    
    // This returns a list of 12 CoolingDataEvents (each event will represent the total for one month) for the past year
    var finalRangeData: [RangeElementTotal]
    
    var highestData: RangeElementTotal
    
    var rangeLabel: [String] = []
    
    init(coolingData: [CoolingDataEvent], heatingData: [HeatingDataEvent], range: RangeType, emissionsType: EmissionsType) {
        self.range = range
        self.emissionsType = emissionsType
        self.coolingData = coolingData
        self.heatingData = heatingData
        //var newData: [CoolingDataEvent] = []
        var lowerBoundDate: Date = Date()
        var upperBoundDate: Date = Date()
        var iteratingComponent: Calendar.Component = .nanosecond
        var rangeData: [RangeElementTotal] = []
        
        let currentYear = Calendar.current.dateComponents([.year], from: Date.now).year!
        let currentMonth = Calendar.current.dateComponents([.month], from: Date.now).month!
        let currentWeek = Calendar.current.dateComponents([.weekOfMonth], from: Date.now).weekOfMonth!
        let currentDay = Calendar.current.dateComponents([.day], from: Date.now).day!
        //        var rangeIterator: ClosedRange<Int> // the
        
        switch range {
        case .decade:
            //currentRangeElement = Calendar.current.dateComponents([.year], from: Date.now).year!
            //rangeIterator = currentRangeElement-10...currentRangeElement
            lowerBoundDate = Calendar.current.date(byAdding: .year, value: -10, to: Date.now)!
            iteratingComponent = .year
            //newData = data.filter({ $0.endTime >= lowerBoundDate })
        case .year:
            lowerBoundDate = Calendar.current.date(from: DateComponents(year: currentYear, month: 1, day: 1))!
            upperBoundDate = Calendar.current.date(byAdding: .year, value: 1, to: lowerBoundDate)!
            iteratingComponent = .month
            rangeLabel = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        case .month:
            lowerBoundDate = Calendar.current.date(from: DateComponents(year: currentYear, month: currentMonth, day: 1))!
            upperBoundDate = Calendar.current.date(byAdding: .month, value: 1, to: lowerBoundDate)!
            iteratingComponent = .day
            for i in Calendar.current.range(of: .day, in: .month, for: Date())! {
                rangeLabel.append(String(i))
            }
        case .week:
            lowerBoundDate = Calendar.current.date(from: DateComponents(year: currentYear, month: currentMonth, weekOfMonth: currentWeek))!
            upperBoundDate = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: lowerBoundDate)!
            iteratingComponent = .day
            rangeLabel = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        case .day:
            lowerBoundDate = Calendar.current.date(from: DateComponents(year: currentYear, month: currentMonth, day: currentDay, hour: 0))!
            upperBoundDate = Calendar.current.date(byAdding: .day, value: 1, to: lowerBoundDate)!
            iteratingComponent = .hour
            rangeLabel = ["12 AM", "1 AM", "2 AM", "3 AM", "4 AM", "5 AM", "6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"]
        case .custom:
            lowerBoundDate = Calendar.current.date(byAdding: .month, value: -12, to: Date.now)! // placeholder, will work on
            upperBoundDate = Calendar.current.date(byAdding: .month, value: -12, to: Date.now)! // placeholder, will work on -- if user set's "now" as upperbound, then just use Date.now
        }
        
        while lowerBoundDate < upperBoundDate {
            let currentUpperBoundDate = Calendar.current.date(byAdding: iteratingComponent, value: 1, to: lowerBoundDate)!
            print("Lower bound date: \(lowerBoundDate)")
            print("Upper bound date: \(currentUpperBoundDate)")
            var currentIterationTotal = RangeElementTotal()
            for datum in coolingData {
                if datum.endTime > lowerBoundDate && datum.endTime < currentUpperBoundDate {
                    currentIterationTotal.totalCoolingDuration += datum.totalDuration
                    currentIterationTotal.fankWhUsed += datum.fankWhUsed
                    currentIterationTotal.compressorkWhUsed += datum.compressorkWhUsed
                    currentIterationTotal.totalkWhUsed += datum.totalkWhUsed
                    currentIterationTotal.totalCoolingCost += datum.totalCost
                    currentIterationTotal.totalCoolingEmissions += datum.totalEmisssions
                }
            }
            
            for datum in heatingData {
                if datum.endTime > lowerBoundDate && datum.endTime < currentUpperBoundDate {
                    currentIterationTotal.totalHeatingDuration += datum.totalDuration
                    currentIterationTotal.totaloilGallonsUsed += datum.oilGallonsUsed
                    currentIterationTotal.otherElectricalkWhUsed += datum.otherElectricalkWhUsed
                    currentIterationTotal.totalHeatingCost += datum.totalCost
                    currentIterationTotal.totalHeatingEmissions += datum.totalEmisssions
                }
            }
            
            rangeData.append(currentIterationTotal)
            lowerBoundDate = Calendar.current.date(byAdding: iteratingComponent, value: 1, to: lowerBoundDate)!
        }
        print("returned")
        finalRangeData = rangeData
        
        let max = finalRangeData.max() ?? RangeElementTotal() // the .max() function returns the CoolingDataEvent with the largest kWh usage, or nil if there are no events
        if max.totalkWhUsed == 0 { highestData = RangeElementTotal() } // should return a 0 kWh CoolingDataEvent if there are no elements
        print("returning max")
        highestData = max
    }
    
    func calculateLabel(datum: RangeElementTotal) -> (Double, Double) {
        switch emissionsType {
        case .duration:
            return (datum.totalCoolingDuration, datum.totalHeatingDuration)
        case .fanKwh:
            return (datum.fankWhUsed, 0)
        case .compressorKwh:
            return (datum.compressorkWhUsed, 0)
        case .totalkWh:
            return (datum.totalkWhUsed, datum.otherElectricalkWhUsed)
        case .totalMoney:
            return (datum.totalCoolingCost, datum.totalHeatingCost)
        case .oilGallons:
            return (0, datum.totaloilGallonsUsed)
        case .co2_e:
            return (datum.totalCoolingEmissions, datum.totalHeatingEmissions)
        }
    }
    
    // return (coolingHeight, heatingHeight)
    func calculateHeight(geometryHeight: CGFloat, datum: RangeElementTotal) -> (Double, Double) {
        switch emissionsType {
        case .duration:
            var coolingMax = finalRangeData[0].totalCoolingDuration
            for datum in finalRangeData {
                if datum.totalCoolingDuration > coolingMax {
                    coolingMax = datum.totalCoolingDuration
                }
            }
            var heatingMax = finalRangeData[0].totalHeatingDuration
            for datum in finalRangeData {
                if datum.totalHeatingDuration > heatingMax {
                    heatingMax = datum.totalHeatingDuration
                }
            }
            let globalMax = max(coolingMax, heatingMax)
            
            return (geometryHeight * datum.totalCoolingDuration / globalMax, geometryHeight * datum.totalHeatingDuration / globalMax)
        case .fanKwh:
            var coolingMax = finalRangeData[0].fankWhUsed
            for datum in finalRangeData {
                if datum.fankWhUsed > coolingMax {
                    coolingMax = datum.fankWhUsed
                }
            }
            return (geometryHeight * datum.fankWhUsed / coolingMax, 0)
        case .compressorKwh:
            var coolingMax = finalRangeData[0].compressorkWhUsed
            for datum in finalRangeData {
                if datum.compressorkWhUsed > coolingMax {
                    coolingMax = datum.compressorkWhUsed
                }
            }
            return (geometryHeight * datum.compressorkWhUsed / coolingMax, 0)
        case .totalkWh:
            var coolingMax = finalRangeData[0].totalkWhUsed
            for datum in finalRangeData {
                if datum.totalkWhUsed > coolingMax {
                    coolingMax = datum.totalkWhUsed
                }
            }
            var heatingMax = finalRangeData[0].otherElectricalkWhUsed
            for datum in finalRangeData {
                if datum.otherElectricalkWhUsed > heatingMax {
                    heatingMax = datum.otherElectricalkWhUsed
                }
            }
            let globalMax = max(coolingMax, heatingMax)
            
            return (geometryHeight * datum.totalkWhUsed / globalMax, geometryHeight * datum.otherElectricalkWhUsed / globalMax)
        case .totalMoney:
            var coolingMax = finalRangeData[0].totalCoolingCost
            for datum in finalRangeData {
                if datum.totalCoolingCost > coolingMax {
                    coolingMax = datum.totalCoolingCost
                }
            }
            var heatingMax = finalRangeData[0].totalHeatingCost
            for datum in finalRangeData {
                if datum.totalHeatingCost > heatingMax {
                    heatingMax = datum.totalHeatingCost
                }
            }
            let globalMax = max(coolingMax, heatingMax)
            
            return (geometryHeight * datum.totalCoolingCost / globalMax, geometryHeight * datum.totalHeatingCost / globalMax)
        case .oilGallons:
            var heatingMax = finalRangeData[0].totaloilGallonsUsed
            for datum in finalRangeData {
                if datum.totaloilGallonsUsed > heatingMax {
                    heatingMax = datum.totaloilGallonsUsed
                }
            }
            
            return (0, geometryHeight * datum.totaloilGallonsUsed / heatingMax)
        case .co2_e:
            var coolingMax = finalRangeData[0].totalCoolingEmissions
            for datum in finalRangeData {
                if datum.totalCoolingEmissions > coolingMax {
                    coolingMax = datum.totalCoolingEmissions
                }
            }
            var heatingMax = finalRangeData[0].totalHeatingEmissions
            for datum in finalRangeData {
                if datum.totalHeatingEmissions > heatingMax {
                    heatingMax = datum.totalHeatingEmissions
                }
            }
            let globalMax = max(coolingMax, heatingMax)
            
            return (geometryHeight * datum.totalCoolingEmissions / globalMax, geometryHeight * datum.totalHeatingEmissions / globalMax)
        }
    }
    
    var body: some View {
//        GeometryReader { geometry in
//            HStack(alignment: .bottom, spacing: 4.0) {
//                ForEach(finalRangeData.indices, id: \.self) { index in
//                    let width = (geometry.size.width / CGFloat(finalRangeData.count)) - 4.0
//                    let height = geometry.size.height * finalRangeData[index].totalkWhUsed / highestData.totalkWhUsed
//
//                    VStack {
//                        BarView(datum: finalRangeData[index], color: color)
//                            .frame(width: width, height: height, alignment: .bottom)
//
//                        Text(finalRangeData[index].rangeLabel)
//                    }
//                }
//            }.onAppear {
//                print("h")
//            }
//        }
        
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                HStack(alignment: .bottom, spacing: finalRangeData.count < 15 ? 4.0 : nil) {
                    ForEach(finalRangeData.indices, id: \.self) { index in
                        let width = (geometry.size.width / CGFloat(finalRangeData.count)) - 4.0
                        
                        let coolingHeight: Double = calculateHeight(geometryHeight: geometry.size.height, datum: finalRangeData[index]).0
                        let heatingHeight: Double = calculateHeight(geometryHeight: geometry.size.height, datum: finalRangeData[index]).1
                        
//                        let coolingHeight = geometry.size.height * finalRangeData[index].totalCoolingEmissions / highestData.totalHeatingEmissions
//                        let heatingHeight = geometry.size.height * finalRangeData[index].totalHeatingEmissions / highestData.totalHeatingEmissions
                        
//                        let height = geometry.size.height * finalRangeData[index].totalkWhUsed / highestData.totalkWhUsed
                        
                        VStack {
                            HStack(alignment: .bottom/*, spacing: -2.0*/) {
                                VStack {
                                    Text(String((round(calculateLabel(datum: finalRangeData[index]).0*10)/10.0)))
                                        .font(.footnote)
                                    
                                    BarView(datum: calculateLabel(datum: finalRangeData[index]).0, color: .blue)
                                        .frame(width: width, height: coolingHeight, alignment: .bottom)
                                }
                                
                                VStack {
                                    Text(String((round(calculateLabel(datum: finalRangeData[index]).1*10)/10.0)))
                                        .font(.footnote)
                                    
                                    BarView(datum: calculateLabel(datum: finalRangeData[index]).1, color: .red)
                                        .frame(width: width, height: heatingHeight, alignment: .bottom)
                                }
                            }
                            
                            Text(rangeLabel[index])
                                .font(.footnote)
                        }
                    }
                }
            }.onAppear {
                print("h")
            }
        }
    }
}

// A struct representing a total for an ELEMENT of a given range (e.g., a year of a decade, a month of a year, a week of a month, a day of a week, or an hour of a day).
struct RangeElementTotal: Comparable {
    static func < (lhs: RangeElementTotal, rhs: RangeElementTotal) -> Bool {
        lhs.totalHeatingEmissions < rhs.totalHeatingEmissions
    }
    
    var cooling: Bool = false
    
    var totalCoolingDuration: Double = 0
    var fankWhUsed: Double = 0
    var compressorkWhUsed: Double = 0
    var totalkWhUsed: Double = 0
    var totalCoolingCost: Double = 0
    var totalCoolingEmissions: Double = 0
    
    var totalHeatingDuration: Double = 0
    var totaloilGallonsUsed: Double = 0
    var otherElectricalkWhUsed: Double = 0
    var totalHeatingCost: Double = 0
    var totalHeatingEmissions: Double = 0
    
    //var rangeLabel: String // e.g., 2022, Apr, Sun
}
