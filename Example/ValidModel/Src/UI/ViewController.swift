//
//  ViewController.swift
//  Example
//
//  Created by kernel on 5/13/2018.
//  Copyright © 2018 ReImpl. All rights reserved.
//

import UIKit
import ValidModel

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		loadTestItems()
    }
	
	var users: [User] = []
	
	private func loadTestItems() {
		let mv = ModelValidator()
		let contract = UserContract()
		
		users = (0...100).map { _ -> User in
			try! mv.model(from: contract, aggregate: .random)
			}.sorted()
	}
	
	// MARK: UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
	}
	
	private enum Cells: String {
		case user
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let identifier = Cells.user.rawValue
		
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UserCell
		
		cell.loadUser(users[indexPath.row])
		
		return cell
	}

}

