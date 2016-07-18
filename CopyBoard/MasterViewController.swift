//
//  MasterViewController.swift
//  CopyBoard
//
//  Created by 地主 龍一 on 2016/07/10.
//  Copyright © 2016年 地主 龍一. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [String]()
    
    let SAVE_KEY:String = "Value"


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        load()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(didTapAdd(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    
    func load() {
        let ud = NSUserDefaults.standardUserDefaults();
        let tmp = ud.valueForKey(SAVE_KEY);
        print("tmp:\(tmp)");
        if (tmp != nil) {
            let val : String = tmp as! String
            print("val:\(val)");
            
            let ary:Array = val.componentsSeparatedByString(",")
            print("ary:\(ary)");
            objects = ary;
        }
    }
    
    // MARK: -

    func insertNewObject(text: String) {
        objects.insert(text, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        save(text)
    }
    
    func save(text: String) {
        let ud = NSUserDefaults.standardUserDefaults()
        
        let str :String = objects.joinWithSeparator(",")
        ud.setObject(str, forKey:SAVE_KEY)
        ud.synchronize()
    }
    
    func didTapAdd(sender: AnyObject) {
        showAlert(sender);
    }
    
    func showAlert(sender: AnyObject) {
        let alert:UIAlertController = UIAlertController(title: "保存したい単語を入力せよ", message: "", preferredStyle: UIAlertControllerStyle.Alert);
        let cancel:UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel, handler: nil);
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            (action:UIAlertAction) -> Void in
            
            let fields:Array<UITextField>? = alert.textFields as Array<UITextField>?
            if fields != nil {
                for field:UITextField in fields! {
//                    print(field.text);
                    self.insertNewObject(field.text!);
                    break;
                }
            }
        });
        
        alert.addAction(cancel);
        alert.addAction(ok);
        
        alert.addTextFieldWithConfigurationHandler { (field:UITextField) in
//            field.placeholder = "Input text for copy and paste";
        }
        
        presentViewController(alert, animated: true, completion: {
            NSLog("show alert completion");
        });
    }

    // MARK: - Segues

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showDetail" {
//            let pasteboard = UIPasteboard.generalPasteboard()
//            pasteboard.setValue("コピーしたい文字列", forPasteboardType: "public.text")
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! String
//                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
//    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let text = objects[indexPath.row]
        cell.textLabel!.text = text
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let text = objects[indexPath.row];
        let pasteboard = UIPasteboard.generalPasteboard()
        pasteboard.setValue(text, forPasteboardType: "public.text")
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
    }


}

