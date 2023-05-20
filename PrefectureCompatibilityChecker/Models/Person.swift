//
//  Person.swift
//  PrefectureCompatibilityChecker
//
//  Created by Eisuke KASAHARA on 2023/05/18.
//

import Foundation

struct Person {
    var name: String
    var birthday: Date
    var bloodType: String
}

extension Person: Encodable {
    enum CodingKeys: String, CodingKey {
        case name
        case birthday
        case bloodType = "blood_type"
    }
}
