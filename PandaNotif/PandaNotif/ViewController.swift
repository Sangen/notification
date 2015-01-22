//
//  ViewController.swift
//  test2
//
//  Created by 坂口真一 on 2014/12/01.
//  Copyright (c) 2014年 坂口真一. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddViewControllerDelegate, EditViewControllerDelegate {
    @IBOutlet private weak var alarmTableView: UITableView!
    @IBOutlet private weak var minuteTableView: UITableView!
    let calculate = PNDAlarmCalculateClass()
    let texts = ["3分後", "5分後", "10分後", "15分後", "30分後", "60分後"]
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
        self.navigationItem.title = "アラーム"
        self.minuteTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"data")
        self.minuteTableView.delegate = self
        self.minuteTableView.dataSource = self
        self.minuteTableView.backgroundColor = UIColor.clearColor()
        self.minuteTableView.estimatedRowHeight = 80.0
        self.alarmTableView.delegate = self
        self.alarmTableView.dataSource = self
        self.alarmTableView.backgroundColor = UIColor.clearColor()
        self.alarmTableView.estimatedRowHeight = 80.0
        
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        self.alarmTableView.registerNib(nib, forCellReuseIdentifier:"cell")
        
        if PNDUserDafault.arrayForKey("alarmEntities") != nil{
            NSLog("UserDefaults exist value")
            let alarmEntities = PNDUserDefaults.alarmEntities()
            for a in 1...alarmEntities.count{
                self.alarmTimes.append(alarmEntities[a-1].alarmTime)
                self.labels.append(alarmEntities[a-1].label)
                self.repeats.append(alarmEntities[a-1].repeat)
                self.sounds.append(alarmEntities[a-1].sound)
                self.snoozes.append(alarmEntities[a-1].snooze)
                self.enabled.append(alarmEntities[a-1].enabled)
            }
        }else{
            NSLog("UserDefaults not exist value")
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 80
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView.tag == 0{
            return self.texts.count
        }else{
            return self.alarmTimes.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if tableView.tag == 0{
            var cell = tableView.dequeueReusableCellWithIdentifier("data") as UITableViewCell
            cell.textLabel?.text = self.texts[indexPath.row]
            cell.textLabel?.font = UIFont.systemFontOfSize(25.0)
            return cell
        }else{
            let customCell = tableView.dequeueReusableCellWithIdentifier("cell") as CustomCell
            //customCell.delegate = self
            if self.enabled[indexPath.row] == true{
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
            
            if self.repeats[indexPath.row] != "0000000"{
                customCell.repeatLabel.alpha = 1.0
            }else{
                customCell.repeatLabel.alpha = 0
            }
            
            if self.snoozes[indexPath.row] == true{
                customCell.snoozeLabel.alpha = 1.0
            }else{
                customCell.snoozeLabel.alpha = 0
            }
            customCell.timeLabel?.text = self.alarmTimes[indexPath.row]
            customCell.timeLabel?.font = UIFont.systemFontOfSize(40.0)
            customCell.descriptionLabel?.text = self.labels[indexPath.row]
            customCell.enabledSwitch.addTarget(self, action: "onClickEnabledSwicth:", forControlEvents: .ValueChanged)
            customCell.setNeedsLayout()
            customCell.layoutIfNeeded()

            return customCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!){
        if tableView.tag == 0{
            self.minuteTableView.deselectRowAtIndexPath(indexPath, animated: true)
            switch self.texts[indexPath.row]{
                case "3分後":
                    minuteSet(.Minute,number:3,date: calculate.localDate())
                case "5分後":
                    minuteSet(.Minute,number:5,date: calculate.localDate())
                case "10分後":
                    minuteSet(.Minute,number:10,date: calculate.localDate())
                case "15分後":
                    minuteSet(.Minute,number:15,date: calculate.localDate())
                case "30分後":
                    minuteSet(.Minute,number:30,date: calculate.localDate())
                case "60分後":
                    minuteSet(.Minute,number:60,date: calculate.localDate())
                default:
                    break
            }
        }else{
            self.alarmTableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.editIndexPath = indexPath.row
            performSegueWithIdentifier("toEditTableViewController",sender: nil)
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        if tableView.tag == 1{
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
        if tableView.tag == 1{
            return true
        }else{
            return false
        }
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if tableView.tag == 1{
            return true
        }else{
            return false
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.tag == 1{
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
        if segue.identifier == "toEditTableViewController"{
            let VC = segue.destinationViewController as EditTableViewController
            /*editVC.alarmTime = self.alarmTimes[editIndexPath]
            VC.label = self.labels[editIndexPath]
            VC.repeat = self.repeats[editIndexPath]
            VC.snooze = self.snoozes[editIndexPath]
            VC.sound = self.sounds[editIndexPath]
            VC.editIndexPath = self.editIndexPath
            */
            VC.navigationTitle = "アラームの編集"
         // VC.delegate = self
        }else if segue.identifier == "toEditTableViewControllerAdd" {
            let VC = segue.destinationViewController as EditTableViewController
          /*  VC.repeat = "0000000"
            VC.label = "アラーム"
            VC.snooze = true
            VC.sound = UILocalNotificationDefaultSoundName
            VC.delegate = self
          */
            VC.navigationTitle = "アラームの追加"
        }
    }
   
    func onClickEnabledSwicth(sender: UISwitch){
        let pointInTable: CGPoint = sender.convertPoint(sender.bounds.origin, toView: self.alarmTableView)
        let cellIndexPath = self.alarmTableView.indexPathForRowAtPoint(pointInTable)
        let row = cellIndexPath?.row
        
        if self.enabled[row!] == true{
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
    
    func minuteSet(interval: Interval, number: Int, date: NSDate)  {
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

    @IBAction private func backFromAddView(segue:UIStoryboardSegue){
        NSLog("backFromAddView")
    }
    
    @IBAction private func backFromEditView(segue:UIStoryboardSegue){
        NSLog("backFromEditView")
    }

    @IBAction private func addButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier("toEditTableViewControllerAdd",sender: nil)
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
        var entity = PNDAlarmEntity()
        var entityArray = [PNDAlarmEntity]()
        if self.alarmTimes.isEmpty != true{
            for a in 1...alarmTimes.count{
                entity.alarmTime = self.alarmTimes[a-1]
                entity.label = self.labels[a-1]
                entity.repeat = self.repeats[a-1]
                entity.snooze = self.snoozes[a-1]
                entity.sound = self.sounds[a-1]
                entity.enabled = self.enabled[a-1]
                entityArray.append(entity)
            }
            PNDUserDefaults.setAlarmEntities(entityArray)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
