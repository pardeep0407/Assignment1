//
//  InterfaceController.swift
//  FifaWorldCup WatchKit Extension
//
//  Created by Pardeep on 29/06/19.
//  Copyright © 2019 Pardeep. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import Alamofire

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var arrMatchList : [MatchSections] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.getSchedule()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //MARK: - UIButton Actions
    @IBAction func scheduleAction(_ sender: WKInterfaceButton){
        pushController(withName: "ScheduleListsVC", context: arrMatchList)
    }
    
    @IBAction func subscribedAction(_ sender: WKInterfaceButton){
        pushController(withName: "SubscribedListsVC", context: arrMatchList)
    }
    
    //MARK: - WCSession Delegates
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        WKInterfaceDevice().play(.notification)
        if let subscribedMatchIds = message["SubscribedMatched"] as? [String]{
            print(subscribedMatchIds)
            PrefrenceManager.sharedPrefrenceInstance.subscribeMatchIds = subscribedMatchIds
            NotificationCenter.default.post(name: Notification.Name.init("Did_Get_Schedules"), object: nil)
        }
    }
    
    //MARK: - WebServices
    
    func getSchedule(){
        
        do{
            var request = try URLRequest.init(url: URL.init(string: "https://fifa-women-s-worldcup.firebaseio.com/list.json")!, method: .get)
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
            Alamofire.request(request).responseJSON { (response) in
                switch response.result
                {
                case .success:
                    print("Sucess")
                    //Parse Api Response
                    if let jsonResult = response.value as? NSArray{
                        print(jsonResult)
                        
                        self.arrMatchList.removeAll()
                        
                        for matchSectionDict in jsonResult{
                            
                            let sectionDict = matchSectionDict as! NSDictionary
                            
                            var arrMatches : [Match] = []
                            for matchDict in sectionDict["matches"] as! NSArray{
                                
                                let mDict = matchDict as! NSDictionary
                                
                                let timeStemp = mDict["date"] as! Double
                                let mDisplayDate = self.getDisplayDate(timeStemp: timeStemp)
                                
                                let matchItem = Match.init(
                                    mMatchId : mDict["matchId"] as! String,
                                    mTimeStemp : timeStemp,
                                    mDate: mDisplayDate,
                                    mStadium: mDict["stadium"] as! String,
                                    mCity: mDict["city"] as! String,
                                    mMatchNumber: mDict["match"] as! String,
                                    mLatitude: mDict["latitude"] as! Double,
                                    mLongitude: mDict["longitude"] as! Double,
                                    mTeam1: mDict["team1"] as! String,
                                    mTeam2: mDict["team2"] as! String,
                                    mTeam1Flag: mDict["team1Flag"] as! String,
                                    mTeam2Flag: mDict["team2Flag"] as! String)
                                
                                arrMatches.append(matchItem)
                            }
                            
                            let matchSectionItem = MatchSections.init(sesionName: sectionDict["section"] as! String, matches: arrMatches)
                            self.arrMatchList.append(matchSectionItem)
                            
                            NotificationCenter.default.post(name: Notification.Name.init("Did_Get_Schedules"), object: self.arrMatchList)
                            
                        }
                    }
                case .failure( _):
                    print("Faild")
                }
                
            }
            
        }catch{
            print("Error")
        }
    }
    
    func getDisplayDate(timeStemp : Double) -> String{
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "dd LLL yyyy hh:mm a"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        return dateFormatter.string(from: Date.init(timeIntervalSince1970: timeStemp))
    }
    
    
}


struct MatchSections {
    var sesionName : String = ""
    var matches : [Match] = []
    
}


struct Match {
    var mMatchId : String = ""
    var mTimeStemp : Double = 0.0
    var mDate : String = ""
    var mStadium : String = ""
    var mCity : String = ""
    var mMatchNumber : String = ""
    var mLatitude : Double = 0.0
    var mLongitude : Double = 0.0
    var mTeam1 : String = ""
    var mTeam2 : String = ""
    var mTeam1Flag : String = ""
    var mTeam2Flag : String = ""
}

class PrefrenceManager : NSObject {
    
    static let sharedPrefrenceInstance: PrefrenceManager = {
        let instance = PrefrenceManager()
        return instance
    } ()
    
    var subscribeMatchIds : [String] {
        get{
            if let arrSub = UserDefaults.standard.array(forKey: "Subscribed_Matched") as? [String]{
                return arrSub
            }
            return []
        }set{
            UserDefaults.standard.set(newValue, forKey: "Subscribed_Matched")
        }
    }
}
