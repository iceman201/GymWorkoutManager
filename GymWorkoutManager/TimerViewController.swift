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
        self.totalTime = timeDate(["0", "0", "0"])
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
            startButton.setTitle("Stop", for: UIControlState())
            timerCountdown = Timer.scheduledTimer(timeInterval: MILLI_SECOND, target: self, selector: #selector(TimerViewController.timeCountdown), userInfo: nil, repeats: true)
        } else {
            stopTimeCountDown()
        }
    }
    
    
    @objc fileprivate func claimRecord(_ sender: AnyObject) {
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
            if repsTextField.text == "" {
                repsTextField.text = "0"
            }
            
            DatabaseHelper.sharedInstance.beginTransaction()
            newExecrise.set = self.startRound 
            newExecrise.times = self.totalWorkoutTimer.text ?? "None"
            newExecrise.reps = repsTextField.text ?? "0"
            newExecrise.exerciseName = execriseNameTextField.text ?? "None"
            newExecrise.date = self.getDate()
            newExecrise.workoutType = self.workoutType.selectedSegmentIndex
            localUser.exercise.append(newExecrise)
            DatabaseHelper.sharedInstance.commitTransaction()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func getDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day, .month,.year], from: date)
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
            round = String(NumberFormatter().number(from: round)!.int32Value - 1)
            repeatTimer.text = timeString(time)
            aroundNumber.text = round
            stopTimeCountDown()
        } else {
            //Continue counting down.
            time = time.addingTimeInterval(-MILLI_SECOND)
            totalTime = totalTime.addingTimeInterval(MILLI_SECOND)
            repeatTimer.text = self.timeString(time).replacingOccurrences(of: ".", with: ":")
            totalWorkoutTimer.text = self.timeString(totalTime).replacingOccurrences(of: ".", with: ":")
        }
    }
    
    fileprivate func stopTimeCountDown(){
        startButton.setTitle("GO!", for: UIControlState())
        timerCountdown.invalidate()
    }
    
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Timer"
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: self, action: #selector(claimRecord))

        startButton.layer.cornerRadius = 16
        startButton.layer.borderWidth = 1
        print(Realm.Configuration.defaultConfiguration.fileURL)
        self.time = timeDate(receivedTime)
        self.totalTime = timeDate(receivedTime)
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            self.view.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }
    }
    
    // MARK: - TimeSetUpViewControllerDelegate
    
    func timeSetupFinish(_ timeSetupViewController: TimeSetupViewController, result: [String]) {
        self.receivedTime = result
        self.round = result[2]
        self.startRound = round
        self.time = timeDate(result)
        self.repeatTimer.text = self.timeString(result).replacingOccurrences(of: ".", with: ":")
        self.totalWorkoutTimer.text = self.timeString(totalTime).replacingOccurrences(of: ".", with: ":")
        self.aroundNumber.text = round
    }
    
    // MARK: - Private Method
    fileprivate func timeDate(_ time: [String]) -> Date {
        let numberFormatter = NumberFormatter();
        let repeatString = String.init(format: "%02d:%02d.00", numberFormatter.number(from: time[0])!.intValue, numberFormatter.number(from: time[1])!.intValue)
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "mm:ss.SS", options: 0, locale: Locale.current)
        return dateFormatter.date(from: repeatString)!
    }

    fileprivate func timeString(_ time: [String]) -> String {
        let numberFormatter = NumberFormatter();
        return String.init(format: "%02d:%02d.00", numberFormatter.number(from: time[0])!.intValue, numberFormatter.number(from: time[1])!.intValue)
    }
    
    fileprivate func timeString(_ timeDate: Date) -> String {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "mm:ss.SS", options: 0, locale: Locale.current)
        return dateFormatter.string(from: timeDate)
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
    
    func playEffectSound(_ name:String,type:String){
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType:type)!)
        audioPlayer = try! AVAudioPlayer(contentsOf: alertSound, fileTypeHint: nil)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
}
