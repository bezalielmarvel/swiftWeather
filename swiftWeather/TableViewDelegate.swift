//
//  TableViewDelegate.swift
//  swiftWeather
//
//  Created by Bezaliel Marvel on 06/06/2019.
//  Copyright © 2019 Bezaliel Marvel. All rights reserved.
//

import UIKit

class TableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
 
    //let cellReuseIdentifier = "detailCell"

    
    var data = [String]()
    
    // variable that holds a stores a function
    // which return Void but accept an Int and a UITableViewCell as arguments.
    var didSelectRow: ((_ dataItem: String, _ cell: UITableViewCell) -> Void)?
    
    init(data: [String]) {
        self.data = data
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
        //tableView.register("detailCell", forCellReuseIdentifier: "cell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let text = String(data[indexPath.row])
        cell.textLabel?.text = text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)!
        let dataItem = data[indexPath.row]
        
        if let didSelectRow = didSelectRow {
            // Calling didSelectRow that was set in ViewController.
            didSelectRow(dataItem, cell)
        }
    }

}
