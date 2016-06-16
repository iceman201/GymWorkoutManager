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
            guard exercise.isEmpty == false else {
                return 0
            }
            var reps:[Int] = []
            var sets:[Int] = []
            for eachExercise in exercise {
                
                reps.append(Int(eachExercise.reps) ?? 0)
                sets.append(Int(eachExercise.set) ?? 0)
            }
            let totalReps = reps.reduce(0, combine: +)
            let totalSets = sets.reduce(0, combine: +)
            let averageReps = totalReps/reps.count
            let averageSets = totalSets/sets.count

            if averageReps >= 8 && averageReps <= 16 {
                if averageSets > 3 && averageSets <= 5 {
                    return 8
                } else {
                    return 5
                }
            } else if averageSets == 0 || averageReps == 0 {
                return 0
            } else {
                return 2
            }
        }
    }
}