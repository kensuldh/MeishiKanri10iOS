//
//  ViewControllerKamiResist.swift
//  MeishiKanri10
//
//  Created by 酒井健輔 on 2023/04/01.
//

import UIKit

class ViewControllerKamiResist: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var labelNameKami: UILabel!
    @IBOutlet weak var labelBikoKami: UILabel!
    
    
    @IBOutlet weak var textfNameKami: UITextField!
    @IBOutlet weak var textfBikoKami: UITextField!
    
    
    @IBOutlet weak var btKamiResist: UIButton!
    @IBOutlet weak var btKamiCancel: UIButton!
    
    @IBOutlet weak var imagevKamiMeishi: UIImageView!
    
    
    var recvImage:UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfNameKami.delegate = self
        textfBikoKami.delegate = self
        

        btKamiResist.tintColor = Color.Palette.KamiMeishiButton
        btKamiResist.setTitleColor(Color.Palette.Black, for: .normal)
        
        btKamiCancel.tintColor = Color.Palette.KamiMeishiButton
        btKamiCancel.setTitleColor(Color.Palette.Black, for: .normal)
        
        imagevKamiMeishi.image = recvImage
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickKamiResist(_ sender: Any) {
        
        //写真をカメラロールに保存
        guard let image = imagevKamiMeishi.image else {
                print("画像がないよ")
                return
            }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        
        //DBへの保存処理
        let (oldsuccess, olderrorMessage, oldcount) = DBServiceKami.shared.getUriCount()
        
        var oldid = oldcount + 1
        
        let uri1 = Uri(id: oldid, name: textfNameKami.text!, uritext: "https://lit.link", biko: textfBikoKami.text!)
        
        print(uri1)
        
        if DBServiceKami.shared.insertUriDB(meishi: uri1) {
            print("Insert success")
            print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
        } else {
            print("Insert Failed")
        }
        
        self.performSegue(withIdentifier: "toKamiTop", sender: nil)
    }
    
    
    @IBAction func inputBikoKami(_ sender: Any) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      //リターンキーが押された時に実行される
        // 今フォーカスが当たっているテキストボックスからフォーカスを外す
        textField.resignFirstResponder()
        // 次のTag番号を持っているテキストボックスがあれば、フォーカスする
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    @objc    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("失敗：\(error)")
        } else {
            print("写真の保存に成功したよ")
        }
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
