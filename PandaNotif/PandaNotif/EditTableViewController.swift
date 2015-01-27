//
//  EditTableViewController.swift
//  PandaNotif
//
//  Created by ShinichiSakaguchi on 2015/01/20.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

protocol EditTableViewControllerDelegate : class {
    func saveNewAlarm(alarmTime:String,label:String,repeat:String,sound:String,snooze:Bool)
    func saveEditAlarm(alarmTime:String,label:String,repeat:String,sound:String,snooze:Bool,enabled:Bool,indexPath:Int)
}

class EditTableViewController: UITableViewController, RepeatTableViewControllerDelegate, SoundTableViewControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var editTable: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var snoozeSwitch: UISwitch!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var label: UITextField!
    @IBOutlet weak var sound: UILabel!
    weak var delegate: EditTableViewControllerDelegate? = nil
    let calculate = PNDAlarmCalculateClass()
    let tableClass = PNDAlarmTableViewClass()
    var from = String()
    var editIndexPath = Int()
    var alarmEntity = PNDAlarmEntity()
    var defaultAlarmTime = String()
    var defaultLabel = String()
    var defaultRepeat = String()
    var defaultSound = String()
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
        let currentDate = calendar.dateBySettingHour(calculate.convertTimeStringToHour(self.alarmEntity.alarmTime), minute:calculate.convertTimeStringToMinute(self.alarmEntity.alarmTime), second: 0, ofDate: NSDate(), options: nil)!
        datePicker.setDate(currentDate, animated: false)
        
        self.label.addTarget(self, action:"editingChangedLabel:",forControlEvents: UIControlEvents.EditingChanged)
        self.snoozeSwitch.addTarget(self, action: "onClickSnoozeSwicth:", forControlEvents: UIControlEvents.ValueChanged)
        
        if self.alarmEntity.snooze {
            self.snoozeSwitch.on = true
        } else {
            self.snoozeSwitch.on = false
        }
        self.defaultAlarmTime = self.alarmEntity.alarmTime
        self.defaultLabel = self.alarmEntity.label
        self.defaultRepeat = self.alarmEntity.repeat
        self.defaultSound = self.alarmEntity.sound
        self.defaultSnooze = self.alarmEntity.snooze
        self.defaultEnabled = self.alarmEntity.enabled
        
        self.repeatLabel.text = self.tableClass.repeatStatus(self.alarmEntity.repeat)
        self.label.text = self.alarmEntity.label
        self.sound.text = self.tableClass.soundName(self.alarmEntity.sound)
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
            vc.repeat = alarmEntity.repeat
            vc.delegate = self
        } else if segue.identifier == "toSoundTableViewController" {
            let vc = segue.destinationViewController as SoundTableViewController
            vc.navigationItem.title = "サウンド"
            vc.sound = alarmEntity.sound
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
    
    @IBAction func saveButtonPush(sender: UIBarButtonItem) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let selectedTime = dateFormatter.stringFromDate(datePicker.date)
        
        if self.from == "add" {
            self.delegate?.saveNewAlarm(selectedTime,label:self.alarmEntity.label,repeat:self.alarmEntity.repeat,sound:self.alarmEntity.sound,snooze:self.alarmEntity.snooze)
        } else {
            self.delegate?.saveEditAlarm(selectedTime, label:self.alarmEntity.label, repeat:self.alarmEntity.repeat, sound:self.alarmEntity.sound, snooze:self.alarmEntity.snooze, enabled:self.alarmEntity.enabled, indexPath:self.editIndexPath)
        }
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func onClickSnoozeSwicth(sender: UISwitch) {
        if sender.on {
            self.alarmEntity.snooze = true
        } else {
            self.alarmEntity.snooze = false
        }
    }
    
    func changeRepeat(repeat:String) {
        self.alarmEntity.repeat = repeat
        self.repeatLabel.text = tableClass.repeatStatus(self.alarmEntity.repeat)
    }
    
    func changeSound(sound:String) {
        self.alarmEntity.sound = sound
        self.sound.text = tableClass.soundName(self.alarmEntity.sound)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
