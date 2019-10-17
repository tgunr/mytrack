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

    let range = 1...12

    var body: some View {
        return
            Picker(selection: $medication.intervalType, label: Text("Interval")) {
                Text("Daily").tag(0)
                Text("Every").tag(1)
//                Stepper("Step", value: binding1)
//                Stepper($medication.atTimes[0], value: range)
//                TimesView($medication.atTimes)
        }
    }
}

struct IntervalDetailView: View {
    @Binding var hour: Int
    @Binding var hourString: String
    
    let range = 1...12
    
    var body: some View {
        let binding = Binding<Int>(
            get: {
//                self.hourString = String(self.hour)
                return self.hour
        },
            set: {
                self.hour = $0
                self.hourString = String(self.hour)
        })
        
        return Stepper(value: binding, in: range) {
            if hour > 1 {
                HStack {
                    Text(verbatim: "Every")
                    Text(verbatim: "\(hourString) hours")
                }
            } else {
                Text(verbatim: "hour")
            }
        }
    }
}

struct IntervalView_Previews: PreviewProvider {
    @State private static var track = Track()
    @State static var med = track.medications[0]

    static var previews: some View {
        IntervalView(medication: $med)
    }
}
