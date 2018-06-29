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
	
}

struct Company: Decodable {
	
	let name: String
	let users: [User]
	
}

extension Company: Comparable {
	
	static func < (lhs: Company, rhs: Company) -> Bool {
		return lhs.name < rhs.name
	}
	
	static func == (lhs: Company, rhs: Company) -> Bool {
		return lhs.name == rhs.name
	}
	
}

