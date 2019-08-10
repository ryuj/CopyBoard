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
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        load()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    
    func load() {
        let ud = UserDefaults.standard;
        let tmp = ud.value(forKey: SAVE_KEY);
        print("tmp:\(tmp)");
        if (tmp != nil) {
            let val : String = tmp as! String
            print("val:\(val)");
            
            let ary:Array = val.components(separatedBy: ",")
            print("ary:\(ary)");
            objects = ary;
        }
    }
    
    // MARK: -

    func insertNewObject(_ text: String) {
        objects.insert(text, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        
        save(text)
    }
    
    func save(_ text: String) {
        let ud = UserDefaults.standard
        
        let str :String = objects.joined(separator: ",")
        ud.set(str, forKey:SAVE_KEY)
        ud.synchronize()
    }
    
    @objc func didTapAdd(_ sender: AnyObject) {
        showAlert(sender);
    }
    
    func showAlert(_ sender: AnyObject) {
        let alert:UIAlertController = UIAlertController(title: "保存したい単語を入力せよ", message: "", preferredStyle: UIAlertController.Style.alert);
        let cancel:UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil);
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
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
        
        alert.addTextField { (field:UITextField) in
//            field.placeholder = "Input text for copy and paste";
        }
        
        present(alert, animated: true, completion: {
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let text = objects[indexPath.row]
        cell.textLabel!.text = text
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = objects[indexPath.row];
        let pasteboard = UIPasteboard.general
        pasteboard.string = text;
        
        tableView.deselectRow(at: indexPath, animated: true);
    }


}

