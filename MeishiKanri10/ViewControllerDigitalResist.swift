//
//  ViewControllerDigitalResist.swift
//  MeishiKanri10
//
//  Created by 酒井健輔 on 2023/03/25.
//

import UIKit
import CoreNFC

class ViewControllerDigitalResist: UIViewController, UITextFieldDelegate, NFCNDEFReaderSessionDelegate {


    @IBOutlet weak var labelBiko: UILabel!
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var textfName: UITextField!
    @IBOutlet weak var textfBiko: UITextField!
    
    
    @IBOutlet weak var btDigitalResist: UIButton!
    @IBOutlet weak var btDigitalCancel: UIButton!
    
    var NFC_session: NFCNDEFReaderSession?
    var textName: String?
    var textUri: String?
    var textBiko: String?
    
    
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("error:\(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("messages:\(messages.debugDescription)")
        
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { timer in
                //NFC読み取りの表示を消す
                session.invalidate()
            }
        }
        
        
        if let record = messages.first?.records.first{
            switch record.typeNameFormat{
            case .absoluteURI:
                print("absoluteURI")
                break
            case .empty:
                print("empty")
                break
            case .media:
                print("media")
                break
            case .nfcExternal:
                print("nfcExternal")
                break
            case .nfcWellKnown:
                print("nfcWellKnown")
                //読み込んだデータがURLだった場合
                if let url = record.wellKnownTypeURIPayload(){
                    print(url)
                    textUri = url.absoluteString
                }
                
                //読み込んだデータがテキストの場合
                if let text0 = record.wellKnownTypeTextPayload().0,let text1 = record.wellKnownTypeTextPayload().1{
                    //アラートで表示、text0にはString、text1にはLocaleが入る
                    let ac = UIAlertController(title: "NFC読み取り結果：Text", message: "テキスト：\(text0)\n location:\(text1)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default ))
                    DispatchQueue.main.async {
                        self.present(ac, animated: true)
                    }
                }
                
                break
            case .unchanged:
                print("unchanged")
                break
            case .unknown:
                print("unknown")
                break
            default:
                break
            }
            
        }else{
            print("noMessage")
        }
        
        insertUri()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfName.delegate = self
        textfBiko.delegate = self
        

        DispatchQueue.main.async {
            self.btDigitalResist.tintColor = Color.Palette.DigitalMeishiButton
            self.btDigitalResist.setTitleColor(Color.Palette.Black, for: .normal)
            
            self.btDigitalCancel.tintColor = Color.Palette.DigitalMeishiButton
            self.btDigitalCancel.setTitleColor(Color.Palette.Black, for: .normal)
            
            self.labelBiko.textColor = .black
            self.labelName.textColor = .black
            
            self.textfName.textColor = .black
            self.textfName.attributedPlaceholder = NSAttributedString(string: "名前", attributes:[NSAttributedString.Key.foregroundColor : UIColor.gray])
            self.textfName.setUnderLine()
            
            self.textfBiko.textColor = .black
            self.textfBiko.attributedPlaceholder = NSAttributedString(string: "備考", attributes:[NSAttributedString.Key.foregroundColor : UIColor.gray])
            self.textfBiko.setUnderLine()
        }
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func onClickDigitalResist(_ sender: Any) {
        
        //NFC読み取り対象機種か確認
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Error",
                message: "本端末はMFCに対応していません",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }

        //NFC読み取り用のインスタンス取得＋delegateにセット
        NFC_session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        if let session = NFC_session{
            session.alertMessage = "スキャン中"
            //beginで読み取り画面が開く
            session.begin()
        }
        
        //DBService.shared.dropTable()
        textName = textfName.text!
        textBiko = textfBiko.text!

    }
    

    @IBAction func inputBikoDigital(_ sender: Any) {
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
    
    func insertUri(){
        //DB関連
        let (oldsuccess, olderrorMessage, oldcount) = DBService.shared.getUriCount()
        
        if oldsuccess {
            var oldid = oldcount + 1
            
            let uri1 = Uri(id: oldid, name: textName!, uritext: textUri!, biko: textBiko!)
            
            print(uri1)
            
            if DBService.shared.insertUriDB(uri: uri1) {
                print("Insert success")
                print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
            } else {
                print("Insert Failed")
            }
            
        }else{
            print(olderrorMessage as Any)
        }
        
        DispatchQueue.main.sync {
            self.performSegue(withIdentifier: "toDigitalTop", sender: nil)
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

