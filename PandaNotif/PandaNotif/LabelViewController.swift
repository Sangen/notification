//
//  LabelViewController.swift
//  PandaNotif
//
//  Created by 坂口真一 on 2014/12/16.
//  Copyright (c) 2014年 Shinichi.Sakaguchi. All rights reserved.
//

import UIKit

protocol LabelViewControllerDelegate : class{
    func labelChange(label:String)
}

class LabelViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var myTextField: UITextField!
    weak var delegate: LabelViewControllerDelegate? = nil
    var label = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let flg:Bool = textField.text == ""
        if flg {
            self.label = "アラーム"
        }else{
            self.label = textField.text
        }
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        self.delegate?.labelChange(label)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
