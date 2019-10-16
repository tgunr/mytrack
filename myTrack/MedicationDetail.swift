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
    
    @ObservedObject var intervalRouter: IntervalRouter

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
                
                Section(header: Text("Time")) {
                    //                    IntervalView(medication: $medication, interval: $medication.interval)
                    if intervalRouter.currentPage == "daily" {
                        Text("view1")
                    } else if intervalRouter.currentPage == "page2" {
                        Text("view2")
                    }
                }
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
    @State private var dosageString: String = "1"
    
    let range = 1...10
    
    var body: some View {
        let binding = Binding<Int>(
            get: { self.doseCount },
            set: {
                self.doseCount = $0
                self.dosageString = String(self.doseCount)
        })
        
        return
            Stepper(value: binding, in: range) {
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
        return MedicationDetail(medication: track.medications[0], intervalRouter: self.intervalRouter).environmentObject(self.track)
    }
}


