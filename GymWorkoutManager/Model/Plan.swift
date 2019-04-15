//
//  Plan.swift
//  GymWorkoutManager
//
//  Created by zhangyunchen on 16/5/26.
//  Copyright © 2016年 McKay. All rights reserved.
//
import RealmSwift

class Plan: Object {
    @objc dynamic var date = ""
    @objc dynamic var exerciseType = ""
    @objc dynamic var detail = ""
}
