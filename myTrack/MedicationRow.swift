//
//  MedicationRow.swift
//  myMeds
//
//  Created by Dave Carlton on 9/29/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import SwiftUI

struct MedicationRowP: PreviewProvider {
    static var previews: some View {
        Group {
            MedicationRow(medication: medicationData[0])
            MedicationRow(medication: medicationData[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}

struct MedicationRow: View {
    var medication: Medication

    var body: some View {
        Text("\(medication.name)")
    }
}
