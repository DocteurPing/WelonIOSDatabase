//
//  File.swift
//  Welon
//
//  Created by Drping on 17/11/2019.
//  Copyright © 2019 Drping. All rights reserved.
//

import Foundation
import CoreData

public class WelonUser:NSManagedObject, Identifiable {
    @NSManaged public var token:String?
}

extension WelonUser {
    static func getAllWelonUsers() -> NSFetchRequest<WelonUser> {
        let request:NSFetchRequest<WelonUser> = WelonUser.fetchRequest() as! NSFetchRequest<WelonUser>
        let sortDescriptor = NSSortDescriptor(key: "token", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        return request
    }
}
