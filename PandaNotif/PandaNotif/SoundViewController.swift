//
//  SoundViewController.swift
//  PandaNotif
//
//  Created by 坂口真一 on 2014/12/17.
//  Copyright (c) 2014年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

class SoundViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var soundTable: UITableView!
    var selectedSounds = String()
    var sounds = ["0","0"]
    var getSound = String()
    var from = Int()
    let texts = ["レーザー", "なし"]
    let myUserDafault = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let getSound2 = getSound
        let flg:Bool = getSound2 == "nil"
        if flg {
            selectedSounds = "nil"
            sounds = ["0","1"]
        }else{
            selectedSounds = UILocalNotificationDefaultSoundName
            sounds = ["1","0"]
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
        cell.textLabel?.text = texts[indexPath.row]
        
        let flg:Bool = sounds[indexPath.row] == "1"
        if flg {
            cell.detailTextLabel?.text = "✔︎"
        }else{
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!)
    {
        soundTable.deselectRowAtIndexPath(indexPath, animated: true)
        switch texts[indexPath.row]{
            case "レーザー":
                let flg:Bool = sounds[0] == "0"
                if flg {
                    selectedSounds = UILocalNotificationDefaultSoundName
                    sounds[0] = "1"
                    sounds[1] = "0"
                }
            case "なし":
                let flg:Bool = sounds[1] == "0"
                if flg {
                    selectedSounds = "nil"
                    sounds[1] = "1"
                    sounds[0] = "0"
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
        let flg:Bool = from == 0
        if flg {
            myUserDafault.setObject(selectedSounds, forKey:"newSound")
        }else{
            myUserDafault.setObject(selectedSounds, forKey:"editSound")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
