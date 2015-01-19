//
//  EditViewController.swift
//  PandaNotif
//
//  Created by 坂口真一 on 2015/01/17.
//  Copyright (c) 2015年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

protocol EditViewControllerDelegate : class{
    func editDidSaved(alarmTime:String,label:String,repeat:String,sound:String,snooze:Bool,indexPath:Int)
    func editDidDeleted(indexPath:Int)
}

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RepeatViewControllerDelegate, LabelViewControllerDelegate, SoundViewControllerDelegate {
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var editTable: UITableView!
    weak var delegate: EditViewControllerDelegate? = nil
    let texts = ["Repeat", "Label", "Sound", "Snooze"]
    var alarmTime = String()
    var repeat = String()
    var label = String()
    var snooze = Bool()
    var sound = String()
    var editIndexPath = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editTable.dataSource = self
        self.editTable.delegate = self
        self.editTable.registerClass(UITableViewCell.self, forCellReuseIdentifier:"data")
        self.editTable.backgroundColor = UIColor.clearColor()
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        let currentDate = calendar.dateBySettingHour(stringForHour(alarmTime), minute:stringForMinute(alarmTime), second: 0, ofDate: NSDate(), options: nil)!
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
            let flg:Bool = snooze
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
            var repeatStatuses = [String]()
            for i in repeat{
                repeatStatuses.append(String(i))
            }

            if repeatStatuses == ["1","1","1","1","1","1","1"]{
                cell.detailTextLabel?.text = "毎日"
            }else if repeatStatuses == ["1","0","0","0","0","0","1"]{
                cell.detailTextLabel?.text = "週末"
            }else if repeatStatuses == ["0","1","1","1","1","1","0"]{
                cell.detailTextLabel?.text = "平日"
            }else if repeatStatuses == ["0","0","0","0","0","0","0"]{
                cell.detailTextLabel?.text = "しない"
            }else{
                var weekDay = ""
                if repeatStatuses[1] == "1"{
                    weekDay += "月 "
                }
                if repeatStatuses[2] == "1"{
                    weekDay += "火 "
                }
                if repeatStatuses[3] == "1"{
                    weekDay += "水 "
                }
                if repeatStatuses[4] == "1"{
                    weekDay += "木 "
                }
                if repeatStatuses[5] == "1"{
                    weekDay += "金 "
                }
                if repeatStatuses[6] == "1"{
                    weekDay += "土 "
                }
                if repeatStatuses[0] == "1"{
                    weekDay += "日"
                }
                cell.detailTextLabel?.text = weekDay
            }
        }else if indexPath.row == 1{
            cell.detailTextLabel?.text = label
        }else if indexPath.row == 2{
            let flg:Bool = sound == UILocalNotificationDefaultSoundName
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
            snooze = true
        } else {
            snooze = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        if (segue.identifier == "toRepeatViewController"){
            let vc = segue.destinationViewController as RepeatViewController
            vc.repeat = repeat
            vc.delegate = self
        }else if (segue.identifier == "toLabelViewController"){
            let vc = segue.destinationViewController as LabelViewController
            vc.label = label
            vc.delegate = self
        }else if (segue.identifier == "toSoundViewController"){
            let vc = segue.destinationViewController as SoundViewController
            vc.sound = sound
            vc.delegate = self
        }
    }
    
    @IBAction func saveButton(sender: UIButton) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let selectedTime = dateFormatter.stringFromDate(datePicker.date)
        self.delegate?.editDidSaved(selectedTime,label:self.label,repeat:self.repeat,sound:self.sound,snooze:self.snooze,indexPath:self.editIndexPath)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func deleteButton(sender: UIButton) {
        self.delegate?.editDidDeleted(editIndexPath)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backFromRepeatView(segue:UIStoryboardSegue){
        self.editTable.reloadData()
    }
    
    @IBAction func backFromLabelView(segue:UIStoryboardSegue){
        self.editTable.reloadData()
    }
    
    @IBAction func backFromSoundView(segue:UIStoryboardSegue){
        self.editTable.reloadData()
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
