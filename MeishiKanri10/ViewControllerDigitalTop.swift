//
//  ViewControllerResistTop.swift
//  MeishiKanri10
//
//  Created by 酒井健輔 on 2023/03/21.
//

import UIKit
import Foundation

class ViewControllerDigitalTop: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var btToResistPage: UIButton!
    
    @IBOutlet weak var btBackDigitalTop: UIButton!
    
    @IBOutlet weak var digitalTableView: UITableView!
    
    var urilist: [Uri] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Run")
        
        btToResistPage.tintColor = Color.Palette.DigitalMeishiButton
        btToResistPage.setTitleColor(Color.Palette.Black, for: .normal)
        
        btBackDigitalTop.tintColor = Color.Palette.DigitalMeishiButton
        btBackDigitalTop.setTitleColor(Color.Palette.Black, for: .normal)
        
        digitalTableView.dataSource = self
        digitalTableView.delegate = self
        
        
        let (success, errorMessage, count) = DBService.shared.getUriCount()
        print(count)
        
        urilist.removeAll()
        
        print(urilist)
        if(count != 0){
            for i in 1...count {
                let (success, errorMessage, uri) = DBService.shared.getUriDB(ID: i)
                if(success){
                    if let uri = uri {
                        print(uri)
                        urilist.append(Uri(id: uri.ID, name: uri.Name, uritext: uri.UriText, biko: uri.Biko))
                    } else {
                        print("Uri not found")
                    }
                } else {
                    print(errorMessage ?? "Error")
                }
            }
        }
        
//        if DBService.shared.deleteUriDB(ID: 1) {
//            print("Delete success")
//        } else {
//            print("Delete Failed")
//        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return urilist.count
        }
    
    //追加
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: UITableViewCell = digitalTableView.dequeueReusableCell(withIdentifier: "DigitalCell", for: indexPath)
        
        guard let cell = digitalTableView.dequeueReusableCell(withIdentifier: "DigitalCell", for: indexPath) as? DigitalTableViewCell else {
                fatalError("Dequeue failed: DigitalCell.")
            }
        
        cell.cellBiko!.text = urilist[indexPath.row].Biko
        cell.cellName!.text = urilist[indexPath.row].Name
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if let indexPath = digitalTableView.indexPathForSelectedRow{
//            digitalTableView.deselectRow(at: indexPath, animated: true)
//        }
        digitalTableView.reloadData()
//        loadView()
//        viewDidLoad()
    }

    
    @IBAction func onClickDigitalDel(_ sender: UIButton) {

        // indexPathを取得
        if let indexPath = digitalTableView.indexPath(for: sender.superview!.superview as! UITableViewCell) {
            print(indexPath.row)
//            print()
            print(urilist[indexPath.row])
            
            if DBService.shared.deleteUriDB(ID: urilist[indexPath.row].ID) {
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
