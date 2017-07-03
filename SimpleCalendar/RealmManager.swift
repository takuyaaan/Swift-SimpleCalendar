//
//  RealmManager.swift
//  SimpleCalendar
//
//  Created by TakuyaMano on 2017/07/03.
//  Copyright © 2017年 TakuyaMano. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class RealmManager {

    fileprivate final let realmVersion = 0
    var realmConfig: Realm.Configuration
    var realm: Realm!
    
    static let sharedInstance = RealmManager()
    private init() {
        
        realmConfig = Realm.Configuration.defaultConfiguration
        realmMigration(version: UInt64(realmVersion))
        
        Realm.Configuration.defaultConfiguration = realmConfig
        if (realm == nil) == true {
            realm = try! Realm()
        }
    }
    
    fileprivate func realmMigration(version: UInt64) {
        let config = Realm.Configuration(
            schemaVersion: version,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                }
        },
            deleteRealmIfMigrationNeeded: true
        )
        realmConfig = config
    }

    func isSaveAt(date: String) -> Bool {
        let subObject = realm.objects(RLMCalendar.self).filter("date == %@", date)
        guard subObject.count > 0 else {
            return false
        }
        return true
    }

    func memoAt(date: String) -> String {
        guard realm != nil else {
            return ""
        }

        let exitCheck = realm.objects(RLMCalendar.self)
        guard exitCheck.count > 0 else {
            return ""
        }

        let subObject = realm.objects(RLMCalendar.self).filter("date == %@", date)
        guard subObject.count > 0 else {
            return ""
        }
        subObject.forEach{(sub) in
            return sub.memoText
        }
        return ""
    }

    func insertDate(date: String, memo: String) {
        guard realm != nil else {
            return
        }
        
        let subObject = realm.objects(RLMCalendar.self).filter("date == %@", date)
        guard subObject.count <= 0 else {
            updateDate(date: date, memo: memo)
            return
        }
        
        let realmObject = RLMCalendar()
        realmObject.memoText = memo
        realmObject.date = date
        try! realm.write {
            realm.add(realmObject)
        }
    }

    func updateDate(date: String, memo: String) {
        guard realm != nil else {
            return
        }

        let subObject = realm.objects(RLMCalendar.self).filter("date == %@", date)
        guard subObject.count > 0 else {
            return
        }

        subObject.forEach{(sub) in
            try! realm.write {
                sub.memoText = memo
            }
        }
    }
    
    func deleteDate(date: String) {
        guard realm != nil else {
            return
        }
        
        let exitCheck = realm.objects(RLMCalendar.self)
        guard exitCheck.count > 0 else {
            return
        }

        let subObject = realm.objects(RLMCalendar.self).filter("date == %@", date)
        guard subObject.count > 0 else {
            return
        }
        try! realm.write {
            realm.delete(subObject)
        }
    }
}
