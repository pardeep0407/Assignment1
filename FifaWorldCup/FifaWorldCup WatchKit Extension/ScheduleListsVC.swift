//
//  ScheduleListsVC.swift
//  FifaWorldCup WatchKit Extension
//
//  Created by Pardeep on 01/07/19.
//  Copyright © 2019 Pardeep. All rights reserved.
//

import UIKit
import WatchKit
import Foundation

class ScheduleListsVC: WKInterfaceController {
    
    @IBOutlet weak var tblSchedule : WKInterfaceTable!
    
    @IBOutlet weak var lblNoSchedule : WKInterfaceLabel!
    
    var arrSchedules : [MatchSections] = []

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.addObservers()
        
       arrSchedules = context as! [MatchSections]
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.setupTableView()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //MARK: - Setup TableView
    func setupTableView(){
        
        let arrMatches = arrSchedules.flatMap({ $0.matches })
        
        lblNoSchedule.setHidden(true)
        if arrMatches.count == 0 {
            lblNoSchedule.setHidden(false)
        }
        
        tblSchedule.setNumberOfRows(arrMatches.count, withRowType: "ScheduleRowType")
        
        for i in 0..<arrMatches.count{
            
            if let row = tblSchedule.rowController(at: i) as? ScheduleRow{
                let matchItem = arrMatches[i]
                row.lblStadium.setText(matchItem.mStadium)
                row.lblCity.setText(matchItem.mCity)
                row.lblDate.setText(matchItem.mDate)
                row.lblMatchNumber.setText(matchItem.mMatchNumber)
                
                row.team1Image.setImage(UIImage.init(named: matchItem.mTeam1Flag))
                row.team2Image.setImage(UIImage.init(named: matchItem.mTeam2Flag))
            }
            
        }
    }
    
    //MARK: - NSNotifications
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(didGetSchedules(notification:)), name: Notification.Name.init("Did_Get_Schedules"), object: nil)
    }
    
    @objc func didGetSchedules(notification: Notification){
        if let arrTempSessions = notification.object as? [MatchSections]{
            arrSchedules = arrTempSessions
        }
        self.setupTableView()
    }
    
}
