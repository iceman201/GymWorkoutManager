//
//  Plan.swift
//  GymWorkoutManager
//
//  Created by zhangyunchen on 16/5/26.
//  Copyright © 2016年 McKay. All rights reserved.
//
import RealmSwift

class Plan: Object {
    dynamic var date = ""
    dynamic var exerciseType = ""
    dynamic var detail = ""
    dynamic var who: Person?
}