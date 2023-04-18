//
//  ViewControllerKamiResist.swift
//  MeishiKanri10
//
//  Created by 酒井健輔 on 2023/04/01.
//

import UIKit
import Photos

class ViewControllerKamiResist: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var labelNameKami: UILabel!
    @IBOutlet weak var labelBikoKami: UILabel!
    
    
    @IBOutlet weak var textfNameKami: UITextField!
    @IBOutlet weak var textfBikoKami: UITextField!
    
    
    @IBOutlet weak var btKamiResist: UIButton!
    @IBOutlet weak var btKamiCancel: UIButton!
    
    @IBOutlet weak var imagevKamiMeishi: UIImageView!
    
    var meishiURL:URL!
    
    var recvImage:UIImage? = nil
    var recvAsset:PHAsset!
    
    var photoAssets:PHAsset? = nil // フォトライブラリ保持用
    
    
    
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
        
//                print(recvAsset as Any)
//                let filename = recvAsset.value(forKey: "filename")
//                print("filename",filename as Any)
//                print("\(recvAsset.pixelWidth) x \(recvAsset.pixelHeight)")
//
//                getUrl(asset: recvAsset) { (url: URL) in
//                    print("obj: \(String(describing: self.recvAsset))")
//                    print("url: \(url)")
//                    self.meishiURL = url
//                    //DBへの保存処理
//                    let (oldsuccess, olderrorMessage, oldcount) = DBServiceKami.shared.getUriCount()
//
//                    if oldsuccess {
//                        let oldid = oldcount + 1
//                        let uri1 = Uri(id: oldid, name: self.textfNameKami.text!, uritext: self.meishiURL.absoluteString, biko: self.textfBikoKami.text!)
//
//                        print(uri1)
//
//                        if DBServiceKami.shared.insertUriDB(meishi: uri1) {
//                            print("Insert success")
//                            print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
//                        } else {
//                            print("Insert Failed")
//                        }
//                    }else{
//                        print(olderrorMessage as Any)
//                    }
        
        let dt = Date()
        let dateFormatter = DateFormatter()

        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
         
        /// 変換フォーマット定義（未設定の場合は自動フォーマットが採用される）
        dateFormatter.dateFormat = "yyyyMdHms"
        
        print(dateFormatter.string(from: dt))
        let fileName = dateFormatter.string(from: dt)
        let fileURL = getFileURL(fileName: "\(fileName).jpg")
        
        guard let imageData = imagevKamiMeishi.image?.jpegData(compressionQuality: 1.0) else {
            return
        }
        do {
            try imageData.write(to: getFileURL(fileName: "\(fileName).jpg"))
            print("Image saved.")
        } catch {
            print("Failed to save the image:", error)
        }
        
        let path = getFileURL(fileName: "\(fileName).jpg").path
        
        //DBへの保存処理
        let (oldsuccess, olderrorMessage, oldcount) = DBServiceKami.shared.getUriCount()

        if oldsuccess {
            let oldid = oldcount + 1
            let uri1 = Uri(id: oldid, name: self.textfNameKami.text!, uritext: path, biko: self.textfBikoKami.text!)

            print(uri1)

            if DBServiceKami.shared.insertUriDB(meishi: uri1) {
                print("Insert success")
                print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
            } else {
                print("Insert Failed")
            }
        }else{
            print(olderrorMessage as Any)
        }
        
        self.performSegue(withIdentifier: "toKamiTop", sender: nil)
    }
    
    //写真をカメラロールに保存
    
    
    
    
//}
    
    
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
    
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("失敗：\(error)")
        } else {
            print("写真の保存に成功したよ")
        }
    }

    
    func getUrl(asset: PHAsset, completion: @escaping (URL) -> Void) {
        switch asset.mediaType {
        case .image:
            let options = PHContentEditingInputRequestOptions()
            asset.requestContentEditingInput(with: options) { (contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) in
                completion(contentEditingInput!.fullSizeImageURL!)
            }
        case .video:
            let options = PHVideoRequestOptions()
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) in
                let urlAsset = asset as! AVURLAsset
                completion(urlAsset.url)
            }
        default:
            break
        }
    }
    
    func getFileURL(fileName: String) -> URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent(fileName)
    }
}
