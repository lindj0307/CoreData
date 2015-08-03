//
//  Bowtie.swift
//  BowTies
//
//  Created by 林东杰 on 15/8/3.
//  Copyright (c) 2015年 Anta. All rights reserved.
//

import Foundation
import CoreData

class Bowtie: NSManagedObject {

    @NSManaged var tintColor: AnyObject
    @NSManaged var timesWorn: NSNumber
    @NSManaged var searchKey: String
    @NSManaged var rating: NSNumber
    @NSManaged var photoData: NSData
    @NSManaged var name: String
    @NSManaged var lastWorn: NSDate
    @NSManaged var isFavorite: NSDate

}
