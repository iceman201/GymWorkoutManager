//
//  FirstViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 18/01/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import UIKit
import ChameleonFramework
import AudioToolbox
import AVFoundation
import RealmSwift


class FirstViewController: UIViewController, TimeSetupViewControllerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet var repeatTimer: UILabel!
    @IBOutlet var totalWorkoutTimer: UILabel!
    @IBOutlet var aroundNumber: UILabel!
    @IBOutlet var startButton: UIButton!
    
    // MARK: - Variables
    let millisecond = 0.01
    var receivedTime : [String] = ["0", "0", "0"]
    var time : NSDate = NSDate()
    var totalTime : NSDate = NSDate()
    var timerRuning : NSTimer = NSTimer()
    var timerCountdown : NSTimer = NSTimer()
    var round = "0"
    var startRound = "0"
    var audioPlayer = AVAudioPlayer()
    var fromReset : Bool = false
    
    @IBAction func reset(sender: AnyObject) {
        self.totalTime = timeDate(["0", "0", "0"])
        round = "0"
        startRound = "0"
        aroundNumber.text = "0"
        fromReset = true
        timeCountdown()
    }
    
    @IBAction func counter(sender: AnyObject) {
        if startButton.currentTitle != "Stop" {
            startButton.setTitle("Stop", forState: .Normal)
            timerCountdown = NSTimer.scheduledTimerWithTimeInterval(millisecond, target: self, selector: #selector(FirstViewController.timeCountdown), userInfo: nil, repeats: true)
        } else {
            startButton.setTitle("GO!", forState: .Normal)
            timerCountdown.invalidate()
        }
    }
    
    @IBAction func claimRecord(sender: AnyObject) {
        let alert = UIAlertController(title: "Record Claim", message: "Which execirse you did today", preferredStyle: .Alert)
        let newExecrise = Exercise()

        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Execirse"
        }
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField) in
            textField.placeholder = "reps"
            newExecrise.reps = textField.text ?? "None"
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) in
            let execriseNameTextField = alert.textFields![0] as UITextField
            let repsTextField = alert.textFields![1] as UITextField

            newExecrise.set = self.startRound ?? "None"
            newExecrise.times = self.totalWorkoutTimer.text ?? "None"
            newExecrise.reps = repsTextField.text ?? ""
            newExecrise.exerciseName = execriseNameTextField.text ?? ""
            do {
                let r = try Realm()
                try r.write({
                    r.add(newExecrise)
                })
            } catch {
                print("Realm write")
                //TODO: Rollbar??? or some error monitor tools
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    func timeCountdown() {
        if round == "0" {
            let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Done_total_set", ofType: "mp3")!)
            repeatTimer.text = "00:00:00"
            startButton.setTitle("GO!", forState: UIControlState.Normal)
            timerCountdown.invalidate()
            timerRuning.invalidate()
            if !fromReset {
                audioPlayer = try! AVAudioPlayer(contentsOfURL: alertSound, fileTypeHint: nil)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
        } else if timeString(time) == "00:00.00" {
            if round != "0" {
                let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Done", ofType: "mp3")!)
                audioPlayer = try! AVAudioPlayer(contentsOfURL: alertSound, fileTypeHint: nil)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
            time = timeDate(receivedTime)
            round = String(NSNumberFormatter().numberFromString(round)!.intValue - 1)
            repeatTimer.text = timeString(time)
            aroundNumber.text = round
            self.repeatTimer.text = self.timeString(self.time)
            self.aroundNumber.text = self.round
            if self.round != "0" {
                self.startButton .sendActionsForControlEvents(UIControlEvents.TouchUpInside)
            }
        } else {
            time = time.dateByAddingTimeInterval(-millisecond)
            totalTime = totalTime.dateByAddingTimeInterval(millisecond)
            repeatTimer.text = self.timeString(time).stringByReplacingOccurrencesOfString(".", withString: ":")
            totalWorkoutTimer.text = self.timeString(totalTime).stringByReplacingOccurrencesOfString(".", withString: ":")
        }
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 16
        startButton.layer.borderWidth = 1
        print(Realm.Configuration.defaultConfiguration.path)
        self.time = timeDate(receivedTime)
        self.totalTime = timeDate(receivedTime)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        fromReset = false
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
}