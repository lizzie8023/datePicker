//
//  ZQDatePicker.swift
//  datePickerDemo
//
//  Created by 张泉 on 16/7/11.
//  Copyright © 2016年 张泉. All rights reserved.
//


import UIKit

let ZQDatePickerNotification = "ZQDatePickerNotification"

@objc public protocol ZQDatePickerDelegate {
    
    optional func datePickerWillAppear(picker: ZQDatePicker)
    optional func datePickerDidAppear(picker: ZQDatePicker)
    
    optional func datePicker(picker: ZQDatePicker, didPickDate date: NSDate)
    optional func datePickerDidCancel(picker: ZQDatePicker)
    
    optional func datePickerWillDisappear(picker: ZQDatePicker)
    optional func datePickerDidDisappear(picker: ZQDatePicker)
}

@objc public class ZQDatePicker: UIView {
    
    public var delegate: ZQDatePickerDelegate?
    
    public var toolbarHeight: CGFloat = 44.0
    private var result:((date:NSDate)->())?
    
    public var pickerBackgroundColor: UIColor? {
        didSet { picker.backgroundColor = pickerBackgroundColor }
    }
    
    /** Initial picker's date */
    public var pickerDate: NSDate = NSDate() {
        didSet { picker.date = pickerDate }
    }
    private var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.translucent = false
        toolbar.barTintColor = UIColor.colorWithString("#22A563")
        toolbar.backgroundColor = UIColor.colorWithString("#22A563")
        return toolbar
    }()
    public var picker: UIDatePicker = UIDatePicker()
    
    // MARK: Lifecycle
    
    public override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        picker.datePickerMode = .Date
        picker.backgroundColor = UIColor.whiteColor()
        addSubview(picker)
        addSubview(toolbar)
        self.picker.locale = NSLocale(localeIdentifier: "zh-Hans")
        setupDefaultButtons()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ZQDatePicker.pressedCancel), name: ZQPickerViewNotification, object: nil)
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
    
    public func showPickerInView(view: UIView, animated: Bool,result:((date:NSDate)->())) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(ZQDatePickerNotification, object: nil)
        self.result = result
        toolbar.frame = CGRectMake(0, 0, view.frame.size.width, toolbarHeight)
        picker.frame = CGRectMake(0, toolbarHeight, view.frame.size.width, picker.frame.size.height)
        self.frame = CGRectMake(0, view.frame.size.height - picker.frame.size.height - toolbar.frame.size.height,
                                view.frame.size.width, picker.frame.size.height + toolbar.frame.size.height)
        view.addSubview(self)
        becomeFirstResponder()
        
        showPickerAnimation(animated)
    }
    
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, withEvent: event)
        
        if view == nil {
            self.hidePickerAnimation(true)
        }
        
        return view
    }
    
    // MARK: Animation
    private func hidePickerAnimation(animated: Bool) {
        self.removeFromSuperview()
    }
    
    private func showPickerAnimation(animated: Bool) {
        delegate?.datePickerWillAppear?(self)
        
        if animated {
            self.frame = CGRectOffset(self.frame, 0, self.frame.size.height)
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.frame = CGRectOffset(self.frame, 0, -1 * self.frame.size.height)
            }) { (finished) -> Void in
                self.delegate?.datePickerDidAppear?(self)
            }
        } else {
            delegate?.datePickerDidAppear?(self)
        }
    }
    
    // MARK: Actions
    public func pressedDone(sender: AnyObject) {
        hidePickerAnimation(true)
     
        if let result = self.result {
            result(date: picker.date)
        }
    }
    
    /**
     Default Cancel actions for picker.
     */
    public func pressedCancel() {
        hidePickerAnimation(true)
    }
}
