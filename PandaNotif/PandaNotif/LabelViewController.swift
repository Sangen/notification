//
//  LabelViewController.swift
//  PandaNotif
//
//  Created by 坂口真一 on 2014/12/16.
//  Copyright (c) 2014年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

class LabelViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var myTextField: UITextField!
    var label = String()
    var getLabel : AnyObject = ""
    var from = Int()
    let myUserDafault = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label = self.getLabel as String
        self.myTextField.text = self.label
        self.myTextField.delegate = self
        self.myTextField.borderStyle = UITextBorderStyle.RoundedRect
        self.myTextField.keyboardType = UIKeyboardType.Default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func textFieldDidBeginEditing(textField: UITextField){
       //println("textFieldDidBeginEditing:" + textField.text)
    }
 
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        let flg:Bool = from == 0
        let flg2:Bool = textField.text == ""
        if flg {
            if flg2 {
                myUserDafault.setObject("アラーム", forKey: "newLabel")
            }else{
                myUserDafault.setObject(textField.text, forKey: "newLabel")
            }
        }else{
            if flg2 {
                myUserDafault.setObject("アラーム", forKey: "editLabel")
            }else{
                myUserDafault.setObject(textField.text, forKey: "editLabel")
            }
        }
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
