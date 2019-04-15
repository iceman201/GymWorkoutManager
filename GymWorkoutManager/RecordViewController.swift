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
    
    func addRecord(_ item:String, time:String){
        let item = ""
        let time = ""
        totalRecord.append("you have been doing\n\(item)\n\(time)")
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return result.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        curentUser = cusers?.first
        if curentUser == nil{
            curentUser = Person()
        }
        if (indexPath as NSIndexPath).section == 0 {
            let infoCell = self.tableView.dequeueReusableCell(withIdentifier: "picture", for: indexPath) as! RecordInfoCell
            if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
                infoCell.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            }
            if let user = curentUser {
                DatabaseHelper.sharedInstance.beginTransaction()
                infoCell.activeDay.text = "\(user.activedDays)"
                infoCell.name.text = user.name
                if user.weight != "" {
                    infoCell.weight.text = user.weight + " KG"
                } else {
                    if infoCell.name.text?.isEmpty == true {
                        infoCell.isHidden = true
                        if let messageCell = self.tableView.dequeueReusableCell(withIdentifier: "messageCell") {
                            messageCell.textLabel?.text = "Reminder:"
                            messageCell.detailTextLabel?.text = "Please enter your details on the profile page."
                            messageCell.detailTextLabel?.textColor = GWMColorYellow
                            return messageCell
                        }
                    }
                }

                if let pictureData = user.profilePicture {
                    
                    infoCell.profileImage.image = UIImage(data: pictureData as Data)
                    
                }
                DatabaseHelper.sharedInstance.commitTransaction()
            }
            if let effectIndex = curentUser?.effectiveIndex {
                infoCell.effectiveIndex.text = "\(effectIndex) / 10.0"
                infoCell.effectiveIndex.textColor = GWMColorYellow
            }
            return infoCell
        } else {
            let recordCell = self.tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath)
            if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
                recordCell.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            }
            guard let user = curentUser else {
                return UITableViewCell()
            }
            
            let eachExercise = user.exercise[(indexPath as NSIndexPath).row]
            recordCell.accessoryView?.frame = CGRect(x: 0.0, y: 0.0, width: 22.0, height: 22.0)
            let image = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 22, height: 22))
            
            if eachExercise.workoutType == 0 {
                image.image = UIImage(named: "1466238314_running.png")
                recordCell.backgroundColor = GWMPieGraphColorCardio
            } else if eachExercise.workoutType == 1 {
                image.image = UIImage(named: "1463131048_dumbbell.png")
                recordCell.backgroundColor = GWMPieGraphColorWeights
                
            } else if eachExercise.workoutType == 2 {
                image.image = UIImage(named: "push_up-256.png")
                recordCell.backgroundColor = GWMPieGraphColorHiit
            }
            
            recordCell.accessoryView = image
            recordCell.textLabel?.text = "[\(eachExercise.date)] \(eachExercise.exerciseName)"
            recordCell.detailTextLabel?.text = "   \(eachExercise.set) Sets - \(eachExercise.reps) Reps"
            recordCell.textLabel?.numberOfLines = 0
            return recordCell
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath as NSIndexPath).section == 0 {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 1 {
            cell.detailTextLabel?.textColor = UIColor.black
            cell.textLabel?.textColor = UIColor(red: 64.0/255.0, green: 224.0/255.0, blue: 208.0/255.0, alpha: 1.0)
            
        }
        cell.selectionStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(result[(indexPath as NSIndexPath).row])
                }
            } catch let error as NSError {
                print(error)
                // TODO: need an error handling API
            }
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 {
            return 183
        } else {
            return 55
        }
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
        self.view.backgroundColor = GWMColorBackground

        self.navigationController?.navigationBar.topItem?.title = "Report"
        self.edgesForExtendedLayout=UIRectEdge()
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        do {
            let r = try Realm()
            result = r.objects(Exercise.self)
            tableView.reloadData()
        } catch {
            print("loading realm faild")
        }
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTable))
    }
    
    @objc func editTable() {
        if self.tableView.isEditing {
            self.tableView.setEditing(false, animated: true)
        } else {
            self.tableView.setEditing(true, animated: true)
        }
    }
}

