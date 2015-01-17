//
// AddViewController.swift
// PandaNotif
//
// Created by 坂口真一 on 2014/12/09.
// Copyright (c) 2014年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var testTable: UITableView!
    let texts = ["Repeat", "Label", "Sound", "Snooze"]
    let myUserDafault = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.testTable.dataSource = self
        self.testTable.delegate = self
        self.testTable.registerClass(UITableViewCell.self, forCellReuseIdentifier:"data")
        self.testTable.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("data") as UITableViewCell
        let flg:Bool = indexPath.row == 3
        if flg {
            let mySwicth = UISwitch()
            let flg:Bool = myUserDafault.boolForKey("newSnooze") == true
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
            let repeatCheck = myUserDafault.stringForKey("newRepeat")!
            var repeats = [String]()
            for i in repeatCheck{
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
            cell.detailTextLabel?.text = myUserDafault.stringForKey("newLabel")
        }else if indexPath.row == 2{
            let flg:Bool = myUserDafault.stringForKey("newSound") == UILocalNotificationDefaultSoundName
            if flg {
                cell.detailTextLabel?.text = "レーザー"
            }else{
                cell.detailTextLabel?.text = "なし"
            }
        }
        cell.textLabel?.text = texts[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!)
    {
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
            myUserDafault.setObject(true, forKey: "newSnooze")
        }else{
            myUserDafault.setObject(false, forKey: "newSnooze")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        if (segue.identifier == "toRepeatViewController"){
            let vc = segue.destinationViewController as RepeatViewController
            var myUserDafault:NSUserDefaults = NSUserDefaults()
            vc.getRepeats = myUserDafault.stringForKey("newRepeat")!
            vc.from = 0
        }else if (segue.identifier == "toViewController"){
            myUserDafault.setObject("0000000", forKey: "newRepeat")
            myUserDafault.setObject("アラーム", forKey: "newLabel")
            myUserDafault.setObject(UILocalNotificationDefaultSoundName, forKey: "newSound")
            myUserDafault.setObject(true, forKey: "newSnooze")
        }else if (segue.identifier == "toLabelViewController"){
            let vc = segue.destinationViewController as LabelViewController
            var newLabel = myUserDafault.stringForKey("newLabel")!
            vc.getLabel = newLabel
            vc.from = 0
        }else if (segue.identifier == "toSoundViewController"){
            let vc = segue.destinationViewController as SoundViewController
            var newSound = myUserDafault.stringForKey("newSound")!
            vc.getSound = newSound
            vc.from = 0
        }
    }
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let selectedTime = dateFormatter.stringFromDate(datePicker.date)
        
        let flg:Bool = myUserDafault.objectForKey("alarmTimes") != nil
        if flg {
            NSLog("Exist value")
            var alarmTimes = myUserDafault.objectForKey("alarmTimes") as [String]
            var descriptions = myUserDafault.objectForKey("descriptions") as [String]
            var repeats = myUserDafault.objectForKey("repeats") as [String]
            var sounds = myUserDafault.objectForKey("sounds") as [String]
            var snoozes = myUserDafault.objectForKey("snoozes") as [Bool]
            var enabled = myUserDafault.objectForKey("enabled") as [Bool]

            alarmTimes.append(selectedTime)
            descriptions.append(myUserDafault.stringForKey("newLabel")!)
            repeats.append(myUserDafault.stringForKey("newRepeat")!)
            sounds.append(myUserDafault.stringForKey("newSound")!)
            snoozes.append(myUserDafault.boolForKey("newSnooze"))
            enabled.append(true)
            
            myUserDafault.setObject(alarmTimes, forKey: "alarmTimes")
            myUserDafault.setObject(descriptions, forKey: "descriptions")
            myUserDafault.setObject(repeats, forKey: "repeats")
            myUserDafault.setObject(sounds, forKey: "sounds")
            myUserDafault.setObject(snoozes, forKey: "snoozes")
            myUserDafault.setObject(enabled, forKey: "enabled")
        }else{
            NSLog("There isn't value")
            var alarmTimes = [String]()
            var descriptions = [String]()
            var repeats = [String]()
            var sounds = [String]()
            var snoozes = [Bool]()
            var enabled = [Bool]()
            
            alarmTimes.append(selectedTime)
            descriptions.append(myUserDafault.stringForKey("newLabel")!)
            repeats.append(myUserDafault.stringForKey("newRepeat")!)
            sounds.append(myUserDafault.stringForKey("newSound")!)
            snoozes.append(myUserDafault.boolForKey("newSnooze"))
            enabled.append(true)
            
            myUserDafault.setObject(alarmTimes, forKey: "alarmTimes")
            myUserDafault.setObject(descriptions, forKey: "descriptions")
            myUserDafault.setObject(repeats, forKey: "repeats")
            myUserDafault.setObject(sounds, forKey: "sounds")
            myUserDafault.setObject(snoozes, forKey: "snoozes")
            myUserDafault.setObject(enabled, forKey: "enabled")
        }
        myUserDafault.setObject("0000000", forKey: "newRepeat")
        myUserDafault.setObject("アラーム", forKey: "newLabel")
        myUserDafault.setObject(UILocalNotificationDefaultSoundName, forKey: "newSound")
        myUserDafault.setObject(true, forKey: "newSnooze")
        myUserDafault.synchronize()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backFromRepeatView(segue:UIStoryboardSegue){
        testTable.reloadData()
    }
    
    @IBAction func backFromLabelView(segue:UIStoryboardSegue){
        testTable.reloadData()
    }
    
    @IBAction func backFromSoundView(segue:UIStoryboardSegue){
        testTable.reloadData()
    }
}