//
//  ModelContract.swift
//  ValidModel
//
//  Created by kernel on 5/13/18.
//  Copyright © 2018 ReImpl. All rights reserved.
//

import Foundation

public typealias PropertyPolicy = (AnyKeyPath, PropertyValidator)

public protocol ModelContract {
	
}

// MARK: - ModelValidator

final public class ModelValidator {
	
	public init() { }
	
	public func validate<T: Decodable>(_ model: T, using contract: ModelContract) throws -> Bool {
		let properties = mirrorProperties(for: contract)
		
		for (propertyName, policy) in properties {
			let keyPath = policy.0
			let validator = policy.1
			
			guard let value = model[keyPath: keyPath] else {
				throw ValidationError.emptyValueNotAllowed(String(describing: keyPath))
			}
			
			guard validator.validate(value) else {
				assertionFailure("""
					Failed to validate model '\(String(describing: T.self))'.
					Property '\(propertyName)' value out of valid bounds. Value: \(value).
					Validator range: \(validator.rangeDescription).
					""")
				
				return false
			}
		}
		
		return true
	}
	
	public func model<T: Decodable>(from contract: ModelContract, aggregate af: ValidatorAggregateFunc) throws -> T {
		let jsonDict = dict(from: contract, aggregate: af)
		let json = try JSONSerialization.data(withJSONObject: jsonDict)
		
		return try JSONDecoder().decode(T.self, from: json)
		
		//			let modelName = String(describing: T.self)
		//			let contractName = String(describing: contract.self)
		//
		//			assertionFailure("""
		//				Failed to create model '\(modelName)' using '\(contractName)' contract.
		//				All model properties have to be mapped & validated in a contract.
		//				Deserialization error: \(error)
		//				""")
	}
	
	public enum ValidationError: Error {
		case emptyValueNotAllowed(String)
	}
	
	// MARK: - Private
	
	private typealias JsonDict = [String: Any]
	
	private func dict(from contract: ModelContract, aggregate af: ValidatorAggregateFunc) -> JsonDict {
		return mirrorProperties(for: contract).mapValues { policy in
			return policy.1.value(for: af)
		}
	}
	
	private func mirrorProperties(for obj: Any) -> [String: PropertyPolicy] {
		var policies: [String: PropertyPolicy] = [:]
		
		let mirror = Mirror(reflecting: obj)
		
		for p in mirror.children {
			guard let propertyName = p.label,
				let policy = p.value as? PropertyPolicy else {
					assertionFailure("Value of the property named: '\(String(describing: p.label))' should be a PropertyPolicy instance.")
					
					continue
			}
			
			policies[propertyName] = policy
		}
		
		return policies
	}
	
}
