//
//  ViewController.swift
//  FifaWorldCup
//
//  Created by Pardeep on 29/06/19.
//  Copyright © 2019 Pardeep. All rights reserved.
//

import UIKit
import WatchConnectivity

//MARK: -
class ViewController: UIViewController, WCSessionDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblList : UITableView!
    @IBOutlet weak var lblNoGames : UILabel!
    
    var arrSubscribedMatches : [String] = PrefrenceManager.sharedPrefrenceInstance.subscribeMatchIds
    
    //MARK: - UIViewcontroller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObservers()
        self.registerCustomCells()
        self.setupWatchConnectivity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tblList.reloadData()
    }
    
    //MARK: - Setups
    
    func registerCustomCells(){
        tblList.register(UINib.init(nibName: "MatchTVC", bundle: nil), forCellReuseIdentifier: "MatchTVC")
    }
    
    func setupWatchConnectivity(){
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
    }
    
    //MARK: - UIButton Actions
    @IBAction func subscribeUnSubscribeAction(_ sender: UIButton){
        
        let section = (sender.tag)/1000;
        let row = (sender.tag)%1000;
        let matchItem = AppDelegate.shared.arrMatchList[section].matches[row]
        if arrSubscribedMatches.contains(matchItem.mMatchId){
            PrefrenceManager.sharedPrefrenceInstance.unSubscribedMatchId(matchId: matchItem.mMatchId)
        }else{
            arrSubscribedMatches.append(matchItem.mMatchId)
            PrefrenceManager.sharedPrefrenceInstance.subscribeMatchIds = arrSubscribedMatches
        }
        
        arrSubscribedMatches = PrefrenceManager.sharedPrefrenceInstance.subscribeMatchIds
        self.sendMessageToWatch(message: ["SubscribedMatched" : arrSubscribedMatches])
        tblList.reloadData()
    }
    
    func sendMessageToWatch(message : [String : Any]){
        if WCSession.default.isReachable{
            WCSession.default.sendMessage(message, replyHandler: nil) { (error) in
                print(error)
            }
        }else{
            
        }
    }
    
    //MARK: - UITableview Datasources and Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return AppDelegate.shared.arrMatchList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate.shared.arrMatchList[section].matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MatchTVC = tableView.dequeueReusableCell(withIdentifier: "MatchTVC") as! MatchTVC
        
        cell.selectionStyle = .none
        
        let matchItem = AppDelegate.shared.arrMatchList[indexPath.section].matches[indexPath.row]
        
        cell.lblDate.text = matchItem.mDate
        cell.lblStadium.text = matchItem.mStadium
        cell.lblCity.text = matchItem.mCity
        cell.lblMatchNumber.text = matchItem.mMatchNumber
        
        cell.team1ImageView.image = UIImage.init(named: matchItem.mTeam1Flag)
        cell.team2ImageView.image = UIImage.init(named: matchItem.mTeam2Flag)
        
        cell.btnSubUnSub.addTarget(self, action: #selector(subscribeUnSubscribeAction(_:)), for: .touchUpInside)
        
        cell.btnSubUnSub.tag = indexPath.section * 1000 + indexPath.row;
        
        cell.btnSubUnSub.setTitle(arrSubscribedMatches.contains(matchItem.mMatchId) ? "Unsubscribe" : "Subscribe", for: .normal)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AppDelegate.shared.arrMatchList[section].sesionName
    }
    
    //MARK: - WCSession Delegates
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session Activate")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    //MARK: - NSNotifications
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(didGetSchedules), name: Notification.Name.init("Did_Get_Schedules"), object: nil)
    }
    
    @objc func didGetSchedules(){
        self.tblList.reloadData()
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
