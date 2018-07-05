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

public protocol PropertyValueGenerator {
	
	func value(for af: ValidatorAggregateFunc) -> Any
	
}

public protocol GeneratedPropertyValidator: PropertyValueGenerator {
	
	var rangeDescription: String { get }
	func validate(_ value: Any) -> Bool
	
}

// MARK: - StringValidator

public struct StringValidator: GeneratedPropertyValidator {
	
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
	
	// MARK: PropertyValueGenerator
	
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
	
	// MARK: Internal
	
	func randomString(of length: LimitType) -> String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
		
		return String((0..<length).map { _ -> Character in
			return letters.randomElement()!
		})
	}
	
}

// MARK: - IntValidator

public struct IntValidator: GeneratedPropertyValidator {
	
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
	
	// MARK: PropertyValueGenerator
	
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

// MARK: - DoubleValidator

public struct DoubleValidator: GeneratedPropertyValidator {
	
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
	
	// MARK: PropertyValueGenerator
	
	public func value(for af: ValidatorAggregateFunc) -> Any {
		let result: ValueType
		
		switch af {
		case .min:
			result = minValue
		case .max:
			result = maxValue
		case .random:
			result = ValueType.random(in: minValue...maxValue)
		}
		
		return result
	}
	
}

// MARK: - ArrayValidator

/// Enforces number of elements to a specific range.
public struct ArrayValidator<MC: ModelContract>: GeneratedPropertyValidator {
	
	public let minCapacity: Int
	public let maxCapacity: Int
	
	private let contract: MC
	
	public init(capacity v: (min: Int, max: Int) = (min: 0, max: 100), contract: MC) {
		assert(v.min <= v.max)
		
		minCapacity = v.min
		maxCapacity = v.max
		
		self.contract = contract
	}
	
	public var rangeDescription: String {
		return "Array containing [\(minCapacity)-\(maxCapacity)] elements."
	}
	
	public func validate(_ value: Any) -> Bool {
		guard let arr = value as? Array<MC.M> else {
			return false
		}
		
		let validator = ModelValidator()
		for item in arr {
			do {
				guard try validator.validate(item, using: contract) else {
					return false
				}
			} catch {
				return false
			}
		}
		
		return arr.count >= minCapacity && arr.count <= maxCapacity
	}
	
	// MARK: PropertyValueGenerator
	
	public func value(for af: ValidatorAggregateFunc) -> Any {
		let n: Int

		switch af {
		case .min:
			n = minCapacity
		case .max:
			n = maxCapacity
		case .random:
			n = randomNumber(between: minCapacity, and: maxCapacity)
		}
		
		return generateObjects(count: n, aggr: af)
	}
	
	private func generateObjects(count n: Int, aggr af: ValidatorAggregateFunc) -> [ModelGenerator.JsonDict] {
		let mg = ModelGenerator()
		
		var items: [ModelGenerator.JsonDict] = []
		items.reserveCapacity(n)
		
		for _ in 0..<n {
			items.append(mg.dict(from: contract, aggregate: af))
		}
		
		return items
	}
	
}

public protocol EnumRepresentable: CaseIterable, RawRepresentable, Decodable { }

// MARK: - EnumValidator

/// EnumValidator works with 'simple' enums that has no associated values.
///
/// Note: https://oleb.net/blog/2018/06/enumerating-enum-cases/
public struct EnumValidator<E: EnumRepresentable>: GeneratedPropertyValidator {
	
	private let contract: E.Type
	
	public init(enumType: E.Type) {
		contract = enumType
	}
	
	public var rangeDescription: String {
		return "Enum."
	}
	
	public func validate(_ value: Any) -> Bool {
		return value is E
	}
	
	// MARK: PropertyValueGenerator
	
	public func value(for af: ValidatorAggregateFunc) -> Any {
		let result: E
		
//		let cases = contract.allCases.map {"\($0)"}.sorted()
		let cases = contract.allCases
		assert(cases.count > 0)
		
//		switch af {
//		case .min:
//			result = cases.first!
//		case .max:
//			result = cases.reversed().first!
//		case .random:
			result = contract.allCases.randomElement()!
//		}
	
		return result.rawValue
	}
	
}

// MARK: -

fileprivate func randomNumber(between min: Int, and max: Int) -> Int {
	guard max > min else {
		return max
	}
	
	return Int.random(in: min...max)
}

