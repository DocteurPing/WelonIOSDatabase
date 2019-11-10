//
//  Restaurant.swift
//  Welon
//
//  Created by Drping on 02/11/2019.
//  Copyright © 2019 Drping. All rights reserved.
//

import Foundation
import CoreData

public class Restaurant:NSManagedObject, Identifiable {
    @NSManaged public var serverId:String?
    @NSManaged public var name:String?
    @NSManaged public var address:String?
}

extension Restaurant {
    static func getAllRestaurants() -> NSFetchRequest<Restaurant> {
        let request:NSFetchRequest<Restaurant> = Restaurant.fetchRequest() as! NSFetchRequest<Restaurant>
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        return request
    }
}
