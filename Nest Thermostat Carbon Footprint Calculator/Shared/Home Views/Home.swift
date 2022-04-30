//
//  Home.swift
//  Nest Thermostat Carbon Footprint Calculator
//
//  Created by Reid Fleishman on 4/28/22.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject private var nc: NetworkController
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(UserData.computeWelcome()) \(UserData.firstName(name: nc.userData.shared.display_name))!")
                .largeTitleStyle()
            
            Text("Home CO2 Emissions")
                .largeTitleStyle()
            
            //BarChartView(data: <#T##[Double]#>, color: <#T##Color#>)
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
