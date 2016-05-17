//
//  CommonUtils.swift
//  GymWorkoutManager
//
//  Created by zhangyunchen on 16/5/17.
//  Copyright © 2016年 McKay. All rights reserved.
//
import UIKit

class CommonUtils {
    
    class func scheduleLocalNotification(){
        print("schedule a local notificaiton")
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 3)
        localNotification.alertBody = "Hellor World"
        //我们必须指定用户点击通知后对应的类目动作。回忆一下，我们前面已经定义了一个类目和类目标示符，我们在这里就能使用到这个标示符了
//        localNotification.category = "category1"
        //schedule this local notification
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
}
