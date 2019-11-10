//
//  RestaurantRowItem.swift
//  Welon
//
//  Created by Drping on 10/11/2019.
//  Copyright © 2019 Drping. All rights reserved.
//

import SwiftUI

struct RestaurantRowItem: View {
    var name: String = ""
    var address: String = ""
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                Text(address)
            }
        }
    }
}

struct RestaurantRowItem_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantRowItem(name: "nom du resto", address: "adresse du resrto")
    }
}
