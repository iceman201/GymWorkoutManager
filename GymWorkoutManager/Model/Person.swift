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
    dynamic var profilePicture : Data?
    dynamic var activedDays : NSNumber = 0
    dynamic var lastTimeUseApp : Date?
    
    let exercise = List<Exercise>()
    let plans = List<Plan>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var effectiveIndex:Float {
        get {
            var result:Float = 0
            guard exercise.isEmpty == false else {
                return result
            }
            var reps:[Int] = []
            var sets:[Int] = []
            var hasWeightTraining: Bool = false
            
            for eachExercise in exercise {
                let totalSeconds = timeToSecond(eachExercise.times)
                if eachExercise.workoutType == 0 {
                    result += 1
                    if totalSeconds >= 3600 {
                        result = 10 //If runner run for an hour or more which means it's absolute effective
                    } else if totalSeconds < 2400 {
                        result = 5 //if runner run less than 40 mins, body fat wont burn much
                    }
                } else if eachExercise.workoutType == 1 {
                    hasWeightTraining = true
                    reps.append(Int(eachExercise.reps) ?? 0)
                    sets.append(Int(eachExercise.set) ?? 0)
                    if totalSeconds >= 1800 {
                        result = 1 // weight training should be more than 30mins at lease
                    }
                } else if eachExercise.workoutType == 2 {
                    if totalSeconds >= 225 {
                        result = 7
                    } else if totalSeconds >= 360 {
                        result = 8.5
                    } else if totalSeconds >= 450 {
                        result = 10
                    }
                }
            }
            if hasWeightTraining {
                let averageReps = reps.reduce(0, +)/reps.count
                let averageSets = sets.reduce(0, +)/sets.count
                if averageReps >= 8 && averageReps <= 16 {
                    if averageSets > 3 && averageSets <= 5 {
                        result += 1
                    } else {
                        result += 2
                    }
                } else if averageSets == 0 || averageReps == 0 {
                    result = 0
                }
            }
            if result >= 10 {
                return 10
            } else {
                return result
            }
        }
    }
    
    func getPercentageOfWorkout(_ whichWorkout:String) -> Double {
        let allTypes = exercise.map({"\($0.workoutType)"})
        var counter = 0.0
        for each in allTypes{
            if each == whichWorkout {
                counter += 1.0
            }
        }
        return (counter/Double(allTypes.count)) * 100
    }
}
