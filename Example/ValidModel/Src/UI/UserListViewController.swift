//
//  ViewController.swift
//  Example
//
//  Created by kernel on 5/13/2018.
//  Copyright © 2018 ReImpl. All rights reserved.
//

import UIKit
import ValidModel

class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	var company: Company!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		assert(company != nil, "'company' must be set by presenting view ctrl.")
    }
	
	// MARK: UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return company.users.count
	}
	
	private enum Cells: String {
		case userCell
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let identifier = Cells.userCell.rawValue
		
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UserCell
		
		cell.loadUser(company.users[indexPath.row])
		
		return cell
	}

}

