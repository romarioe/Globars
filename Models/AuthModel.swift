//
//  AuthModel.swift
//  Globars
//
//  Created by Roman Efimov on 30.09.2020.
//

import Foundation


struct AuthModel: Codable {
    let username: String
    let password: String
}


struct AuthResponseModel: Codable{
    let success: Bool
    let data: String
}
