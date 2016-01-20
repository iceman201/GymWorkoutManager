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
    
    @IBAction func counter(sender: AnyObject) {
        NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: Selector("timeCount"), userInfo: nil, repeats: true)
    }
    
    func timeCount() {
        self.time = self.time.dateByAddingTimeInterval(-0.001)
        self.repeatTimer.text = self.timeString(self.time)
        NSLog("time: %@", self.repeatTimer.text!)
    }
    
    // MARK: - Variables
    var receivedTime : [String] = []
    var time: NSDate = NSDate()
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TimeSetUpViewControllerDelegate
    
    func timeSetupFinish(timeSetupViewController: TimeSetupViewController, result: [String]) {
        self.receivedTime = result
        self.time = self.timeDate(result)
        self.repeatTimer.text = self.timeString(result)
        self.aroundNumber.text = result[2]
    }
    
    // MARK: - Private Method
    private func timeDate(time: [String]) -> NSDate {
        let numberFormatter = NSNumberFormatter();
        let repeatString = String.init(format: "%02d:%02d.000", numberFormatter.numberFromString(time[0])!.longValue, numberFormatter.numberFromString(time[1])!.longValue)
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("mm:ss.SSS", options: 0, locale: NSLocale.currentLocale())
        return dateFormatter.dateFromString(repeatString)!
    }

    private func timeString(time: [String]) -> String {
        let numberFormatter = NSNumberFormatter();
        return String.init(format: "%02d:%02d.000", numberFormatter.numberFromString(time[0])!.longValue, numberFormatter.numberFromString(time[1])!.longValue)
    }
    
    private func timeString(timeDate: NSDate) -> String {
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("mm:ss.SSS", options: 0, locale: NSLocale.currentLocale())
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