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
    @FetchRequest(fetchRequest: WelonUser.getAllWelonUsers()) var users:FetchedResults<WelonUser>
    
    var body: some View {
        VStack {
            HStack {
                Text("RESTAURANTS")
                    .font(.system(size: 30))
                Spacer()
                Image("profile")
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
            }.padding(.bottom, 20)
            ScrollView {
                VStack {
                    ForEach(self.restaurants) { restaurant in
                        RestaurantRowItem(name: restaurant.name!, address: restaurant.address!)
                    }
                }
            }
        }.padding()
    }
}

struct DashBoard_Previews: PreviewProvider {
    static var previews: some View {
        DashBoard()
    }
}
