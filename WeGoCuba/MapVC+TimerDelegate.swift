//
//  MapVC+TimerDelegate.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/5/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation

extension MapViewController: MapIsInactiveDelegate {
    
    func startTimer() {
        if isTimerRunning == false {
            runTimer()
        }
    }
    
    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        
        isTimerRunning = true
        routeController.isTimerRunning = true
    }
    
    func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            if navigationInProgress {
                locationMarker.focus()
            }
            routeController.isTimerRunning = false
        } else {
            
            seconds -= 1
        }
    }
    
    func resetTimer() {
        timer.invalidate()
        seconds = 5
        
        isTimerRunning = false
    }
}
