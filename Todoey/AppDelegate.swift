//
//  AppDelegate.swift
//  Todoey
//
//  Created by Erine Natnat on 9/16/18.
//  Copyright © 2018 Erine Natnat. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        return true
    }

    
    func applicationWillTerminate(_ application: UIApplication) {
      
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    //this NSPersistentContainer is where we are going to store all of our data (similar to a SQLite DB)
    lazy var persistentContainer: NSPersistentContainer = {
        
        //create a constant 'container' that sets up Persistent container with the name of our data model
        let container = NSPersistentContainer(name: "DataModel")
        //then load the persistent store and get it ready for use
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        //log any errors if there is any
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        //if no errors return the container called persistent container
        return container
    }()
    
    // MARK: - Core Data Saving support
    //this provides support in case our application gets terminated
    //context is the staging area and until we're ready or there are changes do we actually commit the data
    func saveContext () {
        let context = persistentContainer.viewContext
        //area where you can change and update your data
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

