//
//  RealmManager.swift
//  Leave Management
//
//  Created by osx on 09/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import Foundation
import RealmSwift


class RealmDatabase
{
    static let shared = RealmDatabase()
    
    private init() {}
    
    func add(object: Object) {
        
        if canAdd(object: object) == false {
            return
        }
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object, update: .all)
                //                realm.add(object, update: true)
            }
        } catch let error as NSError {
            print(error)
        }
    }
    func getDataFromDB<T>(type: T) -> Results<Object>? {
        do {
            let realm = try Realm()
            let results: Results<Object> = realm.objects(type as! Object.Type)
            return results
        }  catch let error as NSError {
            print(error)
            return nil
        }
    }
    func update<T>(type: T, AndValue value: Any) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.create(type as! Object.Type, value: value, update: .all)
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func fetch<T>(type: T, AndPrimaryKey pKey: String) -> Object? {
        do {
            let realm = try Realm()
            let result = realm.object(ofType: type as! Object.Type, forPrimaryKey: pKey)
            return result
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
    func fetch<T>(type: T, AndFilter filter: NSPredicate?) -> Results<Object>? {
        do {
            let realm = try Realm()
            if let queryFilter = filter {
                let results = realm.objects(type as! Object.Type).filter(queryFilter)
                return results
            }
            let results = realm.objects(type as! Object.Type)
            return results
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
    
    func delete<T>(type: T, AndFilter filter: NSPredicate?) {
        do {
            let realm = try Realm()
            try realm.write {
                if let queryFilter = filter {
                    let results = realm.objects(type as! Object.Type).filter(queryFilter)
                    realm.delete(results)
                } else {
                    let results = realm.objects(type as! Object.Type)
                    realm.delete(results)
                }
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    func canAdd(object: Object) -> Bool {
        
        if let user = object as? UserModel {
            return user.id != 0
        }
        return true
    }
    
    func deleteAllFromDatabase()  {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch let error as NSError {
            print(error)
        }
    }
}

