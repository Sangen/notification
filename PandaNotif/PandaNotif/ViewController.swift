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
    var descriptions = [String]() // Label
    var repeats = [String]() // repeat
    var sounds = [String]()// sound
    var snoozes = [Bool]()  // snooze
    var enabled = [Bool]() // enable
    let myUserDafault:NSUserDefaults = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        minuteTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"data")
        minuteTableView.delegate = self
        minuteTableView.dataSource = self
        minuteTableView.backgroundColor = UIColor.clearColor()
        
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        alarmTableView.backgroundColor = UIColor.clearColor()
        
        var nib = UINib(nibName: "CustomCell", bundle: nil)
        alarmTableView.registerNib(nib, forCellReuseIdentifier:"cell")
        
        let check: AnyObject? = myUserDafault.objectForKey("alarmTimes")
        if check != nil {
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
        let check: AnyObject? = myUserDafault.objectForKey("alarmTimes")
        if check != nil {
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
        if tableView.tag == 0{
            return texts.count
        }else{
            return alarmTimes.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if tableView.tag == 0{
            var cell = tableView.dequeueReusableCellWithIdentifier("data") as UITableViewCell
            cell.textLabel?.text = texts[indexPath.row]
            cell.textLabel?.font = UIFont.systemFontOfSize(25.0)
            return cell
        }else{
            var customCell = tableView.dequeueReusableCellWithIdentifier("cell") as CustomCell
            //customCell.delegate = self
            let alarm = alarmTimes[indexPath.row]
            let description = descriptions[indexPath.row]
            
            let flg:Bool = enabled[indexPath.row] == true
            if flg {
                customCell.enabledSwitch.on = true
                customCell.timeLabel?.text = right(alarm,length: 5)
                customCell.timeLabel?.font = UIFont.systemFontOfSize(40.0)
                customCell.timeLabel?.textColor = UIColor.blackColor()
                customCell.descriptionLabel?.text = description
                customCell.descriptionLabel?.textColor = UIColor.blackColor()
            }else{
                customCell.enabledSwitch.on = false
                customCell.timeLabel?.text = right(alarm,length: 5)
                customCell.timeLabel?.font = UIFont.systemFontOfSize(40.0)
                customCell.timeLabel?.textColor = UIColor.grayColor()
                customCell.descriptionLabel?.text = description
                customCell.descriptionLabel?.textColor = UIColor.grayColor()
            }
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
            //Edit code needs here
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let flg:Bool = tableView.tag == 1
        if flg {
            var deleteAlarmTimes = myUserDafault.objectForKey("alarmTimes") as [String]
            var deleteDescriptions = myUserDafault.objectForKey("descriptions") as [String]
            var deleteRepeats = myUserDafault.objectForKey("repeats") as [String]
            var deleteSounds = myUserDafault.objectForKey("sounds") as [String]
            var deleteSnoozes = myUserDafault.objectForKey("snoozes") as [Bool]
            var deleteEnabled = myUserDafault.objectForKey("enabled") as [Bool]
            
            let delete = UITableViewRowAction(style: .Default,
                title: "delete"){(action, indexPath) in
                    self.alarmTimes.removeAtIndex(indexPath.row)
                    self.descriptions.removeAtIndex(indexPath.row)
                    self.repeats.removeAtIndex(indexPath.row)
                    self.sounds.removeAtIndex(indexPath.row)
                    self.snoozes.removeAtIndex(indexPath.row)
                    self.enabled.removeAtIndex(indexPath.row)
                    deleteAlarmTimes.removeAtIndex(indexPath.row)
                    deleteDescriptions.removeAtIndex(indexPath.row)
                    deleteRepeats.removeAtIndex(indexPath.row)
                    deleteSounds.removeAtIndex(indexPath.row)
                    deleteSnoozes.removeAtIndex(indexPath.row)
                    deleteEnabled.removeAtIndex(indexPath.row)
                    self.myUserDafault.setObject(deleteAlarmTimes, forKey: "alarmTimes")
                    self.myUserDafault.setObject(deleteDescriptions, forKey: "descriptions")
                    self.myUserDafault.setObject(deleteRepeats, forKey: "repeats")
                    self.myUserDafault.setObject(deleteSounds, forKey: "sounds")
                    self.myUserDafault.setObject(deleteSnoozes, forKey: "snoozes")
                    self.myUserDafault.setObject(deleteEnabled, forKey: "enabled")
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
      /*  let tmp = [sourceIndexPath.row]
        itemArray.removeAtIndex(sourceIndexPath.row)
        itemArray.insert(tmp, atIndex: destinationIndexPath.row)
      */
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
    
    private func right(str : String, length : Int) -> String {
        var len: Int = countElements(str)
        var buf: String = ""
        var i: Int = 0
        
        if length <= 0 {
            buf = ""
        } else if length > len {
            buf = str
        } else {
            for char: Character in str {
                i++
                if len - i < length {
                    buf = buf + String(char)
                }
            }
        }
        return buf
    }
    
    // 指定した間隔を加算した日時(NSDate)を返します
    // パラメータ
    //  interval : 日時間隔の種類を Interval で指定します
    //  number : 追加する日時間隔を整数で指定します
    //           正の数を指定すれば未来の日時を取得できます
    //           負の数を指定すれば過去の日時を取得できます
    //  date : 元の日時を NSDate で指定します
    //
    
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
        NSLog("I'll　Be　Back")
        alarmTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
