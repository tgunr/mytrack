//
//  DosageDetail.swift
//  myTracking
//
//  Created by Dave Carlton on 10/1/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import SwiftUI

struct DosageDetail_Previews: PreviewProvider {
    @State private static var track = UserData()
    @State static var medication = track.medications[1]

    static var previews: some View {
        return DosageDetail(medication: $medication)
    }
}

struct DosageDetail: View {
    @Binding var medication: Medication

    var body: some View {
        let doesStr = "\(medication.dosage)"
        let name = "\(medication.name)"

        return VStack {
            Text(verbatim: "Dosage for \(name)")
            Form {
                Section(header: Text("Take")) {
                    HStack {
                        Stepper(value: $medication.dosage, in: 1 ... 10) {
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
                    Stepper(value: $medication.dosage, in: 1 ... 10) {
                        Text("At")
                    }

                    Toggle(isOn: $medication.isAM) {
                        Text("PM")
                    }
                }
            }
        }
    }
}
