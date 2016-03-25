//
//  AddAndEditDataController.swift
//  BombTest1
//
//  Created by Chuanxun on 16/3/23.
//  Copyright © 2016年 Leon. All rights reserved.
//

import UIKit

class AddAndEditDataController: UIViewController {

    
    var schema:BmobTableSchema!
    var object:BmobObject? {
        didSet {
            if object == nil {
                for textField in self .textFieldsArray {
                    textField.text = ""
                }
            }else {
                for textField in self .textFieldsArray {
                    textField.text = String(object!.objectForKey(textField.placeholder))
                }
            }
            
        }
    }
    var textFieldsArray = [UITextField]()

    var ignoreFields:Set<String> = ["updatedAt","objectId","ACL","createdAt"]
    
    static private var textFieldHeight:CGFloat = 20
    static private var leftEdge:CGFloat = 16
    static private var topEdge:CGFloat = 16
    
    init(bmSchema:BmobTableSchema,bmobject:BmobObject?){
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.schema = bmSchema
        
        let fields = (bmSchema.fields) as! [String:[String:String]]
        
        var i:CGFloat = 0
        for fieldName in fields.keys {
            
            if self.ignoreFields.contains(fieldName) {
                continue
            }
            
            let textField = UITextField()
            textField.placeholder = fieldName
            textField.borderStyle = .RoundedRect
            if bmobject != nil {
                textField.text = String(bmobject!.objectForKey(fieldName))
            }
            
            textField.frame = CGRect(x: AddAndEditDataController.leftEdge, y: (i + 1)*AddAndEditDataController.topEdge + i*AddAndEditDataController.textFieldHeight + 60, width: CGFloat(200), height: AddAndEditDataController.textFieldHeight)
            
            self.textFieldsArray.append(textField)
            
            self.view.addSubview(textField)
            
            i++
        }
        
        self.object = bmobject
        
        if bmobject == nil {
            let addBtnFrame = CGRect(x: AddAndEditDataController.leftEdge, y: (i + 1)*AddAndEditDataController.topEdge + i*AddAndEditDataController.textFieldHeight + 60, width: CGFloat(100), height: AddAndEditDataController.textFieldHeight)
            let addBtn = UIButton(frame: addBtnFrame)
            addBtn.setTitle("Add", forState: .Normal)
            addBtn.backgroundColor = UIColor.brownColor()
            addBtn.addTarget(self, action: "add:", forControlEvents: .TouchUpInside)
            self.view.addSubview(addBtn)

        }else {
            let editBtnFrame = CGRect(x: AddAndEditDataController.leftEdge + 16, y: (i + 1)*AddAndEditDataController.topEdge + i*AddAndEditDataController.textFieldHeight + 60, width: CGFloat(100), height: AddAndEditDataController.textFieldHeight)
            let editBtn = UIButton(frame: editBtnFrame)
            editBtn.setTitle("Edit", forState: .Normal)
            editBtn.backgroundColor = UIColor.brownColor()
            editBtn.addTarget(self, action: "edit:", forControlEvents: .TouchUpInside)
            
            self.view.addSubview(editBtn)
        }

    }

    
    
    func add(sender:UIButton){
        let newObject = BmobObject(className: self.schema.className)
        let fields = self.schema.fields as! [String:[String:String]]
        for textField in self.textFieldsArray {
            if textField.text != nil {
                let attributeDict = fields[textField.placeholder!]
                let type = attributeDict!["type"]
                if type == "String" {
                    newObject.setObject(textField.text, forKey: textField.placeholder!)
                }else if type == "Number" {
                    newObject.setObject(Int((textField.text! as NSString).intValue), forKey: textField.placeholder!)
                }
            }
        }
        
        newObject.saveInBackgroundWithResultBlock { (isSuccessful, error) -> Void in
            if isSuccessful {
                print("succeeded")
            }else{
                print(error)
            }
        }
    }
    
    func edit(sender:UIButton){
        
        if self.object == nil {
            return
        }
        
        let newObject = BmobObject(withoutDatatWithClassName: self.schema.className, objectId: self.object!.objectId)
        let fields = self.schema.fields as! [String:[String:String]]
        for textField in self.textFieldsArray {
            if textField.text != nil {
                let attributeDict = fields[textField.placeholder!]
                let type = attributeDict!["type"]
                if type == "String" {
                    newObject.setObject(textField.text, forKey: textField.placeholder!)
                }else if type == "Number" {
                    newObject.setObject(Int((textField.text! as NSString).intValue), forKey: textField.placeholder!)
                }
            }
        }
        
        newObject.updateInBackgroundWithResultBlock { (isSuccessful, error) -> Void in
            if isSuccessful {
                print("succeeded")
            }else{
                print(error)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
