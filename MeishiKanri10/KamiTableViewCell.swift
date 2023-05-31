//
//  KamiTableViewCell.swift
//  MeishiKanri10
//
//  Created by 酒井健輔 on 2023/04/01.
//

import UIKit

class KamiTableViewCell: UITableViewCell {

    @IBOutlet weak var cellKamiBiko: UILabel!
    @IBOutlet weak var cellKamiName: UILabel!
    @IBOutlet weak var btKamiBatsu: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btKamiBatsu.tintColor = Color.Palette.Red
        cellKamiBiko.textColor = .black
        cellKamiName.textColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
