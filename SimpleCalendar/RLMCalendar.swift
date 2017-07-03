//
//  RLMCalendar.swift
//  SimpleCalendar
//
//  Created by TakuyaMano on 2017/07/03.
//  Copyright © 2017年 TakuyaMano. All rights reserved.
//

import UIKit
import RealmSwift

class RLMCalendar: Object {

    dynamic var date: String = ""
    dynamic var memoText: String = ""

    override static func primaryKey() -> String? {
        return "date"
    }
}
