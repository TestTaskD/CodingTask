//
//  UpdateType.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 07/11/2023.
//

import Foundation

enum UpdateType<T: Equatable>: Equatable {
    case addition(element:T)
    case editing(element:T, atIndex: Array.Index )
    case deletion(atIndex: Array.Index )
}
