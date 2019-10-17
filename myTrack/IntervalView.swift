//
//  IntervalView.swift
//  myTrack
//
//  Created by Dave Carlton on 10/14/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import SwiftUI

struct IntervalView1: View {
    @Binding var medication: Medication

    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }

    let range = 1 ... 12

    var body: some View {
        let binding = Binding<Int>(
            get: {
                self.medication.interval
            },
            set: {
                self.medication.interval = $0
        })

        return
            VStack {
                Picker(selection: binding, label: Text("Interval")) {
                    Text("Daily").tag(0)
                    Text("At").tag(1)
                    //                Stepper("Step", value: binding1)
                    //                Stepper($medication.atTimes[0], value: range)
                    //                TimesView($medication.atTimes)
                    Text("At").tag(3)
                }
                Spacer()
        }
    }
}

struct IntervalDetailView: View {
    @Binding var hour: Int
    @Binding var hourString: String

    let range = 1 ... 12

    var body: some View {
        let binding = Binding<Int>(
            get: {
                //                self.hourString = String(self.hour)
                self.hour
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
    @State static var intervalRouter = IntervalRouter()
    var med = track.medications[0]

    static var previews: some View {
        let binding = Binding.constant(track.medications[0])
        return IntervalView1(medication: binding).environmentObject(track)
    }
}
