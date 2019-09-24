//
//  AlarmController.swift
//  myAlarm
//
//  Created by Zebadiah Watson on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import UserNotifications

//create protocol
protocol AlarmScheduler: class {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}
//create extension
extension AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Alarm:"
        notificationContent.body = alarm.alarmName
        notificationContent.sound = UNNotificationSound.default()
        let dateComponents = Calendar.current.dateComponents([.minute, .second], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}

class AlarmController: AlarmScheduler {
    
    //sharedinstance
    static let shared = AlarmController()
    
    
    //Source of Truth
    var alarms: [Alarm] = []
    
    
    //CRUD
    //Create
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let newAlarm = Alarm(fireDate: fireDate, alarmName: name, enabled: enabled)
        alarms.append(newAlarm)
        saveToPersistentStore()
        scheduleUserNotifications(for: newAlarm)
        print("alarm created")
    }
    
    // Update
    func Update(to alarm: Alarm, firedate: Date, name: String, enabled: Bool) {
        alarm.fireDate = firedate
        alarm.alarmName = name
        alarm.enabled = enabled
        saveToPersistentStore()
        scheduleUserNotifications(for: alarm)
        print("did update")
    }
    // DELETE
    func deleteAlarm(alarm: Alarm) {
        guard let alarmIndex = alarms.firstIndex(of: alarm) else { return }
        alarms.remove(at: alarmIndex)
        saveToPersistentStore()
        cancelUserNotifications(for: alarm)
        print("did delete")
    }
    
    //SAVE
    func createFileForPersistence() -> URL {
        //grab users document directory
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //create the new fileURL on users Phone
        let fileUrl = urls[0].appendingPathComponent("myAlarm.JSON")
        return fileUrl
    }
    
    func saveToPersistentStore() {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonMyAlarm = try jsonEncoder.encode(alarms)
            try jsonMyAlarm.write(to: createFileForPersistence())
        } catch let encodingError {
            print("There as an error saving the data! \(encodingError.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore() {
        let jsonDecoder = JSONDecoder()
        do {
            let jsonData = try Data(contentsOf: createFileForPersistence())
            let decodedAlarmArray = try jsonDecoder.decode([Alarm].self, from: jsonData)
            alarms = decodedAlarmArray }
        catch let encodingError {
            print("there was an error loading the data! \(encodingError.localizedDescription)")
        }
    }
    
    
}// End Of CLass

var mockAlarms: [Alarm] = {
    
    let alarmOne = Alarm(fireDate: Date(), alarmName: "Alarm One", enabled: true, uuid: "")
    let alarmTwo = Alarm(fireDate: Date(), alarmName: "Alarm Two", enabled: true, uuid: "")
    let alarmThree = Alarm(fireDate: Date(), alarmName: "Alarm Three", enabled: true, uuid: "")
    
    return [alarmOne, alarmTwo, alarmThree]
}()

