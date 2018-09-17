//
//  ViewController.swift
//  Todoey
//
//  Created by Erine Natnat on 9/16/18.
//  Copyright © 2018 Erine Natnat. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demagorgon"]
    
    //access the USER DEFAULTS - this is an interface to the user's defaults where you store key value pairs persistently across the launches of your app
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting the item array to match what's saved in the user defaults
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArray = items
        }
     
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
    
    //MARK - Table View Delegate Methods - Checkmark & Accessories
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
    
    //MARK - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //this var has the scope of the entire addButtonPressed IBAction
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //this indicates what will happen when the user clicks add item in the alert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add Item button
            //if user adds empty textfield, it will be an empty cell
            self.itemArray.append(textField.text!)
            
            //also saving the item into the user defaults var
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //everytime an item is added, the table view will reload data
            self.tableView.reloadData()
        }
        
        //adding information through an alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            
            //line below so var textField can access the information inside the closure
            //this extends the scope to our addButtonPressed
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

