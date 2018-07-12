//
//  UserCell.swift
//  Example
//
//  Created by kernel on 5/13/18.
//  Copyright © 2018 ReImpl. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
	
	func loadUser(_ user: User) {
		emailLabel.text = user.email.lowercased()
		nameLabel.text = "\(user.firstName) \(user.lastName)".capitalized
		
		let date = dateFormatter.string(from: user.hiredDate)
		hiredLabel.text = "Hired: \(date)"
		rankLabel.text = "Rank: \(user.rank)"
	}
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var hiredLabel: UILabel!
	@IBOutlet weak var rankLabel: UILabel!
	
}

fileprivate let dateFormatter: DateFormatter = {
	let df = DateFormatter()
	
	df.dateStyle = .medium
	
	return df
}()
