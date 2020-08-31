//
//  Models.swift
//  RickAndMoryt2
//
//  Created by Anton Redkozubov on 28.08.2020.
//  Copyright © 2020 Anton Redkozubov. All rights reserved.
//

import Foundation

struct Character : Codable {
    let id : Int
    let name : String
    let species : String
    let image : String
    let gender: String
    let type: String
    let status: String
}

struct CharacterList : Codable {
    struct Info : Codable {
        let count : Int
        let pages : Int
        let next : String?
        let prev : String?
    }
    
    let results : [Character]?
    let info : Info?
    let error: String?
}
