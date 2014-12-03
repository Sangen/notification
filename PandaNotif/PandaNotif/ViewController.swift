//
//  ViewController.swift
//  test2
//
//  Created by 坂口真一 on 2014/12/01.
//  Copyright (c) 2014年 坂口真一. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var alarmTableView: UITableView!
    @IBOutlet weak var minuteTableView: UITableView!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // アラート表示の許可
        UIApplication.sharedApplication().registerUserNotificationSettings(
            UIUserNotificationSettings(
                forTypes:UIUserNotificationType.Sound | UIUserNotificationType.Alert,
                categories: nil)
        )
        minuteTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"data")
        minuteTableView.delegate = self
        minuteTableView.dataSource = self
        minuteTableView.backgroundColor = UIColor.clearColor()
        
        alarmTableView.registerNib(UINib(nibName: "CustomViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
//        var nib = UINib(nibName: "CustomViewCell", bundle: nil)
//        alarmTableView.registerNib(nib, forCellReuseIdentifier:"Cell")
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        alarmTableView.backgroundColor = UIColor.clearColor()
    }
    
    var texts = ["3 min", "5 min", "10 min", "15 min", "30 min", "60 min"]
    var texts2 = ["14:30", "15:30", "18:30"]

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 80
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == 0{
            return texts.count
        }else{
            return texts2.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("data", forIndexPath: indexPath) as UITableViewCell
        let customCell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as CustomViewCell
     
        if tableView.tag == 0{
            cell.textLabel?.text = texts[indexPath.row]
            cell.textLabel?.font = UIFont.systemFontOfSize(25.0)
            return cell
        }else{
          //  customCell.timeLabel.text = texts2[indexPath.row]
           // customCell.textLabel?.font = UIFont.systemFontOfSize(18.0)
            return customCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!)
    {
        if tableView.tag == 0 {
            switch texts[indexPath.row]{
                case "3 min":
                    showNotificationFire(180,label: "アラーム")
                case "5 min":
                    showNotificationFire(300,label: "アラーム")
                case "10 min":
                    showNotificationFire(600,label: "アラーム")
                case "15 min":
                    showNotificationFire(900,label: "アラーム")
                case "30 min":
                    showNotificationFire(1800,label: "アラーム")
                case "60 min":
                    showNotificationFire(3600,label: "アラーム")
                default:
                    break
            }
        }else{
            showNotificationFire(10, label: "アラームテスト")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }
}
