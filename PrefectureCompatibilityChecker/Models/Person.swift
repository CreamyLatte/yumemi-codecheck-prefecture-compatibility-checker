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

extension Person {
    init() {
        self.name = ""
        self.birthday = Calendar.current.date(from: DateComponents(year: 1976, month: 4, day: 1))!
        self.bloodType = "a"
    }
}
