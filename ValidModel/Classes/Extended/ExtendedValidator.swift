//
//  Extended.swift
//  ValidModel
//
//  Created by kernel on 5/13/18.
//  Copyright © 2018 ReImpl. All rights reserved.
//

import Foundation
import Fakery

public struct FirstNameValidator: PropertyValidator {
	
	private let stringValidator = StringValidator(length: (min: 1, max: 30))
	
	public init() { }
	
	public var rangeDescription: String {
		return "FirstName of length: \(stringValidator.minLength) - \(stringValidator.maxLength)"
	}
	
	public func validate(_ value: Any) -> Bool {
		return stringValidator.validate(value)
	}
	
	public func value(for af: ValidatorAggregateFunc) -> Any {
		return faker.name.firstName()
	}
	
}

public struct LastNameValidator: PropertyValidator {
	
	private let stringValidator = StringValidator(length: (min: 1, max: 30))
	
	public init() { }
	
	public var rangeDescription: String {
		return "LastName of length: \(stringValidator.minLength) - \(stringValidator.maxLength)"
	}
	
	public func validate(_ value: Any) -> Bool {
		return stringValidator.validate(value)
	}
	
	public func value(for af: ValidatorAggregateFunc) -> Any {
		return faker.name.lastName()
	}
	
}

public struct EmailValidator: PropertyValidator {
	
	private let stringValidator = StringValidator(length: (min: 5, max: 256))
	
	public init() { }
	
	public var rangeDescription: String {
		return "Email of length: \(stringValidator.minLength) - \(stringValidator.maxLength)"
	}
	
	public func validate(_ value: Any) -> Bool {
		guard stringValidator.validate(value),
			let s = value as? String,
			s.utf8.count >= 5 else {
				return false
		}
		
		let beforeMailSign = s.index(s.startIndex, offsetBy: 1)
		let afterMailSign = s.index(s.startIndex, offsetBy: 3)
		
		let beforeDotSign = s.index(s.endIndex, offsetBy: -3)
		let afterDotSign = s.index(s.endIndex, offsetBy: -1)
		
		guard s[beforeMailSign..<beforeDotSign].contains("@"),
			s[afterMailSign..<afterDotSign].contains(".") else {
				return false
		}
		
		return true
	}
	
	public func value(for af: ValidatorAggregateFunc) -> Any {
		return faker.internet.email()
	}
	
}

fileprivate let faker = Faker()
