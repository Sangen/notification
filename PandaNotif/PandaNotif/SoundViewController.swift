//
//  SoundViewController.swift
//  PandaNotif
//
//  Created by 坂口真一 on 2014/12/17.
//  Copyright (c) 2014年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

protocol SoundViewControllerDelegate : class{
    func soundChange(sound:String)
}

class SoundViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var soundTable: UITableView!
    weak var delegate: SoundViewControllerDelegate? = nil
    var soundStatuses = ["0","0"]
    var sound = String()
    let texts = ["レーザー", "なし"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let flg:Bool = sound == "nil"
        if flg {
            self.soundStatuses = ["0","1"]
        }else{
            self.soundStatuses = ["1","0"]
        }
        
        self.soundTable.delegate = self
        self.soundTable.dataSource = self
        self.soundTable.registerClass(UITableViewCell.self, forCellReuseIdentifier:"data")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return texts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("data") as UITableViewCell
        cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "data")
        cell.textLabel?.text = self.texts[indexPath.row]
        
        let flg:Bool = self.soundStatuses[indexPath.row] == "1"
        if flg {
            cell.detailTextLabel?.text = "✔︎"
        }else{
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!)
    {
        self.soundTable.deselectRowAtIndexPath(indexPath, animated: true)
        switch self.texts[indexPath.row]{
            case "レーザー":
                let flg:Bool = self.soundStatuses[0] == "0"
                if flg {
                    self.sound = UILocalNotificationDefaultSoundName
                    self.soundStatuses[0] = "1"
                    self.soundStatuses[1] = "0"
                }
            case "なし":
                let flg:Bool = self.soundStatuses[1] == "0"
                if flg {
                    self.sound = "nil"
                    self.soundStatuses[1] = "1"
                    self.soundStatuses[0] = "0"
                }
            default:
                break
        }
        let delay = 0.2 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.soundTable.reloadData()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        self.delegate?.soundChange(sound)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
