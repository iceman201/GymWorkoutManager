//
//  PlannerViewController.swift
//  GymWorkoutManager
//
//  Created by zhangyunchen on 16/5/24.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit
import CVCalendar
import RealmSwift

class PlannerViewController: UIViewController,CVCalendarMenuViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var setPlan: UIButton!
    
    var selectedDay:String?
    var results :Results<(Plan)>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setPlan.backgroundColor = GWMColorPurple
        setPlan.tintColor = GWMColorYellow
        
        selectedDay = calendarView.presentedDate.commonDescription
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Planner"
        do {
            let r = try Realm()
            results = r.objects(Plan)
            calendarView.contentController.refreshPresentedMonth()
        } catch {
            print("loading realm faild")
        }

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "setPlan" {
            let destinationVC = segue.destinationViewController as! SetPlanViewController
            if let selectedDay = selectedDay {
                destinationVC.updateplan = nil
                if let results = results{
                    for result in results {
                        if selectedDay == result.date {
                            destinationVC.updateplan = result
                        }
                    }
                }
                destinationVC.date = selectedDay
            }
        }
    }
    

}

//MARK: Implemente of CAValendarViewDelegate

extension PlannerViewController:CVCalendarViewDelegate {
   
    func presentationMode() -> CalendarMode {
        return CalendarMode.MonthView
    }
    
    func firstWeekday() -> Weekday {
        return Weekday.Monday
    }
    
    func didSelectDayView(dayView: DayView, animationDidFinish: Bool){
        selectedDay = dayView.date.commonDescription
    }
    
    
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        let π = M_PI
        
        let ringSpacing: CGFloat = 4.0
        let ringInsetWidth: CGFloat = 1.0
        let ringVerticalOffset: CGFloat = 1.0
        var ringLayer: CAShapeLayer!
        let ringLineWidth: CGFloat = 2.0
        let ringLineColour: UIColor = GWMColorPurple
        
        let newView = UIView(frame: dayView.bounds)
        
        let diameter: CGFloat = (newView.bounds.width) - ringSpacing
        let radius: CGFloat = diameter / 2.0
        
        let rect = CGRectMake(newView.frame.midX-radius, newView.frame.midY-radius-ringVerticalOffset, diameter, diameter)
        
        ringLayer = CAShapeLayer()
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.CGColor
        
        let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
        let ringRect: CGRect = CGRectInset(rect, ringLineWidthInset, ringLineWidthInset)
        let centrePoint: CGPoint = CGPointMake(ringRect.midX, ringRect.midY)
        let startAngle: CGFloat = CGFloat(-π/2.0)
        let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
        let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        ringLayer.path = ringPath.CGPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        
        guard let results = results else {
            return false
        }
        
        for result in results {
            if dayView.date == nil {
                print("date is nil  and this is a bug????")
                return false
            }
            if dayView.date.commonDescription == result.date {
                return true
            }
        }
        
        return false
        
    }

    
    

}
