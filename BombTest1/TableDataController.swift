//
//  TableDataController.swift
//  BombTest1
//
//  Created by Chuanxun on 16/3/23.
//  Copyright © 2016年 Leon. All rights reserved.
//

import UIKit

let reuse_id = "table_data_cell"

class TableDataController: UITableViewController {

    var tableName:String!
    var queryResult:[BmobObject]!
    var schema:BmobTableSchema!
    
    var ignoreFields:Set<String> = ["updatedAt","ACL","createdAt"]
    
    init(bmobSchema:BmobTableSchema){
        
        self.tableName = bmobSchema.className
        self.schema = bmobSchema
        
        super.init(style: .Plain)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        
        //self.tableView.registerClass(TableDataCell.self, forCellReuseIdentifier: self.tableName)
        
        self.loadALlData()
        
        self.title = self.tableName
        
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let addItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "add:")
        
        self.navigationItem.rightBarButtonItems = [addItem,self.editButtonItem()]
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadALlData()
    }
    
    
    func loadALlData(){
        
        let query = BmobQuery(className: self.tableName)
        
        query.limit = 100
        
        query.findObjectsInBackgroundWithBlock { (result, error) -> Void in
            if error != nil {
                print(error.description)
            }else{
                self.queryResult = result as? [BmobObject]
                
                self.tableView.reloadData()
            }
        }
        
    }
    
    func add(sender:UIBarButtonItem){
        let vc = AddAndEditDataController(bmSchema: self.schema, bmobject: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.queryResult == nil {
            return 0
        }else {
            return (self.queryResult?.count)!
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.tableName) as? TableDataCell
        
        if cell == nil {
            cell = TableDataCell(bmobSchema: self.schema)
        }
        
        cell!.object = self.queryResult![indexPath.row]
        
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return TableDataCell.bestHeightWith(self.schema)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
           
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! TableDataCell
            let obj = cell.object
            
            obj?.deleteInBackgroundWithBlock({ (isSuccessful, error) -> Void in
                if isSuccessful {
                     NSLog("Delete OK")
                    self.loadALlData()
                }else{
                    print(error.description)
                }
            })
            
        case .Insert:
            NSLog("Insert");
        default:
            NSLog("Default")
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = AddAndEditDataController(bmSchema: self.schema,bmobject: self.queryResult[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
