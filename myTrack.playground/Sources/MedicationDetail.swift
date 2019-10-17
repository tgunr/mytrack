//
//  MedicationDetail.swift
//  myMeds
//
//  Created by Dave Carlton on 9/29/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import SwiftUI

struct MedicationDetail: View {
    @EnvironmentObject var track: Track
    @State var medication: Medication
    @State private var ampmString            = ""
    @State private var dosageString          = ""
    @State private var intervalString        = ""
    @State private var timesString           = ""
    @State private var intervalType          = ""
    

    var medicationIndex: Int {
        track.medications.firstIndex(where: { $0.id == medication.id })!
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }

    var body: some View {
        let stack = VStack {
            Form {
                Section(header: Text("Prescription")) {
                    HStack{
                        Text("Name:")
                        TextField("Name", text: $medication.name)
                    }
                    HStack {
                        Text("Quantity:")
                        TextField("0", value: $medication.quantity, formatter: NumberFormatter())
                    }
                    HStack{
                        Text("Refills Left:")
                        TextField("0", value: $medication.refills, formatter: NumberFormatter())
                    }
                    DatePicker(selection: $medication.startDate, in: ...Date(), displayedComponents: .date) {
                        Text("Start Date")
                    }
                }
                
                Section(header: Text("Take")) {
                    DoseageView(doseCount: $medication.dosage)
                }
                
//                Section(header: Text("Time")) {
//                    IntervalView(medication: medication)
//                }

                Section(header: Text("Notifications settings")) {
                    Toggle(isOn: $medication.notify) {
                        Text("Notify Me To Take")
                    }
                    Toggle(isOn: $medication.refill) {
                        Text("Notify Me To Refill")
                    }
                }
            }
            HStack {
                Button(action: {
                    self.track.save(medication: self.medication)
                }) {
                    Text("Save")
                }
            }
        }
        return stack
    }
}

struct TimeDetails: Identifiable {
    let id = UUID()
    var times = Set<String>()
}

struct TimeDetailsView: View {
    let timeDetails: TimeDetails

    var body: some View {
        HStack{
            Text("Time:")
            Text(timeDetails.times.description)
        }
    }
}

struct TimesView: View {
    @Binding var times: [MedTime]
    //    @Binding var timesString: String
     private var time: String
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        //        ScrollView {
        //            List {
        HStack {
            
            //            ForEach($times, id: \.self, content: { aTime in
//                time = self.$times[index]
//                DatePicker(time, displayedComponents: .hourAndMinute)
                TextField("title", value: $times[0], formatter: timeFormatter)
//                Text(verbatim: "index: \(self.times[index])")
            }
        }
    }


struct DoseageView: View {
    @Binding var doseCount: Int
    @State private var dosageString: String
    
    let range = 1...10
    
    var body: some View {
        let binding = Binding<Int>(
            get: { self.doseCount },
            set: {
                self.doseCount = $0
                self.dosageString = String(self.doseCount)
        })
        
        self.dosageString = String(self.doseCount)
        return
            Stepper(value: $doseCount, in: range) {
                if doseCount > 1 {
                    Text(verbatim: "\(dosageString) pills")
                } else {
                    Text(verbatim: "\(dosageString) pill")
                }
                
        }
    }
}

struct AMPMView: View {
    @Binding var ampmString: String
    @State private var queryType: Int = 0
    
    let operators = ["AM", "PM"]
    
    var body: some View {
        
        let binding = Binding<Int>(
            get: { self.queryType },
            set: {
                self.queryType = $0
                self.ampmString = self.operators[self.queryType]
        })
        
        return Picker(selection: binding, label: Text("Query")) {
            ForEach(operators.indices) { index in
                Text(self.operators[index]).tag(index)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
}

struct MedicationDetailP: PreviewProvider {
    static let track = Track()
    static let intervalRouter = IntervalRouter()

    static var previews: some View {
        return MedicationDetail(medication: track.medications[0]).environmentObject(self.track)
    }
}



struct IntervalView: View {
    @State var medication: Medication
    @State private var selection: Int = 0

    var body: some View {
        let binding = Binding<Int>(
            get: { self.selection },
            set: {
                self.selection = $0
                self.medication.intervalType = $0
        })

        return VStack {
                Picker(selection: binding, label: Text("Interval")) {
                Text(verbatim: "Daily At").tag(0)
                Text(verbatim: "Daily AM").tag(1)
                Text(verbatim: "Daily PM").tag(2)
                Text(verbatim: "Hours").tag(3)
                //                Stepper("Step", value: binding1)
                //                Stepper($medication.atTimes[0], value: range)
                //                TimesView($medication.atTimes)
            }
            // This makes Xcode explode when compiling preview
//          if $medication.intervalType == 0 {
            if self.selection == 0 {
                Text(verbatim: "TIME")
            }
        }
    }
}
