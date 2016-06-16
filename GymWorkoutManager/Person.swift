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
    let plans = List<Plan>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var effectiveIndex:Int {
        get {
            var totalReps:[Int] = []
            var totalSets:[Int] = []
            for eachExercise in exercise {
                totalReps.append((eachExercise.reps as NSString).integerValue)
                totalSets.append((eachExercise.set as NSString).integerValue)
            }
            let averageReps = totalReps.reduce(0, combine: +)/totalReps.count
            let averageSets = totalSets.reduce(0, combine: +)/totalSets.count
            if averageReps >= 8 && averageReps <= 16 {
                if averageSets > 3 && averageSets <= 5 {
                    return 8
                } else {
                    return 5
                }
            } else {
                return 2
            }
        }
    }
}