//
//  FriendlyTips.swift
//  Simple Scheduler
//
//  Created by Alan Li on 10/24/18.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import Foundation

struct FriendlyTip {

    struct Defaults {
        static let array = [callMom, trimFingernails, meditation, drinkWater, exercise]

        static let callMom = FriendlyTip(motivationText: StringStore.FriendlyTips.callMom,
                                         taskName: "Call Mom",
                                         taskTime: 10)
        static let trimFingernails = FriendlyTip(motivationText: StringStore.FriendlyTips.trimFingernails,
                                         taskName: "Trim fingernails",
                                         taskTime: 5)
        static let meditation = FriendlyTip(motivationText: StringStore.FriendlyTips.meditation,
                                            taskName: "Meditate",
                                            taskTime: 20)
        static let drinkWater = FriendlyTip(motivationText: StringStore.FriendlyTips.drinkWater,
                                            taskName: "Drink water",
                                            taskTime: 3)
        static let exercise = FriendlyTip(motivationText: StringStore.FriendlyTips.exercise,
                                          taskName: "Workout!!!",
                                          taskTime: 60)
    }

    let motivationText: String
    let taskName: String
    let taskTime: Int
}
