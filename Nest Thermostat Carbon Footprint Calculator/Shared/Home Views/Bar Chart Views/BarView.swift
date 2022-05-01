//
//  BarView.swift
//  Nest Thermostat Carbon Footprint Calculator
//
//  Created by Reid Fleishman on 4/29/22.
//

import SwiftUI

struct BarView: View {
    //var datum: CoolingDataEvent
    var datum: RangeElementTotal
    //var colors: [Color]
    var color: Color
    
    //  var gradient: LinearGradient {
    //    LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
    //  }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(color)
            .opacity(datum.totalkWhUsed == 0.0 ? 0.0 : 1.0)
    }
}

//struct BarView_Previews: PreviewProvider {
//    static var previews: some View {
//        BarView()
//    }
//}
