//
//  ViewController.swift
//  test2
//
//  Created by 坂口真一 on 2014/12/01.
//  Copyright (c) 2014年 坂口真一. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var alarmTableView: UITableView!
    @IBOutlet weak var minuteTableView: UITableView!
  //  var custom:CustomCell!
    
 /*   required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        self.custom = CustomCell()
        self.custom.delegate = self
    }
 */
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
    var alarmTimes : [ String ] = [ "17:05", "18:15" ]
    var descriptions : [ String ] = [ "アラーム", "マル秘" ] // Label
    var repeats : [ String ] = [ "0","1","1","1","0","0","0",  "1","1","1","1","1","1","1"  ] // repeat
    var sounds : [ String? ] = [ UILocalNotificationDefaultSoundName, nil, "sample" ] // sound
    var snoozes : [ Bool ] = [ true,false ] // snooze
    var enabled : [ Bool ] = [ true,true ]

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
            
            if enabled[indexPath.row]{
                customCell.enabledSwitch.on = true
                customCell.timeLabel?.text = right(alarmTimes[indexPath.row],length: 5)
                customCell.timeLabel?.font = UIFont.systemFontOfSize(40.0)
                customCell.timeLabel?.textColor = UIColor.blackColor()
                customCell.descriptionLabel?.text = descriptions[indexPath.row]
                customCell.descriptionLabel?.textColor = UIColor.blackColor()
            }else{
                customCell.enabledSwitch.on = false
                customCell.timeLabel?.text = right(alarmTimes[indexPath.row],length: 5)
                customCell.timeLabel?.font = UIFont.systemFontOfSize(40.0)
                customCell.timeLabel?.textColor = UIColor.grayColor()
                customCell.descriptionLabel?.text = descriptions[indexPath.row]
                customCell.descriptionLabel?.textColor = UIColor.grayColor()
            }
            customCell.enabledSwitch.addTarget(self, action: "onClickEnabledSwicth:", forControlEvents: .ValueChanged)

            return customCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!)
    {
        if tableView.tag == 0 {
            switch texts[indexPath.row]{
                case "3 min":
                    minuteSet(.Minute,number:3,date: NSDate())
                    
                    for i in 1...30 {
                        let days = makeDate(.Day,number: i,date: NSDate())
                        var calender = NSCalendar.currentCalendar()
                        var components = calender.components(NSCalendarUnit.YearCalendarUnit|NSCalendarUnit.MonthCalendarUnit|NSCalendarUnit.DayCalendarUnit|NSCalendarUnit.WeekdayCalendarUnit, fromDate: days)
                        var weekday = components.weekday
                        
                        if weekday == 1{
                            println(days,"は日曜日です")
                        }
                        if weekday == 2{
                            println(days,"は月曜日です")
                        }
                        if weekday == 3{
                            println(days,"は火曜日です")
                        }
                        if weekday == 4{
                            println(days,"は水曜日です")
                        }
                        if weekday == 5{
                            println(days,"は木曜日です")
                        }
                        if weekday == 6{
                            println(days,"は金曜日です")
                        }
                        if weekday == 7{
                            println(days,"は土曜日です")
                        }
                    }
                case "5 min":
                    minuteSet(.Minute,number:5,date: NSDate())
                case "10 min":
                    minuteSet(.Minute,number:10,date: NSDate())
                case "15 min":
                    minuteSet(.Minute,number:15,date: NSDate())
                case "30 min":
                    minuteSet(.Minute,number:30,date: NSDate())
                case "60 min":
                    minuteSet(.Minute,number:60,date: NSDate())
                default:
                    break
            }
        }
    }
   
    func onClickEnabledSwicth(sender: UISwitch){
        let pointInTable: CGPoint = sender.convertPoint(sender.bounds.origin, toView: self.alarmTableView)
        let cellIndexPath = self.alarmTableView.indexPathForRowAtPoint(pointInTable)
        let row = cellIndexPath?.row
        if enabled[row!] {
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
    
    //有効なNotificationか確認する
    private func makeNotification(time:NSString, repeat:String, snooze:Bool, label:String, sound:String, enabled:Bool) {
        
        //スイッチ無効の場合は何もせず終了
        if enabled == false {
            return
        }

        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let dateFromString = dateFormatter.dateFromString(time)
        let now = NSDate()
        
        // 現在より過去の時刻を指定した場合は通知しない
        if (dateFromString!.compare(now) == NSComparisonResult.OrderedAscending || repeat == "no repeat"){
            return
        }
        
        showNotificationFire(dateFromString!, repeat: repeat, snooze: snooze, label: label, sound: sound)
    }

    //notification 全部発火？
    private func showNotificationFire(time:NSDate, repeat:String, snooze:Bool, label:String, sound:String){
        // Notificationの生成
        let myNotification: UILocalNotification = UILocalNotification()
        myNotification.alertBody = label
        myNotification.soundName = sound
        myNotification.timeZone = NSTimeZone.defaultTimeZone()
        myNotification.fireDate = time
        
        //repeat時は繰り返し（繰り返し期間は1ヶ月くらい？）

        UIApplication.sharedApplication().scheduleLocalNotification(myNotification)
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
    
    func makeDate(interval: Interval, number: Int, date: NSDate) -> NSDate {
        
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
        return calendar.dateByAddingComponents(comp, toDate: date, options: nil)!
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
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"

        alarmTimes.append(dateFormatter.stringFromDate(alarmTime))
        descriptions.append("アラーム")
        for i in 1...7 {
            repeats.append("0")
        }
        snoozes.append(true)
        enabled.append(true)
        alarmTableView.reloadData()
    }
    
    func tableView(changeSwitchValue: NSIndexPath){
        println("testman")
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
