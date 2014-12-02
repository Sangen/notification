//
//  ViewController.swift
//  test2
//
//  Created by 坂口真一 on 2014/12/01.
//  Copyright (c) 2014年 坂口真一. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    var myNotificationButton: UIButton!
    var myNotificationFireButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // アラート表示の許可をもらう.
        UIApplication.sharedApplication().registerUserNotificationSettings(
            UIUserNotificationSettings(
                forTypes:UIUserNotificationType.Sound | UIUserNotificationType.Alert,
                categories: nil)
        )
        
        // すぐにNotificationを発火するボタンを作成する.
        myNotificationButton = UIButton(frame: CGRectMake(0,0,200,80))
        myNotificationButton.backgroundColor = UIColor.orangeColor()
        myNotificationButton.layer.masksToBounds = true
        myNotificationButton.setTitle("Notification", forState: .Normal)
        myNotificationButton.layer.cornerRadius = 20.0
        myNotificationButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:200)
        myNotificationButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        myNotificationButton.tag = 1
        
        // 時間をおいてNotificationを発火するボタンを作成する.
        myNotificationFireButton = UIButton(frame: CGRectMake(0,0,200,80))
        myNotificationFireButton.backgroundColor = UIColor.blueColor()
        myNotificationFireButton.layer.masksToBounds = true
        myNotificationFireButton.setTitle("Notification(Fire)", forState: .Normal)
        myNotificationFireButton.layer.cornerRadius = 20.0
        myNotificationFireButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:400)
        myNotificationFireButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        myNotificationFireButton.tag = 2
        
        // ViewにButtonを追加する.
        view.addSubview(myNotificationButton)
        view.addSubview(myNotificationFireButton)
    }
    /*
    ボタンイベント
    */
    func onClickMyButton(sender: UIButton){
        if sender.tag == 1 {
            showNotification()
        } else if sender.tag == 2 {
            showNotificationFire()
        }
    }
    /*
    Show Notification
    */
    private func showNotification(){
        // Notificationの生成する.
        let myNotification: UILocalNotification = UILocalNotification()
        // メッセージを代入する.
        myNotification.alertBody = "TEST"
        // Timezoneを設定をする.
        myNotification.timeZone = NSTimeZone.defaultTimeZone()
        // Notificationを表示する.
        UIApplication.sharedApplication().scheduleLocalNotification(myNotification)
    }
    /*
    Show Notification(10 sec後に発火)
    */
    private func showNotificationFire(){
        // Notificationの生成する.
        let myNotification: UILocalNotification = UILocalNotification()
        // メッセージを代入する.
        myNotification.alertBody = "こっち見んな"
        // 再生サウンドを設定する.
        myNotification.soundName = UILocalNotificationDefaultSoundName
        // Timezoneを設定する.
        myNotification.timeZone = NSTimeZone.defaultTimeZone()
        // 10秒後に設定する.
        myNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        // Notificationを表示する.
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
