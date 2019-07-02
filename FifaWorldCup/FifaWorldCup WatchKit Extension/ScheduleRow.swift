//
//  ScheduleRow.swift
//  FifaWorldCup WatchKit Extension
//
//  Created by Pardeep on 01/07/19.
//  Copyright © 2019 Pardeep. All rights reserved.
//

import UIKit
import WatchKit

class ScheduleRow: NSObject {
    
    @IBOutlet weak var lblStadium : WKInterfaceLabel!
    @IBOutlet weak var lblCity : WKInterfaceLabel!
    @IBOutlet weak var lblDate : WKInterfaceLabel!
    @IBOutlet weak var lblMatchNumber : WKInterfaceLabel!
    
    @IBOutlet weak var team1Image : WKInterfaceImage!
    @IBOutlet weak var team2Image : WKInterfaceImage!

}
