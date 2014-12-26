//
//  CustomCell.swift
//  PandaNotif
//
//  Created by 坂口真一 on 2014/12/08.
//  Copyright (c) 2014年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

// 依頼したい処理の名前と引数を書く
protocol CustomCellDelegate{
    func tableView(tableView: UITableView, changeSwitchValue: Bool, indexPath:NSIndexPath!)
 //   func tableView(changeSwitchValue: NSIndexPath)
}

class CustomCell: UITableViewCell {
    
    //デリゲートの依頼
    let delegate:CustomCellDelegate!
    
    var _delegate:AnyObject!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var enabledSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
// switch押された時の処理
    @IBAction func switchPush(sender: UISwitch){

        /*var tableView:AnyObject = sender.superview!
        while tableView.isKindOfClass(UITableView)  {
            tableView = tableView.superview!!
        }
        */
       // let pointInTable: CGPoint = sender.convertPoint(sender.bounds.origin, toView: tableView)
       // let cellIndexPath = self.tableView.indexPathForRowAtPoint(pointInTable)
        
       // let indexPath:NSIndexPath = tableView.indexPathForCell(cell)
      //  [_delegate, tableView:tableView changeSwitchValue:self.ValueSwitch.on indexPath:indexPath]

        // 依頼書に書いた機能の実行をお願いする
        //self.delegate?.tableView()
    }

}
