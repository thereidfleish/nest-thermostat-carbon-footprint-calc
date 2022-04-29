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
        Text("\(UserData.computeWelcome()) \(UserData.firstName(name: nc.userData.shared.display_name))!")
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
