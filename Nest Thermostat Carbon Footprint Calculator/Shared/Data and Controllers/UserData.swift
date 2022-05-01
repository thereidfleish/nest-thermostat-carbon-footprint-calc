//
//  Data.swift
//  AI Tennis Coach
//
//  Created by Reid Fleishman on 12/29/21.
//

import Foundation
import UIKit
import AVFoundation
import SwiftUI

struct UserData {
//    var id: Int
//    var username: String
//    var display_name: String
//    var email: String
//    var profilePic: URL?
//    var loggedIn: Bool
    
    var id = -1
    var username = "thereidfleish"
    var display_name = "Reid Fleishman"
    var email = "reidfleishman5@gmail.com"
    var profilePic: URL? = nil
    var loggedIn = false
    
    //    @AppStorage("electricityRate") var electricityRate: Double = 0
    //
    //    @AppStorage("coolingType") var coolingType: CoolingType = .unknown
    //    @AppStorage("fanWattage") var fanWattage: Double? = 0
    //    @AppStorage("compressorWattage") var compressorWattage: Double?
    //
    //    @AppStorage var type: HeatingType
    //    @AppStorage var oilGPH: Double?
    //    @AppStorage var gasUnitsPH: Double?
    
    var homeConfig: HomeConfig = Helpers.loadHomeConfig()
    
//    init() {
////        id = -1
////        username = "thereidfleish"
////        display_name = "Reid Fleishman"
////        email = "reidfleishman5@gmail.com"
////        profilePic = nil
////        loggedIn = false
//
//        //homeConfig = HomeConfig()
//        // DO I NEED TO LOAD THIS, AND WILL DOING SO ALLOW ME TO NOT HAVE TO LOAD THE HOME CONFIGS ON THE TOP OF THE SETUP PAGES???
//
//        homeConfig = loadHomeConfig()
//        //print("loaded old HomeConfig!")
//
//
//
//    }
    //var shared: SharedData
    
    //var cooling: Cooling
    
    //var heating: Heating
}

struct Helpers {
    static func loadHomeConfig() -> HomeConfig {
        if let savedHomeConfig = UserDefaults.standard.object(forKey: "HomeConfig") as? Data {
            if let loadedHomeConfig = try? JSONDecoder().decode(HomeConfig.self, from: savedHomeConfig) {
                return loadedHomeConfig
            }
        }
        return HomeConfig()
    }
    
    static func saveHomeConfig(homeConfig: HomeConfig) {
        if let encoded = try? JSONEncoder().encode(homeConfig) {
            UserDefaults.standard.set(encoded, forKey: "HomeConfig")
            print("saved changes")
        }
    }
    
    
    static func computeWelcome() -> String {
        let currentHour = Calendar.current.dateComponents([.hour], from: Date())
        
        if currentHour.hour ?? -1 >= 0 && currentHour.hour ?? -1 < 12 {
            return "Good morning,"
        }
        if currentHour.hour ?? -1 >= 12 && currentHour.hour ?? -1 < 18 {
            return "Good afternoon,"
        }
        if currentHour.hour ?? -1 >= 18 && currentHour.hour ?? -1 < 24 {
            return "Good evening,"
        }
        else {
            return "Welcome,"
        }
    }
    
    static func firstName(name: String) -> String {
        let firstSpace = name.firstIndex(of: " ") ?? name.endIndex
        let firstName = name[..<firstSpace]
        return String(firstName)
    }
    
    static func computeErrorMessage(errorMessage: String) -> String {
        return "Error: \(errorMessage).  \(errorMessage.contains("0") ? "JSON Encode Error" : "JSON Decode Error").  Please check your internet connection, log out/log in, or try again later."
    }
    
    static func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
}

struct GenerateRandomDates {
    // tuple of startDate, endDate
    //    var dates: ([Date], [Date]) {
    //        var dates: ([Date], [Date]) = ([], [])
    //        let months = [("04", 28), ("05", 29), ("06", 28), ("07", 29), ("08", 29), ("09", 28), ("10", 29), ("11", 28), ("12", 29), ("01", 29), ("02", 26), ("03", 29)]
    //        //let days = [30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31]
    //
    //        for (month, days) in months {
    //            for day in 1...days {
    //                dates.0.append(Date.randomBetween(start: Date.parse("\(Int(month)! < 4 ? "2022" : "2021")-\(month)-\(String(day))"), end: Date.parse("\(Int(month)! < 4 ? "2022" : "2021")-\(month)-\(String(day+1))")))
    //                dates.1.append(Date.randomBetween(start: Date.parse("\(Int(month)! < 4 ? "2022" : "2021")-\(month)-\(String(day+1))"), end: Date.parse("\(Int(month)! < 4 ? "2022" : "2021")-\(month)-\(String(day+2))")))
    //            }
    //        }
    //
    //        return dates
    //    }
    
