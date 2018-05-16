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
		nameLabel.text = "\(user.firstName) \(user.lastName)".capitalized
		
		emailLabel.text = user.email.lowercased()
		
		rankLabel.text = "Rank: \(user.rank)"
	}
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var rankLabel: UILabel!
	
}
