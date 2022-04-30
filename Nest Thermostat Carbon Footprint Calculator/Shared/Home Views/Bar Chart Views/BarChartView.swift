//
//  BarChartView.swift
//  Nest Thermostat Carbon Footprint Calculator
//
//  Created by Reid Fleishman on 4/29/22.
//

import SwiftUI

struct BarChartView: View {
    var data: [CoolingDataEvent]  // SOMEWHERE WE'RE GONNA NEED TO DO A SUBTRACTION OF THE TWO DATES!!
    //var colors: [Color]
    var color: Color
    
    var highestData: CoolingDataEvent {
        let max = data.max() ?? CoolingDataEvent(startTime: Date.now, endTime: Date.now) // the .max() function returns the CoolingDataEvent with the largest kWh usage, or nil if there are no events
        if max.totalkWhUsed == 0 { return CoolingDataEvent(startTime: Date.now, endTime: Date.now) } // should return a 0 kWh CoolingDataEvent if there are no elements
        return max
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 4.0) {
                ForEach(data.indices, id: \.self) { index in
                    let width = (geometry.size.width / CGFloat(data.count)) - 4.0
                    let height = geometry.size.height * data[index].totalkWhUsed / highestData.totalkWhUsed
                    
                    BarView(datum: data[index], color: color)
                        .frame(width: width, height: height, alignment: .bottom)
                }
            }
        }
    }
}
