//
//  CustomerListViewController.swift
//  customerList
//
//  Created by Rohit Rajput on 27/04/18.
//  Copyright © 2018 Rohit Rajput. All rights reserved.
//

import UIKit

class CustomerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    let cellID = "CustomerCell"
    var database: SQLiteDatabase!
    
    // Mark: - Instantiating UISearchController
    let searchController = UISearchController(searchResultsController: nil)
    // to store Filtered Names During Search
    var filteredCustomer = [Customer]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        sortButton.isEnabled = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // To initialize a database customer array so that it doesn't return nil and cause a crash
        let customer = BirdeyeService.instance.customer
        database = SQLiteDatabase(customer)
        
        BirdeyeService.instance.getCustomer { (success) in
            if success {
                DispatchQueue.main.async {
                    self.sortButton.isEnabled = true
                    let customer = BirdeyeService.instance.customer
                    self.database = SQLiteDatabase(customer)
                    self.tableView.reloadData()
                }
            }
        }
        // Notify Observer for Newly Added Customer Data
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NOTIFY_ADDED_DATA, object: nil)
    }
    
    @IBAction func sortButtonDidPress(_ sender: Any) {
        
    }
    // Mark: - TableView Setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredCustomer.count
        }
        return database.customer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CustomerListTableViewCell {
            
            let person: Customer
            if isFiltering() {
                person = filteredCustomer[indexPath.row]
            } else {
                person = database.customer[indexPath.row]
            }
            
            DispatchQueue.main.async {
                cell.configureCell(person: person)
            }
            return cell
        } else {
            return UITableViewCell()
        }    }
    
    // Mark: - Swipe to delete row function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Get the customer number
            let number = BirdeyeService.instance.customer[indexPath.row].number
            BirdeyeService.instance.customer.remove(at: indexPath.row)
            database.customer.remove(at: indexPath.row)
            
            // Delete customer from API
            BirdeyeService.instance.deletePerson(number: number!) { (success) in
                if success{
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc func reload() {
        let customer = BirdeyeService.instance.customer
        self.database = SQLiteDatabase(customer)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}




extension CustomerListViewController : UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    // Setup the Search Controller
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Names"
        searchController.searchBar.tintColor = UIColor.white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Customize search bar text field
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.black
           
            if let backgroundview = textfield.subviews.first {
                // Background color
                backgroundview.backgroundColor = UIColor.white
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        
    }
    
    // MARK: - Private instance methods
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCustomer = database.customer.filter({ (person: Customer) -> Bool in
            return person.firstName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

