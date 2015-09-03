//
//  Dog.swift
//  DogWalk
//
//  Created by 林东杰 on 9/2/15.
//  Copyright (c) 2015 anta. All rights reserved.
//

import Foundation
import CoreData

class Dog: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var walks: NSOrderedSet

}
