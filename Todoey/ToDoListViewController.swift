//
//  ViewController.swift
//  Todoey
//
//  Created by Erine Natnat on 9/16/18.
//  Copyright © 2018 Erine Natnat. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demagorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
     
    }

    //MARK - Tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //printing the row that was selected to the console
            //print(indexPath.row)
        //print items list per row
//        print(itemArray[indexPath.row])
        
        //this creates or removes the checkmark accessory
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //this makes the gray hightlight flash instead of linger. Comment out to see the difference!
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

