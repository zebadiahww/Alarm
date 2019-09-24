//
//  Alarm.swift
//  myAlarm
//
//  Created by Zebadiah Watson on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class Alarm: Codable {
    var fireDate: Date
    var alarmName: String
    var enabled: Bool
    var uuid: String
    var fireTimeAsString: String {
        let timeFormat = DateFormatter()
        timeFormat.timeStyle = .none
        timeFormat.timeStyle = .short
        return timeFormat.string(from: fireDate)
    }
    
    init(fireDate: Date, alarmName: String, enabled: Bool = true, uuid: String = UUID().uuidString) {
        self.alarmName = alarmName
        self.fireDate = fireDate
        self.enabled = enabled
        self.uuid = uuid
    }
}// End of Class

extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.alarmName == rhs.alarmName && lhs.fireDate == rhs.fireDate
    }
}



