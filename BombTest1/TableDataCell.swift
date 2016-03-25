//
//  TableDataCell.swift
//  BombTest1
//
//  Created by Chuanxun on 16/3/23.
//  Copyright © 2016年 Leon. All rights reserved.
//

import UIKit

class TableDataCell: UITableViewCell {

    var bmobSchema:BmobTableSchema?
    var textFieldsArray = [UITextField]()
    var ignoreFields:Set<String> = ["updatedAt","ACL","createdAt"]

    
    var object:BmobObject? {
        didSet {
            guard object != nil else {
                return
            }
            for textField in self.textFieldsArray {
                let value = object!.objectForKey(textField.placeholder)
                textField.text = String(value)
            }
        }
    }
    
    static private var textFieldHeight:CGFloat = 30
    static private var leftEdge:CGFloat = 16
    static private var topEdge:CGFloat = 8
    
    
     convenience init(bmobSchema:BmobTableSchema) {
        
        self.init(style: .Default, reuseIdentifier: bmobSchema.className)
        
        self.bmobSchema = bmobSchema
        
        let fields = (bmobSchema.fields) as! [String:[String:String]]
        
        var i:CGFloat = 0
        for fieldName in fields.keys {
            
            if self.ignoreFields.contains(fieldName) {
                continue
            }
            
            let label = UILabel()
            label.text = fieldName
            label.frame = CGRect(x: TableDataCell.leftEdge, y: (i + 1)*TableDataCell.topEdge + i*TableDataCell.textFieldHeight, width: CGFloat(100), height: TableDataCell.textFieldHeight)
            self.contentView.addSubview(label)
            label.backgroundColor = UIColor.brownColor()
            
            let textField = UITextField()
            textField.placeholder = fieldName
            self.textFieldsArray.append(textField)
            self.contentView.addSubview(textField)
            textField.frame = CGRect(x: TableDataCell.leftEdge + 100, y: (i + 1)*TableDataCell.topEdge + i*TableDataCell.textFieldHeight, width: CGFloat(200), height: TableDataCell.textFieldHeight)
            textField.borderStyle = .RoundedRect
            
            i++
        }
        
        //self.contentView.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    static func bestHeightWith(bmobSchema:BmobTableSchema)->CGFloat{
        let fields = (bmobSchema.fields) as! [String:[String:String]]
        return CGFloat(fields.count) * (textFieldHeight + topEdge) + topEdge
    }
    
     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
     }
    
}
