//
//  FavoriteSearchTableViewController.swift
//  swiftWeather
//
//  Created by Bezaliel Marvel on 01/06/2019.
//  Copyright © 2019 Bezaliel Marvel. All rights reserved.
//

import UIKit
import Weather

class FavoriteSearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var favCityTable: UITableView!
    
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
        // #warning Incomplete implementation, return the number of sections
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
    
        if let destination = segue.destination as? FavoriteTableViewController {
            destination.selectedCity = wc.citiesSuggestions(for: resultSearchController.searchBar.text!)[(favCityTable.indexPathForSelectedRow?.row)!]
        }
    
        FavoriteTableViewController.favCities.append(wc.citiesSuggestions(for: resultSearchController.searchBar.text!)[(favCityTable.indexPathForSelectedRow?.row)!])
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let selectedCity = wc.citiesSuggestions(for: resultSearchController.searchBar.text!)[indexPath.row]
        let fileName = "favCities"
        let selectedCity = wc.citiesSuggestions(for: resultSearchController.searchBar.text!)[(favCityTable.indexPathForSelectedRow?.row)!]
        
        let dir = try? FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask, appropriateFor: nil, create: true)
        var inString = String()
        
        if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("txt") {
            
            // Then reading it back from the file
            do {
                inString = try String(contentsOf: fileURL)
            } catch {
                print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
            }
        }
        
        let text = inString + selectedCity.name + ";" + selectedCity.identifier.description + "\n"
        

        //print(dir)
        // If the directory was found, we write a file to it and read it back
        if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("txt") {
            
            // Write to the file named Test
            do {
                try text.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }
        }
        //print(text)
        
        performSegue(withIdentifier: "showfavorite", sender: self)
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
