//
//  ViewController.swift
//  MeishiKanri10
//
//  Created by 酒井健輔 on 2023/03/19.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var btDigitalMeishi: UIButton!
    @IBOutlet weak var btKamiMeishi: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Run")
        
        btDigitalMeishi.tintColor = Color.Palette.DigitalMeishiButton
        btDigitalMeishi.setTitleColor(Color.Palette.Black, for: .normal)
        
        btKamiMeishi.tintColor = Color.Palette.KamiMeishiButton
        btKamiMeishi.setTitleColor(Color.Palette.Black, for: .normal)
        
        
        
    }


}

