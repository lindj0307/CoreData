//
//  CoreDataStack.swift
//  DogWalk
//
//  Created by 林东杰 on 9/1/15.
//  Copyright (c) 2015 anta. All rights reserved.
//

import CoreData


class CoreDataStack {
    let context:NSManagedObjectContext
    let psc:NSPersistentStoreCoordinator
    let model:NSManagedObjectModel
    let store:NSPersistentStore
    
    //This is a simple helper method that returns a URL to your application's documents directory.
    //Store the SQLite database(which is simply a file) in the documents directory.
    class func applicationDocumentsDirectory() -> NSURL {
        let fileManager = NSFileManager.defaultManager()
        
        let urls = fileManager.URLsForDirectory(.DocumentationDirectory, inDomains: .UserDomainMask) as! [NSURL]
        
        return urls[0]
    }
    
    init() {
        //1
        let bundle = NSBundle.mainBundle()
        let modelURL = bundle.URLForResource("DogWalk", withExtension: "momd")
        model = NSManagedObjectModel(contentsOfURL: modelURL!)!
        
        //2
        psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        //3
        context = NSManagedObjectContext()
        context.persistentStoreCoordinator = psc
        
        //4
        let documentsURL = CoreDataStack.applicationDocumentsDirectory()
        let storeURL = documentsURL.URLByAppendingPathComponent("DogWalk")
        
        let options = [NSMigratePersistentStoresAutomaticallyOption: true]
        
        var error: NSError? = nil
        store = psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options, error: &error)!
        
        //error
//        if store == nil {
//            print("Error adding persistent store: \(error)\n")
//            abort()
//        }
    }
    
    func saveContext() {
        var error: NSError? = nil
        if context.hasChanges && !context.save(&error) {
            print("Could not save:\(error),\(error?.userInfo)")
        }
    }
    
}























