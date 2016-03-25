//
//  ViewController.swift
//  BombTest1
//
//  Created by Chuanxun on 16/3/23.
//  Copyright © 2016年 Leon. All rights reserved.
//

import UIKit

class TableSchemaController: UITableViewController {

    
    var tablesSchemaArray = [BmobTableSchema]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.save()
        self.loadAllTable()
    }



    func save() {
        
        let bmobObject = BmobObject(className: "student")
        bmobObject.setObject("leon", forKey: "name")
        
        bmobObject.saveInBackgroundWithResultBlock { (succeeded, error) -> Void in
            if succeeded {
                print("succeeded")
            }else{
                print("\(error.description)")
            }
        }
    }
    
    func loadAllTable(){
        Bmob.getAllTableSchemasWithCallBack { (tablesArray, error) -> Void in
            if error != nil {
                print("\(error.userInfo["error"])")
            }else{
                self.tablesSchemaArray = tablesArray as! [BmobTableSchema]
                for bmobTableSchema in tablesArray {
                    print("\(bmobTableSchema.className)")
                    
                    let fields = bmobTableSchema.fields as! [String:[String:String]]
                    for (key,value) in fields {
                        
                        let type = value["type"]
                        if type == "Pointer" {
                            print("     \(key) point to \(value["targetClass"])")
                        }else{
                            print("     \(key) is \(type)")
                        }
                    }
                    
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tablesSchemaArray.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let schema = self.tablesSchemaArray[section]
        return schema.fields.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tablesSchemaArray[section].className
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("table_schema_cell", forIndexPath: indexPath)
        
        let schema = self.tablesSchemaArray[indexPath.section]
        
        let fields = schema.fields as! [String:[String:String]]
        
        cell.textLabel?.text = ([String](fields.keys))[indexPath.row]
        
        let field = ([[String:String]](fields.values))[indexPath.row]
        
        let type = field["type"]
        
        if type == "Pointer" {
            cell.detailTextLabel?.text = "point to \(field["targetClass"])"
        }else{
            cell.detailTextLabel?.text = type
        }
        
        return cell
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let schema = self.tablesSchemaArray[indexPath.section]
        
        let tableDataController = TableDataController(bmobSchema: schema)
        
        self.navigationController?.pushViewController(tableDataController, animated: true)
    }
}

