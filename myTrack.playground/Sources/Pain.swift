//
//  Pain.swift
//  myMeds
//
//  Created by Dave Carlton on 9/29/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import SwiftUI

enum PainLevel:Int, Codable {
    case none
    case mild
    case discomfort
    case tolerable
    case distressing
    case distressingplus
    case intense
    case intenseplus
    case horrible
    case excuriating
    case unspeakable
}

enum PainLocation:String, Codable {
    case head
    case sholder
    case arm
    case hand
    case torso
    case chest
    case abdomen
    case groin
    case leg
    case knee
    case foot
}

struct Pain: Hashable, Codable, Identifiable {
    var id: Int
    var level: PainLevel
    var location: PainLocation
    var duration: TimeInterval
}
