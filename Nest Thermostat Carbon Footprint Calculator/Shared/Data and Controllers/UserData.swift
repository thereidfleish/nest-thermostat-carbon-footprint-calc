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
    // Shared data
    var shared: SharedData
    
    var loggedIn: Bool = false
    
    var profilePic: URL?
    
    var electricityRate: Double
    
    var cooling: Cooling
    
    var heating: Heating
    
    
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
        let months = [("04", 28), ("05", 29), ("06", 28), ("07", 29), ("08", 29), ("09", 28), ("10", 29), ("11", 28), ("12", 29), ("01", 29), ("02", 26), ("03", 29)]
        //let days = [30, 31, 30, 31, 31, 30, 31, 30, 31, 31, 28, 31]
        
        for (month, days) in months {
            for day in 1...days {
                dates.append(CoolingDataEvent(startTime: Date.randomBetween(start: Date.parse("\(Int(month)! < 4 ? "2022" : "2021")-\(month)-\(String(day))"), end: Date.parse("\(Int(month)! < 4 ? "2022" : "2021")-\(month)-\(String(day+1))")), endTime: Date.randomBetween(start: Date.parse("\(Int(month)! < 4 ? "2022" : "2021")-\(month)-\(String(day+1))"), end: Date.parse("\(Int(month)! < 4 ? "2022" : "2021")-\(month)-\(String(day+2))"))))
            }
        }
        
        return dates
    }
}

struct SharedData: Codable, Identifiable {
    var id: Int
    var username: String
    var display_name: String
    var email: String?
    //var type: Int // -1 == user not logged in, 0 == student, 1 == coach
}

enum CoolingType {
    case unknown
    case none
    case onlyFan
    case fanAndCompressor
}

struct Cooling {
    var type: CoolingType
    var fanWattage: Double?
    var compressorWattage: Double?
    var events: [CoolingDataEvent]
}

// This represents one specific cooling event (e.g, one instance the A/C was on and how much energy it used)
struct CoolingDataEvent: Comparable {
    // These two static functions help the struct conform to the Comparable protocol
    static func < (lhs: CoolingDataEvent, rhs: CoolingDataEvent) -> Bool {
        lhs.totalkWhUsed < rhs.totalkWhUsed
    }
    static func == (lhs: CoolingDataEvent, rhs: CoolingDataEvent) -> Bool {
        lhs.totalkWhUsed == rhs.totalkWhUsed
    }
    
    @EnvironmentObject private var nc: NetworkController
    var startTime: Date // the time this event started
    var endTime: Date // the time this event ended
    var totalTime: Double { // the total duration of this event
        return endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
    }
    var fankWhUsed: Double {
        return (nc.userData.cooling.fanWattage ?? 0) * totalTime
    }
    var compressorkWhUsed: Double {
        return (nc.userData.cooling.compressorWattage ?? 0) * totalTime
    }
    var totalkWhUsed: Double {
        return fankWhUsed + compressorkWhUsed
    }
}

//// This represents all of the cooling data events, and is a computed property
//struct CoolingData {
//    var coolingData: [CoolingDataEvent]
//    var coolingEvents: [CoolingDataEvent] {
//
//    }
//}

enum HeatingType {
    case unknown
    case none
    case oilBurner
    case gasBurner
    case electricResistance
}

struct Heating {
    var type: HeatingType
    var oilGPH: Double?
    var gasUnitsPH: Double?
    var otherElectricalWattage: Double?
}
