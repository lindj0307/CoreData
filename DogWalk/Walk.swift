//
//  Walk.swift
//  DogWalk
//
//  Created by 林东杰 on 9/2/15.
//  Copyright (c) 2015 anta. All rights reserved.
//

import Foundation
import CoreData

class Walk: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var dog: Dog

}
