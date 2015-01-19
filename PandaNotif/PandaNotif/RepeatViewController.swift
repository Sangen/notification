//
// RepeatViewController.swift
// PandaNotif
//
// Created by 坂口真一 on 2014/12/09.
// Copyright (c) 2014年 Shinichi.Sakaguchi. All rights reserved.
//
import UIKit

protocol RepeatViewControllerDelegate : class{
    func repeatChange(repeat:String)
}

class RepeatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var repeatTable: UITableView!
    weak var delegate: RepeatViewControllerDelegate? = nil
    var repeat = String()
    var repeatStatuses = [String]()
    let texts = ["毎日曜日","毎月曜日","毎火曜日","毎水曜日","毎木曜日","毎金曜日","毎土曜日"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.repeatTable.delegate = self
        self.repeatTable.dataSource = self
        self.repeatTable.registerClass(UITableViewCell.self, forCellReuseIdentifier:"data")
        for i in repeat{
            self.repeatStatuses.append(String(i))
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.texts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("data") as UITableViewCell
        cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "data")
        cell.textLabel?.text = self.texts[indexPath.row]
        let flg:Bool = self.repeatStatuses[indexPath.row] == "1"
        if flg {
            cell.detailTextLabel?.text = "✔︎"
        }else{
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!){
        self.repeatTable.deselectRowAtIndexPath(indexPath, animated: true)
        switch self.texts[indexPath.row]{
            case "毎日曜日":
                let flg:Bool = self.repeatStatuses[0] == "0"
                if flg {
                    self.repeatStatuses[0] = "1"
                }else{
                    self.repeatStatuses[0] = "0"
                }
            case "毎月曜日":
                let flg:Bool = self.repeatStatuses[1] == "0"
                if flg {
                    self.repeatStatuses[1] = "1"
                }else{
                    self.repeatStatuses[1] = "0"
                }
            case "毎火曜日":
                let flg:Bool = self.repeatStatuses[2] == "0"
                if flg {
                    self.repeatStatuses[2] = "1"
                }else{
                    self.repeatStatuses[2] = "0"
                }
            case "毎水曜日":
                let flg:Bool = self.repeatStatuses[3] == "0"
                if flg {
                    self.repeatStatuses[3] = "1"
                }else{
                    self.repeatStatuses[3] = "0"
                }
            case "毎木曜日":
                let flg:Bool = self.repeatStatuses[4] == "0"
                if flg {
                    self.repeatStatuses[4] = "1"
                }else{
                    self.repeatStatuses[4] = "0"
                }
            case "毎金曜日":
                let flg:Bool = self.repeatStatuses[5] == "0"
                if flg {
                    self.repeatStatuses[5] = "1"
                }else{
                    self.repeatStatuses[5] = "0"
                }
            case "毎土曜日":
                let flg:Bool = self.repeatStatuses[6] == "0"
                if flg {
                    self.repeatStatuses[6] = "1"
                }else{
                    self.repeatStatuses[6] = "0"
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
        self.repeat = ""
        for i in 0...6{
            self.repeat = self.repeat + self.repeatStatuses[i]
        }
        self.delegate?.repeatChange(repeat)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}