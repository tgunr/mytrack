///: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import SwiftUI

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let dateFormatterEncode = DateFormatter()
        dateFormatterEncode.dateFormat = "MM/dd/yy:HH:mm"

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatterEncode)

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}

struct MedTime: Codable, Equatable, Identifiable {
    var id: Int
    var time: String
}

struct Medication: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var startDate: Date
    var quantity: Int
    var dosage: Int
    var isAM: Bool
    var intervalType: Int
    var atTimes: [MedTime]
    var interval: Int
    var notify: Bool
    var refill: Bool
    var refills: Int
    var instructions: String
}

class Track: ObservableObject {
    @Published var medications: [Medication] = Bundle.main.decode([Medication].self, from: "medications.json")
    @Published var currentMed: Medication?
    
    func save(medication: Medication) {
        let medindex = medications.firstIndex(where: {$0.id ==  medication.id})
        medications[medindex!] = medication
    }
}

struct ContentView: View {
    @EnvironmentObject private var track: Track
    
    var addButton: some View {
        return Image(systemName: "plus")
            .font(.largeTitle)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(track.medications) { med in
                    NavigationLink(destination: MedicationDetail(medication: med).environmentObject(self.track)) {
                        MedicationRow(medication: med)
                    }
                }
            }
            .navigationBarTitle(Text("Meds"))
        }
        
//        func add() {
//            let newmed = Medication(id: UUID(), name: "Name", startDate: Date(), quantity: 0, dosage: 0, isAM: true, atTimes: ["0800"], interval: 0, notify: false, refill: false, instructions: "")
//            track.medications.append(newmed)
//        }
//
//        func delete(at offsets: IndexSet) {
//            track.medications.remove(atOffsets: offsets)
//        }
    }
}


let host = UIHostingController(rootView: ContentView())
PlaygroundPage.current.liveView = host
