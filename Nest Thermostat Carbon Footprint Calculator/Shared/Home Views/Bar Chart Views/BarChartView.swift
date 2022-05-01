//
//  BarChartView.swift
//  Nest Thermostat Carbon Footprint Calculator
//
//  Created by Reid Fleishman on 4/29/22.
//

import SwiftUI

struct BarChartView: View {
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }
    
    func generateMods(currentMonth: Int) -> [Int] {
        var mods: [Int] = []
        for i in [11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0] {
            if (currentMonth - i == 0) {
                mods.append(12)
            } else {
                mods.append(mod(currentMonth-i, 12))
            }
        }
        return mods
    }
    
    var coolingData: [CoolingDataEvent]
    var heatingData: [HeatingDataEvent]
    //var colors: [Color]
    var color: Color
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
    
    init(coolingData: [CoolingDataEvent], heatingData: [HeatingDataEvent], range: RangeType, emissionsType: EmissionsType, color: Color) {
        self.color = color
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
    
    //    var highestData: MonthlyTotal {
    //        let max = annualData.max() ?? MonthlyTotal() // the .max() function returns the CoolingDataEvent with the largest kWh usage, or nil if there are no events
    //        if max.totalkWhUsed == 0 { return MonthlyTotal() } // should return a 0 kWh CoolingDataEvent if there are no elements
    //        print("returning max")
    //        return max
    //    }
    
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
                        
                        var coolingHeight: Double = 0
                        var heatingHeight: Double = 0

//                        switch emissionsType {
//                        case .duration:
//                            coolingHeight = geometry.size.height * finalRangeData[index].totalCoolingDuration / highestData.totalCoolingDuration
//                            heatingHeight = geometry.size.height * finalRangeData[index].totalCoolingDuration / highestData.totalCoolingDuration
//                        case .fanKwh:
//                            coolingHeight = geometry.size.height * finalRangeData[index].fankWhUsed / highestData.fankWhUsed
//                            heatingHeight = 0
//                        case .compressorKwh:
//                            coolingHeight = geometry.size.height * finalRangeData[index].compressorKwh / highestData.compressorKwh
//                            heatingHeight = 0
//                        case .totalkWh:
//                            coolingHeight = geometry.size.height * finalRangeData[index].totalkWhUsed / highestData.totalkWhUsed
//                            heatingHeight = geometry.size.height * finalRangeData[index].otherElectricalkWhUsed / highestData.otherElectricalkWhUsed
//                        case .totalMoney:
//                            coolingHeight = geometry.size.height * finalRangeData[index].totalCoolingCost / highestData.totalCoolingCost
//                            heatingHeight = geometry.size.height * finalRangeData[index].totalHeatingCost / highestData.totalHeatingCost
//                        case .oilGallons:
//                            coolingHeight = 0
//                            heatingHeight = geometry.size.height * finalRangeData[index].totaloilGallonsUsed / highestData.totaloilGallonsUsed
//                        case .co2_e:
//                            coolingHeight = geometry.size.height * finalRangeData[index].totalCoolingEmissions / highestData.totalCoolingEmissions
//                            heatingHeight = geometry.size.height * finalRangeData[index].totalHeatingEmissions / highestData.totalHeatingEmissions
//                        }



                            


                        
                        
                        
//                        let coolingHeight = geometry.size.height * finalRangeData[index].totalCoolingEmissions / highestData.totalHeatingEmissions
//                        let heatingHeight = geometry.size.height * finalRangeData[index].totalHeatingEmissions / highestData.totalHeatingEmissions
                        
                        let height = geometry.size.height * finalRangeData[index].totalkWhUsed / highestData.totalkWhUsed
                        
                        VStack {
                            
                            
                            HStack(alignment: .bottom) {
                                VStack {
                                    Text(String((round(finalRangeData[index].totalCoolingEmissions*10)/10.0)))
                                        .font(.footnote)
                                    
                                    BarView(datum: finalRangeData[index], color: .blue)
                                        .frame(width: width, height: coolingHeight, alignment: .bottom)
                                }
                                
                                VStack {
                                    Text(String((round(finalRangeData[index].totalHeatingEmissions*10)/10.0)))
                                        .font(.footnote)
                                    
                                    BarView(datum: finalRangeData[index], color: .red)
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
