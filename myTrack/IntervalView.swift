//
//  IntervalView.swift
//  myTrack
//
//  Created by Dave Carlton on 10/14/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import SwiftUI

struct IntervalView: View {
    @Binding var medication: Medication

    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }

    let range = 1 ... 12

    var body: some View {
        return
            Picker(selection: $medication.intervalType, label: Text("Interval")) {
                Text("Daily").tag(0)
                Text("Every").tag(1)
                Text("As needed").tag(2)
//                Stepper("Step", value: binding1)
//                Stepper($medication.atTimes[0], value: range)
//                TimesView($medication.atTimes)
            }
    }
}

struct IntervalDetailView: View {
    @Binding var medication: Medication

    let range = 1 ... 12

    var body: some View {
        Group {
            IntervalView(medication: $medication)

            if medication.intervalType == 0 { // Daily
                DatePicker(selection: $medication.startTime, displayedComponents: .hourAndMinute, label: { Text("At ") })
            } else {
                Stepper(value: $medication.interval, in: range, label: { Text("\(medication.interval) Hours") })
                DatePicker(selection: $medication.startTime, displayedComponents: .hourAndMinute, label: { Text("Starting At ") })
            }
        }
    }
}

struct IntervalView_Previews: PreviewProvider {
    @State private static var track = UserData()
    @State static var med = track.medications[0]

    static var previews: some View {
        IntervalView(medication: $med)
    }
}
