//
//  Scheduler.swift
//  Activity Logger
//
//  Created by HIDENORI MATSUKI on 2019/08/11.
//  Copyright © 2019 Hidenori Matsuki. All rights reserved.
//

import Foundation

extension Scheduler {
    private static var instance: Scheduler?
    static var main: Scheduler {
        if instance == nil {
            instance = Scheduler()
        }
        return instance!
    }
}

struct Scheduler {
    private let serialQueue = DispatchQueue(
        label: "\(Bundle.main.infoDictionary?["CFBundleIdentifier"] as! String).scheduler"
    )
    private let timer = DispatchSource.makeTimerSource(
        flags: [],
        queue: DispatchQueue.global(qos: .background))
    private var intervalMinutes = 15
    private var repeating: DispatchTimeInterval {
        return DispatchTimeInterval.seconds(intervalMinutes * 60)
    }
    private var nextDeadline: DispatchTime {
        let dateComponent = Calendar.current.dateComponents(
            [
                Calendar.Component.minute,
                Calendar.Component.second,
            ],
            from: Date())
        let current = (minute: dateComponent.minute ?? 0, second: dateComponent.second ?? 0)
        let exceeded = (minute: current.minute % intervalMinutes, second: current.second)
        let diffMinutes: Int = intervalMinutes - exceeded.minute
        let diffSeconds: Double = Double(diffMinutes * 60 - exceeded.second)
        
        let now = DispatchTime.now()
        let aligned = now + diffSeconds
        return aligned
    }
    var running: Bool = false {
        didSet {
            if running {
                serialQueue.sync {
                    prepareTimer()
                    timer.resume()
                }
            } else {
                serialQueue.sync {
                    timer.suspend()
                }
            }
        }
    }
    
    var handler: () -> Void = {
        #if DEBUG
        NSLog("empty hander called")
        #endif
    }
    
    private func prepareTimer() {
        timer.schedule(deadline: nextDeadline, repeating: repeating)
        timer.setEventHandler {
            self.handler()
        }
    }
    
    private init() {
        #if DEBUG
        intervalMinutes = 2
        #endif
    }
}
