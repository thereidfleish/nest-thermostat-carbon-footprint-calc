//
//  Data.swift
//  AI Tennis Coach
//
//  Created by Reid Fleishman on 12/29/21.
//

import Foundation
import UIKit
import AVFoundation

struct UserData {
    // Shared data
    var shared: SharedData
    
    var loggedIn: Bool = false
    
    var profilePic: URL?
    
    var electricityRate = Double
    
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

struct SharedData: Codable, Identifiable {
    var id: Int
    var username: String
    var display_name: String
    var email: String?
    //var type: Int // -1 == user not logged in, 0 == student, 1 == coach
}

enum CoolingType {
    case onlyFan
    case fanAndCompressor
}

struct Cooling {
    var type: CoolingType
    var fanWattage: Double
    var compressorWattage: Double?
}

enum HeatingType {
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
