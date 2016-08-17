//
//  FirstViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 18/01/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation
import RealmSwift


class TimerViewController: UIViewController, TimeSetupViewControllerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet var repeatTimer: UILabel!
    @IBOutlet var totalWorkoutTimer: UILabel!
    @IBOutlet var aroundNumber: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet weak var workoutType: UISegmentedControl!
    
    // MARK: - Variables
    let MILLI_SECOND = 0.01
    var receivedTime : [String] = ["0", "0", "0"]
    var time : NSDate = NSDate()
    var totalTime : NSDate = NSDate()
    var timerCountdown : NSTimer = NSTimer()
    var round = "0"
    var startRound = "0"
    var audioPlayer = AVAudioPlayer()
    var curentUser: Person?
    
    @IBAction func reset(sender: AnyObject) {
        self.totalTime = timeDate(["0", "0", "0"])
        round = "0"
        startRound = "0"
        aroundNumber.text = "0"
        repeatTimer.text = "00:00:00"
        stopTimeCountDown()
    }
    
    @IBAction func startButton(sender: AnyObject) {
        if round == "0" {
            // must have a round to start, warn users with alert
            let alert = UIAlertController(title: "Message", message: "Must set time first", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        guard workoutType.selectedSegmentIndex != -1 else {
            let alert = UIAlertController(title: "Message", message: "Please select your workout type.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if startButton.currentTitle != "Stop" {
            startButton.setTitle("Stop", forState: .Normal)
            timerCountdown = NSTimer.scheduledTimerWithTimeInterval(MILLI_SECOND, target: self, selector: #selector(TimerViewController.timeCountdown), userInfo: nil, repeats: true)
        } else {
            stopTimeCountDown()
        }
    }
    
    
    @objc private func claimRecord(sender: AnyObject) {
        //TODO: claim with workout type
        guard workoutType.selectedSegmentIndex != -1 else {
            let alert = UIAlertController(title: "oops!", message: "Please select which exercise you have done.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let alert = UIAlertController(title: "Record Claim", message: "Which execirse you did today", preferredStyle: .Alert)

        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Execirse"
        }
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField) in
            textField.keyboardType = .NumberPad
            textField.placeholder = "reps"
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) in
            let execriseNameTextField = alert.textFields![0] as UITextField
            let repsTextField = alert.textFields![1] as UITextField
            let newExecrise = Exercise()
            let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
            self.curentUser = cusers?.first
            if self.curentUser == nil{
                self.curentUser = Person()
            }
            
            guard let localUser = self.curentUser else {
                return
            }
            if repsTextField.text == "" {
                repsTextField.text = "0"
            }
            
            DatabaseHelper.sharedInstance.beginTransaction()
            newExecrise.set = self.startRound ?? "0"
            newExecrise.times = self.totalWorkoutTimer.text ?? "None"
            newExecrise.reps = repsTextField.text ?? "0"
            newExecrise.exerciseName = execriseNameTextField.text ?? "None"
            newExecrise.date = self.getDate()
            newExecrise.workoutType = self.workoutType.selectedSegmentIndex
            localUser.exercise.append(newExecrise)
            DatabaseHelper.sharedInstance.commitTransaction()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func getDate() -> String {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month,.Year], fromDate: date)
        let day = components.day
        let month = components.month
        let year = components.year
        let formater = "\(day)/\(month)/\(year)"
        return formater
    }
    
    func timeCountdown() {
        if round == "0" {
            // this means rounds up, there comes the end.
            playEffectSound("Done_total_set", type: "mp3")
            repeatTimer.text = "00:00:00"
            stopTimeCountDown()
            return
        }
        
        if timeString(time) == "00:00.00" {
            //this means time up, there comes a end.
            playEffectSound("Done", type: "mp3")
            time = timeDate(receivedTime)
            round = String(NSNumberFormatter().numberFromString(round)!.intValue - 1)
            repeatTimer.text = timeString(time)
            aroundNumber.text = round
            stopTimeCountDown()
        } else {
            //Continue counting down.
            time = time.dateByAddingTimeInterval(-MILLI_SECOND)
            totalTime = totalTime.dateByAddingTimeInterval(MILLI_SECOND)
            repeatTimer.text = self.timeString(time).stringByReplacingOccurrencesOfString(".", withString: ":")
            totalWorkoutTimer.text = self.timeString(totalTime).stringByReplacingOccurrencesOfString(".", withString: ":")
        }
    }
    
    private func stopTimeCountDown(){
        startButton.setTitle("GO!", forState: .Normal)
        timerCountdown.invalidate()
    }
    
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Timer"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Record", style: .Plain, target: self, action: #selector(claimRecord))

        startButton.layer.cornerRadius = 16
        startButton.layer.borderWidth = 1
        print(Realm.Configuration.defaultConfiguration.fileURL)
        self.time = timeDate(receivedTime)
        self.totalTime = timeDate(receivedTime)
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            self.view.transform = CGAffineTransformMakeScale(0.85, 0.85)
        }
    }
    
    // MARK: - TimeSetUpViewControllerDelegate
    
    func timeSetupFinish(timeSetupViewController: TimeSetupViewController, result: [String]) {
        self.receivedTime = result
        self.round = result[2]
        self.startRound = round
        self.time = timeDate(result)
        self.repeatTimer.text = self.timeString(result).stringByReplacingOccurrencesOfString(".", withString: ":")
        self.totalWorkoutTimer.text = self.timeString(totalTime).stringByReplacingOccurrencesOfString(".", withString: ":")
        self.aroundNumber.text = round
    }
    
    // MARK: - Private Method
    private func timeDate(time: [String]) -> NSDate {
        let numberFormatter = NSNumberFormatter();
        let repeatString = String.init(format: "%02d:%02d.00", numberFormatter.numberFromString(time[0])!.longValue, numberFormatter.numberFromString(time[1])!.longValue)
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("mm:ss.SS", options: 0, locale: NSLocale.currentLocale())
        return dateFormatter.dateFromString(repeatString)!
    }

    private func timeString(time: [String]) -> String {
        let numberFormatter = NSNumberFormatter();
        return String.init(format: "%02d:%02d.00", numberFormatter.numberFromString(time[0])!.longValue, numberFormatter.numberFromString(time[1])!.longValue)
    }
    
    private func timeString(timeDate: NSDate) -> String {
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("mm:ss.SS", options: 0, locale: NSLocale.currentLocale())
        return dateFormatter.stringFromDate(timeDate)
    }
    
    // MARK: - PrepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "setTime" {
            let destinationViewController = segue.destinationViewController as! TimeSetupViewController
            destinationViewController.delegate = self;
        }
        if segue.identifier == "" {
            
        }
    }
    
    func playEffectSound(name:String,type:String){
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType:type)!)
        audioPlayer = try! AVAudioPlayer(contentsOfURL: alertSound, fileTypeHint: nil)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
}