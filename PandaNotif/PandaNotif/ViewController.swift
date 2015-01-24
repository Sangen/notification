//
//  ViewController.swift
//  test2
//
//  Created by 坂口真一 on 2014/12/01.
//  Copyright (c) 2014年 坂口真一. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, PNDTableViewDataSourceDelegate, EditTableViewControllerDelegate {
    @IBOutlet weak var alarmTableView: UITableView!
    @IBOutlet weak var minuteTableView: UITableView!
    let dataSource = PNDTableViewDataSource()
    let minutesDataSource = PNDMinutesTableViewDataSource()
    let calculate = PNDAlarmCalculateClass()
    var editIndexPath = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enterBackground:", name:"applicationDidEnterBackground", object: nil)
        NSLog("viewDidLoad")
        self.navigationItem.title = "アラーム"
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        self.alarmTableView.registerNib(nib, forCellReuseIdentifier:"cell")
        
        self.dataSource.delegate = self
        self.dataSource.alarmEntities = PNDUserDefaults.alarmEntities()
        
        self.minuteTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"data")
        self.minuteTableView.delegate = self
        self.minuteTableView.dataSource = self.minutesDataSource
        self.minuteTableView.backgroundColor = UIColor.clearColor()
        self.minuteTableView.estimatedRowHeight = 80.0
        self.alarmTableView.delegate = self
        self.alarmTableView.dataSource = self.dataSource
        self.alarmTableView.backgroundColor = UIColor.clearColor()
        self.alarmTableView.estimatedRowHeight = 80.0
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!) {
        if tableView.tag == 0 {
            self.minuteTableView.deselectRowAtIndexPath(indexPath, animated: true)
            switch self.minutesDataSource.texts[indexPath.row] {
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
            if indexPath.row == 0 {
                self.editIndexPath = Int(0)
                NSLog("indexPath.row = 0")
            }else{
                self.editIndexPath = indexPath.row
            }
            NSLog("editIndexPath : %d", editIndexPath)
            performSegueWithIdentifier("toEditTableViewController",sender: nil)
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        if tableView.tag == 1 {
            let delete = UITableViewRowAction(style: .Default, title: "delete"){ action, indexPath in
                self.dataSource.alarmEntities.removeAtIndex(indexPath.row)
                self.alarmTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                println("\(indexPath) deleted")
            }
            delete.backgroundColor = UIColor.redColor()
            return [delete]
        }else{
            return nil
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "toEditTableViewController" {
            let vc = segue.destinationViewController as EditTableViewController
            vc.navigationItem.title = "アラームの編集"
            vc.alarmEntity = self.dataSource.alarmEntities[editIndexPath]
            vc.editIndexPath = self.editIndexPath
            vc.delegate = self
            vc.from = "edit"
        }else if segue.identifier == "toEditTableViewControllerAdd" {
            let vc = segue.destinationViewController as EditTableViewController
            vc.navigationItem.title = "アラームの追加"
            var alarmEntity = PNDAlarmEntity()
            alarmEntity.alarmTime = calculate.currentTime()
            alarmEntity.label = "アラーム"
            alarmEntity.repeat = "0000000"
            alarmEntity.snooze = true
            alarmEntity.enabled = true
            alarmEntity.sound = UILocalNotificationDefaultSoundName
            vc.alarmEntity = alarmEntity
            vc.delegate = self
            vc.from = "add"
        }
    }
    
    func pndDataSource(sender: PNDTableViewDataSource, didChangeSwitchOnCell switchOnCell: UISwitch) {
        let pointInTable: CGPoint = switchOnCell.convertPoint(switchOnCell.bounds.origin, toView: self.alarmTableView)
        let cellIndexPath = self.alarmTableView.indexPathForRowAtPoint(pointInTable)
        if let row = cellIndexPath?.row {
            self.dataSource.alarmEntities[row].enabled = switchOnCell.on
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

        var alarmEntity = PNDAlarmEntity()
        alarmEntity.alarmTime = dateFormatter.stringFromDate(alarmTime)
        alarmEntity.label = "アラーム"
        alarmEntity.repeat = "0000000"
        alarmEntity.snooze = true
        alarmEntity.enabled = true
        alarmEntity.sound = UILocalNotificationDefaultSoundName
        
        self.dataSource.alarmEntities += [alarmEntity]
        
        self.alarmTableView.reloadData()
    }

    @IBAction private func backFromEditView(segue:UIStoryboardSegue) {
        NSLog("backFromEditView")
    }

    @IBAction private func addButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier("toEditTableViewControllerAdd",sender: nil)
    }
    
    func savedNewAlarm(alarmTime:String,label:String,repeat:String,sound:String,snooze:Bool) {
        NSLog("saved New Alarm fire")
        var alarmEntity = PNDAlarmEntity()
        alarmEntity.alarmTime = alarmTime
        alarmEntity.label = label
        alarmEntity.repeat = repeat
        alarmEntity.snooze = snooze
        alarmEntity.enabled = true
        alarmEntity.sound = sound
        
        self.dataSource.alarmEntities += [alarmEntity]

        self.alarmTableView.reloadData()
    }
    
    func savedEditAlarm(alarmTime:String,label:String,repeat:String,sound:String,snooze:Bool,enabled:Bool,indexPath:Int) {
        NSLog("saved Edit Alarm fire")

        var alarmEntity = PNDAlarmEntity()
        alarmEntity.alarmTime = alarmTime
        alarmEntity.label = label
        alarmEntity.repeat = repeat
        alarmEntity.snooze = snooze
        alarmEntity.sound = sound
        alarmEntity.enabled = enabled
        
        self.dataSource.alarmEntities[indexPath] = alarmEntity
        
        self.alarmTableView.reloadData()
    }
    
    func deletedAlarm(indexPath:Int) {
        NSLog("Deleted fire")

        self.dataSource.alarmEntities.removeAtIndex(indexPath)

        self.alarmTableView.reloadData()
    }
    
    func enterBackground(notification: NSNotification) {
        NSLog("applicationDidEnterBackground")
        PNDUserDefaults.setAlarmEntities(self.dataSource.alarmEntities)
        NSLog("alarmEntities : %@",PNDUserDefaults.alarmEntities())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
