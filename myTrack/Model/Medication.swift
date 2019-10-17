//
//  Medication.swift
//  myMeds
//
//  Created by Dave Carlton on 9/29/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import SwiftUI

struct MedTime: Codable, Equatable, Identifiable {
    var id: Int
    var time: String
}

struct Medication: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var startDate: Date
    var startTime: Date
    var quantity: Int
    var dosage: Int
    var isAM: Bool
    var intervalType: Int
    var atTimes: [MedTime]
    var interval: Int
    var notify: Bool
    var refill: Bool
    var refills: Int
    var instructions: String
}

