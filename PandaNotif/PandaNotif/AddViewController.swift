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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.testTable.dataSource = self
        self.testTable.delegate = self
        self.testTable.registerClass(UITableViewCell.self, forCellReuseIdentifier:"data")
        self.testTable.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view.
    }
    
    let texts = ["Repeat", "Label", "Sound", "Snooze"]
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("data") as UITableViewCell
        if indexPath.row == 3 {
            let mySwicth: UISwitch = UISwitch()
            var myUserDafault:NSUserDefaults = NSUserDefaults()
            if myUserDafault.boolForKey("NewSnooze"){
                mySwicth.on = true
            }else{
                mySwicth.on = false
            }
            cell.accessoryView = mySwicth
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            // SwitchのOn/Off切り替わりの際に、呼ばれるイベントを設定する.
            mySwicth.addTarget(self, action: "onClickMySwicth:", forControlEvents: UIControlEvents.ValueChanged)
        }else{
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "data")
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        if indexPath.row == 0{
            var myUserDafault:NSUserDefaults = NSUserDefaults()
            var repeatCheck:Array = myUserDafault.arrayForKey("NewRepeat")!
            var repeats = repeatCheck as [String]
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
            var myUserDafault:NSUserDefaults = NSUserDefaults()
            cell.detailTextLabel?.text = myUserDafault.stringForKey("NewLabel")!
        }else if indexPath.row == 2{
            var myUserDafault:NSUserDefaults = NSUserDefaults()
            let soundMan = myUserDafault.stringForKey("NewSound")
            cell.detailTextLabel?.text = soundMan
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
        var myUserDafault:NSUserDefaults = NSUserDefaults()
        if sender.on == true {
            myUserDafault.setObject(true, forKey: "NewSnooze")
        } else {
            myUserDafault.setObject(false, forKey: "NewSnooze")
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
            var newRepeat = myUserDafault.arrayForKey("NewRepeat")!
            vc.getRepeats = newRepeat
        }else if (segue.identifier == "toViewController"){
            var myUserDafault:NSUserDefaults = NSUserDefaults()
            myUserDafault.setObject(["0","0","0","0","0","0","0"], forKey: "NewRepeat")
            myUserDafault.setObject("アラーム", forKey: "NewLabel")
            myUserDafault.setObject(["レーザー",UILocalNotificationDefaultSoundName], forKey: "NewSound")
            myUserDafault.setObject(true, forKey: "NewSnooze")
        }else if (segue.identifier == "toLabelViewController"){
            let vc = segue.destinationViewController as LabelViewController
            var myUserDafault:NSUserDefaults = NSUserDefaults()
            var newLabel = myUserDafault.stringForKey("NewLabel")!
            vc.getLabel = newLabel
        }else if (segue.identifier == "toSoundViewController"){
            let vc = segue.destinationViewController as SoundViewController
            var myUserDafault:NSUserDefaults = NSUserDefaults()
            var newSound = myUserDafault.stringArrayForKey("NewSound")!
            vc.getSound = newSound
        }
    }
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        //create new alarm
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