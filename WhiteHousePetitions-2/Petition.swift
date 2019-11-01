//
//  Petition.swift
//  WhiteHousePetitions-2
//
//  Created by Keishin CHOU on 2019/11/01.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import Foundation

struct Petition: Codable {
    
    var title: String
    var body: String
    var signatureCount: Int
}

struct Petitions: Codable {
    
    var results: [Petition]
}
