//
//  SessionModel.swift
//  Globars
//
//  Created by Roman Efimov on 30.09.2020.
//

import Foundation


struct SessionModel: Codable{
    let success: Bool
    let data: [SessionData]
}

enum SessionData: Codable{
    case id(IdStruct)
    
    init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if let x = try? container.decode(IdStruct.self) {
                self = .id(x)
                return
            }
        
        throw DecodingError.typeMismatch(SessionData.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for DataElement"))
            }
            
            func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .id(let x):
                    try container.encode(x)
            }
            }
        
}

struct IdStruct: Codable {
    var id: String
}
