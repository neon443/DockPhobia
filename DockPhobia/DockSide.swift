//
//  DockSide.swift
//  DockPhobia
//
//  Created by neon443 on 28/05/2025.
//

import Foundation

enum DockSide: Int, RawRepresentable {
	case left
	case bottom
	case right
	
	public typealias RawValue = String
	
	public var rawValue: RawValue {
		switch self {
		case .left:
			return "left"
		case .right:
			return "right"
		case .bottom:
			return "bottom"
		}
	}
	
	/// Random Dock Side
	/// - will return a random Dock Side when calling DockSide()
	public init() {
		self = DockSide(rawValue: Int.random(in: 1...3))!
	}
	
	public init?(rawValue: String) {
		switch rawValue {
		case "left":
			self = .left
		case "right":
			self = .right
		case "bottom":
			self = .bottom
		default:
			return nil
		}
	}
	
	public init?(rawValue: Int) {
		switch rawValue {
		case 1:
			self = .left
		case 2:
			self = .bottom
		case 3:
			self = .right
		default:
			return nil
		}
	}
}
