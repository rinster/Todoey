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
    
    //creating a file path to the documents folder - to the user's domain mask and save their personal items associated
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        

        print(dataFilePath)
    
        
        loadItems()
     
    }

    //MARK: - Tableview DataSource Methods
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
    
    //MARK: - Table View Delegate Methods - Checkmark & Accessories
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //printing the row that was selected to the console
            //print(indexPath.row)
        //print items list per row
//        print(itemArray[indexPath.row])
        
        //this toggles the checkmark to either true or false using the not bool operator and reversing what it use to be
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //this makes the gray hightlight flash instead of linger. Comment out to see the difference!
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
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
            
            self.saveItems()
            
        }
        
        //MARK: adding information through a MODAL alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            
            //line below so var textField can access the information inside the closure
            //this extends the scope to our addButtonPressed
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems()  {
        let encoder =  PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        //everytime an item is added, the table view will reload data
        self.tableView.reloadData()
    }
    
    func loadItems()  {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
             print("Error encoding item array, \(error)")
        }
    }

    }
}
