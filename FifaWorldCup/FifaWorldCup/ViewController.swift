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

    //MARK: - UIViewcontroller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCustomCells()
        self.setupWatchConnectivity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
     
        if WCSession.default.isReachable{
            
            let message = ["Message" : "Hello"]
            WCSession.default.sendMessage(message, replyHandler: nil) { (error) in
                print(error)
            }
            
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
        let matchItem = AppDelegate.shared.arrMatchList[indexPath.section].matches[indexPath.row]
        
        cell.lblDate.text = matchItem.mDate
        cell.lblAddress.text = matchItem.mAddress
        cell.lblMatchNumber.text = matchItem.mMatchNumber
        
        cell.btnSubUnSub.addTarget(self, action: #selector(subscribeUnSubscribeAction(_:)), for: .touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    //MARK: - WCSession Delegates
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}

struct MatchSections {
    var sesionName : String = ""
    var matches : [Match] = []
    
}


struct Match {
    var mDate : String = ""
    var mAddress : String = ""
    var mMatchNumber : String = ""
    var mLatitude : Double = 0.0
    var mLongitude : Double = 0.0
}
