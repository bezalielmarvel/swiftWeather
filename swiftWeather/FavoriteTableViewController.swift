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
    var favStrings: [String] = []
    
    let cellReuseIdentifier = "cell"
    
    var selectedCity: City!
    
    var wc: WeatherClient = WeatherClient(key: "057235dd5c2aec8dee5db666fe163476")
    
    @IBOutlet var favTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    // number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let fileName = "favCities"
        
        let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        var inString = String()
        
        if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("txt") {
            
            // Then reading it back from the file
            do {
                inString = try String(contentsOf: fileURL)
                let cityLine = inString.components(separatedBy: .newlines)
                favStrings = cityLine
         
            } catch {
                print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
            }
        }
        
        return self.favStrings.count - 1
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        //cell.backgroundView = UIImageView(image: UIImage(named: "clear-bg.png")!)
        
        let fileName = "favCities"
        
        let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        var inString = String()
        
        if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("txt") {
            
            // Then reading it back from the file
            do {
                inString = try String(contentsOf: fileURL)
                let cityLine = inString.components(separatedBy: .newlines)
                favStrings = cityLine
              
            } catch {
                print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
            }
        }
        
        let favStringsTab = favStrings[indexPath.row].components(separatedBy: ";")

        cell.textLabel?.text = "\(transformIDtoCity(cityName: favStringsTab[0], cityID: favStringsTab[1]).name), \(transformIDtoCity(cityName: favStringsTab[0], cityID: favStringsTab[1]).country)"
        
        if !favStringsTab.isEmpty {
            wc.weather(for: transformIDtoCity(cityName: favStringsTab[0], cityID: favStringsTab[1])) { (forecast) in
            //print(forecast)
                DispatchQueue.main.async {
                    let str = forecast?.weather.description
                
                    let string = str!.replacingOccurrences(of: "[(title: \"", with: "")
                    if let range = string.range(of: "description") {
                        let firstPart = string[string.startIndex..<range.lowerBound]
                        let weatherName = firstPart.replacingOccurrences(of: "\",", with: "")
                        
                        let clouds = "Clouds"
                        let clear = "Clear"
                        let rain = "Rain"
                        let snow = "Snow"
                        let drizzle = "Drizzle"
                        let thunderstorm = "Thunderstorm"
                        
                        if weatherName.contains(clouds) {
                            
                            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
                            backgroundImage.image = UIImage(named: "clouds-bg")
                            cell.backgroundView = backgroundImage
                        }
                        else if weatherName.contains(clear) {
                            
                            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
                            backgroundImage.image = UIImage(named: "clear-bg")
                            cell.backgroundView = backgroundImage
                           
                            
                        }
                        else if weatherName.contains(snow) {
                           
                            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
                            backgroundImage.image = UIImage(named: "snow-bg")
                            cell.backgroundView = backgroundImage
                            
                        }
                        else if weatherName.contains(rain) {
                            
                            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
                            backgroundImage.image = UIImage(named: "rain-bg")
                            cell.backgroundView = backgroundImage
                        }
                        else if weatherName.contains(drizzle) {
                           
                            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
                            backgroundImage.image = UIImage(named: "drizzle-bg")
                            cell.backgroundView = backgroundImage
                        }
                        else if weatherName.contains(thunderstorm) {
                            
                            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
                            backgroundImage.image = UIImage(named: "thunderstorm-bg")
                            cell.backgroundView = backgroundImage
                        }
                        else {
                            
                            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
                            backgroundImage.image = UIImage(named: "else-bg")
                            cell.backgroundView = backgroundImage
                        }

                    }
                }
            }
        }
        
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "Avenir-Medium", size: 25)
 
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0;//Choose your custom row height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CityViewController {
//            destination.selectedCity = FavoriteTableViewController.favCities[(favTableView.indexPathForSelectedRow?.row)!]
            let favStringsTab = favStrings[(favTableView.indexPathForSelectedRow?.row)!].components(separatedBy: ";")
            destination.selectedCity = transformIDtoCity(cityName: favStringsTab[0], cityID: favStringsTab[1])
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let selectedCity = wc.citiesSuggestions(for: resultSearchController.searchBar.text!)[indexPath.row]
        performSegue(withIdentifier: "backtocityview", sender: self)
        
    }
    
    // this method handles row deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let fileName = "favCities"
        let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        if editingStyle == .delete {
            
            // remove the item from the data model
            
            //FavoriteTableViewController.favCities.remove(at: indexPath.row)
            
            var inString = String()
            
            if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("txt") {
                
                // Then reading it back from the file
                do {
                    inString = try String(contentsOf: fileURL)
                    let cityLine = inString.components(separatedBy: .newlines)
                    favStrings = cityLine
                } catch {
                    print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
                }
            }
            
            favStrings.remove(at: indexPath.row)
            
            let stringRepresentation = favStrings.joined(separator:"\n")
            
            // If the directory was found, we write a file to it and read it back
            if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("txt") {
                
                // Write to the file named Test
                do {
                    try stringRepresentation.write(to: fileURL, atomically: true, encoding: .utf8)
                } catch {
                    print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
                }
            }
            
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
    
    func transformIDtoCity(cityName: String, cityID: String) -> City {
        
        var chosenCity = wc.citiesSuggestions(for: "Paris")[1]
        let cityArray = wc.citiesSuggestions(for: cityName)
        for city in cityArray {
            let cityID1 = Int(city.identifier).description
            if cityID1 == cityID {
                chosenCity = city
            }
        }
        return chosenCity
    }
    
}
