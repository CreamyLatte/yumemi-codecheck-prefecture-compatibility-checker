//
//  DateStruct.swift
//  PrefectureCompatibilityChecker
//
//  Created by Eisuke KASAHARA on 2023/05/18.
//

import Foundation

struct DateStruct: Codable {
    var year: Int
    var month: Int
    var day: Int
}

extension DateStruct {
    static var today: DateStruct {
        let currentDate = Date()
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)

        let year = dateComponents.year!
        let month = dateComponents.month!
        let day = dateComponents.day!
        
        return DateStruct(year: year, month: month, day: day)
    }
}
