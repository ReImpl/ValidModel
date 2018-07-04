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
	
	private let sectionTitles: [String] = {
		Product.allCases.map { $0.rawValue }.sorted()
	}()
	private var sectionCompanies: GroupedCompanyMap = [:]
	
	typealias GroupedCompanyMap = [String: [Company]]
	
	private func loadTestItems() {
		let generator = ModelGenerator()
		let contract = CompanyContract()
		
		let companies = (0...20).map { _ -> Company in
			var company: Company!
			do {
				company = try generator.model(from: contract, aggregate: .random)
			} catch {
				assertionFailure("\(error)")
			}
			return company
			}
		
		let groupedCompanies: GroupedCompanyMap = companies.reduce([:]) { resultMap, next in
			let name = next.productType.rawValue
			
			let companies: [Company]
			if let existing = resultMap[name] {
				companies = existing + [next]
			} else {
				companies = [next]
			}
			
			var results = resultMap
			results[name] = companies
			
			return results
		}
		
		var sortedCompanies: GroupedCompanyMap = [:]
		for (key, val) in groupedCompanies {
			sortedCompanies[key] = val.sorted()
		}
		
		sectionCompanies = sortedCompanies
	}
	
	// MARK: UITableViewDataSource
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return sectionTitles.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sectionTitles[section].capitalized
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let title = sectionTitles[section]
		
		return sectionCompanies[title]?.count ?? 0
	}
	
	private enum Cells: String {
		case companyCell
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let title = sectionTitles[indexPath.section]
		
		guard let company = sectionCompanies[title]?[indexPath.row] else {
			assertionFailure("Data processed incorrectly")
			
			return UITableViewCell()
		}
		
		let identifier = Cells.companyCell.rawValue
		
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CompanyCell
		
		cell.loadCompany(company)
		
		return cell
	}
	
}
