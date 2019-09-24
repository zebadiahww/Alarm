//
//  SwitchTableViewCell.swift
//  myAlarm
//
//  Created by Zebadiah Watson on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

// Step 1 of 5
protocol AlarmTableViewCellDelegate: class {
    func enabledValueChanged(_ cell: SwitchTableViewCell, selected: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    
    
    // Landing Pad
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    // STEP 2 of 5
    weak var delegate: AlarmTableViewCellDelegate?

    @IBOutlet weak var alarmSwitch: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    //STEP 3 of 5 
    //Actions
    @IBAction func alarmSwitch(_ sender: Any) {
        delegate?.enabledValueChanged(self, selected: alarmSwitch.isOn)
    }

    func updateViews() {
        guard let alarm = alarm else { return }
        nameLabel.text = alarm.alarmName
        timeLabel.text = alarm.fireTimeAsString
        alarmSwitch.isOn = alarm.enabled
        
    }
}
