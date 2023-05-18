//
//  Person.swift
//  PrefectureCompatibilityChecker
//
//  Created by Eisuke KASAHARA on 2023/05/18.
//

import Foundation

struct Person: Codable {
    var name: String
    var birthday: DateStruct
    var bloodType: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case birthday
        case bloodType = "blood_type"
    }
}
