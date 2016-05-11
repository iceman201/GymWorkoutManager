//
//  RecordViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 18/01/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import UIKit


class RecordViewController: UITableViewController {
    var totalRecord = ["1","2","3"]
    
    func addRecord(item:String, time:String){
        let item = ""
        let time = ""
        totalRecord.append("you have been doing\n\(item)\n\(time)")
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalRecord.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("contentCell", forIndexPath: indexPath)
        switch indexPath.section {
        case 0:
            cell.backgroundColor = UIColor.blackColor()
        case 1:
            cell.textLabel?.text = totalRecord[indexPath.row]
            cell.textLabel?.textColor = UIColor.blueColor()
            cell.textLabel?.numberOfLines = totalRecord[indexPath.row].characters.count
        default:
            break
        }
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

