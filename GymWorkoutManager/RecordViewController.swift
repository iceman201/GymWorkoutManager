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
            let infoCell = self.tableView.dequeueReusableCellWithIdentifier("picture", forIndexPath: indexPath) as! RecordInfoCell
            infoCell.age.text = "1"
            infoCell.activeDay.text = "3"
            infoCell.effectiveIndex.text = "0.3"
            infoCell.name.text = "Liguo Jiao"
            infoCell.profileImage.image = UIImage(named: "Icon-60@2x.png")
            return infoCell
        } else {
            let recordCell = self.tableView.dequeueReusableCellWithIdentifier("contentCell", forIndexPath: indexPath)
            let content = result[indexPath.row]
            // TODO: correct content text
            recordCell.textLabel?.text = "\(content.date)---\(content.exerciseName) \(content.reps) reps \(content.set) sets "
            recordCell.textLabel?.textColor = recordCell.tintColor
            recordCell.textLabel?.numberOfLines = totalRecord[indexPath.row].characters.count
            return recordCell
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 183
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
        self.edgesForExtendedLayout=UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
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

