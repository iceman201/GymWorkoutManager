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
    var receivedTime : [String] = []
    var time: NSDate = NSDate()
    
    var startRuningTime = NSTimeInterval()
    var timerRuning = NSTimer()
    var timerCountdown = NSTimer()

    
    @IBAction func counter(sender: AnyObject) {
        if startButton.currentTitle != "Stop" {
            startButton.setTitle("Stop", forState: .Normal)
            timerCountdown = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("timeCountdown"), userInfo: nil, repeats: true)
            timerRuning = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("timeRuning"), userInfo: nil, repeats: true)
            startRuningTime = NSDate.timeIntervalSinceReferenceDate()
        } else {
            startButton.setTitle("GO!", forState: .Normal)
            timerCountdown.invalidate()
            timerRuning.invalidate()
        }
        
    }
    
    func timeRuning() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime: NSTimeInterval = currentTime - startRuningTime
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        let fraction = UInt8(elapsedTime * 100)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        self.totalWorkoutTimer.text = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    
    func timeCountdown() {
        self.time = self.time.dateByAddingTimeInterval(-0.01)
        self.repeatTimer.text = self.timeString(self.time).stringByReplacingOccurrencesOfString(".", withString: ":")
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TimeSetUpViewControllerDelegate
    
    func timeSetupFinish(timeSetupViewController: TimeSetupViewController, result: [String]) {
        self.receivedTime = result
        self.time = self.timeDate(result)
        self.repeatTimer.text = self.timeString(result).stringByReplacingOccurrencesOfString(".", withString: ":")
        self.aroundNumber.text = result[2]
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