//
//  EditTableViewController.swift
//  PandaNotif
//
//  Created by ShinichiSakaguchi on 2015/01/20.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

protocol EditTableViewControllerDelegate: class {
    func saveNewAlarm(alarmEntity: PNDAlarmEntity)
    func saveEditAlarm(alarmEntity: PNDAlarmEntity, editedRow: Int)
}

class EditTableViewController: UITableViewController, RepeatTableViewControllerDelegate, SoundTableViewControllerDelegate, UITextFieldDelegate {
    @IBOutlet private weak var editTable: UITableView!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var snoozeSwitch: UISwitch!
    @IBOutlet private weak var repeatLabel: UILabel!
    @IBOutlet private weak var label: UITextField!
    @IBOutlet private weak var sound: UILabel!
    weak var delegate: EditTableViewControllerDelegate?
    var from = ""
    var editedRow = 0
    var alarmEntity = PNDAlarmEntity()
    var defaultAlarmTime = ""
    var defaultLabel = ""
    var defaultRepeat = ""
    var defaultSound = ""
    var defaultSnooze = Bool()
    var defaultEnabled = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let v = UIView(frame: CGRectZero)
        v.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = v
        self.tableView.tableHeaderView = v
        self.label.delegate = self
        
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        let currentDate = calendar.dateBySettingHour(PNDAlarmCalculateManager.convertTimeStringToHour(self.alarmEntity.alarmTime), minute:PNDAlarmCalculateManager.convertTimeStringToMinute(self.alarmEntity.alarmTime), second: 0, ofDate: NSDate(), options: nil)!
        datePicker.setDate(currentDate, animated: false)
        
        self.label.addTarget(self, action:"editingChangedLabel:",forControlEvents: UIControlEvents.EditingChanged)
        self.snoozeSwitch.addTarget(self, action: "onClickSnoozeSwicth:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.snoozeSwitch.on = (self.alarmEntity.snooze ? true : false)
        self.defaultAlarmTime = self.alarmEntity.alarmTime
        self.defaultLabel = self.alarmEntity.label
        self.defaultRepeat = self.alarmEntity.repeat
        self.defaultSound = self.alarmEntity.sound
        self.defaultSnooze = self.alarmEntity.snooze
        self.defaultEnabled = self.alarmEntity.enabled
        
        self.repeatLabel.text = PNDAlarmTableViewManager.repeatStatus(self.alarmEntity.repeat)
        self.label.text = self.alarmEntity.label
        self.sound.text = PNDAlarmTableViewManager.soundName(self.alarmEntity.sound)
    }
    
    override func viewWillDisappear(animated: Bool) {
        let viewControllers = self.navigationController?.viewControllers!
        if indexOfArray(viewControllers!, searchObject: self) == nil {
            self.alarmEntity.alarmTime = self.defaultAlarmTime
            self.alarmEntity.label = self.defaultLabel
            self.alarmEntity.repeat = self.defaultRepeat
            self.alarmEntity.sound = self.defaultSound
            self.alarmEntity.snooze = self.defaultSnooze
            self.alarmEntity.enabled = self.defaultEnabled
        }
        super.viewWillDisappear(animated)
    }
    
    func indexOfArray(array:[AnyObject], searchObject: AnyObject)-> Int? {
        for (index, value) in enumerate(array) {
            if value as UIViewController == searchObject as UIViewController {
                return index
            }
        }
        return nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "toRepeatTableViewController" {
            let vc = segue.destinationViewController as RepeatTableViewController
            vc.navigationItem.title = "繰り返し"
            vc.repeat = self.alarmEntity.repeat
            vc.delegate = self
        } else if segue.identifier == "toSoundTableViewController" {
            let vc = segue.destinationViewController as SoundTableViewController
            vc.navigationItem.title = "サウンド"
            vc.sound = self.alarmEntity.sound
            vc.delegate = self
        }
    }

    func editingChangedLabel(sender: UITextField) {
        if !self.label.text.isEmpty {
            self.alarmEntity.label = self.label.text
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction private func saveButtonPush(sender: UIBarButtonItem) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.alarmEntity.alarmTime = dateFormatter.stringFromDate(datePicker.date)
        
        if self.from == "add" {
            self.delegate?.saveNewAlarm(self.alarmEntity)
        } else {
            NSLog("editIndexPath : %d",self.editedRow)
            self.delegate?.saveEditAlarm(self.alarmEntity, editedRow: self.editedRow)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func onClickSnoozeSwicth(sender: UISwitch) {
        self.alarmEntity.snooze = (sender.on ? true : false)
    }
    
    func changeRepeat(repeat:String) {
        self.alarmEntity.repeat = repeat
        self.repeatLabel.text = PNDAlarmTableViewManager.repeatStatus(self.alarmEntity.repeat)
    }
    
    func changeSound(sound:String) {
        self.alarmEntity.sound = sound
        self.sound.text = PNDAlarmTableViewManager.soundName(self.alarmEntity.sound)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
