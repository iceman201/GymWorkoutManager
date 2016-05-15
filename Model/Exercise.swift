//
//  File.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 30/04/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import RealmSwift

class Exercise: Object {
    dynamic var exerciseName = ""
    dynamic var times = ""
    dynamic var reps = ""
    dynamic var set = ""
    dynamic var date = ""
    dynamic var who: Person?
}

class Person: Object {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var sex = ""
    dynamic var birthdate = NSDate(timeIntervalSince1970: 1)
    dynamic var BMI = ""
    dynamic var profilePicture : NSData?
    dynamic var activedDays : NSNumber = 0
    
    let exercise = List<Exercise>()
    override static func primaryKey() -> String? {
        return "id"
    }
}