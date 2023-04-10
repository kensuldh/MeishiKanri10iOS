//
//  ViewControllerKamiTop.swift
//  MeishiKanri10
//
//  Created by 酒井健輔 on 2023/03/21.
//

import UIKit
import AVFoundation
import Photos

class ViewControllerKamiTop: UIViewController,UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var btToCamScreen: UIButton!
    
    @IBOutlet weak var btBackKamiTop: UIButton!
    
    @IBOutlet weak var kamiTableView: UITableView!
    
    var meishilist: [Uri] = []
    
    //撮影結果
    var resultImage:UIImage? = nil
    var resultAsset:PHAsset? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btToCamScreen.tintColor = Color.Palette.KamiMeishiButton
        btToCamScreen.setTitleColor(Color.Palette.Black, for: .normal)
        
        btBackKamiTop.tintColor = Color.Palette.KamiMeishiButton
        btBackKamiTop.setTitleColor(Color.Palette.Black, for: .normal)
        
        kamiTableView.dataSource = self
        kamiTableView.delegate = self
        
        let (success, errorMessage, count) = DBServiceKami.shared.getUriCount()
        if success{
            print(count)
            
            meishilist.removeAll()
            
            print(meishilist)
            if(count != 0){
                for i in 1...count {
                    let (success, errorMessage, uri) = DBServiceKami.shared.getUriDB(ID: i)
                    if(success){
                        if let uri = uri {
                            print(uri)
                            meishilist.append(Uri(id: uri.ID, name: uri.Name, uritext: uri.UriText, biko: uri.Biko))
                        } else {
                            print("Uri not found")
                        }
                    } else {
                        print(errorMessage ?? "Error")
                    }
                }
            }
            
        }else{
            print(errorMessage as Any)
        }
    }
    
    @IBAction func runCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }
            else {
                print("Camera not available.")
            }

    }
    
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else {
                print("Image not found.")
                return
            }
        
        do {
              var localIdentifier: String?
              try PHPhotoLibrary.shared().performChangesAndWait {
                  let changeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                  localIdentifier = changeRequest.placeholderForCreatedAsset?.localIdentifier
              }
              guard let identifier = localIdentifier,
                    let asset = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil).firstObject else {
                  fatalError("取得に失敗しました")
                  return
              }
            resultAsset = asset
          } catch {
              fatalError(error.localizedDescription)
          }
        resultImage = image
        performSegue(withIdentifier: "toKamiResist", sender: nil)

    }
    
    //画面遷移が起きると呼ばれるメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toKamiResist" {
            let sendImage = segue.destination as? ViewControllerKamiResist
            let sendAsset = segue.destination as? ViewControllerKamiResist

            sendImage?.recvImage = resultImage
            sendAsset?.recvAsset = resultAsset!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return meishilist.count
        }
    
    //追加
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = kamiTableView.dequeueReusableCell(withIdentifier: "KamiCell", for: indexPath) as? KamiTableViewCell else {
                fatalError("Dequeue failed: DigitalCell.")
            }
        
        cell.cellKamiBiko!.text = meishilist[indexPath.row].Biko
        cell.cellKamiName!.text = meishilist[indexPath.row].Name
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        kamiTableView.reloadData()
    }
    
    @IBAction func onClickKamiDel(_ sender: UIButton) {

        // indexPathを取得
        if let indexPath = kamiTableView.indexPath(for: sender.superview!.superview as! UITableViewCell) {
            print(indexPath.row)
//            print()
            print(meishilist[indexPath.row])
            
            if DBServiceKami.shared.deleteUriDB(ID: meishilist[indexPath.row].ID) {
                print("Delete success")
            } else {
                print("Delete Failed")
            }
            
            loadView()
            viewDidLoad()
            
        } else {
            //ここには来ないはず
            print("indexPath not found.")
        }
    }
}
