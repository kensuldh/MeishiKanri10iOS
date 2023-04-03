//
//  ViewControllerKamiResist.swift
//  MeishiKanri10
//
//  Created by 酒井健輔 on 2023/04/01.
//

import UIKit

class ViewControllerKamiResist: UIViewController {

    @IBOutlet weak var labelNameKami: UILabel!
    @IBOutlet weak var labelBikoKami: UILabel!
    
    @IBOutlet weak var textfName: UITextField!
    @IBOutlet weak var textfBiko: UITextField!
    
    @IBOutlet weak var btKamiResist: UIButton!
    @IBOutlet weak var btKamiCancel: UIButton!

    @IBOutlet weak var imagevKamiMeishi: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btKamiResist.tintColor = Color.Palette.KamiMeishiButton
        btKamiResist.setTitleColor(Color.Palette.Black, for: .normal)
        
        btKamiCancel.tintColor = Color.Palette.KamiMeishiButton
        btKamiCancel.setTitleColor(Color.Palette.Black, for: .normal)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickKamiResist(_ sender: Any) {
        let (oldsuccess, olderrorMessage, oldcount) = DBService.shared.getUriCount()
        
        var oldid = oldcount + 1
        
        let uri1 = Uri(id: oldid, name: textfName.text!, uritext: "https://lit.link", biko: textfBiko.text!)
        
        print(uri1)
        
        if DBServiceKami.shared.insertUriDB(meishi: uri1) {
            print("Insert success")
            print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
        } else {
            print("Insert Failed")
        }
        
        self.performSegue(withIdentifier: "toKamiTop", sender: nil)
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
