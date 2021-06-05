//  RectData.swift
//  SortingAlgorithmns
//
//  Oringinal created by Haipp on 03.05.21.
//  Modify by Hung-Chun, Tsai on 30,05,21.
	

import UIKit

class RectData: ObservableObject, Identifiable {
	let id = UUID()
	let value: CGFloat
	
	init(height: CGFloat) {
		self.value = height
	}
}

extension RectData: Comparable {
	static func < (lhs: RectData, rhs: RectData) -> Bool {
		return lhs.value < rhs.value
	}
	
	static func == (lhs: RectData, rhs: RectData) -> Bool {
		return lhs.id == rhs.id
	}
}
