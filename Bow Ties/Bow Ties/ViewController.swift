//
//  ViewController.swift
//  Bow Ties
//
//  Created by 林东杰 on 15/8/3.
//  Copyright (c) 2015年 Anta. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var timesWornLabel: UILabel!
    @IBOutlet weak var lastWornLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var managedContext: NSManagedObjectContext!
    var currentBowtie: Bowtie!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //1
        insertSampleData()
        
        //2
        let request = NSFetchRequest(entityName: "Bowtie")
        let firstTitle = segmentedControl.titleForSegmentAtIndex(0)
        
        request.predicate = NSPredicate(format: "searchKey == %@", firstTitle!)
        
        //3
        var error: NSError? = nil
        var results = managedContext.executeFetchRequest(request, error: &error) as! [Bowtie]?
        
        //4
        if let bowties = results {
            currentBowtie = bowties[0]
            populate(currentBowtie)
        } else {
            print("Could not fetch\(error),\(error!.userInfo) \n")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func segmentedControl(sender: UISegmentedControl) {
        let selectedValue = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)
        let fetchRequest = NSFetchRequest(entityName: "Bowtie")
        
        fetchRequest.predicate = NSPredicate(format: "searchKey == %@", selectedValue!)
        
        var error: NSError?
        let results = managedContext.executeFetchRequest(fetchRequest, error: &error) as! [Bowtie]?
        
        if let bowties = results {
            currentBowtie = bowties.last!
            populate(currentBowtie)
        } else {
            print("Could not fetch \(error), \(error!.userInfo) \n")
        }
    }

    @IBAction func wear(sender: AnyObject) {
        let times = currentBowtie.timesWorn.integerValue
        currentBowtie.timesWorn = NSNumber(integer: (times + 1))
        currentBowtie.lastWorn = NSDate()
        
        var error: NSError?
        if !managedContext.save(&error) {
            print("Could not save \(error),\(error!.userInfo)")
        }
        populate(currentBowtie)
    }
    
    @IBAction func rate(sender: AnyObject) {
        let alert = UIAlertController(title: "New Rating", message: "Rate this bow tie", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!)  in })
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!)  in
            let textField = alert.textFields![0] as! UITextField
            self.updateRating(numericString: textField.text)
        })
        

        alert.addTextFieldWithConfigurationHandler(nil)
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateRating(#numericString: String) {
        let rating = (numericString as NSString).doubleValue
        currentBowtie.rating = (numericString as NSString).doubleValue
        
        var error: NSError?
        if !managedContext.save(&error) {
            if error!.code == NSValidationNumberTooLargeError ||  error!.code == NSValidationNumberTooSmallError
            {
                print("Could not save \(error) ,\(error!.userInfo)")
            }
        }
        
        populate(currentBowtie)
    }
    
    func populate(bowtie: Bowtie) {
        imageView.image = UIImage(data: bowtie.photoData)
        nameLabel.text = bowtie.name
        ratingLabel.text = "Rating: \(bowtie.rating.doubleValue)/5.0 \n"
        timesWornLabel.text = "# times worn: \(bowtie.timesWorn.integerValue)"
        let dateFormater = NSDateFormatter()
        dateFormater.dateStyle = .ShortStyle
        dateFormater.timeStyle = .NoStyle
        
        lastWornLabel.text = "Last worn: " + dateFormater.stringFromDate(bowtie.lastWorn)
        favoriteLabel.hidden = !bowtie.isFavorite.boolValue
        
        view.tintColor = bowtie.tintColor as! UIColor
    }
    
    func insertSampleData() {
        let fetchRequest = NSFetchRequest(entityName: "Bowtie")
        fetchRequest.predicate = NSPredicate(format: "searchKey != nil")
        let count = managedContext.countForFetchRequest(fetchRequest, error: nil)
        if count > 0 { return }
        
        let path = NSBundle.mainBundle().pathForResource("SampleData", ofType: "plist")
        //此处与书上不一致,需要调整才可以
        if let dataArray = NSArray(contentsOfFile: path!) {
        for dict: AnyObject in dataArray {
            let entity = NSEntityDescription.entityForName("Bowtie", inManagedObjectContext: managedContext)
            
            let bowtie = Bowtie(entity: entity!, insertIntoManagedObjectContext: managedContext)
            let btDict = dict as! NSDictionary
            
            bowtie.name = btDict["name"]  as! String
            bowtie.searchKey = btDict["searchKey"]  as! String
            bowtie.rating = btDict["rating"] as! Double
            let tintColorDict = btDict["tintColor"] as! NSDictionary
            bowtie.tintColor = colorFromDict(tintColorDict)
            let imageName = btDict["imageName"] as! String
            let image = UIImage(named: imageName)
            let photoData = UIImagePNGRepresentation(image)
            bowtie.photoData = photoData
            bowtie.lastWorn = btDict["lastWorn"] as! NSDate
            bowtie.timesWorn = btDict["timesWorn"] as! Int
            bowtie.isFavorite = btDict["isFavorite"] as! Bool
        }
        }
        var error: NSError?
        if !managedContext.save(&error) {
            print("Could not save \(error),\(error!.userInfo)")
        }
        
    }
    
    func colorFromDict(dict: NSDictionary) -> UIColor {
        let red = dict["red"] as! NSNumber
        let green = dict["green"] as! NSNumber
        let blue = dict["blue"] as! NSNumber
        
        let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
        
        return color
    }
    
}





























