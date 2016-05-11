//
//  RecordViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 18/01/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import UIKit
import RealmSwift

class RecordViewController: UITableViewController {
    var totalRecord = ["1","2","3"]
    var result : Results<Exercise>!
    //
    
    func addRecord(item:String, time:String){
        let item = ""
        let time = ""
        totalRecord.append("you have been doing\n\(item)\n\(time)")
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return result.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let pictureCell = self.tableView.dequeueReusableCellWithIdentifier("picture", forIndexPath: indexPath)
           // pictureCell.backgroundColor = UIColor.redColor()
            return pictureCell
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("contentCell", forIndexPath: indexPath)
            let content = result[indexPath.row]
            // TODO: correct content text
            cell.textLabel?.text = "\(content.date)---\(content.exerciseName) \(content.reps) reps \(content.set) sets "
            cell.textLabel?.textColor = cell.tintColor
            cell.textLabel?.numberOfLines = totalRecord[indexPath.row].characters.count
            return cell
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 153
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        do {
            let r = try Realm()
            result = r.objects(Exercise)
            tableView.reloadData()
        } catch {
            print("loading realm faild")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

