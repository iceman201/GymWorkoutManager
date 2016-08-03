//
//  CommonUtils.swift
//  GymWorkoutManager
//
//  Created by zhangyunchen on 16/5/17.
//  Copyright © 2016 McKay. All rights reserved.
//
import UIKit

class CommonUtils {
    
    class func scheduleLocalNotification(){
        print("schedule a local notificaiton")
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 3)
        localNotification.alertBody = "Hellor World"
        //schedule this local notification
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
}

func timeToSecond(time: String) -> Int {
    let formater = time.characters.split{$0 == ":"}.map(String.init)
    let mins = Int(formater[0])
    let sec = Int(formater[1])
    guard let m = mins, let s = sec else {
        return 0
    }
    return m * 60 + s
}

func numberEnterOnly(replacementString string: String) -> Bool {
    let inverseSet = NSCharacterSet(charactersInString:"0123456789.").invertedSet
    let components = string.componentsSeparatedByCharactersInSet(inverseSet)
    let filtered = components.joinWithSeparator("")
    return string == filtered
}

extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}