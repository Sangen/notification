//
//  ViewController.swift
//  test2
//
//  Created by 坂口真一 on 2014/12/01.
//  Copyright (c) 2014年 坂口真一. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddViewControllerDelegate, EditViewControllerDelegate {
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var alarmTableView: UITableView!
    @IBOutlet weak var minuteTableView: UITableView!
    let texts = ["3 min", "5 min", "10 min", "15 min", "30 min", "60 min"]
    var alarmTimes = [String]()
    var labels = [String]()
    var repeats = [String]()
    var sounds = [String]()
    var snoozes = [Bool]()
    var enabled = [Bool]()
    var editIndexPath = Int()
    let PNDUserDafault = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enterBackground:", name:"applicationDidEnterBackground", object: nil)
        NSLog("viewDidLoad")
        self.minuteTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"data")
        self.minuteTableView.delegate = self
        self.minuteTableView.dataSource = self
        self.minuteTableView.backgroundColor = UIColor.clearColor()
        
        self.alarmTableView.delegate = self
        self.alarmTableView.dataSource = self
        self.alarmTableView.backgroundColor = UIColor.clearColor()
        
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        self.alarmTableView.registerNib(nib, forCellReuseIdentifier:"cell")
        
        let flg:Bool = self.PNDUserDafault.objectForKey("alarmTimes") != nil
        if flg {
            NSLog("UserDefaults exist value")
            self.alarmTimes = self.PNDUserDafault.objectForKey("alarmTimes") as [String]
            self.labels = self.PNDUserDafault.objectForKey("labels") as [String]
            self.repeats = self.PNDUserDafault.objectForKey("repeats") as [String]
            self.sounds = self.PNDUserDafault.objectForKey("sounds") as [String]
            self.snoozes = self.PNDUserDafault.objectForKey("snoozes") as [Bool]
            self.enabled = self.PNDUserDafault.objectForKey("enabled") as [Bool]
        }else{
            NSLog("UserDefaults not exist value")
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 80
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let flg:Bool = tableView.tag == 0
        if flg {
            return self.texts.count
        }else{
            return self.alarmTimes.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let flg:Bool = tableView.tag == 0
        if flg {
            var cell = tableView.dequeueReusableCellWithIdentifier("data") as UITableViewCell
            cell.textLabel?.text = self.texts[indexPath.row]
            cell.textLabel?.font = UIFont.systemFontOfSize(25.0)
            return cell
        }else{
            var customCell = tableView.dequeueReusableCellWithIdentifier("cell") as CustomCell
            //customCell.delegate = self
            let flg:Bool = self.enabled[indexPath.row] == true
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
            
            let flg2:Bool = self.repeats[indexPath.row] != "0000000"
            if flg2 {
                customCell.repeatLabel.alpha = 1.0
            }else{
                customCell.repeatLabel.alpha = 0
            }
            
            let flg3:Bool = self.snoozes[indexPath.row] == true
            if flg3 {
                customCell.snoozeLabel.alpha = 1.0
            }else{
                customCell.snoozeLabel.alpha = 0
            }
            customCell.timeLabel?.text = self.alarmTimes[indexPath.row]
            customCell.timeLabel?.font = UIFont.systemFontOfSize(40.0)
            customCell.descriptionLabel?.text = self.labels[indexPath.row]
            customCell.enabledSwitch.addTarget(self, action: "onClickEnabledSwicth:", forControlEvents: .ValueChanged)

            return customCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!){
        let flg:Bool = tableView.tag == 0
        if flg {
            self.minuteTableView.deselectRowAtIndexPath(indexPath, animated: true)
            switch self.texts[indexPath.row]{
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
            self.alarmTableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.editIndexPath = indexPath.row
            performSegueWithIdentifier("toEditViewController",sender: nil)
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let flg:Bool = tableView.tag == 1
        if flg {
            let delete = UITableViewRowAction(style: .Default,
                title: "delete"){(action, indexPath) in
                    self.alarmTimes.removeAtIndex(indexPath.row)
                    self.labels.removeAtIndex(indexPath.row)
                    self.repeats.removeAtIndex(indexPath.row)
                    self.sounds.removeAtIndex(indexPath.row)
                    self.snoozes.removeAtIndex(indexPath.row)
                    self.enabled.removeAtIndex(indexPath.row)
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
        if segue.identifier == "toEditViewController" {
            let editVC = segue.destinationViewController as EditViewController
            editVC.alarmTime = self.alarmTimes[editIndexPath]
            editVC.label = self.labels[editIndexPath]
            editVC.repeat = self.repeats[editIndexPath]
            editVC.snooze = self.snoozes[editIndexPath]
            editVC.sound = self.sounds[editIndexPath]
            editVC.editIndexPath = self.editIndexPath
            editVC.delegate = self
        }else if segue.identifier == "toAddViewController" {
            let addVC = segue.destinationViewController as AddViewController
            addVC.repeat = "0000000"
            addVC.label = "アラーム"
            addVC.snooze = true
            addVC.sound = UILocalNotificationDefaultSoundName
            addVC.delegate = self
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
        
        let flg:Bool = self.enabled[row!] == true
        if flg {
            self.enabled[row!] = false
        }else{
            self.enabled[row!] = true
        }
        
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

        self.alarmTimes.append(dateFormatter.stringFromDate(alarmTime))
        self.labels.append("アラーム")
        self.repeats.append("0000000")
        self.snoozes.append(true)
        self.enabled.append(true)
        self.sounds.append(UILocalNotificationDefaultSoundName)
        
        self.alarmTableView.reloadData()
    }

    @IBAction func backFromAddView(segue:UIStoryboardSegue){
        NSLog("backFromAddView")
    }
    
    @IBAction func backFromEditView(segue:UIStoryboardSegue){
        NSLog("backFromEditView")
    }

    @IBAction func addButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier("toAddViewController",sender: nil)
    }
    
    func addDidSaved(alarmTime:String,label:String,repeat:String,sound:String,snooze:Bool){
        NSLog("addDidSaved fire")
        self.alarmTimes.append(alarmTime)
        self.labels.append(label)
        self.repeats.append(repeat)
        self.sounds.append(sound)
        self.snoozes.append(snooze)
        self.enabled.append(true)
        self.alarmTableView.reloadData()
    }
    
    func editDidSaved(alarmTime:String,label:String,repeat:String,sound:String,snooze:Bool,indexPath:Int){
        NSLog("editDidSaved fire")
        NSLog("editalarmTimes : %@", alarmTime)
        self.alarmTimes[indexPath] = alarmTime
        self.labels[indexPath] = label
        self.repeats[indexPath] = repeat
        self.sounds[indexPath] = sound
        self.snoozes[indexPath] = snooze
        self.alarmTableView.reloadData()
    }
    
    func editDidDeleted(indexPath:Int){
        NSLog("editDidDeleted fire")
        self.alarmTimes.removeAtIndex(indexPath)
        self.labels.removeAtIndex(indexPath)
        self.repeats.removeAtIndex(indexPath)
        self.sounds.removeAtIndex(indexPath)
        self.snoozes.removeAtIndex(indexPath)
        self.enabled.removeAtIndex(indexPath)
        self.alarmTableView.reloadData()
    }
    
    func enterBackground(notification: NSNotification){
        NSLog("applicationDidEnterBackground")
        self.PNDUserDafault.setObject(alarmTimes, forKey: "alarmTimes")
        self.PNDUserDafault.setObject(labels, forKey: "labels")
        self.PNDUserDafault.setObject(repeats, forKey: "repeats")
        self.PNDUserDafault.setObject(snoozes, forKey: "snoozes")
        self.PNDUserDafault.setObject(sounds, forKey: "sounds")
        self.PNDUserDafault.setObject(enabled, forKey: "enabled")
        self.PNDUserDafault.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
