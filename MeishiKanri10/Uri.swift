//
//  Uri.swift
//  MeishiKanri10
//
//  Created by 酒井健輔 on 2023/03/21.
//

import Foundation

struct Uri {
    var ID: Int
    var Name: String
    var UriText: String
    var Biko: String
    
    init(id: Int,name: String, uritext: String, biko: String) {
        self.ID = id
        self.Name = name
        self.UriText = uritext
        self.Biko = biko
    }
}
