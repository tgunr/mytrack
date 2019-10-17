//
//  ContentView.swift
//  myTrack
//
//  Created by Dave Carlton on 10/6/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import SwiftUI

//            Section {
//                        self.track.currentMed = medication
//                        MedicationRow(medication: medication).environmentObject(self.track)
//                        HStack {
//                            }
//                        }
//                        }
//                    }
//                    .navigationBarTitle(Text("Medications"))
//                    .navigationBarItems(leading: Button(action: add, label: { Text("Add") }), trailing: EditButton())
//            }

struct ContentView: View {
    @EnvironmentObject private var track: Track
    var intervalRouter = IntervalRouter()
    
    var addButton: some View {
        return Image(systemName: "plus")
            .font(.largeTitle)
    }
    
    var body: some View {
      return      NavigationView {
            List {
                ForEach(track.medications) { medication in
                    NavigationLink(destination: MedicationDetail(medication: medication).environmentObject(self.track)) {
                        MedicationRow(medication: medication)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle(Text("Prescriptions"))
            .navigationBarItems(leading: Button(action: add, label: { Text("Add") }), trailing: EditButton())
        }
        
    }
        func add() {
            let newmed = Medication(id: UUID(), name: "Name", startDate: Date(), startTime: Date(), quantity: 0, dosage: 0, isAM: true, intervalType: 0, atTimes: [MedTime(id: 0, time: "0800")], interval: 0, notify: false, refill: false, refills: 0, instructions: "")
            track.medications.append(newmed)
        }

        func delete(at offsets: IndexSet) {
            track.medications.remove(atOffsets: offsets)
        }
    
}

struct ContentView_Previews: PreviewProvider {
    static let track = Track()
    static let intervalRouter = IntervalRouter()
    
    static var previews: some View {
        return ContentView().environmentObject(track)
    }
}