    var coolingDates: [CoolingDataEvent] {
        var dates: [CoolingDataEvent] = []
        let months = [("06", 28), ("07", 29), ("08", 29), ("09", 28), ("10", 29), ("11", 28), ("12", 29), ("01", 29), ("02", 26), ("03", 29), ("04", 28), ("05", 1)]
        //let days = [30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31]
        
        for (month, days) in months {
            for day in 1...days {
                dates.append(CoolingDataEvent(startTime: Date.randomBetween(start: Date.parse("\(Int(month)! < 6 ? "2022" : "2021")-\(month)-\(String(day))"), end: Date.parse("\(Int(month)! < 6 ? "2022" : "2021")-\(month)-\(String(day+1))")), endTime: Date.randomBetween(start: Date.parse("\(Int(month)! < 6 ? "2022" : "2021")-\(month)-\(String(day+1))"), end: Date.parse("\(Int(month)! < 6 ? "2022" : "2021")-\(month)-\(String(day+2))"))))
            }
        }
        print("done")
        return dates
    }
    
    var heatingDates: [HeatingDataEvent] {
        var dates: [HeatingDataEvent] = []
        let months = [("06", 28), ("07", 29), ("08", 29), ("09", 28), ("10", 29), ("11", 28), ("12", 29), ("01", 29), ("02", 26), ("03", 29), ("04", 28), ("05", 1)]
        //let days = [30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31]
        
        for (month, days) in months {
            for day in 1...days {
                dates.append(HeatingDataEvent(startTime: Date.randomBetween(start: Date.parse("\(Int(month)! < 6 ? "2022" : "2021")-\(month)-\(String(day))"), end: Date.parse("\(Int(month)! < 6 ? "2022" : "2021")-\(month)-\(String(day+1))")), endTime: Date.randomBetween(start: Date.parse("\(Int(month)! < 6 ? "2022" : "2021")-\(month)-\(String(day+1))"), end: Date.parse("\(Int(month)! < 6 ? "2022" : "2021")-\(month)-\(String(day+2))"))))
            }
        }
        print("done")
        return dates
    }
}

//struct SharedData: Codable, Identifiable {
//    var id: Int
//    var username: String
//    var display_name: String
//    var email: String?
//    //var type: Int // -1 == user not logged in, 0 == student, 1 == coach
//}

struct HomeConfig: Codable {
    var electricityRate: Double
    var cooling: Cooling
    var heating: Heating
    
    init() {
        electricityRate = 0
        cooling = Cooling()
        heating = Heating()
    }
}

enum CoolingType: Codable {
    case unknown
    case none
    case onlyFan
    case fanAndCompressor
}

struct Cooling: Codable {
    var type: CoolingType
    
    var fanAmperage: Double
    var fanVoltage: Double
    var fanWattage: Double {
        return fanAmperage * fanVoltage
    }
    
    var compressorAmperage: Double
    var compressorVoltage: Double
    var compressorWattage: Double {
        return compressorAmperage * compressorVoltage
    }
    
    init() {
        type = .unknown
        fanAmperage = 0
        fanVoltage = 0
        compressorAmperage = 0
        compressorVoltage = 0
    }
    
    //var events: [CoolingDataEvent]
}

// This represents one specific cooling event (e.g, one instance the A/C was on and how much energy it used)
struct CoolingDataEvent {
    
    //@EnvironmentObject private var nc: NetworkController
    var startTime: Date // the time this event started
    var endTime: Date // the time this event ended
    
    // The rest are computed properties
    var totalDuration: Double { // the total duration of this event in hours
        return (endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate) / 3600
    }
    var fankWhUsed: Double {
        return (UserData().homeConfig.cooling.fanWattage) * totalDuration / 1000
    }
    var compressorkWhUsed: Double {
        return (UserData().homeConfig.cooling.compressorWattage) * totalDuration / 1000
    }
    var totalkWhUsed: Double {
        return fankWhUsed + compressorkWhUsed
    }
    var totalCost: Double {
        return totalkWhUsed * UserData().homeConfig.electricityRate
    }
    var totalEmisssions: Double {
        return totalkWhUsed * 0.18387
    }
}

enum HeatingType: Codable {
    case unknown
    case none
    case oilBurner
    case gasBurner
    case electricResistance
}

struct Heating: Codable {
    var type: HeatingType
    var oilPrice: Double
    var oilGPH: Double
    var gasUnitsPH: Double
    var otherElectricalAmps: Double
    var otherElectricalVoltage: Double
    var otherElectricalWattage: Double {
        return otherElectricalAmps * otherElectricalVoltage
    }
    
    init() {
        type = .unknown
        oilPrice = 0
        oilGPH = 0
        gasUnitsPH = 0
        otherElectricalAmps = 0
        otherElectricalVoltage = 0
    }
}

// This represents one specific cooling event (e.g, one instance the A/C was on and how much energy it used)
struct HeatingDataEvent {
    
    //@EnvironmentObject private var nc: NetworkController
    var startTime: Date // the time this event started
    var endTime: Date // the time this event ended
    
    // The rest are computed properties
    var totalDuration: Double { // the total duration of this event in hours
        return (endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate) / 3600
    }
    var oilGallonsUsed: Double {
        return (UserData().homeConfig.heating.oilGPH) * totalDuration
    }
    var otherElectricalkWhUsed: Double {
        return (UserData().homeConfig.heating.otherElectricalWattage) * totalDuration / 1000
    }
    var totalCost: Double {
        return otherElectricalkWhUsed * UserData().homeConfig.electricityRate + oilGallonsUsed * UserData().homeConfig.heating.oilPrice
    }
    var totalEmisssions: Double {
        return otherElectricalkWhUsed * 0.18387 + oilGallonsUsed * 10.43925
    }
}
