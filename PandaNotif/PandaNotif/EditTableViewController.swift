//
//  EditTableViewController.swift
//  PandaNotif
//
//  Created by ShinichiSakaguchi on 2015/01/20.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

protocol EditTableViewControllerDelegate : class {
    func savedNewAlarm(alarmTime:String,label:String,repeat:String,sound:String,snooze:Bool)
    func savedEditAlarm(alarmTime:String,label:String,repeat:String,sound:String,snooze:Bool,enabled:Bool,indexPath:Int)
    func deletedAlarm(indexPath:Int)
}

class EditTableViewController: UITableViewController, RepeatTableViewControllerDelegate, SoundTableViewControllerDelegate {
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
    var defaultSnooze = Bool()
    var defaultSound = String()
    var defaultEnabled = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let v = UIView(frame: CGRectZero)
        v.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = v
        self.tableView.tableHeaderView = v
        
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        let currentDate = calendar.dateBySettingHour(calculate.stringForHour(self.alarmEntity.alarmTime), minute:calculate.stringForMinute(self.alarmEntity.alarmTime), second: 0, ofDate: NSDate(), options: nil)!
        datePicker.setDate(currentDate, animated: false)
        
        self.label.addTarget(self, action:"editingChangedLabel:",forControlEvents: UIControlEvents.EditingChanged)
        self.snoozeSwitch.addTarget(self, action: "onClickSnoozeSwicth:", forControlEvents: UIControlEvents.ValueChanged)
        
        if self.alarmEntity.snooze {
            self.snoozeSwitch.on = true
        }else{
            self.snoozeSwitch.on = false
        }
        
        self.defaultRepeat = alarmEntity.repeat
        self.defaultLabel = alarmEntity.label
        self.defaultAlarmTime = alarmEntity.alarmTime
        self.defaultSnooze = alarmEntity.snooze
        self.defaultSound = alarmEntity.sound
        self.defaultEnabled = alarmEntity.enabled
        
        self.repeatLabel.text = tableClass.repeatStatus(self.alarmEntity.repeat)
        self.label.text = self.alarmEntity.label
        self.sound.text = tableClass.soundName(alarmEntity.sound)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
/*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 5
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath){
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
            switch indexPath.row {
            case 1:
                performSegueWithIdentifier("toRepeatTableViewController",sender: nil)
            case 2:
                performSegueWithIdentifier("toLabelTableViewController",sender: nil)
            case 3:
                performSegueWithIdentifier("toSoundTableViewController",sender: nil)
            default:
                break
        }
    }
*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "toRepeatTableViewController" {
            let vc = segue.destinationViewController as RepeatTableViewController
            vc.navigationItem.title = "繰り返し"
            vc.repeat = alarmEntity.repeat
            vc.delegate = self
        }else if segue.identifier == "toSoundTableViewController" {
            let vc = segue.destinationViewController as SoundTableViewController
            vc.navigationItem.title = "サウンド"
            vc.sound = alarmEntity.sound
            vc.delegate = self
        }
    }

    func editingChangedLabel(sender: UITextField) {
        self.alarmEntity.label = self.label.text
    }
    
    @IBAction func saveButtonPush(sender: UIBarButtonItem) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let selectedTime = dateFormatter.stringFromDate(datePicker.date)
        NSLog("saveButtonPush fire")
        NSLog("selectedTime : %@", selectedTime)
        NSLog("Label : %@", self.alarmEntity.label)
        NSLog("repeat : %@", self.alarmEntity.repeat)
        NSLog("sound : %@", self.alarmEntity.sound)
        NSLog("snooze : %@", self.alarmEntity.snooze)
        NSLog("enabled : %@", self.alarmEntity.enabled)
        NSLog("editIndexPath : %d", editIndexPath)
        
        if self.from == "add" {
            self.delegate?.savedNewAlarm(selectedTime,label:self.alarmEntity.label,repeat:self.alarmEntity.repeat,sound:self.alarmEntity.sound,snooze:self.alarmEntity.snooze)
        }else{
            self.delegate?.savedEditAlarm(selectedTime, label:self.alarmEntity.label, repeat:self.alarmEntity.repeat, sound:self.alarmEntity.sound, snooze:self.alarmEntity.snooze, enabled:self.alarmEntity.enabled, indexPath:self.editIndexPath)
        }
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func onClickSnoozeSwicth(sender: UISwitch) {
        if sender.on {
            self.alarmEntity.snooze = true
        }else{
            self.alarmEntity.snooze = false
        }
    }
    
    func changeRepeat(repeat:String) {
        NSLog("change repeat fire")
        self.alarmEntity.repeat = repeat
        self.repeatLabel.text = tableClass.repeatStatus(self.alarmEntity.repeat)
    }
    
    func changeSound(sound:String) {
        NSLog("change sound fire")
        self.alarmEntity.sound = sound
        self.sound.text = tableClass.soundName(self.alarmEntity.sound)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
