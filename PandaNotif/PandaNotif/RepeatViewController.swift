//
// RepeatViewController.swift
// PandaNotif
//
// Created by 坂口真一 on 2014/12/09.
// Copyright (c) 2014年 Shinichi.Sakaguchi. All rights reserved.
//
import UIKit
class RepeatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var repeatTable: UITableView!
    var getRepeats = String()
    var repeats = [String]()
    var from = Int()
    let texts = ["毎日曜日","毎月曜日","毎火曜日","毎水曜日","毎木曜日","毎金曜日","毎土曜日"]
    let myUserDafault = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.repeatTable.delegate = self
        self.repeatTable.dataSource = self
        self.repeatTable.registerClass(UITableViewCell.self, forCellReuseIdentifier:"data")
        for i in getRepeats{
            repeats.append(String(i))
        }
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
        let flg:Bool = repeats[indexPath.row] == "1"
        if flg {
            cell.detailTextLabel?.text = "✔︎"
        }else{
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!){
        repeatTable.deselectRowAtIndexPath(indexPath, animated: true)
        switch texts[indexPath.row]{
            case "毎日曜日":
                let flg:Bool = repeats[0] == "0"
                if flg {
                    repeats[0] = "1"
                }else{
                    repeats[0] = "0"
                }
            case "毎月曜日":
                let flg:Bool = repeats[1] == "0"
                if flg {
                    repeats[1] = "1"
                }else{
                    repeats[1] = "0"
                }
            case "毎火曜日":
                let flg:Bool = repeats[2] == "0"
                if flg {
                    repeats[2] = "1"
                }else{
                    repeats[2] = "0"
                }
            case "毎水曜日":
                let flg:Bool = repeats[3] == "0"
                if flg {
                    repeats[3] = "1"
                }else{
                    repeats[3] = "0"
                }
            case "毎木曜日":
                let flg:Bool = repeats[4] == "0"
                if flg {
                    repeats[4] = "1"
                }else{
                    repeats[4] = "0"
                }
            case "毎金曜日":
                let flg:Bool = repeats[5] == "0"
                if flg {
                    repeats[5] = "1"
                }else{
                    repeats[5] = "0"
                }
            case "毎土曜日":
                let flg:Bool = repeats[6] == "0"
                if flg {
                    repeats[6] = "1"
                }else{
                    repeats[6] = "0"
                }
            default:
                break
        }
        let delay = 0.2 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.repeatTable.reloadData()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        var joinRepeats = String()
        for i in 0...6{
            joinRepeats = joinRepeats + repeats[i]
        }
        let flg:Bool = from == 0
        if flg {
            myUserDafault.setObject(joinRepeats, forKey: "newRepeat")
        }else{
            myUserDafault.setObject(joinRepeats, forKey: "editRepeat")
        }
        myUserDafault.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}