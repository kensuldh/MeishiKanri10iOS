//
//  ViewControllerDigitalResist.swift
//  MeishiKanri10
//
//  Created by 酒井健輔 on 2023/03/25.
//

import UIKit

class ViewControllerDigitalResist: UIViewController {

    @IBOutlet weak var labelBiko: UILabel!
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var textfName: UITextField!
    @IBOutlet weak var textfBiko: UITextField!
    
    
    @IBOutlet weak var btDigitalResist: UIButton!
    @IBOutlet weak var btDigitalCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btDigitalResist.tintColor = Color.Palette.DigitalMeishiButton
        btDigitalResist.setTitleColor(Color.Palette.Black, for: .normal)
        
        btDigitalCancel.tintColor = Color.Palette.DigitalMeishiButton
        btDigitalCancel.setTitleColor(Color.Palette.Black, for: .normal)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickDigitalResist(_ sender: Any) {
        let (oldsuccess, olderrorMessage, oldcount) = DBService.shared.getUriCount()
        
        var oldid = oldcount + 1
        
        let uri1 = Uri(id: oldid, name: textfName.text!, uritext: "https://lit.link", biko: textfBiko.text!)
        
        print(uri1)
        
        if DBService.shared.insertUriDB(uri: uri1) {
            print("Insert success")
            print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
        } else {
            print("Insert Failed")
        }
        
        self.performSegue(withIdentifier: "toDigitalTop", sender: nil)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
