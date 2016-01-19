//
//  FirstViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 18/01/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, TimeSetupViewControllerDelegate {
    // MARK: - Variables
    var receivedTime : String = ""
    
    var startRuningTime = NSTimeInterval()
    var startCountdownTime = NSTimeInterval()
    var timerRuning = NSTimer()
    var timerCountdown = NSTimer()
    // MARK: - IBOutlets
    
    @IBOutlet var repeatTimer: UILabel!
    @IBOutlet var totalWorkoutTimer: UILabel!
    @IBOutlet var aroundNumber: UILabel!
    @IBAction func startButton(sender: AnyObject) {
        timerRuning = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("timeRuning"), userInfo: nil, repeats: true)
        startRuningTime = NSDate.timeIntervalSinceReferenceDate()
        print(NSDate(timeIntervalSinceReferenceDate: startRuningTime))

        timerCountdown = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("timeCountdown"), userInfo: nil, repeats: true)
        startCountdownTime = NSDate().timeIntervalSinceNow
        
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
        let dateFormatter = NSDateFormatter();
        
        dateFormatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("mm:ss:zzZ", options: 0, locale: NSLocale.currentLocale())
        
        let haha = dateFormatter.dateFromString(repeatTimer.text!)

        let cTime = NSDate().timeIntervalSinceDate(haha!)
        
        
        var elapsedTime: NSTimeInterval = cTime + startCountdownTime
        
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime += (NSTimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        elapsedTime += NSTimeInterval(seconds)
        let fraction = UInt8(elapsedTime * 100)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        self.repeatTimer.text = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
    
    // MARK: - TimeSetUpViewControllerDelegate
    
    func timeSetupFinish(timeSetupViewController: TimeSetupViewController, result: [String]) {
        self.receivedTime = self.timeString(result)
        self.repeatTimer.text = self.timeString(result)
        self.aroundNumber.text = result[3]
    }
    
    // MARK: - Private Method
    private func timeDate(time: [String]) -> NSDate {
        let numberFormatter = NSNumberFormatter();
        
        let repeatString = String.init(format: "%02d:%02d:%02d", numberFormatter.numberFromString(time[0])!.longValue, numberFormatter.numberFromString(time[1])!.longValue,numberFormatter.numberFromString(time[2])!.longValue)
        
        let dateFormatter = NSDateFormatter();
        
        dateFormatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("mm:ss:zz", options: 0, locale: NSLocale.currentLocale())
        return dateFormatter.dateFromString(repeatString)!
    }
    
    private func timeString(time: [String]) -> String {
        let numberFormatter = NSNumberFormatter();
        return String.init(format: "%02d:%02d:%02d", numberFormatter.numberFromString(time[0])!.longValue, numberFormatter.numberFromString(time[1])!.longValue, numberFormatter.numberFromString(time[2])!.longValue)
    }
    
    private func timeString(timeDate: NSDate) -> String {
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("mm:ss:zz", options: 0, locale: NSLocale.currentLocale())
        return dateFormatter.stringFromDate(timeDate)
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
    
    // MARK: - PrepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "setTime" {
            let destinationViewController = segue.destinationViewController as! TimeSetupViewController
            destinationViewController.delegate = self;
        }
    }
}