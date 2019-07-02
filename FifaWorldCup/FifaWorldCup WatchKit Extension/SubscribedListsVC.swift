//
//  SubscribedListsVC.swift
//  FifaWorldCup WatchKit Extension
//
//  Created by Pardeep on 01/07/19.
//  Copyright © 2019 Pardeep. All rights reserved.
//

import UIKit
import WatchKit

class SubscribedListsVC: WKInterfaceController {
    
    @IBOutlet weak var tblSubscribedSchedule : WKInterfaceTable!
    @IBOutlet weak var lblNoSubscribed : WKInterfaceLabel!
   
    var arrAllSchedules : [MatchSections] = []
    var arrSubscribedSchedules : [Match] = []
    var arrSubscribedMatchIds : [String] = PrefrenceManager.sharedPrefrenceInstance.subscribeMatchIds
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        arrAllSchedules = context as! [MatchSections]
        self.addObservers()
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.getSubscribedSchedules()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //MARK: - Setups
    func getSubscribedSchedules(){
        
        arrSubscribedSchedules.removeAll()
        for sessionItem in arrAllSchedules{
            for matchItem in sessionItem.matches{
                if arrSubscribedMatchIds.contains(matchItem.mMatchId){
                    arrSubscribedSchedules.append(matchItem)
                }
            }
        }
        
        lblNoSubscribed.setHidden(true)
        if arrSubscribedSchedules.count == 0{
            lblNoSubscribed.setHidden(false);
        }
        
        self.setupTableView()
        
    }
    
    //MARK: - Setup TableView
    func setupTableView(){
        
        tblSubscribedSchedule.setNumberOfRows(arrSubscribedSchedules.count, withRowType: "ScheduleRowType")
        
        for i in 0..<arrSubscribedSchedules.count{
            
            if let row = tblSubscribedSchedule.rowController(at: i) as? ScheduleRow{
                let matchItem = arrSubscribedSchedules[i]
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
        NotificationCenter.default.addObserver(self, selector: #selector(didGetSchedules), name: Notification.Name.init("Did_Get_Schedules"), object: nil)
    }
    
    @objc func didGetSchedules(notification: Notification){
        if let arrTempSessions = notification.object as? [MatchSections]{
            arrAllSchedules = arrTempSessions
        }
        arrSubscribedMatchIds = PrefrenceManager.sharedPrefrenceInstance.subscribeMatchIds
        self.getSubscribedSchedules()
    }
    
    
}
