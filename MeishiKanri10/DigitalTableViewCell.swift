//
//  DigitalTableViewCell.swift
//  MeishiKanri10
//
//  Created by 酒井健輔 on 2023/03/25.
//

import UIKit

class DigitalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBiko: UILabel!
    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var btDigitalBatsu: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btDigitalBatsu.tintColor = Color.Palette.Red
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  
    
    
}
