//
//  FirstViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 18/01/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import UIKit

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

    
    @IBAction func counter(sender: AnyObject) {
        if startButton.currentTitle != "Stop" {
            startButton.setTitle("Stop", forState: .Normal)
            timerCountdown = NSTimer.scheduledTimerWithTimeInterval(millisecond, target: self, selector: Selector("timeCountdown"), userInfo: nil, repeats: true)
        } else {
            startButton.setTitle("GO!", forState: .Normal)
            timerCountdown.invalidate()
        }
    }
    
    func timeCountdown() {
        if round == "0" {
            repeatTimer.text = "00:00:00"
            startButton.setTitle("GO!", forState: UIControlState.Normal)
            timerCountdown.invalidate()
            timerRuning.invalidate()
            
        } else if timeString(time) == "00:00.00" {
            time = timeDate(receivedTime)
            round = String(NSNumberFormatter().numberFromString(round)!.intValue - 1)
            repeatTimer.text = timeString(time)
            aroundNumber.text = round
            
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
        self.time = timeDate(result)
        self.totalTime = timeDate(["0", "0", "0"])
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
    }
}