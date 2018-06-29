//
//  CompanyCell.swift
//  Example
//
//  Created by Anthony on 6/29/18.
//  Copyright © 2018 ReImpl. All rights reserved.
//

import UIKit

final class CompanyCell: UITableViewCell {
	
	var company: Company!
	
	func loadCompany(_ company: Company) {
		self.company = company
		
		textLabel?.text = company.name
	}
	
}
