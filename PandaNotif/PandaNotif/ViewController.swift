//
//  ViewController.swift
//  test2
//
//  Created by 坂口真一 on 2014/12/01.
//  Copyright (c) 2014年 坂口真一. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var alarmTableView: UITableView!
    @IBOutlet weak var minuteTableView: UITableView!

    let texts = ["3 min", "5 min", "10 min", "15 min", "30 min", "60 min"]
    
    var alarmTimes = [String]()
    var descriptions = [String]()
    var repeats = [String]()
    var sounds = [String]()
    var snoozes = [Bool]()
    var enabled = [Bool]()
    var editIndexPath = "No edit"
    let myUserDafault = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        minuteTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"data")
        minuteTableView.delegate = self
        minuteTableView.dataSource = self
        minuteTableView.backgroundColor = UIColor.clearColor()
        
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        alarmTableView.backgroundColor = UIColor.clearColor()
        
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        alarmTableView.registerNib(nib, forCellReuseIdentifier:"cell")
        
        let flg:Bool = myUserDafault.objectForKey("alarmTimes") != nil
        if flg {
            NSLog("Exist value")
            alarmTimes = myUserDafault.objectForKey("alarmTimes") as [String]
            descriptions = myUserDafault.objectForKey("descriptions") as [String]
            repeats = myUserDafault.objectForKey("repeats") as [String]
            sounds = myUserDafault.objectForKey("sounds") as [String]
            snoozes = myUserDafault.objectForKey("snoozes") as [Bool]
            enabled = myUserDafault.objectForKey("enabled") as [Bool]
        }else{
            NSLog("There isn't value")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        let flg:Bool = myUserDafault.objectForKey("alarmTimes") != nil
        if flg {
            NSLog("Exist value")
            alarmTimes = myUserDafault.objectForKey("alarmTimes") as [String]
            descriptions = myUserDafault.objectForKey("descriptions") as [String]
            repeats = myUserDafault.objectForKey("repeats") as [String]
            sounds = myUserDafault.objectForKey("sounds") as [String]
            snoozes = myUserDafault.objectForKey("snoozes") as [Bool]
            enabled = myUserDafault.objectForKey("enabled") as [Bool]
        }else{
            NSLog("There isn't value")
        }
        alarmTableView.reloadData()
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 80
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let flg:Bool = tableView.tag == 0
        if flg {
            return texts.count
        }else{
            return alarmTimes.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let flg:Bool = tableView.tag == 0
        if flg {
            var cell = tableView.dequeueReusableCellWithIdentifier("data") as UITableViewCell
            cell.textLabel?.text = texts[indexPath.row]
            cell.textLabel?.font = UIFont.systemFontOfSize(25.0)
            return cell
        }else{
            var customCell = tableView.dequeueReusableCellWithIdentifier("cell") as CustomCell
            //customCell.delegate = self
            let description = descriptions[indexPath.row]
            
            let flg:Bool = enabled[indexPath.row] == true
            if flg {
                customCell.enabledSwitch.on = true
                customCell.repeatLabel.enabled = true
                customCell.snoozeLabel.enabled = true
                customCell.timeLabel?.textColor = UIColor.blackColor()
                customCell.descriptionLabel?.textColor = UIColor.blackColor()
            }else{
                customCell.enabledSwitch.on = false
                customCell.repeatLabel.enabled = false
                customCell.snoozeLabel.enabled = false
                customCell.timeLabel?.textColor = UIColor.grayColor()
                customCell.descriptionLabel?.textColor = UIColor.grayColor()
            }
            
            let flg2:Bool = repeats[indexPath.row] != "0000000"
            if flg2 {
                customCell.repeatLabel.alpha = 1.0
            }else{
                customCell.repeatLabel.alpha = 0
            }
            
            let flg3:Bool = snoozes[indexPath.row] == true
            if flg3 {
                customCell.snoozeLabel.alpha = 1.0
            }else{
                customCell.snoozeLabel.alpha = 0
            }
            
            customCell.timeLabel?.text = alarmTimes[indexPath.row]
            customCell.timeLabel?.font = UIFont.systemFontOfSize(40.0)
            customCell.descriptionLabel?.text = description
            customCell.enabledSwitch.addTarget(self, action: "onClickEnabledSwicth:", forControlEvents: .ValueChanged)

            return customCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!)
    {
        let flg:Bool = tableView.tag == 0
        if flg {
            minuteTableView.deselectRowAtIndexPath(indexPath, animated: true)
            switch texts[indexPath.row]{
                case "3 min":
                    minuteSet(.Minute,number:3,date: localDate())
                case "5 min":
                    minuteSet(.Minute,number:5,date: localDate())
                case "10 min":
                    minuteSet(.Minute,number:10,date: localDate())
                case "15 min":
                    minuteSet(.Minute,number:15,date: localDate())
                case "30 min":
                    minuteSet(.Minute,number:30,date: localDate())
                case "60 min":
                    minuteSet(.Minute,number:60,date: localDate())
                default:
                    break
            }
        }else{
            myUserDafault.setObject(alarmTimes[indexPath.row], forKey:"editTime")
            myUserDafault.setObject(descriptions[indexPath.row], forKey:"editLabel")
            myUserDafault.setObject(repeats[indexPath.row], forKey:"editRepeat")
            myUserDafault.setObject(sounds[indexPath.row], forKey:"editSound")
            myUserDafault.setObject(snoozes[indexPath.row], forKey:"editSnooze")
            myUserDafault.synchronize()
            editIndexPath = String(indexPath.row)
            performSegueWithIdentifier("toEditViewController",sender: nil)
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let flg:Bool = tableView.tag == 1
        if flg {
            let delete = UITableViewRowAction(style: .Default,
                title: "delete"){(action, indexPath) in
                    self.alarmTimes.removeAtIndex(indexPath.row)
                    self.descriptions.removeAtIndex(indexPath.row)
                    self.repeats.removeAtIndex(indexPath.row)
                    self.sounds.removeAtIndex(indexPath.row)
                    self.snoozes.removeAtIndex(indexPath.row)
                    self.enabled.removeAtIndex(indexPath.row)

                    self.myUserDafault.setObject(self.alarmTimes, forKey: "alarmTimes")
                    self.myUserDafault.setObject(self.descriptions, forKey: "descriptions")
                    self.myUserDafault.setObject(self.repeats, forKey: "repeats")
                    self.myUserDafault.setObject(self.sounds, forKey: "sounds")
                    self.myUserDafault.setObject(self.snoozes, forKey: "snoozes")
                    self.myUserDafault.setObject(self.enabled, forKey: "enabled")
                    self.myUserDafault.synchronize()
                    self.alarmTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    println("\(indexPath) deleted")}
            delete.backgroundColor = UIColor.redColor()
            return [delete]
        }else{
            return nil
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let flg:Bool = tableView.tag == 1
        if flg {
            return true
        }else{
            return false
        }
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let flg:Bool = tableView.tag == 1
        if flg {
            return true
        }else{
            return false
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let flg:Bool = tableView.tag == 1
        if flg {
            switch editingStyle {
            case .Delete:
                self.alarmTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            default:
                return
            }
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toEditViewController") {
            let editVC = segue.destinationViewController as EditViewController
            editVC.editIndexPath = editIndexPath
        }
    }
    
    func localDate() -> NSDate {
        let date = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let timeZone = NSTimeZone(name: NSTimeZone.systemTimeZone().name)
        dateFormatter.timeZone = timeZone
        
        let dStr = dateFormatter.stringFromDate(date)
        return dateFormatter.dateFromString(dStr)!
    }
   
    func onClickEnabledSwicth(sender: UISwitch){
        let pointInTable: CGPoint = sender.convertPoint(sender.bounds.origin, toView: self.alarmTableView)
        let cellIndexPath = self.alarmTableView.indexPathForRowAtPoint(pointInTable)
        let row = cellIndexPath?.row
        
        let flg:Bool = enabled[row!] == true
        if flg {
            enabled[row!] = false
            myUserDafault.setObject(enabled, forKey:"enabled")
        }else{
            enabled[row!] = true
            myUserDafault.setObject(enabled, forKey:"enabled")
        }
        myUserDafault.synchronize()
        
        let delay = 0.2 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.alarmTableView.reloadData()
        })
    }
    
    enum Interval: String {
        case Year = "yyyy"
        case Month = "MM"
        case Day = "dd"
        case Hour = "HH"
        case Minute = "mm"
        case Second = "ss"
    }
    
    private func minuteSet(interval: Interval, number: Int, date: NSDate)  {
        let calendar = NSCalendar.currentCalendar()
        var comp = NSDateComponents()
        
        switch interval {
            case .Year:
                comp.year = number
            case .Month:
                comp.month = number
            case .Day:
                comp.day = number
            case .Hour:
                comp.hour = number
            case .Minute:
                comp.minute = number
            case .Second:
                comp.second = number
            default:
                comp.day = 0
        }
        
        let alarmTime = calendar.dateByAddingComponents(comp, toDate: date, options: nil)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        alarmTimes.append(dateFormatter.stringFromDate(alarmTime))
        descriptions.append("アラーム")
        repeats.append("0000000")
        snoozes.append(true)
        enabled.append(true)
        sounds.append(UILocalNotificationDefaultSoundName)
        
        myUserDafault.setObject(alarmTimes, forKey: "alarmTimes")
        myUserDafault.setObject(descriptions, forKey: "descriptions")
        myUserDafault.setObject(repeats, forKey: "repeats")
        myUserDafault.setObject(snoozes, forKey: "snoozes")
        myUserDafault.setObject(sounds, forKey: "sounds")
        myUserDafault.setObject(enabled, forKey: "enabled")
        myUserDafault.synchronize()
        
        alarmTableView.reloadData()
    }
    
    @IBAction func backFromAddView(segue:UIStoryboardSegue){
        NSLog("backFromAddView")
        alarmTableView.reloadData()
    }
    
    @IBAction func backFromEditView(segue:UIStoryboardSegue){
        NSLog("backFromEditView")
        alarmTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
