# GymWorkoutManager V1.0
[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action) 
[![Build Status](https://www.bitrise.io/app/525c553aef64bd02.svg?token=BasjApmM7Nb3N5gSzhjYYw&branch=master)](https://www.bitrise.io/app/525c553aef64bd02)
[![Swift 2.1](https://img.shields.io/badge/Swift-2.1-orange.svg?style=flat)](https://developer.apple.com/swift/) 
[![Build Status](https://travis-ci.org/NZSwift/GymWorkoutManager.svg?branch=master)](https://travis-ci.org/NZSwift/GymWorkoutManager)
[![codebeat badge](https://codebeat.co/badges/74638e53-fc92-4a28-bf68-2f7f883e011d)](https://codebeat.co/projects/github-com-nzswift-gymworkoutmanager) [![Issues](https://img.shields.io/github/issues/NZSwift/GymWorkoutManager.svg?style=flat
)](https://github.com/NZSwift/GymWorkoutManager/issues?state=open) [![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)

##Introduction
**Gym Workout Manager** is a personal exercise recorder application coded by Swift language. User could use it as a helper/mentor during the workout, and record all the workout information to analysis the effectiveness of their workout.

##Structure
######Functionality
* Timer
	* HIIT Workout Timer.
	* Weight Training Timer.
* Record
	* Display user information.
	* Display execrise records.
* Personal Information
	* BMI
	* BMR
	* Self info upload.
* Analysis
	* Graphs of the period execrise analysis.
	* Give tips/advice about what should be improved for smash/closer to your goal.
* Help
	* Give brief explaination about how the app works.
	* what's those stand for and whats those name means such as `BMR` & `BMI`
	
* Self Challenge
	* Note: this function may develop on future version, since we cant solve the server issue atm.
	* `¯\_(ツ)_/¯`

######Frame Tree
![Alt text](http://g.gravizo.com/g?
  digraph G {
    aize ="4,4";
    main [shape=box]; Timer [shape=box]; Personal_Information [shape=box]; Cardio [shape=box]; Analysis [shape=box]; Record [shape=box];
    main -> Timer;
    main -> Personal_Information [style=bold];
    main -> Record;
    main -> Analysis;
    Analysis -> Graphic_data_display [style=dotted];
    Analysis -> Table_data_display [style=dotted];
    main -> Cardio;
    Cardio -> Running [style=dotted];
    Personal_Information -> User_Information [style=dotted];
    Personal_Information -> User_BMI_BMR_Record [style=dotted];
    Personal_Information -> Calender_Plan_record [style=dotted];
    Calender_Plan_record -> RealmDB[style=dotted,label="WriteIn"];
    Calender_Plan_record -> Server_Notification[style=dotted];
    Server_Notification -> Calender_Plan_record;
    Timer -> HitTimer[style=dotted];
    SetTimer -> Timer[style=dotted];
    node [shape=box,style=filled,color=".7 .3 1.0"];
    edge [color=red];
    HitTimer -> SetTimer[style=dotted];
    HitTimer -> Claim[style=dotted];
    Claim -> RealmDB[style=dotted,label="WriteIn"];
    User_Information -> CC [style=dotted];
    User_BMI_BMR_Record -> CC[style=dotted];
    Running -> MapTracking[style=dotted];
    MapTracking -> RealmDB[style=dotted,label="WriteIn"];
    CC[label = "Collection & Calculation"];
    RealmDB [shape=box,style=filled,color= green];
    Server_Notification [shape=box,style=filled,color= green];
    CC -> RealmDB [style=dotted,label="WriteIn"];
    edge [color=green];
    RealmDB -> Record[label="ReadOut"];
    RealmDB -> Analysis[label="ReadOut"];
  }
)
 - Note: 
  	- box -> Controller
 	- circle -> View
 	- box(colored) -> Model

##Framework
* See Podfile

##ChangeLog
* Please Checkout [here](https://github.com/NZSwift/GymWorkoutManager/wiki)

##Acknowledgements
Contributor|Github|Version
-------------|-------------|-------------
GL|[gl-Lei](https://github.com/gl-Lei)| iOS
Yunchen Zhang|[zyunchen](https://github.com/zyunchen)| iOS
XiaoYao |[xyjwsj](https://github.com/xyjwsj)| iOS
