//
//  ZQPickerView.swift
//  datePickerDemo
//
//  Created by 张泉 on 16/7/11.
//  Copyright © 2016年 张泉. All rights reserved.
//

import UIKit

let ZQPickerViewNotification = "ZQPickerViewNotification"

@objc public protocol ZQPickerViewDelegate {
    
    optional func pickerViewWillAppear(picker: ZQPickerView)
    optional func pickerViewDidAppear(picker: ZQPickerView)
    
    optional func pickerView(picker: ZQPickerView, didPickDate date: NSDate)
    optional func pickerViewDidCancel(picker: ZQPickerView)
    
    optional func pickerViewWillDisappear(picker: ZQPickerView)
    optional func pickerViewDidDisappear(picker: ZQPickerView)
    
}

public class ZQPickerView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {
    
    private var toolbarHeight: CGFloat = 44.0
    public var delegate: ZQPickerViewDelegate?
    private var result:((result:Int)->())?
    private var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.translucent = false
        toolbar.barTintColor = UIColor.colorWithString("#22A563")
        toolbar.backgroundColor = UIColor.colorWithString("#22A563")
        return toolbar
    }()
    public lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    private var maxAge:Int = 99
    private var minAge:Int = 0
    private var currentAge:Int = 0
    public var pickerBackgroundColor: UIColor? {
        didSet { picker.backgroundColor = pickerBackgroundColor }
    }

    public override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        picker.backgroundColor = UIColor.whiteColor()
        addSubview(picker)
        addSubview(toolbar)
        setupDefaultButtons()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ZQPickerView.pressedCancel(_:)), name: ZQDatePickerNotification, object: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func setupDefaultButtons() {
        let doneButton = UIBarButtonItem(title: "完成  ",
                                         style: UIBarButtonItemStyle.Plain,
                                         target: self,
                                         action: #selector(ZQDatePicker.pressedDone(_:)))
        let itemSpring = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "  取消",
                                           style: UIBarButtonItemStyle.Plain,
                                           target: self,
                                           action: #selector(ZQDatePicker.pressedCancel))
        
        toolbar.items = [cancelButton,itemSpring,doneButton]
    }
    
    func showPickView(view:UIView,maxAge:Int,minAge:Int,currentAge:Int,animated:Bool,result:((result:Int)->())) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(ZQPickerViewNotification, object: nil)
        
        toolbar.frame = CGRectMake(0, 0, view.frame.size.width, toolbarHeight)
        picker.frame = CGRectMake(0, toolbarHeight, view.frame.size.width, picker.frame.size.height)
        self.frame = CGRectMake(0,
                                view.frame.size.height - picker.frame.size.height - toolbar.frame.size.height,
                                view.frame.size.width, picker.frame.size.height + toolbar.frame.size.height)
        view.addSubview(self)
        picker.selectRow(currentAge, inComponent: 0, animated: true)
        becomeFirstResponder()
        self.result = result
        showPickerAnimation(animated)
    }
    
    public func pressedDone(sender: AnyObject) {
        hidePickerAnimation(true)
        
        if let result = self.result {
            result(result: self.picker.selectedRowInComponent(0))
        }
    }
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, withEvent: event)
        
        if view == nil {
            self.hidePickerAnimation(true)
        }
        
        return view
    }

    public func pressedCancel(sender: AnyObject) {
        hidePickerAnimation(true)
    }
    
    
    private func hidePickerAnimation(animated: Bool) {
        self.removeFromSuperview()
    }
    
    private func showPickerAnimation(animated: Bool) {
        delegate?.pickerViewWillAppear?(self)
        
        if animated {
//            self.frame = CGRectOffset(self.frame, 0, self.frame.size.height)
            self.frame = CGRectMake(0, SCREENH, SCREENW, self.frame.size.height)
            UIView.animateWithDuration(0.2, animations: { () -> Void in
//                self.frame = CGRectOffset(self.frame, 0, -1 * self.frame.size.height)
                self.frame = CGRectMake(0, SCREENH - self.frame.size.height, SCREENW, self.frame.size.height)
            }) { (finished) -> Void in
                self.delegate?.pickerViewDidAppear?(self)
            }
        } else {
            delegate?.pickerViewDidAppear?(self)
        }
    }
    
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxAge - minAge
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(minAge + row)岁"
    }
}

