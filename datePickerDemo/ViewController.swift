//
//  ViewController.swift
//  datePickerDemo
//
//  Created by 张泉 on 16/7/11.
//  Copyright © 2016年 张泉. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ZQDatePickerDelegate,ZQPickerViewDelegate {

    private var datePicker:ZQDatePicker = ZQDatePicker()
    private var activeDatePicker: ZQDatePicker?
    
    private var pickerView:ZQPickerView = ZQPickerView()
    private var activePickerView:ZQPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(dateButton)
        dateButton.frame = CGRectMake(100, 50, 200, 50)
        
        view.addSubview(ageButton)
        ageButton.frame = CGRectMake(100, 110, 200, 50)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @objc private func dateButtonClick() {
        
        if datePicker.isFirstResponder() {
            return
        }
        
        datePicker.showPickerInView(UIApplication.sharedApplication().keyWindow!, animated: true) { (date) in
            print(date)
        }
        datePicker.delegate = self
        
        activeDatePicker = datePicker
    }
    
    @objc private func ageButtonClick() {
        pickerView.showPickView(UIApplication.sharedApplication().keyWindow!, maxAge: 0, minAge: 0,currentAge:20, animated: true) { (result) in
            print(result)
        }
        pickerView.delegate = self
        activePickerView = pickerView
    }
    
    private lazy var dateButton:UIButton = {
        let dateButton = UIButton()
        dateButton.backgroundColor = UIColor.grayColor()
        dateButton.setTitle("生日选择", forState: UIControlState.Normal)
        dateButton.addTarget(self, action: #selector(ViewController.dateButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        return dateButton
    }()
    
    private lazy var ageButton:UIButton = {
        let ageButton = UIButton()
        ageButton.backgroundColor = UIColor.blueColor()
        ageButton.setTitle("年龄选择", forState: UIControlState.Normal)
        ageButton.addTarget(self, action: #selector(ViewController.ageButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        return ageButton
    }()
}

