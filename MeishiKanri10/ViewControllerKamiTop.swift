//
//  ViewControllerKamiTop.swift
//  MeishiKanri10
//
//  Created by 酒井健輔 on 2023/03/21.
//

import UIKit
import AVFoundation

class ViewControllerKamiTop: UIViewController,UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var btToCamScreen: UIButton!
    
    @IBOutlet weak var btBackKamiTop: UIButton!
    
    @IBOutlet weak var kamiTableView: UITableView!
    
    var meishilist: [Uri] = []
    
    var VCKamiResist: ViewControllerKamiResist?
    
    //撮影結果
    var resultImage:UIImage? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btToCamScreen.tintColor = Color.Palette.KamiMeishiButton
        btToCamScreen.setTitleColor(Color.Palette.Black, for: .normal)
        
        btBackKamiTop.tintColor = Color.Palette.KamiMeishiButton
        btBackKamiTop.setTitleColor(Color.Palette.Black, for: .normal)
        
        kamiTableView.dataSource = self
        kamiTableView.delegate = self
        
        let (success, errorMessage, count) = DBServiceKami.shared.getUriCount()
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
        
        //test
        let (oldsuccess, olderrorMessage, oldcount) = DBServiceKami.shared.getUriCount()
        
        var oldid = oldcount + 1
        
        let uri1 = Uri(id: oldid, name: "名前", uritext: "https://lit.link", biko: "備考")
        
        print(uri1)
        
        if DBServiceKami.shared.insertUriDB(meishi: uri1) {
            print("Insert success")
            print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
        } else {
            print("Insert Failed")
        }
        //kokomade
        
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
//        print("Camera fin")

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return meishilist.count
        }
    
    //追加
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: UITableViewCell = digitalTableView.dequeueReusableCell(withIdentifier: "DigitalCell", for: indexPath)
        
        guard let cell = kamiTableView.dequeueReusableCell(withIdentifier: "KamiCell", for: indexPath) as? KamiTableViewCell else {
                fatalError("Dequeue failed: DigitalCell.")
            }
        
        cell.cellKamiBiko!.text = meishilist[indexPath.row].Biko
        cell.cellKamiName!.text = meishilist[indexPath.row].Name
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if let indexPath = digitalTableView.indexPathForSelectedRow{
//            digitalTableView.deselectRow(at: indexPath, animated: true)
//        }
        kamiTableView.reloadData()
//        loadView()
//        viewDidLoad()
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
