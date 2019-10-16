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
    @Binding var intervalRouter: IntervalRouter
    @State private var interval: Int
    @State private var intervalString: String
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }

    let range = 1...12

    var body: some View {
        let binding = Binding<Int>(
            get: {
                return self.interval
        },
            set: {
                self.interval = $0
                self.intervalString = String(self.interval)
        })
         
        return
            Picker(selection: binding, label: Text("Interval")) {
                Text("Daily").tag(0)
                Text("At").tag(1)
//                Stepper("Step", value: binding1)
//                Stepper($medication.atTimes[0], value: range)
//                TimesView($medication.atTimes)
                Text("At").tag(3)
        }
    }
}

struct IView: View {
    @State var selection: Int
    var body: some View {
        VStack {
            TabView(selection: $selection) {
                Text("Tab 1").tabItem { Text("Daily") }.tag(1)
                Text("Tab Content 2").tabItem {
                    Text("Every")
                    Text("hours")
                }.tag(2)
            }
            Spacer()
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
    @State static var intervalRouter = IntervalRouter()
    @State static var med = track.medications[0]

    static var previews: some View {
        IView(selection: med.intervalType)
    }
}
