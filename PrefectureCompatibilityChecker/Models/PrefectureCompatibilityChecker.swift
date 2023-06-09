//
//  PrefectureCompatibilityChecker.swift
//  PrefectureCompatibilityChecker
//
//  Created by Eisuke KASAHARA on 2023/05/19.
//

import Foundation

enum APIError: Error {
    case failedToCreateURL
    case failedToJSONEncode
    case failedtoURLSession
    case httpResponseError(Int, String)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedToCreateURL:
            return "API接続のためのURLが生成できませんでした"
        case .failedToJSONEncode:
            return "JSONデータのエンコードに失敗しました"
        case .failedtoURLSession:
            return "URLSessionの接続に失敗しました"
        case .httpResponseError(let code, let error):
            return "サーバに接続できませんでした\n\(code): \(error)"
        }
    }
}

class PrefectureCompatibilityChecker {
    let baseURL = "https://yumemi-ios-junior-engineer-codecheck.app.swift.cloud"
    let endPoint = "/my_fortune"
    let apiVersion = "v1"
    
    func checkCompatibility(request: Request) async throws -> FortuneResult {
        guard let url = URL(string: baseURL)?.appendingPathComponent(endPoint) else {
            throw APIError.failedToCreateURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(apiVersion, forHTTPHeaderField: "API-Version")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(request)
        urlRequest.httpBody = jsonData
        
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw APIError.failedtoURLSession
        }
        
        guard httpResponse.statusCode == 200 else {
            let statusCode = httpResponse.statusCode
            let responseMessage = String(data: data, encoding: .utf8)
            let errorMessage = responseMessage ?? "no message."
            throw APIError.httpResponseError(statusCode, errorMessage)
        }
        
        let jsonDecoder = JSONDecoder()
        let result = try jsonDecoder.decode(FortuneResult.self, from: data)
        
        return result
    }
    
    struct Request: Encodable {
        var name: String
        var birthday: YearMonthDay
        var bloodType: String
        var today: YearMonthDay = YearMonthDay.today
        
        struct YearMonthDay: Encodable {
            var year: Int
            var month: Int
            var day: Int
            
            static var today: YearMonthDay {
                let currentDate = Date()
                return YearMonthDay(date: currentDate)
            }
            
            init(date: Date) {
                let calendar = Calendar.current
                let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)

                self.year = dateComponents.year!
                self.month = dateComponents.month!
                self.day = dateComponents.day!
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case name
            case birthday
            case bloodType = "blood_type"
            case today
        }
    }
}

extension PrefectureCompatibilityChecker {
    func checkCompatibility(person: Person) async throws -> FortuneResult {
        let name = person.name
        let birthday = Request.YearMonthDay(date: person.birthday)
        let bloodType = person.bloodType
        let request = Request(name: name, birthday: birthday, bloodType: bloodType)
        return try await checkCompatibility(request: request)
    }
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

