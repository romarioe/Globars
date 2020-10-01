//
//  UnitsModel.swift
//  Globars
//
//  Created by Roman Efimov on 01.10.2020.
//

import Foundation


struct UnitsModel: Codable {
    let success: Bool
    let data: [UnitsData]
}


struct UnitsData: Codable {
    let name: String
    let checked: Bool
    let position: Position
    let eye: Bool
    
}


struct Position: Codable{
    let lt: Double
    let ln: Double
}
