//
//  Track.swift
//  myMeds
//
//  Created by Dave Carlton on 9/29/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import SwiftUI
import Combine
import Foundation

/// Tracking things
enum TrackType: Int, Codable {
    case medication
    case pain
    
    var description : String {
        switch self {
        case .medication: return "medication"
        case .pain: return "pain"
        }
    }
}

class IntervalRouter: ObservableObject {
    let objectWillChange = PassthroughSubject<IntervalRouter,Never>()
    var currentPage: String = "daily" {
        didSet {
            objectWillChange.send(self)
        }
    }
}
