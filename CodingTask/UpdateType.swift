//
//  UpdateType.swift
//  CodingTask
//
//  Created by Denis Aleshyn on 07/11/2023.
//

import Foundation

enum UpdateType<T> {
    case addition(element:T)
    case editing(element:T, atIndex: Array.Index )
    case deletion(atIndex: Array.Index )
}
