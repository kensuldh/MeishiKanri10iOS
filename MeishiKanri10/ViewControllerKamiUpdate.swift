//
//  ViewControllerKamiUpdate.swift
//  MeishiKanri10
//
//  Created by 酒井健輔 on 2023/04/13.
//

import UIKit

class ViewControllerKamiUpdate: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var labelNameKamiUp: UILabel!
    @IBOutlet weak var labelBikoKamiUp: UILabel!
    
    @IBOutlet weak var imagevKamiMeishiUp: UIImageView!
    
    @IBOutlet weak var textfNameKamiUp: UITextField!
    @IBOutlet weak var textfBikoKamiUp: UITextField!
    
    @IBOutlet weak var btKamiUpdate: UIButton!
    @IBOutlet weak var btKamiUpCancel: UIButton!
    
    var recvKamiID:Int!
    var updateUri:Uri!
    
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textfNameKamiUp.delegate = self
        textfBikoKamiUp.delegate = self

        btKamiUpdate.tintColor = Color.Palette.KamiMeishiButton
        btKamiUpdate.setTitleColor(Color.Palette.Black, for: .normal)
        
        btKamiUpCancel.tintColor = Color.Palette.KamiMeishiButton
        btKamiUpCancel.setTitleColor(Color.Palette.Black, for: .normal)
        
        // スクリーンの縦横サイズを取得
        let screenWidth:CGFloat = view.frame.size.width
        let screenHeight:CGFloat = view.frame.size.height
        
        let(success, errorMessage, uri) = DBServiceKami.shared.getUriDB(ID: recvKamiID)
        print(uri)
        
        updateUri = uri
        
        textfNameKamiUp.text = uri?.Name
        textfBikoKamiUp.text = uri?.Biko

        let filePath = uri!.UriText
        let fileURL = URL(fileURLWithPath: filePath)
        
        // 画像をファイルから読み込み
        if let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
            let image = UIImage(data: data)
            let width:Double = 305
            let height:Double = 255
            var resizedSize = CGSize(width: 0, height: 0)
            
            if image!.size.width > image!.size.height{
                let aspectScale = image!.size.height / image!.size.width
                resizedSize = CGSize(width: width, height: width * Double(aspectScale))
            }else{
                let aspectScale = image!.size.width / image!.size.height
                resizedSize = CGSize(width: height * Double(aspectScale), height: height)
            }
            
            UIGraphicsBeginImageContext(resizedSize)
            image!.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            imageView = UIImageView(image: resizedImage)
            
            // 画像の中心を画面の中心に設定
            imageView.center = CGPoint(x:screenWidth/2, y:screenHeight/2)
            imageView.backgroundColor = UIColor.white
            view.addSubview(imageView)
        }
        
        imagevKamiMeishiUp = imageView
        // Do any additional setup after loading the view.
    }
    
    func getFileURL(fileName: String) -> URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent(fileName)
    }
    
    @IBAction func onClickKamiUpdate(_ sender: Any) {
        
        updateUri.Name = textfNameKamiUp.text!
        updateUri.Biko = textfBikoKamiUp.text!
        
        DBServiceKami.shared.updateUriDB(meishi: updateUri)
        print("UpdateUriDB!")
        self.performSegue(withIdentifier: "toKamiTopfromUpdate", sender: nil)
    }

    @IBAction func inputBikoKamiUp(_ sender: Any) {
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
