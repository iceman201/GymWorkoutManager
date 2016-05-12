# GymWorkoutManager V1.0
[![Swift 2.1](https://img.shields.io/badge/Swift-2.1-orange.svg?style=flat)](https://developer.apple.com/swift/) [![Build Status](https://travis-ci.org/NZSwift/GymWorkoutManager.svg?branch=master)](https://travis-ci.org/NZSwift/GymWorkoutManager)
[![Language: Swift](https://img.shields.io/badge/language-swift-orange.svg)](https://github.com/CBoostSwift/GymWorkoutManager)
![](http://ruby-gem-downloads-badge.herokuapp.com/)


##Introduction
**Gym Workout Manager** is a personal execrise recorder app. User could use it as a helper/mentor during the workout, and record all the workout information to analysis the effectiveness of their workout.

##Structure
###Functionality
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
* Self Challenge*
	* Note: this function may develop on future version.

###Frame Tree
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
    Cardio -> Self_Charllege [style=dotted,label="??"]; 
    Cardio -> Running [style=dotted];
    Personal_Information -> User_Information [style=dotted];
    Personal_Information -> User_BMI_BMR_Record [style=dotted];
    Timer -> HiitTimer[style=dotted];
    SetTimer -> Timer[style=dotted];
    node [shape=box,style=filled,color=".7 .3 1.0"];
    edge [color=red];
    HiitTimer -> SetTimer[style=dotted];
    HiitTimer -> Claim[style=dotted];
    Claim -> RealmDB[style=dotted,label="WriteIn"];
    User_Information -> CC [style=dotted];
    User_BMI_BMR_Record -> CC[style=dotted];
    Running -> MapTracking[style=dotted];
    MapTracking -> RealmDB[style=dotted,label="WriteIn"];
    CC[label = "Collection & Calculation"];
    RealmDB [shape=box,style=filled,color= green];
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
Contributor|Github
-------------|-------------
GL|[gl-Lei](https://github.com/gl-Lei)
Rita|[jiting71](https://github.com/jiting71)
GrandKai|[GrandKai](https://github.com/GrandKai)
