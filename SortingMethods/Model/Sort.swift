//
//  Sort.swift
//  SortingMethods
//
//  Created by Hung-Chun Tsai on 2021-05-29.
//

import Foundation

protocol SortType {
    var name: String { get }
    func sort(items: [RectData]) -> [SwapData]
}
