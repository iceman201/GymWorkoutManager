# GymWorkoutManager V1.0
[![Swift 2.1](https://img.shields.io/badge/Swift-2.1-orange.svg?style=flat)](https://developer.apple.com/swift/) [![](https://travis-ci.org/CBoostSwift/GymWorkoutManager.svg?branch=master)](https://travis-ci.org/NZSwift/GymWorkoutManager.svg?branch=master)
[![Language: Swift](https://img.shields.io/badge/language-swift-orange.svg)](https://github.com/CBoostSwift/GymWorkoutManager)
[![GitHub version](https://badge.fury.io/gh/CBoostSwift%2FGymWorkoutManager.svg)](https://badge.fury.io/gh/CBoostSwift%2FGymWorkoutManager)
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
    main [shape=box];
    main -> Timer [weight=8];
    main -> Personal Information [style=bold,label="TabBarVC"];
    Personal Information -> User Information [style=dotted];
    Personal Information -> User BMI&BMR Record [style=dotted];
    main -> Analysis;
  }
)

##Framework
* See Podfile

##ChangeLog
* Please Checkout [here](https://github.com/NZSwift/GymWorkoutManager/wiki)

##License

##Acknowledgements
Contributor|Github
-------------|-------------
GL|[gl-Lei](https://github.com/gl-Lei)
Rita|[jiting71](https://github.com/jiting71)
GrandKai|[GrandKai](https://github.com/GrandKai)
