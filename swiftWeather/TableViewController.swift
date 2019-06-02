//
//  TableViewController.swift
//  swiftWeather
//
//  Created by Bezaliel Marvel on 10/05/2019.
//  Copyright © 2019 Bezaliel Marvel. All rights reserved.
//

import UIKit
import Weather

class TableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var tblCitySearch: UITableView!
    
    var tableData = [String]()
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    
    var wc: WeatherClient = WeatherClient(key: "057235dd5c2aec8dee5db666fe163476")
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredTableData.removeAll(keepingCapacity: false)
        tableData.removeAll()
        
        for city in wc.citiesSuggestions(for: searchController.searchBar.text!) {
            tableData.append(city.name + " - " + city.country)
        }
        
        //let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        //let array = (tableData as NSArray).filtered(using: searchPredicate)
        filteredTableData = tableData
        
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        // Reload the table
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        if  (resultSearchController.isActive) {
            return filteredTableData.count
        } else {
            return tableData.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if (resultSearchController.isActive) {
            cell.textLabel?.text = filteredTableData[indexPath.row]
            
            return cell
        }
        else {
            cell.textLabel?.text = tableData[indexPath.row]
            print(tableData[indexPath.row])
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CityViewController {
            destination.selectedCity = wc.citiesSuggestions(for: resultSearchController.searchBar.text!)[(tblCitySearch.indexPathForSelectedRow?.row)!]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let selectedCity = wc.citiesSuggestions(for: resultSearchController.searchBar.text!)[indexPath.row]
        performSegue(withIdentifier: "showdetail", sender: self)
        
    }
    
    
    
}
