//
//  DatabaseHelper.swift
//  GymWorkoutManager
//
//  Created by Hoolai on 16/5/15.
//  Copyright © 2016年 McKay. All rights reserved.
//

import Foundation
import RealmSwift

struct DatabaseHelper {
    
    fileprivate var realm:Realm?
    
    fileprivate init(){
        realm = try! Realm()
    }
    
    static let sharedInstance = DatabaseHelper()
    
}


extension DatabaseHelper {
    func insert(_ object:Object) {
        try! realm?.write({
            realm?.add(object)
        })
    }
    
    func delete(_ object:Object) {
        try! realm?.write({
            realm?.delete(object)
        })
    }
    
    func update(_ object:Object) {
        try! realm?.write({
            realm?.add(object, update: true)
        })
    }
    
    func queryAll<T:Object>(_ clazz:T) -> Array<T>? {
        var array:[T] = []
        if realm != nil {
            let objs:Results<T> = (realm?.objects(T))!
            for result in objs {
                array.append(result)
            }
        }
        return array
    }
}

extension DatabaseHelper {
    /**
     Calling when start editing the database
     */
    func beginTransaction() {
        if realm != nil {
            if !(realm?.inWriteTransaction)! {
                realm?.beginWrite()
            }
        }
    }
    
    /**
     Calling after use the database
     */
    func commitTransaction() {
        if realm != nil {
            try! realm?.commitWrite()
        }
    }
}

