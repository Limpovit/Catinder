//
//  Cat.swift
//  Catinder
//
//  Created by HexaHack on 13.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import Foundation

// MARK: - Cat
struct Cats: Codable {
    let breeds: [Breed]?
    let categories: [Category]?
    let id: String
    let url: String
    let width, height: Int
}

// MARK: - Breed
struct Breed: Codable {
    let weight: Weight
    let id, name: String
    let vetstreetURL: String?
    let vcahospitalsURL: String?
    let temperament, origin, countryCodes, countryCode: String
    let breedDescription, lifeSpan: String
    let indoor, lap: Int?
    let altNames: String?
    let adaptability, affectionLevel, childFriendly, dogFriendly: Int?
    let energyLevel, grooming, healthIssues, intelligence: Int?
    let sheddingLevel, socialNeeds, strangerFriendly, vocalisation: Int?
    let experimental, hairless, natural, rare: Int?
    let rex, suppressedTail, shortLegs: Int?
    let wikipediaURL: String?
    let hypoallergenic: Int?

    enum CodingKeys: String, CodingKey {
        case weight, id, name = "name"
        case vetstreetURL = "vetstreet_url"
        case vcahospitalsURL = "vcahospitals_url"
        case temperament, origin = "origin"
        case countryCodes = "country_codes"
        case countryCode = "country_code"
        case breedDescription = "description"
        case lifeSpan = "life_span"
        case indoor, lap = "lap"
        case altNames = "alt_names"
        case adaptability = "adaptability"
        case affectionLevel = "affection_level"
        case childFriendly = "child_friendly"
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case grooming = "grooming"
        case healthIssues = "health_issues"
        case intelligence = "intelligence"
        case sheddingLevel = "shedding_level"
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
        case vocalisation, experimental, hairless, natural, rare, rex = "rex"
        case suppressedTail = "suppressed_tail"
        case shortLegs = "short_legs"
        case wikipediaURL = "wikipedia_url"
        case hypoallergenic = "hypoallergenic"
    }
    
}

// MARK: - Weight
struct Weight: Codable {
    let imperial, metric: String
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name: String
}
