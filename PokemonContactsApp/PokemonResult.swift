//
//  PokemonResult.swift
//  PokemonContactsApp
//
//  Created by 허성필 on 4/18/25.
//

import Foundation

struct PokemonResult: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
}

struct Sprites: Codable {
    let front_default: String
}
