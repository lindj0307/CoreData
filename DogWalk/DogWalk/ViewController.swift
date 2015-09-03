//
//  ViewController.swift
//  DogWalk
//
//  Created by 林东杰 on 8/31/15.
//  Copyright (c) 2015 anta. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    //var walks: Array<NSDate> = []
    var currentDog:Dog!
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //Insert Dog entity
        let dogEntity = NSEntityDescription.entityForName("Dog", inManagedObjectContext: managedContext)
        
        let dog = Dog(entity: dogEntity!, insertIntoManagedObjectContext: managedContext)
        
        let dogName = "Fido"
        let dogFetch = NSFetchRequest(entityName: "Dog")
        dogFetch.predicate = NSPredicate(format: "name == %@", dogName)
        
        var error: NSError?
        let result = managedContext.executeFetchRequest(dogFetch, error: &error) as! [Dog]?
        
        if let dogs = result {
            if dogs.count == 0 {
                currentDog = Dog(entity: dogEntity!, insertIntoManagedObjectContext: managedContext)
                currentDog.name = dogName
                
                if !managedContext.save(&error) {
                    print("Could not save:\(error)\n")
                }
            } else {
                currentDog = dogs[0]
            }
        } else {
            print("Could not fetch: \(error)\n")
        }
    }
    
    func tableView(tableView: UITableView,numberOfRowsInSection section:Int) -> Int {
        var numRows = 0
        if let dog = currentDog {
            numRows = dog.walks.count
        }
        return numRows
    }
    
    func tableView(tableView: UITableView,titleForHeaderInSection section: Int) -> String? {
        return "List of Walks"
    }
    
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .MediumStyle
        
        //let date = walks[indexPath.row]
        let walk = currentDog.walks[indexPath.row] as! Walk
        cell.textLabel!.text = dateFormatter.stringFromDate(walk.date)
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            //1
            let walkToRemove = currentDog.walks[indexPath.row] as! Walk
            
            //2
            let walks = currentDog.walks.mutableCopy() as! NSMutableOrderedSet
            walks.removeObjectAtIndex(indexPath.row)
            currentDog.walks = walks.copy() as! NSOrderedSet
            
            //3
            managedContext.deletedObjects(walkToRemove)
            
            //4
            var error: NSError?
            if !managedContext.save(&error) {
                print("Could not save: \(error)")
            }
            
            //5
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func add(sender: AnyObject) {
        //walks.append(NSDate())
        //Insert new Walk entity into Core Data
        let walkEntity = NSEntityDescription.entityForName("Walk", inManagedObjectContext: managedContext)
        let walk = Walk(entity: walkEntity!,insertIntoManagedObjectContext: managedContext)
        
        walk.date = NSDate()
        
        var walks = currentDog.walks.mutableCopy() as! NSMutableOrderedSet
        
        walks.addObject(walk)
        currentDog.walks = walks.copy() as! NSOrderedSet
        
        var error: NSError?
        if !managedContext!.save(&error) {
            print("Could not save:\(error)")
        }
        
        tableView.reloadData()
        
    }

}

