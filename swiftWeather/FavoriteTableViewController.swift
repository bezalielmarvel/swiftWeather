//
//  FavoriteTableViewController.swift
//  swiftWeather
//
//  Created by Bezaliel Marvel on 17/05/2019.
//  Copyright © 2019 Bezaliel Marvel. All rights reserved.
//

import UIKit
import Weather

class FavoriteTableViewController: UITableViewController {

    static var favCities: [City] = []
    
    let cellReuseIdentifier = "cell"
    
    var selectedCity: City!
    
    var wc: WeatherClient = WeatherClient(key: "057235dd5c2aec8dee5db666fe163476")
    
    @IBOutlet var favTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        //UserDefaults.se
//        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//        backgroundImage.image = UIImage(named: "clouds-bg")
//        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
//        self.view.insertSubview(backgroundImage, at: 0)
        //self.view.backgroundColor = UIColor.black
        // It is possible to do the following three things in the Interface Builder
        // rather than in code if you prefer.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if FavoriteTableViewController.favCities.isEmpty {
            showInputDialog()
        }
    }
    
    // number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoriteTableViewController.favCities.count
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        wc.weather(for: FavoriteTableViewController.favCities[indexPath.row]) { (forecast) in
            DispatchQueue.main.async {
                let temperatureAvg = Int((forecast?.temperature)!)
                let str = forecast?.weather.description
                let string = str!.replacingOccurrences(of: "[(title: \"", with: "")
                if let range = string.range(of: "description") {
                    let firstPart = string[string.startIndex..<range.lowerBound]
                    let weatherName = firstPart.replacingOccurrences(of: "\",", with: "")
                    
//                    self.modifyBasedOnWeather(weatherName: weatherName, tempMax: temperatureMax, tempMin: temperatureMin)
                }
            }
            
        }
        //cell.backgroundView = UIImageView(image: UIImage(named: "clear-bg.png")!)

        cell.textLabel?.text = "\(FavoriteTableViewController.favCities[indexPath.row].name), \(FavoriteTableViewController.favCities[indexPath.row].country)"
        cell.textLabel?.textColor = UIColor.black
        
        
        return cell
    }
    
//    // method to run when table view cell is tapped
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        print("You tapped cell number \(indexPath.row).")
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CityViewController {
            destination.selectedCity = FavoriteTableViewController.favCities[(favTableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let selectedCity = wc.citiesSuggestions(for: resultSearchController.searchBar.text!)[indexPath.row]
        performSegue(withIdentifier: "backtocityview", sender: self)
        
    }
    
    // this method handles row deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // remove the item from the data model
            FavoriteTableViewController.favCities.remove(at: indexPath.row)
            
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            
            // Not used in our example, but if you were adding a new row, this is where you would do it.
        }
    }
    
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Favorites", message: "You currently have no favorite city. Please use the add button to add a city to your favorites", preferredStyle: .alert)
    
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
