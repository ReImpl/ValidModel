//
//  PropertyValidator.swift
//  ValidModel
//
//  Created by kernel on 5/13/18.
//  Copyright © 2018 ReImpl. All rights reserved.
//

import Foundation

public enum ValidatorAggregateFunc {
	case min
	case max
	case random
}

public protocol PropertyValidator {
	
	var rangeDescription: String { get }
	
	func validate(_ value: Any) -> Bool
	func value(for af: ValidatorAggregateFunc) -> Any
	
}

public struct StringValidator: PropertyValidator {
	
	public typealias LimitType = UInt
	
	public let minLength: LimitType
	public let maxLength: LimitType
	
	public init(exactLength l: LimitType) {
		self.init(length: (min: l, max: l))
	}
	
	public init(length l: (min: LimitType, max: LimitType) = (min: 0, max: LimitType.max)) {
		assert(l.min <= l.max)
		
		minLength = l.min
		maxLength = l.max
	}
	
	public var rangeDescription: String {
		return "String of length: \(minLength) - \(maxLength)"
	}
	
	public func validate(_ value: Any) -> Bool {
		guard let str = value as? String else {
			return false
		}
		
		let length = str.utf8.count
		return length >= minLength && length <= maxLength
	}
	
	public func value(for af: ValidatorAggregateFunc) -> Any {
		let result: String
		
		switch af {
		case .min:
			result = randomString(of: minLength)
		case .max:
			result = randomString(of: maxLength)
		case .random:
			let length = randomNumber(between: Int(minLength), and: Int(maxLength))
			
			result = randomString(of: LimitType(length))
		}
		
		return result
	}
	
	// MARK: - Internal
	
	func randomString(of length: LimitType) -> String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
		let lettersLength = UInt32(letters.count)
		
		return (0..<length).map { i -> String in
			let offset = Int(arc4random_uniform(lettersLength))
			
			let index = letters.index(letters.startIndex, offsetBy: offset)
			return String(letters[index])
		}.joined()
	}
	
}

public struct IntValidator: PropertyValidator {
	
	public typealias ValueType = Int
	
	public let minValue: ValueType
	public let maxValue: ValueType
	
	public init(inRange v: (min: ValueType, max: ValueType) = (min: 0, max: ValueType.max)) {
		assert(v.min <= v.max)
		
		minValue = v.min
		maxValue = v.max
	}
	
	public var rangeDescription: String {
		return "Int value in between: \(minValue) - \(maxValue)"
	}
	
	public func validate(_ value: Any) -> Bool {
		guard let number = value as? Int else {
			return false
		}
		
		return number >= minValue && number <= maxValue
	}
	
	public func value(for af: ValidatorAggregateFunc) -> Any {
		let result: ValueType
		
		switch af {
		case .min:
			result = minValue
		case .max:
			result = maxValue
		case .random:
			result = randomNumber(between: minValue, and: maxValue)
		}
		
		return result
	}
	
}

public struct DoubleValidator: PropertyValidator {
	
	public typealias ValueType = Double
	
	public let minValue: ValueType
	public let maxValue: ValueType
	
	public init(inRange v: (min: ValueType, max: ValueType) = (min: 0, max: 1)) {
		assert(v.min <= v.max)
		
		minValue = v.min
		maxValue = v.max
	}
	
	public var rangeDescription: String {
		return "Double value in between: \(minValue) - \(maxValue)"
	}
	
	public func validate(_ value: Any) -> Bool {
		guard let number = value as? ValueType else {
			return false
		}
		
		return number >= minValue && number <= maxValue
	}
	
	public func value(for af: ValidatorAggregateFunc) -> Any {
		let result: ValueType
		
		switch af {
		case .min:
			result = minValue
		case .max:
			result = maxValue
		case .random:
			result = drand48()
		}
		
		return result
	}
	
}

// TODO: - Add ArrayValidator (enforces number of elements to a specific range)
// TODO: - Add DictionaryValidator

// MARK: -

fileprivate func randomNumber(between min: Int, and max: Int) -> Int {
	guard max > min else {
		return max
	}
	
	return Int(arc4random_uniform(UInt32(max - min)) + UInt32(min))
}

