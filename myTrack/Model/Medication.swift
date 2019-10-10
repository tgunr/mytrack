//
//  Medication.swift
//  myMeds
//
//  Created by Dave Carlton on 9/29/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import SwiftUI

struct Medication: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var startDate: Date
    var quantity: Int
    var dosage: Int
    var isAM: Bool
    var atTimes: [String]
    var interval: Int
    var notify: Bool
    var refill: Bool
    var refills: Int
    var instructions: String
}

