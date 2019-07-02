//
//  MatchTVC.swift
//  FifaWorldCup
//
//  Created by Pardeep on 01/07/19.
//  Copyright © 2019 Pardeep. All rights reserved.
//

import UIKit

class MatchTVC: UITableViewCell {
    
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var lblStadium : UILabel!
    @IBOutlet weak var lblCity : UILabel!
    @IBOutlet weak var lblMatchNumber : UILabel!
    
    @IBOutlet weak var team1ImageView : UIImageView!
    @IBOutlet weak var team2ImageView : UIImageView!
    
    @IBOutlet weak var btnSubUnSub : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
