/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A model object that stores app data.
*/

import UIKit
import Combine
import SwiftUI
import CoreData

let medicationData: [Medication] = load("medication.json")

func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
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
    
    let dateFormatterEncode = DateFormatter()
    dateFormatterEncode.dateFormat = "MM/dd/yy:HH:mm"

    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatterEncode)

        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

class UserData: ObservableObject {
    @Published var medications: [Medication] = Bundle.main.decode([Medication].self, from: "medications.json")
    @Published var pains = [Pain]()
    @Published var currentMed: Medication?
    @Published var permission: Bool = true
    
    static let shared = UserData()

    func save(medication: Medication) {
        let medindex = medications.firstIndex(where: {$0.id ==  medication.id})
        medications[medindex!] = medication
    }
}
