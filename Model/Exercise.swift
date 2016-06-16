//
//  Exercise.swift
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
}