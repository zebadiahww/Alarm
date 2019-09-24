//
//  AlarmTableViewController.swift
//  myAlarm
//
//  Created by Zebadiah Watson on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AlarmController.shared.loadFromPersistentStore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AlarmController.shared.alarms.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableVIewCell", for: indexPath) as? SwitchTableViewCell
        let alarm = AlarmController.shared.alarms[indexPath.row]
        cell?.alarm = alarm
        
        //Step 5 of 5
        cell?.delegate = self
        // Configure the cell...
        
        return cell ?? UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.deleteAlarm(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "alarmDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let destinationVC = segue.destination as? AlarmDetailTableViewController else { return }
            
            let objectToSend = AlarmController.shared.alarms[indexPath.row]
            destinationVC.alarm = objectToSend
        }
        
    }
    
    
} // End Of Class

// STEP 4 of 5

extension AlarmTableViewController: AlarmTableViewCellDelegate {
    func enabledValueChanged(_ cell: SwitchTableViewCell, selected: Bool) {
        guard let alarm = cell.alarm else { return }
        alarm.enabled = selected
        cell.updateViews()
        
    }
    
    
}

