//
//  AppDelegate.swift
//  FifaWorldCup
//
//  Created by Pardeep on 29/06/19.
//  Copyright © 2019 Pardeep. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var arrMatchList : [MatchSections] = []
    var spinner : UIActivityIndicatorView?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.getSchedule()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @objc static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //MARK: - Global Functions
    func getSchedule(){
        self.startLoading()
        Alamofire.request(URL.init(string: "https://fifa-women-s-worldcup.firebaseio.com/list.json")!).responseJSON { (response) in
            
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
                        
                        arrMatches.sort(by: { $0.mTimeStemp > $1.mTimeStemp })
                        let matchSectionItem = MatchSections.init(sesionName: sectionDict["section"] as! String, matches: arrMatches)
                        self.arrMatchList.append(matchSectionItem)
                    }
                    
                    //Sort Matches According to Date
                    self.arrMatchList.sort(by: { ($0.matches.max(by: { $0.mTimeStemp > $1.mTimeStemp }))!.mTimeStemp > ($1.matches.max(by: { $0.mTimeStemp > $1.mTimeStemp }))!.mTimeStemp })
                    NotificationCenter.default.post(name: Notification.Name.init("Did_Get_Schedules"), object: nil)
                }
            case .failure( _):
                print("Faild")
            }
            
            self.stopLoading()
        }
    }
    
    func getDisplayDate(timeStemp : Double) -> String{
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "dd LLL yyyy hh:mm a"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        return dateFormatter.string(from: Date.init(timeIntervalSince1970: timeStemp))
    }
    
    func startLoading(){
        
        spinner = UIActivityIndicatorView(frame: CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height)) as UIActivityIndicatorView
        spinner?.style = UIActivityIndicatorView.Style.whiteLarge
        spinner?.backgroundColor = .black
        spinner?.alpha = 0.75
        spinner?.startAnimating()
        window?.rootViewController?.view.addSubview(spinner!)
    }
    
    func stopLoading(){
        spinner?.stopAnimating()
        spinner?.removeFromSuperview()
    }
    
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
    
    
    func unSubscribedMatchId(matchId: String){
        var arrSub = self.subscribeMatchIds
        if arrSub.contains(matchId) {
            arrSub.removeAll(where: { $0 == matchId })
        }
        self.subscribeMatchIds = arrSub
    }
    
}

