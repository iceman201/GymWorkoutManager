//
//  Timer.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 22/01/17.
//  Copyright © 2017 McKay. All rights reserved.
//

import Foundation

class CountingTimer: NSObject {
    public static let shareTimer = CountingTimer() // Singleton
    
    func timeDate(_ time: [String]) -> Date {
        let numberFormatter = NumberFormatter();
        let repeatString = String.init(format: "%02d:%02d.00", numberFormatter.number(from: time[0])!.intValue, numberFormatter.number(from: time[1])!.intValue)
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "mm:ss.SS", options: 0, locale: Locale.current)
        return dateFormatter.date(from: repeatString)!
    }
    
    func timeString(_ time: [String]) -> String {
        let numberFormatter = NumberFormatter();
        return String.init(format: "%02d:%02d.00", numberFormatter.number(from: time[0])!.intValue, numberFormatter.number(from: time[1])!.intValue)
    }
    
    func timeDateString(_ timeDate: Date) -> String {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "mm:ss.SS", options: 0, locale: Locale.current)
        return dateFormatter.string(from: timeDate)
    }
    
    func getDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day, .month,.year], from: date)
        let day = components.day
        let month = components.month
        let year = components.year
        guard let d = day, let m = month, let y = year else {
            return ""
        }
        let formater = "\(d)/\(m)/\(y)"
        
        return formater
    }

}

