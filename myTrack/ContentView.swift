//
//  ContentView.swift
//  myTrack
//
//  Created by Dave Carlton on 10/6/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import SwiftUI

struct ContentView_Previews: PreviewProvider {
    static let data = UserData()

    static var previews: some View {
        return ContentView().environmentObject(data)
    }
}

struct ModalView: View {
    var body: some View {
        Text("This is a modal")
    }
}

struct ContentView: View {
    @EnvironmentObject private var data: UserData

    var addButton: some View {
        return Image(systemName: "plus")
            .font(.largeTitle)
    }

    var body: some View {
        return NavigationView {
            List {
                ForEach(data.medications) { medication in
                    NavigationLink(destination: MedicationDetail(medication: medication).environmentObject(self.data)) {
                        MedicationRow(medication: medication)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle(Text("Prescriptions"))
            .navigationBarItems(leading: Button(action: add, label: { Text("Add") }), trailing: EditButton())
        }
        .alert(isPresented: $data.permission) {
            Alert(title:
                    Text("This application requires notifications in order to be useful. The purpose of the application is to remind you when to take your medications.\nPlease go to the Settings -> Notications -> myTrack and enable notifications ")
            )
        }
    }

    func add() {
        let newmed = Medication(id: UUID(), name: "Name", startDate: Date(), startTime: Date(), quantity: 0, dosage: 0, isAM: true, intervalType: 0, atTimes: [MedTime(id: 0, time: "0800")], interval: 0, notify: false, refill: false, refills: 0, instructions: "")
        data.medications.append(newmed)
    }

    func delete(at offsets: IndexSet) {
        data.medications.remove(atOffsets: offsets)
    }
}

