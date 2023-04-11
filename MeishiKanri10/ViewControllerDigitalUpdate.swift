//
//  ViewControllerDigitalUpdate.swift
//  MeishiKanri10
//
//  Created by 酒井健輔 on 2023/04/12.
//

import UIKit

class ViewControllerDigitalUpdate: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var labelNameDigitalUp: UILabel!
    @IBOutlet weak var labelBikoDigitalUp: UILabel!
    @IBOutlet weak var labelUriDigitalUp: UILabel!
    @IBOutlet weak var labelUritextDigitalUp: UILabel!
    
    @IBOutlet weak var textfNameDigitalUp: UITextField!
    @IBOutlet weak var textfBikoDigitalUp: UITextField!
    
    @IBOutlet weak var btDigitalUpdate: UIButton!
    @IBOutlet weak var btDigitalUpCancel: UIButton!
    
    var recvDigitalID:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textfNameDigitalUp.delegate = self
        textfBikoDigitalUp.delegate = self

        btDigitalUpdate.tintColor = Color.Palette.DigitalMeishiButton
        btDigitalUpdate.setTitleColor(Color.Palette.Black, for: .normal)
        
        btDigitalUpCancel.tintColor = Color.Palette.DigitalMeishiButton
        btDigitalUpCancel.setTitleColor(Color.Palette.Black, for: .normal)
        
        
        let(success, errorMessage, uri) = DBService.shared.getUriDB(ID: recvDigitalID)
        print(uri)
        
        textfNameDigitalUp.text = uri?.Name
        textfBikoDigitalUp.text = uri?.Biko
        labelUritextDigitalUp.text = uri?.UriText
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickDigitalUpdate(_ sender: Any) {
        
        
        
    }
    
    
    @IBAction func inputBikoDigitalUp(_ sender: Any) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 今フォーカスが当たっているテキストボックスからフォーカスを外す
        textField.resignFirstResponder()
        // 次のTag番号を持っているテキストボックスがあれば、フォーカスする
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        }
        return true
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
