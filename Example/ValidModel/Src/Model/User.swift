//
//  User.swift
//  Example
//
//  Created by kernel on 5/13/18.
//  Copyright © 2018 ReImpl. All rights reserved.
//

import ValidModel

struct UserContract: ModelContract {
	
	typealias M = User
	typealias P = PropertyPolicy
	
	let firstName: P = (\M.firstName, FirstNameValidator())
	let lastName: P = (\M.lastName, LastNameValidator())
	let email: P = (\M.email, EmailValidator())
	
	let rank: P = (\M.rank, IntValidator(inRange: (min: 1, max: 100)))
	let hiredDate: P = (\M.hiredDate, DateValidator(inRange: (min: fiveYearsAgo, max: Date())))
	
}

struct User: Decodable {
	
	let firstName: String
	let lastName: String
	let email: String
	
	let rank: Int
	let hiredDate: Date
	
}

extension User: Comparable {
	
	static func < (lhs: User, rhs: User) -> Bool {
		return (lhs.firstName, lhs.lastName) < (rhs.firstName, rhs.lastName)
	}
	
	static func == (lhs: User, rhs: User) -> Bool {
		return lhs.email == rhs.email
	}
	
}

fileprivate let fiveYearsAgo = Date(timeIntervalSinceNow: -5 * 365 * 24 * 3600)
