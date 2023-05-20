//
//  DateStruct.swift
//  PrefectureCompatibilityChecker
//
//  Created by Eisuke KASAHARA on 2023/05/18.
//

import Foundation

struct DateStruct: Encodable {
    var year: Int
    var month: Int
    var day: Int
}

extension DateStruct {
    static var today: DateStruct {
        let currentDate = Date()
        return DateStruct(date: currentDate)
    }
}

extension DateStruct {
    init(date: Date) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)

        self.year = dateComponents.year!
        self.month = dateComponents.month!
        self.day = dateComponents.day!
    }
}
