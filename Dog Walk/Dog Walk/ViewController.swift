//
//  ViewController.swift
//  Dog Walk
//
//  Created by 林东杰 on 8/31/15.
//  Copyright (c) 2015 anta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var walks:Array<NSDate> = []
    
    @IBOutlet weak var tableView2: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView2.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func tableView2(tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return walks.count
    }
    
    func tableView2(tableView: UITableView,titleForHeaderInSection section: Int) -> String? {
        return "List of Walks"
    }
    
    func tableView2(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .MediumStyle
        
        let date = walks[indexPath.row]
        cell.textLabel!.text = dateFormatter.stringFromDate(date)
        
        return cell
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func add(sender: AnyObject) {
        walks.append(NSDate())
        tableView2.reloadData()
    }
}

