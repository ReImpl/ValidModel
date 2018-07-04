//
//  Company.swift
//  Example
//
//  Created by Anthony on 6/28/18.
//  Copyright © 2018 ReImpl. All rights reserved.
//

import ValidModel

struct CompanyContract: ModelContract {
	
	typealias M = Company
	typealias P = PropertyPolicy
	
	let name: P = (\M.name, CompanyNameValidator())
	let users: P = (\M.users, ArrayValidator(capacity: (min: 1, max: 100), contract: UserContract()))
	
	let productType: P = (\M.productType, EnumValidator(enumType: Product.self))
	
}

struct Company: Decodable {
	
	let name: String
	let users: [User]
	let productType: Product
	
}

extension Company: Comparable {
	
	static func < (lhs: Company, rhs: Company) -> Bool {
		if lhs.productType == rhs.productType {
			return lhs.name < rhs.name
		} else {
			return lhs.productType < rhs.productType
		}
	}
	
	static func == (lhs: Company, rhs: Company) -> Bool {
		if lhs.productType == rhs.productType {
			return lhs.name == rhs.name
		} else {
			return lhs.productType < rhs.productType
		}
	}
	
}

// MARK: - Product

enum Product: String, EnumRepresentable, Equatable {
	case space
	case avionics
	case machinery
	case aviation
	case military
}

extension Product: Comparable {
	
	static func < (lhs: Product, rhs: Product) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
	
	static func == (lhs: Product, rhs: Product) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}
	
}

