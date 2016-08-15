//
//  CommonUtils.swift
//  GymWorkoutManager
//
//  Created by zhangyunchen on 16/5/17.
//  Copyright © 2016年 McKay. All rights reserved.
//
import UIKit

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}

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