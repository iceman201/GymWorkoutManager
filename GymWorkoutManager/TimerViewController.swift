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
    var time : Date = Date()
    var totalTime : Date = Date()
    var timerCountdown : Timer = Timer()
    var round = "0"
    var startRound = "0"
    var audioPlayer = AVAudioPlayer()
    var curentUser: Person?
    
    @IBAction func reset(_ sender: AnyObject) {
        self.totalTime = CountingTimer.shareTimer.timeDate(["0", "0", "0"])
        round = "0"
        startRound = "0"
        aroundNumber.text = "0"
        repeatTimer.text = "00:00:00"
        stopTimeCountDown()
    }
    
    @IBAction func startButton(_ sender: AnyObject) {
        if round == "0" {
            // must have a round to start, warn users with alert
            let alert = UIAlertController(title: "Message", message: "Must set time first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard workoutType.selectedSegmentIndex != -1 else {
            let alert = UIAlertController(title: "Message", message: "Please select your workout type.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if startButton.currentTitle != "Stop" {
            startButton.setTitle("Stop", for: UIControl.State())
            timerCountdown = Timer.scheduledTimer(timeInterval: MILLI_SECOND, target: self, selector: #selector(TimerViewController.timeCountdown), userInfo: nil, repeats: true)
        } else {
            stopTimeCountDown()
        }
    }
    
    
    @objc private func claimRecord(_ sender: AnyObject) {
        //TODO: claim with workout type
        guard workoutType.selectedSegmentIndex != -1 else {
            let alert = UIAlertController(title: "oops!", message: "Please select which exercise you have done.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let alert = UIAlertController(title: "Record Claim", message: "Which execirse you did today", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Execirse"
        }
        alert.addTextField { (textField:UITextField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "reps"
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
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
            if execriseNameTextField.text?.isEmpty == true {
                execriseNameTextField.text = "None"
            }
            if repsTextField.text == "" {
                repsTextField.text = "0"
            }
            
            DatabaseHelper.sharedInstance.beginTransaction()
            newExecrise.set = self.startRound 
            newExecrise.times = self.totalWorkoutTimer.text ?? "None"
            newExecrise.reps = repsTextField.text ?? "0"
            newExecrise.exerciseName = execriseNameTextField.text ?? "None"
            newExecrise.date = CountingTimer.shareTimer.getDate()
            newExecrise.workoutType = self.workoutType.selectedSegmentIndex
            localUser.exercise.append(newExecrise)
            DatabaseHelper.sharedInstance.commitTransaction()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @objc private func timeCountdown() {
        if round == "0" {
            // this means rounds up, there comes the end.
            AudioServicesPlaySystemSound (1016)
            repeatTimer.text = "00:00:00"
            stopTimeCountDown()
            return
        }
        
        if CountingTimer.shareTimer.timeDateString(time) == "00:00.00" {//date
            //this means time up, there comes a end.
            AudioServicesPlaySystemSound (1016)
            time = CountingTimer.shareTimer.timeDate(receivedTime)
            round = String(NumberFormatter().number(from: round)!.int32Value - 1)
            repeatTimer.text = CountingTimer.shareTimer.timeDateString(time)//date
            aroundNumber.text = round
            stopTimeCountDown()
        } else {
            //Continue counting down.
            time = time.addingTimeInterval(-MILLI_SECOND)
            totalTime = totalTime.addingTimeInterval(MILLI_SECOND)
            repeatTimer.text = CountingTimer.shareTimer.timeDateString(time).replacingOccurrences(of: ".", with: ":")//date
            totalWorkoutTimer.text = CountingTimer.shareTimer.timeDateString(totalTime).replacingOccurrences(of: ".", with: ":")//date
        }
    }
    
    fileprivate func stopTimeCountDown(){
        startButton.setTitle("GO!", for: UIControl.State())
        timerCountdown.invalidate()
    }
    
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Timer"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: self, action: #selector(claimRecord))

        startButton.layer.cornerRadius = 16
        startButton.layer.borderWidth = 1
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
        self.time = CountingTimer.shareTimer.timeDate(receivedTime)
        self.totalTime = CountingTimer.shareTimer.timeDate(receivedTime)
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            self.view.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }
    }
    
    // MARK: - TimeSetUpViewControllerDelegate
    
    func timeSetupFinish(_ timeSetupViewController: TimeSetupViewController, result: [String]) {
        self.receivedTime = result
        self.round = result[2]
        self.startRound = round
        self.time = CountingTimer.shareTimer.timeDate(result)
        self.repeatTimer.text = CountingTimer.shareTimer.timeString(result).replacingOccurrences(of: ".", with: ":")//string
        self.totalWorkoutTimer.text = CountingTimer.shareTimer.timeDateString(totalTime).replacingOccurrences(of: ".", with: ":")//date
        self.aroundNumber.text = round
    }
    

    
    // MARK: - PrepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setTime" {
            let destinationViewController = segue.destination as! TimeSetupViewController
            destinationViewController.delegate = self;
        }
        if segue.identifier == "" {
            
        }
    }
}
