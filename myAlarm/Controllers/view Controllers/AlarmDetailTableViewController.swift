//
//  AlarmDetailTableViewController.swift
//  myAlarm
//
//  Created by Zebadiah Watson on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    var alarm: Alarm?
    var alarmIsOn = true
    
    //OUTLETS
    @IBOutlet weak var disableButton: UIButton!
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var alarmTimePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    //ACTIONS
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let alarmName = alarmNameTextField.text,
            let alarmTime = alarmTimePicker?.date,
            !alarmName.isEmpty
            else { return }
        
        if let alarm = alarm {
            AlarmController.shared.Update(to: alarm, firedate: alarmTime, name: alarmName, enabled: alarmIsOn)
        } else {
            AlarmController.shared.addAlarm(fireDate: alarmTime, name: alarmName, enabled: alarmIsOn)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func enableButtonTapped(_ sender: Any) {
        // declare new constant to pass in
        guard let alarm = alarm else { return }
        if alarmIsOn == true {
            alarmIsOn = false
            disableButton.setTitle("Enable", for: .normal)
            AlarmController.shared.scheduleUserNotifications(for: alarm) // pass in new constant
        } else {
            alarmIsOn = true
            disableButton.setTitle("Disable", for: .normal)
            AlarmController.shared.cancelUserNotifications(for: alarm) // pass in new constant 
        }
    }
    
    
    private func updateViews() {
        guard let alarm = alarm else { return }
        alarmTimePicker.date = alarm.fireDate
        alarmNameTextField.text = alarm.alarmName
        self.title = alarm.alarmName
        self.alarmIsOn = alarm.enabled
        if alarm.enabled == true {
            disableButton.setTitle("Disable", for: .normal)
        } else {
            disableButton.setTitle("Enable", for: .normal)
        }
    }
    
}
