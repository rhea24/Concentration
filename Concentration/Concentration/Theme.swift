//
//  Theme.swift
//  Concentration
//
//  Created by Rhea Malik on 6/25/21.
//  Copyright © 2021 Rhea Malik. All rights reserved.
//

import Foundation
import SwiftUI

struct Theme<CardContent> where CardContent: Equatable {
    let name: String
    let emojis: [CardContent]
    let numPairs: Int
    let color: Color
}
