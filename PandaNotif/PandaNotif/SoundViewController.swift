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
    
    var selectedSounds = ["",""]
    var sounds = ["0","0"]
    var getSound :AnyObject = ""
    let texts = ["レーザー(デフォルト)", "なし"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var getSound2 = getSound as [String]
        if getSound2[0]  == "なし"{
            selectedSounds = ["なし","nil"]
            sounds = ["0","1"]
        }else{
            selectedSounds = ["レーザー",UILocalNotificationDefaultSoundName]
            sounds = ["1","0"]
        }
        
        self.soundTable.delegate = self
        self.soundTable.dataSource = self
        self.soundTable.registerClass(UITableViewCell.self, forCellReuseIdentifier:"data")

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return texts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("data") as UITableViewCell
        
        cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "data")
        cell.textLabel?.text = texts[indexPath.row]
        
        if sounds[indexPath.row] == "1"{
            cell.detailTextLabel?.text = "✔︎"
        }else{
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!)
    {
        switch texts[indexPath.row]{
            case "レーザー(デフォルト)":
                if sounds[0] == "0" {
                    selectedSounds = ["レーザー",UILocalNotificationDefaultSoundName]
                    sounds[0] = "1"
                    sounds[1] = "0"
                }
            case "なし":
                if sounds[1] == "0" {
                    selectedSounds = ["なし","nil"]
                    sounds[1] = "1"
                    sounds[0] = "0"
                }
            default:
                break
        }
        soundTable.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        var myUserDafault:NSUserDefaults = NSUserDefaults()
        myUserDafault.setObject(selectedSounds, forKey: "NewSound")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
