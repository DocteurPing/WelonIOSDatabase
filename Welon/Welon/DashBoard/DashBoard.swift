//
//  DashBoard.swift
//  Welon
//
//  Created by Drping on 02/11/2019.
//  Copyright © 2019 Drping. All rights reserved.
//

import SwiftUI

struct DashBoard: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Restaurant.getAllRestaurants()) var restaurants:FetchedResults<Restaurant>
    
    var body: some View {
        List {
            Section(header: Text("Restaurants")) {
                ForEach(self.restaurants) { restaurant in
                    RestaurantRowItem(name: restaurant.name!, address: restaurant.address!)
                }
            }
            Text("test")
        }
    }
}

struct DashBoard_Previews: PreviewProvider {
    static var previews: some View {
        DashBoard()
    }
}
