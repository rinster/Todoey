//
//  ViewController.swift
//  Todoey
//
//  Created by Erine Natnat on 9/16/18.
//  Copyright © 2018 Erine Natnat. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    //accessing the model class - an array of item objects
    var itemArray = [Item]()
    
    //access the USER DEFAULTS - this is an interface to the user's defaults where you store key value pairs persistently across the launches of your app
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem.title = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem.title = "Destroy Demagorgon"
        itemArray.append(newItem3)
        
        //setting the item array to match what's saved in the user defaults
        //accessing the userDefaults as an array of items
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
     
    }

    //MARK - Tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary Operator ===>
        //value = condition ? valueIfTrue : valueIfFalse
        //one line expression that does the same below
        // cell.accessoryType = item.done ? .checkmark : .none
        
        if item.done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    //MARK - Table View Delegate Methods - Checkmark & Accessories
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //printing the row that was selected to the console
            //print(indexPath.row)
        //print items list per row
//        print(itemArray[indexPath.row])
        
        //this toggles the checkmark to either true or false using the not bool operator and reversing what it use to be
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //reload the data so that the checkmarks appear
        tableView.reloadData()
        
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
            
            let newItem = Item()
            newItem.title = textField.text!
            
            //what will happen once the user clicks the add Item button
            //if user adds empty textfield, it will be an empty cell
            self.itemArray.append(newItem)
            
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

