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

extension NSDate {
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}

extension UIColor {
    
    // Convert a hex string to a UIColor object.
    class func colorFromHex(hexString:String) -> UIColor {
        
        func cleanHexString(hexString: String) -> String {
            
            var cleanedHexString = String()
            
            // Remove the leading "#"
            if(hexString[hexString.startIndex] == "#") {
                cleanedHexString = hexString.substringFromIndex(hexString.startIndex.advancedBy(1))
            }
            
            // TODO: Other cleanup. Allow for a "short" hex string, i.e., "#fff"
            
            return cleanedHexString
        }
        
        let cleanedHexString = cleanHexString(hexString)
        
        // If we can get a cached version of the colour, get out early.
        if let cachedColor = UIColor.getColorFromCache(cleanedHexString) {
            return cachedColor
        }
        
        // Else create the color, store it in the cache and return.
        let scanner = NSScanner(string: cleanedHexString)
        
        var value:UInt32 = 0
        
        // We have the hex value, grab the red, green, blue and alpha values.
        // Have to pass value by reference, scanner modifies this directly as the result of scanning the hex string. The return value is the success or fail.
        if(scanner.scanHexInt(&value)){
            
            // intValue = 01010101 11110111 11101010    // binary
            // intValue = 55       F7       EA          // hexadecimal
            
            //                     r
            //   00000000 00000000 01010101 intValue >> 16
            // & 00000000 00000000 11111111 mask
            //   ==========================
            // = 00000000 00000000 01010101 red
            
            //            r        g
            //   00000000 01010101 11110111 intValue >> 8
            // & 00000000 00000000 11111111 mask
            //   ==========================
            // = 00000000 00000000 11110111 green
            
            //   r        g        b
            //   01010101 11110111 11101010 intValue
            // & 00000000 00000000 11111111 mask
            //   ==========================
            // = 00000000 00000000 11101010 blue
            
            let intValue = UInt32(value)
            let mask:UInt32 = 0xFF
            
            let red = intValue >> 16 & mask
            let green = intValue >> 8 & mask
            let blue = intValue & mask
            
            // red, green, blue and alpha are currently between 0 and 255
            // We want to normalise these values between 0 and 1 to use with UIColor.
            let colors:[UInt32] = [red, green, blue]
            let normalised = normaliseColors(colors)
            
            let newColor = UIColor(red: normalised[0], green: normalised[1], blue: normalised[2], alpha: 1)
            UIColor.storeColorInCache(cleanedHexString, color: newColor)
            
            return newColor
            
        }
            // We couldn't get a value from a valid hex string.
        else {
            print("Error: Couldn't convert the hex string to a number, returning UIColor.whiteColor() instead.")
            return UIColor.whiteColor()
        }
    }
    
    // Takes an array of colours in the range of 0-255 and returns a value between 0 and 1.
    private class func normaliseColors(colors: [UInt32]) -> [CGFloat]{
        var normalisedVersions = [CGFloat]()
        
        for color in colors{
            normalisedVersions.append(CGFloat(color % 256) / 255)
        }
        
        return normalisedVersions
    }
    
    // Caching
    // Store any colours we've gotten before. Colours don't change.
    private static var hexColorCache = [String : UIColor]()
    
    private class func getColorFromCache(hexString: String) -> UIColor? {
        guard let color = UIColor.hexColorCache[hexString] else {
            return nil
        }
        
        return color
    }
    
    private class func storeColorInCache(hexString: String, color: UIColor) {
        
        if UIColor.hexColorCache.keys.contains(hexString) {
            return // No work to do if it is already there.
        }
        
        UIColor.hexColorCache[hexString] = color
    }
    
    private class func clearColorCache() {
        UIColor.hexColorCache.removeAll()
    }
}

