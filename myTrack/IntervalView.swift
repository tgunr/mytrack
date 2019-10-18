//
//  IntervalView.swift
//  myTrack
//
//  Created by Dave Carlton on 10/14/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import SwiftUI

struct IntervalView_Previews: PreviewProvider {
    @State private static var track = UserData()
    @State static var med = track.medications[2]

    static var previews: some View {
        VStack {
            IntervalView(medication: $med)
            IntervalSubView(medication: $med)
        }
    }
}

struct IntervalView: View {
    @Binding var medication: Medication

    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }

    var body: some View {
        return
            Picker(selection: $medication.intervalType, label: Text("Interval")) {
                Text("Daily").tag(0)
                Text("Every").tag(1)
                Text("As needed").tag(2)
            }
    }
}

struct IntervalSubView: View {
    @Binding var medication: Medication

    var body: some View {
        // Expression too complex break out
        let intType = medication.intervalType
        return Group {
            if intType == 0 { // Daily
                IntervalDailyView(medication: $medication)
            }
            if intType == 1 { // Every
                IntervalEveryView(medication: $medication)
            }
            if intType == 2 { // As needed
                EmptyView()
            }
        }
    }
}

struct IntervalEveryView: View {
    @Binding var medication: Medication

    var body: some View {
        let range = 1 ... 12
        let intervalB = $medication.interval
        let interval = medication.interval
        let everyLabel = Text("\(interval) Hours")
        return Group {
            Stepper(value: intervalB, in: range, label: { everyLabel })
            DatePicker(selection: $medication.startTime, displayedComponents: .hourAndMinute, label: { Text("Starting At ") })
        }
    }
}

struct IntervalDailyView: View {
    @Binding var medication: Medication
    var body: some View {
        let st = $medication.startTime
        let atLabel = Text("At ")
       return DatePicker(selection: st, displayedComponents: .hourAndMinute, label: { atLabel })
    }
}
