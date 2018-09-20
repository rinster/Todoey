//
//  ViewController.swift
//  Todoey
//
//  Created by Erine Natnat on 9/16/18.
//  Copyright © 2018 Erine Natnat. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    //accessing the model class - an array of item objects
    var itemArray = [Item]()
    
    //tapping into AppDelegate file and accessing the viewcontext of that persistent container
    //then we grab a reference to that context of that persistent container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //this line will print the file path to see the SQlite DB Data File in our hard drive
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        //fetching all the items in the DB
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //this calls the function that will load the data from the data into the itemArray
        loadItems(with: request)
     
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
    
    //MARK: - Table View Delegate Methods - Checkmark & Accessories - UPDATING
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //printing the row that was selected to the console
            //print(indexPath.row)
        //print items list per row
//        print(itemArray[indexPath.row])
        
        //the order of the two lines below matter! Otherwise you will get an 'index out of range' error
        //deletes the item from the persistent container
        context.delete(itemArray[indexPath.row])
        //Removes item from the itemArray
        itemArray.remove(at: indexPath.row)
        
        
        //this toggles the checkmark to either true or false using the not bool operator and reversing what it use to be
        //this line fulfills the UPDATE portion of CRUD
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //this makes the gray hightlight flash instead of linger. Comment out to see the difference!
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - CREATING - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //this var has the scope of the entire addButtonPressed IBAction
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //this indicates what will happen when the user clicks add item in the alert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
        
        //these lines below will save the data to the persistent container
        let newItem = Item(context: self.context)
        newItem.title = textField.text!
        //since the attrib is done, then we need a default value
        //if this is not set then there will be error messages.
        newItem.done = false
            
            
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
        
        do {
            //once you are happy with the updates to your data, then do you save the context
            try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        
        //everytime an item is added, the table view will reload data
        self.tableView.reloadData()
    }
    
    //MARK: READING - Getting items from the DB to display onto the tableview
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest())  {

        do {
            //pushing the stored items into the itemArray
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
}

//MARK: Search bar methods
extension ToDoListViewController : UISearchBarDelegate {
    //when search button is clicked - perform this function
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        
        //Longer version of code prior to refactoring
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
        
         request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
         request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //loading items using the loadItems function so we dont have to do/try/catch again
        loadItems(with: request)
        
    }
}
