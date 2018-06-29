//
//  CompanyListViewController.swift
//  Example
//
//  Created by Anthony on 6/29/18.
//  Copyright © 2018 ReImpl. All rights reserved.
//

import UIKit
import ValidModel

final class CompanyListViewController: UITableViewController {
	
	private enum Segues: String {
		case showCompanyDetails
	}
		
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let knownSegue = Segues(rawValue: segue.identifier ?? "") else {
			super.prepare(for: segue, sender: sender)
			
			return
		}
		
		switch knownSegue {
		case .showCompanyDetails:
			let userListCtrl = segue.destination as! UserListViewController
			
			userListCtrl.company = (sender as! CompanyCell).company
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Companies"
		
		loadTestItems()
	}
	
	var companies: [Company] = []
	
	private func loadTestItems() {
		let generator = ModelGenerator()
		let contract = CompanyContract()
		
		companies = (0...20).map { _ -> Company in
			var company: Company!
			do {
				company = try generator.model(from: contract, aggregate: .random)
			} catch {
				assertionFailure("\(error)")
			}
			return company
			}.sorted()
	}
	
	// MARK: UITableViewDataSource
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return companies.count
	}
	
	private enum Cells: String {
		case companyCell
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let identifier = Cells.companyCell.rawValue
		
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CompanyCell
		
		cell.loadCompany(companies[indexPath.row])
		
		return cell
	}
	
}
