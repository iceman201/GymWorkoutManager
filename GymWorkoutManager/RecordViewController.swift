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
    // MARK: - Variables
    var totalRecord = ["1","2","3"]
    var result : Results<Exercise>!
    var curentUser:Person?
    
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
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        curentUser = cusers?.first
        if curentUser == nil{
            curentUser = Person()
        }
        if indexPath.section == 0 {
            let infoCell = self.tableView.dequeueReusableCellWithIdentifier("picture", forIndexPath: indexPath) as! RecordInfoCell
            
            
            if let user = curentUser {
                DatabaseHelper.sharedInstance.beginTransaction()
                infoCell.activeDay.text = "\(user.activedDays)"
                infoCell.name.text = user.name
                if user.weight != "" {
                    infoCell.weight.text = user.weight + " KG"
                }
                
                if let pictureData = user.profilePicture {
                    infoCell.profileImage.image = UIImage(data: pictureData)
                }
                DatabaseHelper.sharedInstance.commitTransaction()
            }
            if let effectIndex = curentUser?.effectiveIndex {
                infoCell.effectiveIndex.text = "\(effectIndex) / 10.0"
                infoCell.effectiveIndex.textColor = GWMColorYellow
            }
            return infoCell
        } else {
            let recordCell = self.tableView.dequeueReusableCellWithIdentifier("contentCell", forIndexPath: indexPath)
            guard let user = curentUser else {
                return UITableViewCell()
            }
            
            let eachExercise = user.exercise[indexPath.row]
            recordCell.accessoryView?.frame = CGRectMake(0.0, 0.0, 22.0, 22.0)
            let image = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 22, height: 22))
            
            if eachExercise.workoutType == 0 {
                image.image = UIImage(named: "1466238314_running.png")
            } else if eachExercise.workoutType == 1 {
                image.image = UIImage(named: "1463131048_dumbbell.png")
                
            } else if eachExercise.workoutType == 2 {
                image.image = UIImage(named: "push_up-256.png")
            }
            recordCell.accessoryView = image
            recordCell.textLabel?.text = "[\(eachExercise.date)] \(eachExercise.exerciseName)"
            recordCell.detailTextLabel?.text = "   \(eachExercise.set) Sets - \(eachExercise.reps) Reps"
            recordCell.textLabel?.numberOfLines = 0
            return recordCell
        }
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            cell.backgroundColor = UIColor.clearColor()
            cell.textLabel?.textColor = GWMColorPurple
            cell.detailTextLabel?.textColor = UIColor.blackColor()
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete) {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(result[indexPath.row])
                }
            } catch let error as NSError {
                print(error)
                // TODO: need an error handling API
            }
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 183
        } else {
            return 55
        }
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.backgroundColor = GWMColorYellow
        
        self.navigationController?.navigationBar.topItem?.title = "Report"
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
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: #selector(editTable))
    }
    
    func editTable() {
        if self.tableView.editing {
            self.tableView.setEditing(false, animated: true)
        } else {
            self.tableView.setEditing(true, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

