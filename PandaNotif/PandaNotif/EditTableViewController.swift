//
//  EditTableViewController.swift
//  PandaNotif
//
//  Created by ShinichiSakaguchi on 2015/01/20.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

protocol EditTableViewControllerDelegate : class{
    func savedNewAlarm(alarmTime:String,label:String,repeat:String,sound:String,snooze:Bool)
    func savedEditAlarm(alarmTime:String,label:String,repeat:String,sound:String,snooze:Bool,indexPath:Int)
    func deletedAlarm(indexPath:Int)
}

class EditTableViewController: UITableViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var snoozeSwitch: UISwitch!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var label: UITextField!
    @IBOutlet weak var sound: UILabel!
    weak var delegate: EditTableViewControllerDelegate? = nil
    let calculate = PNDAlarmCalculateClass()
    var from = String()
    var editIndexPath = Int()
    var alarmEntity = PNDAlarmEntity()

    override func viewDidLoad() {
        super.viewDidLoad()
        var v = UIView(frame: CGRectZero)
        v.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = v
        self.tableView.tableHeaderView = v
        
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        let currentDate = calendar.dateBySettingHour(calculate.stringForHour(self.alarmEntity.alarmTime), minute:calculate.stringForMinute(self.alarmEntity.alarmTime), second: 0, ofDate: NSDate(), options: nil)!
        datePicker.setDate(currentDate, animated: false)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        switch indexPath.row {
            case 0,4,5:
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            default:
            break
        }

        if self.alarmEntity.snooze {
            self.snoozeSwitch.on = true
        }else{
            self.snoozeSwitch.on = false
        }
        self.snoozeSwitch.addTarget(self, action: "onClickSnoozeSwicth:", forControlEvents: UIControlEvents.ValueChanged)
    
        var repeats = [String]()
        for i in alarmEntity.repeat { repeats.append(String(i)) }
    
        if repeats == ["1","1","1","1","1","1","1"] {
            self.repeatLabel.text = "毎日"
        }else if repeats == ["1","0","0","0","0","0","1"] {
            self.repeatLabel.text = "週末"
        }else if repeats == ["0","1","1","1","1","1","0"] {
            self.repeatLabel.text = "平日"
        }else if repeats == ["0","0","0","0","0","0","0"] {
            self.repeatLabel.text = "しない"
        }else{
            var weekDay = String()
            if repeats[1] == "1" {
                weekDay += "月 "
            }
            if repeats[2] == "1" {
                weekDay += "火 "
            }
            if repeats[3] == "1" {
                weekDay += "水 "
            }
            if repeats[4] == "1" {
                weekDay += "木 "
            }
            if repeats[5] == "1" {
                weekDay += "金 "
            }
            if repeats[6] == "1" {
                weekDay += "土 "
            }
            if repeats[0] == "1" {
                weekDay += "日"
            }
            self.repeatLabel.text = weekDay
        }
        self.label.text = self.alarmEntity.label

        if self.alarmEntity.sound == UILocalNotificationDefaultSoundName {
            self.sound.text = "レーダー（デフォルト）"
        }else{
            self.sound.text = "なし"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath){
     /*   let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
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
    */
    }
    
    @IBAction func saveButtonPush(sender: UIBarButtonItem) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let selectedTime = dateFormatter.stringFromDate(datePicker.date)
        if self.from == "add" {
            self.delegate?.savedNewAlarm(selectedTime,label:self.alarmEntity.label,repeat:self.alarmEntity.repeat,sound:self.alarmEntity.sound,snooze:self.alarmEntity.snooze)
        }else{
            self.delegate?.savedEditAlarm(selectedTime, label:self.alarmEntity.label, repeat:self.alarmEntity.repeat, sound:self.alarmEntity.sound, snooze:self.alarmEntity.snooze, indexPath:self.editIndexPath)
        }
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func onClickSnoozeSwicth(sender: UISwitch){
        if sender.on {
            self.alarmEntity.snooze = true
        }else{
            self.alarmEntity.snooze = false
        }
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
