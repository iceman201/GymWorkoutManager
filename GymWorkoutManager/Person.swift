//
//  Person.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/5/15.
//  Copyright © 2016年 McKay. All rights reserved.
//
import RealmSwift

class Person: Object {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var sex = ""
    dynamic var age : NSNumber = 0
    dynamic var BMI = ""
    dynamic var height = ""
    dynamic var weight = ""
    dynamic var bodyFat : NSNumber = 0
    dynamic var profilePicture : NSData?
    dynamic var activedDays : NSNumber = 0
    dynamic var lastTimeUseApp : NSDate?
    
    let exercise = List<Exercise>()
    override static func primaryKey() -> String? {
        return "id"
    }
}