//
//  DosageDetail.swift
//  myTracking
//
//  Created by Dave Carlton on 10/1/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import SwiftUI

struct DosageDetail: View {
    @Binding var medication: Medication
    
    var body: some View {
        let doesStr = "\($medication.dosage)"
        let name = "\($medication.name)"
        
        let stack = VStack {
            Text("Dosage for \(name)")
            Form {
                Section(header: Text("Take")) {
                    HStack {
                        Stepper(value: $medication.dosage, in: 1...10) {
                            Text("\(doesStr) pill")
                        }
                    }
                }
                Section(header: Text("Time settings")) {
                    Text("Every")
                    Picker(selection: .constant(1), label: Text("Interval")) {
                        Text("Day").tag(1)
                        Text("Hours").tag(2)
                    }
                    Stepper(value: $medication.dosage, in: 1...10) {
                        Text("At")
                    }
                    
                    Toggle(isOn: $medication.isAM) {
                        Text("PM")
                    }
                }
                
                //                Button(action: {
                //                    do {
                //                        try self.medication.save(CoreDataManager.shared.mainContext)
                //
                //                    } catch {
                //                        print("Save failed")
                //                    }
                //                }) {
                //                    Text("Save")
                //                }
            }
        }
        return stack
    }
}
    
    
//struct DosageDetail_Previews: PreviewProvider {
//    static let track = Track()
//    static var previews: some View {
//        let medication = track.medications[0]
//        return DosageDetail(medication: medication)
//    }
//}

