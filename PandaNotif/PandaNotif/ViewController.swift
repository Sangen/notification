//
//  ViewController.swift
//  test2
//
//  Created by 坂口真一 on 2014/12/01.
//  Copyright (c) 2014年 坂口真一. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var alarmTableView: UITableView!
    @IBOutlet weak var minuteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().registerUserNotificationSettings(
            UIUserNotificationSettings(
                forTypes:UIUserNotificationType.Sound | UIUserNotificationType.Alert,
                categories: nil)
        )

        minuteTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"data")
        minuteTableView.delegate = self
        minuteTableView.dataSource = self
        minuteTableView.backgroundColor = UIColor.clearColor()
        
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        alarmTableView.backgroundColor = UIColor.clearColor()
        
        var nib = UINib(nibName: "CustomCell", bundle: nil)
        alarmTableView.registerNib(nib, forCellReuseIdentifier:"cell")
    }
    
    var texts = ["3 min", "5 min", "10 min", "15 min", "30 min", "60 min"]
    var alarmTimes : [ String ] = [ ]
    var descriptions : [ String ] = [ ]
    var repeats : [ String ] = [ ]
    var sounds : [ String? ] = [ ]
    var snoozes : [ Bool ] = [ ]
    var enabled : [ Bool ] = [ ]

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
            
            customCell.timeLabel?.text = right(alarmTimes[indexPath.row],length: 5)
            customCell.timeLabel?.font = UIFont.systemFontOfSize(40.0)
            customCell.descriptionLabel?.text = descriptions[indexPath.row]
            return customCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!)
    {
        if tableView.tag == 0 {
            switch texts[indexPath.row]{
                case "3 min":
                    dateAdd(.Minute,number:3,date: NSDate())
                    stringForDate(  alarmTimes[indexPath.row],
                                    repeat: repeats[indexPath.row],
                                    snooze:snoozes[indexPath.row],
                                    label:descriptions[indexPath.row],
                                    sound: sounds[indexPath.row]!)
                case "5 min":
                    dateAdd(.Minute,number:5,date: NSDate())
                case "10 min":
                    dateAdd(.Minute,number:10,date: NSDate())
                case "15 min":
                    dateAdd(.Minute,number:15,date: NSDate())
                case "30 min":
                    dateAdd(.Minute,number:30,date: NSDate())
                case "60 min":
                    dateAdd(.Minute,number:60,date: NSDate())
                default:
                    break
            }
        }
    }

    //notification 全部発火？
    private func showNotificationFire(time:NSDate, repeat:String, snooze:Bool, label:String, sound:String){
        // Notificationの生成
        let myNotification: UILocalNotification = UILocalNotification()
        myNotification.alertBody = label
        myNotification.soundName = sound
        myNotification.timeZone = NSTimeZone.defaultTimeZone()
        myNotification.fireDate = time
        UIApplication.sharedApplication().scheduleLocalNotification(myNotification)
    }
    
    private func stringForDate(time:NSString, repeat:String, snooze:Bool, label:String, sound:String) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let dateFromString = dateFormatter.dateFromString(time)
        let now = NSDate()
        
        // 現在より過去の時刻を指定した場合は通知しないß
        if dateFromString!.compare(now) == NSComparisonResult.OrderedAscending{
            return
        }
        
        showNotificationFire(dateFromString!, repeat: repeat, snooze: snooze, label: label, sound: sound)
        
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
    
    enum Interval: String {
        case Year = "yyyy"
        case Month = "MM"
        case Day = "dd"
        case Hour = "HH"
        case Minute = "mm"
        case Second = "ss"
    }
    
    // 指定した間隔を加算した日時(NSDate)を返します
    // パラメータ
    //  interval : 日時間隔の種類を Interval で指定します
    //  number : 追加する日時間隔を整数で指定します
    //           正の数を指定すれば未来の日時を取得できます
    //           負の数を指定すれば過去の日時を取得できます
    //  date : 元の日時を NSDate で指定します
    //
    
    private func dateAdd(interval: Interval, number: Int, date: NSDate)  {
        
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
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"

        alarmTimes.append(dateFormatter.stringFromDate(alarmTime))
        descriptions.append("アラーム")
        repeats.append("0")
        snoozes.append(true)
        enabled.append(true)
        alarmTableView.reloadData()
    }
    
    @IBAction func leftBarButtonItem(sender: UIBarButtonItem) {
        //編集
        println("edit push")
    }
    
    @IBAction func backFromAddView(segue:UIStoryboardSegue){
        NSLog("I'll　Be　Back")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
