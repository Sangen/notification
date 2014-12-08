//
//  ViewController.swift
//  test2
//
//  Created by 坂口真一 on 2014/12/01.
//  Copyright (c) 2014年 坂口真一. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var alarmTableView: UITableView!
    @IBOutlet weak var minuteTableView: UITableView!
    var myRightButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().registerUserNotificationSettings(
            UIUserNotificationSettings(
                forTypes:UIUserNotificationType.Sound | UIUserNotificationType.Alert,
                categories: nil)
        )

        self.title = "My Navigation"
        self.navigationController?.navigationBar;
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // 右ボタンを作成する
        myRightButton = UIBarButtonItem(title: "RightBtn", style: .Plain, target: self, action: "onClickMyButton:")
        myRightButton.tag = 2
        
        // ナビゲーションバーの右に設置する.
        self.navigationItem.rightBarButtonItem = myRightButton

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
            customCell.timeLabel?.text = alarmTimes[indexPath.row]
            customCell.timeLabel?.font = UIFont.systemFontOfSize(40.0)
            customCell.descriptionLabel?.text = descriptions[indexPath.row]
            return customCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!)
    {
        if tableView.tag == 0 {
            let now = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
            
            switch texts[indexPath.row]{
                case "3 min":
                    dateAdd(.Minute,number:3,date: NSDate())
                    //println(alarmTimes)
                    //println(descriptions)
                    showNotificationFire(180,label: "アラーム")
                case "5 min":
                    dateAdd(.Minute,number:5,date: NSDate())
                    showNotificationFire(300,label: "アラーム")
                case "10 min":
                    dateAdd(.Minute,number:10,date: NSDate())
                    showNotificationFire(600,label: "アラーム")
                case "15 min":
                    dateAdd(.Minute,number:15,date: NSDate())
                    showNotificationFire(900,label: "アラーム")
                case "30 min":
                    dateAdd(.Minute,number:30,date: NSDate())
                    showNotificationFire(1800,label: "アラーム")
                case "60 min":
                    dateAdd(.Minute,number:60,date: NSDate())
                    showNotificationFire(3600,label: "アラーム")
                default:
                    break
            }
        }
    }

    private func showNotificationFire(time:Double, label:String){
        // Notificationの生成
        let myNotification: UILocalNotification = UILocalNotification()
        // メッセージ
        myNotification.alertBody = label
        // 再生サウンド
        myNotification.soundName = UILocalNotificationDefaultSoundName
        // Timezone
        myNotification.timeZone = NSTimeZone.defaultTimeZone()
        // 指定秒
        myNotification.fireDate = NSDate(timeIntervalSinceNow: time)
        // Notificationを表示
        UIApplication.sharedApplication().scheduleLocalNotification(myNotification)
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
        dateFormatter.dateFormat = "HH:mm"

        alarmTimes.append(dateFormatter.stringFromDate(alarmTime))
        descriptions.append("アラーム")
        alarmTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
