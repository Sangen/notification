//
// AddViewController.swift
// PandaNotif
//
// Created by 坂口真一 on 2014/12/09.
// Copyright (c) 2014年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

protocol AddViewControllerDelegate : class{
    func addDidSaved(alarmTime:String,label:String,repeat:String,sound:String,snooze:Bool)
}

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RepeatViewControllerDelegate, LabelViewControllerDelegate, SoundViewControllerDelegate {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var testTable: UITableView!
    weak var delegate: AddViewControllerDelegate? = nil
    let repeatView = RepeatViewController()
    let labelView = LabelViewController()
    let soundView = SoundViewController()
    let texts = ["Repeat", "Label", "Sound", "Snooze"]
    let mySwicth = UISwitch()
    var repeat = String()
    var label = String()
    var snooze = Bool()
    var sound = String()
    
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
            let flg:Bool = self.snooze == true
            if flg {
                self.mySwicth.on = true
            }else{
                self.mySwicth.on = false
            }
            cell.accessoryView = self.mySwicth
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            self.mySwicth.addTarget(self, action: "onClickMySwicth:", forControlEvents: UIControlEvents.ValueChanged)
        }else{
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "data")
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        if indexPath.row == 0{
            var repeats = [String]()
            for i in repeat{
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
                var weekDay = String()
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
            cell.detailTextLabel?.text = self.label
        }else if indexPath.row == 2{
            let flg:Bool = self.sound == UILocalNotificationDefaultSoundName
            if flg {
                cell.detailTextLabel?.text = "レーザー"
            }else{
                cell.detailTextLabel?.text = "なし"
            }
        }
        cell.textLabel?.text = self.texts[indexPath.row]
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
            self.snooze = true
        }else{
            self.snooze = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        if (segue.identifier == "toRepeatViewController"){
            let vc = segue.destinationViewController as RepeatViewController
            vc.repeat = self.repeat
            vc.delegate = self
        }else if (segue.identifier == "toLabelViewController"){
            let vc = segue.destinationViewController as LabelViewController
            vc.label = self.label
            vc.delegate = self
        }else if (segue.identifier == "toSoundViewController"){
            let vc = segue.destinationViewController as SoundViewController
            vc.sound = self.sound
            vc.delegate = self
        }
    }
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let selectedTime = dateFormatter.stringFromDate(datePicker.date)
        self.delegate?.addDidSaved(selectedTime,label:self.label,repeat:self.repeat,sound:self.sound,snooze:self.snooze)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func repeatChange(repeat:String){
        NSLog("repeat changed fire")
        self.repeat = repeat
    }
    
    func labelChange(label:String){
        NSLog("label changed fire")
        self.label = label
    }
    
    func soundChange(sound:String){
        NSLog("sound changed fire")
        self.sound = sound
    }
    
    @IBAction func backFromRepeatView(segue:UIStoryboardSegue){
        self.testTable.reloadData()
    }
    
    @IBAction func backFromLabelView(segue:UIStoryboardSegue){
        self.testTable.reloadData()
    }
    
    @IBAction func backFromSoundView(segue:UIStoryboardSegue){
        self.testTable.reloadData()
    }
}