//
//  StorageManager.swift
//  myPlaces
//
//  Created by Артем Хребтов on 31.05.2021.
//

import RealmSwift

let realm = try! Realm()
class StorageManager {
    
    static func saveObject (_ coctail: Coctail){
        try! realm.write{
            realm.add(coctail)
        }
        
    }
    static func deleteObject (_ coctail: Coctail){
        try! realm.write {
            realm.delete(coctail)
        }
    }
}
