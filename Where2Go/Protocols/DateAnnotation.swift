//
//  File.swift
//  Where2Go
//
//  Created by João Felipe Schwaab on 21/11/25.
//

import Foundation


protocol DateAnnotation {
    var localName : String { get set }
    var localType : LocalType { get set }
}


enum LocalType: String, Codable {
    case restaurant
    case shopping
    case park
    case cinema
    case museum
    case gym
    case hotel
    case bakery
    case bar
    case cafe
    case other
}
