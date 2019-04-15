//
//  Exercise.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 30/04/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import RealmSwift

class Exercise: Object {
    @objc dynamic var exerciseName = ""
    @objc dynamic var times = ""
    @objc dynamic var reps = ""
    @objc dynamic var set = ""
    @objc dynamic var date = ""
    @objc dynamic var workoutType = -1
}
