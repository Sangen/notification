//
//  EditViewController.swift
//  PandaNotif
//
//  Created by 坂口真一 on 2015/01/17.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var editTable: UITableView!
    
    let texts = ["Repeat", "Label", "Sound", "Snooze"]
    let myUserDafault = NSUserDefaults()
    var editIndexPath = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editTable.dataSource = self
        self.editTable.delegate = self
        self.editTable.registerClass(UITableViewCell.self, forCellReuseIdentifier:"data")
        self.editTable.backgroundColor = UIColor.clearColor()
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        let currentDate = calendar.dateBySettingHour(stringForHour(myUserDafault.stringForKey("editTime")!), minute:         stringForMinute(myUserDafault.stringForKey("editTime")!), second: 0, ofDate: NSDate(), options: nil)!
        datePicker.setDate(currentDate, animated: false)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("data") as UITableViewCell
        if indexPath.row == 3 {
            let mySwicth = UISwitch()
            let flg:Bool = myUserDafault.boolForKey("editSnooze")
            if flg {
                mySwicth.on = true
            }else{
                mySwicth.on = false
            }
            cell.accessoryView = mySwicth
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            mySwicth.addTarget(self, action: "onClickMySwicth:", forControlEvents: UIControlEvents.ValueChanged)
        }else{
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "data")
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        if indexPath.row == 0{
            var editRepeat = myUserDafault.stringForKey("editRepeat")!
            var repeats = [String]()
            
            for i in editRepeat{
                repeats.append(String(i))
            }

            if repeats == ["1","1","1","1","1","1","1"]{
                cell.detailTextLabel?.text = "毎日"
            }else if repeats == ["1","0","0","0","0","0","1"]{
                cell.detailTextLabel?.text = "週末"
            }else if repeats == ["0","1","1","1","1","1","0"]{
                cell.detailTextLabel?.text = "平日"
            }else if repeats == ["0","0","0","0","0","0","0"]{
                cell.detailTextLabel?.text = "しない"
            }else{
                var weekDay = ""
                if repeats[1] == "1"{
                    weekDay += "月 "
                }
                if repeats[2] == "1"{
                    weekDay += "火 "
                }
                if repeats[3] == "1"{
                    weekDay += "水 "
                }
                if repeats[4] == "1"{
                    weekDay += "木 "
                }
                if repeats[5] == "1"{
                    weekDay += "金 "
                }
                if repeats[6] == "1"{
                    weekDay += "土 "
                }
                if repeats[0] == "1"{
                    weekDay += "日"
                }
                cell.detailTextLabel?.text = weekDay
            }
        }else if indexPath.row == 1{
            cell.detailTextLabel?.text = myUserDafault.stringForKey("editLabel")
        }else if indexPath.row == 2{
            let flg:Bool = myUserDafault.stringForKey("editSound") == UILocalNotificationDefaultSoundName
            if flg {
                cell.detailTextLabel?.text = "レーザー"
            }else{
                cell.detailTextLabel?.text = "なし"
            }
        }
        cell.textLabel?.text = texts[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!){
        switch texts[indexPath.row]{
        case "Repeat":
            performSegueWithIdentifier("toRepeatViewController",sender: nil)
        case "Label":
            performSegueWithIdentifier("toLabelViewController",sender: nil)
        case "Sound":
            performSegueWithIdentifier("toSoundViewController",sender: nil)
        default:
            break
        }
    }
    
    func onClickMySwicth(sender: UISwitch){
        let flg:Bool = sender.on == true
        if flg {
            myUserDafault.setObject(true, forKey: "editSnooze")
        } else {
            myUserDafault.setObject(false, forKey: "editSnooze")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        if (segue.identifier == "toRepeatViewController"){
            let vc = segue.destinationViewController as RepeatViewController
            vc.getRepeats = myUserDafault.stringForKey("editRepeat")!
            vc.from = 1
        }else if (segue.identifier == "toViewController"){
            myUserDafault.setObject("", forKey:"editTime")
            myUserDafault.setObject("", forKey:"editRepeat")
            myUserDafault.setObject("", forKey:"editLabel")
            myUserDafault.setObject("", forKey: "editSound")
            myUserDafault.setObject(true, forKey: "editSnooze")
        }else if (segue.identifier == "toLabelViewController"){
            let vc = segue.destinationViewController as LabelViewController
            var editLabel = myUserDafault.stringForKey("editLabel")!
            vc.getLabel = editLabel
            vc.from = 1
        }else if (segue.identifier == "toSoundViewController"){
            let vc = segue.destinationViewController as SoundViewController
            var editSound = myUserDafault.stringForKey("editSound")!
            vc.getSound = editSound
            vc.from = 1
        }
    }
    
    @IBAction func saveButton(sender: UIButton) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let selectedTime = dateFormatter.stringFromDate(datePicker.date)
        
        var alarmTimes = myUserDafault.objectForKey("alarmTimes") as [String]
        var descriptions = myUserDafault.objectForKey("descriptions") as [String]
        var repeats = myUserDafault.objectForKey("repeats") as [String]
        var sounds = myUserDafault.objectForKey("sounds") as [String]
        var snoozes = myUserDafault.objectForKey("snoozes") as [Bool]
        var enabled = myUserDafault.objectForKey("enabled") as [Bool]
        
        let indexPath = editIndexPath.toInt()!
        alarmTimes[indexPath] = selectedTime
        descriptions[indexPath] = myUserDafault.stringForKey("editLabel")!
        repeats[indexPath] = myUserDafault.stringForKey("editRepeat")!
        sounds[indexPath] = myUserDafault.stringForKey("editSound")!
        snoozes[indexPath] = myUserDafault.boolForKey("editSnooze")
        
        myUserDafault.setObject(alarmTimes, forKey: "alarmTimes")
        myUserDafault.setObject(descriptions, forKey: "descriptions")
        myUserDafault.setObject(repeats, forKey: "repeats")
        myUserDafault.setObject(sounds, forKey: "sounds")
        myUserDafault.setObject(snoozes, forKey: "snoozes")
        myUserDafault.setObject("", forKey:"editTime")
        myUserDafault.setObject("", forKey:"editLabel")
        myUserDafault.setObject("", forKey:"editRepeat")
        myUserDafault.setObject("", forKey:"editSound")
        myUserDafault.setObject(true, forKey:"editSnooze")
        myUserDafault.setObject("", forKey: "editIndexPath")
        myUserDafault.synchronize()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func deleteButton(sender: UIButton) {
        var alarmTimes = myUserDafault.objectForKey("alarmTimes") as [String]
        var descriptions = myUserDafault.objectForKey("descriptions") as [String]
        var repeats = myUserDafault.objectForKey("repeats") as [String]
        var sounds = myUserDafault.objectForKey("sounds") as [String]
        var snoozes = myUserDafault.objectForKey("snoozes") as [Bool]
        var enabled = myUserDafault.objectForKey("enabled") as [Bool]
        let indexPath = editIndexPath.toInt()!
        alarmTimes.removeAtIndex(indexPath)
        descriptions.removeAtIndex(indexPath)
        repeats.removeAtIndex(indexPath)
        sounds.removeAtIndex(indexPath)
        snoozes.removeAtIndex(indexPath)
        enabled.removeAtIndex(indexPath)
        myUserDafault.setObject(alarmTimes, forKey: "alarmTimes")
        myUserDafault.setObject(descriptions, forKey: "descriptions")
        myUserDafault.setObject(repeats, forKey: "repeats")
        myUserDafault.setObject(sounds, forKey: "sounds")
        myUserDafault.setObject(snoozes, forKey: "snoozes")
        myUserDafault.setObject(enabled, forKey: "enabled")
        myUserDafault.synchronize()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backFromRepeatView(segue:UIStoryboardSegue){
        editTable.reloadData()
    }
    
    @IBAction func backFromLabelView(segue:UIStoryboardSegue){
        editTable.reloadData()
    }
    
    @IBAction func backFromSoundView(segue:UIStoryboardSegue){
        editTable.reloadData()
    }
    
    private func stringForHour(hour: String) -> Int{
        let startIndex = advance(hour.startIndex, 0)
        let endIndex = advance(hour.startIndex, 2)
        
        return hour.substringFromIndex(startIndex).substringToIndex(endIndex).toInt()!
    }
    
    private func stringForMinute(minute: String) -> Int{
        let startIndex = advance(minute.startIndex, 3)
        let endIndex = advance(minute.startIndex, 2)
        
        return minute.substringFromIndex(startIndex).substringToIndex(endIndex).toInt()!
    }
}
