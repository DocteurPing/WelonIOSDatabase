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
    
    var body: some View {
        VStack {
            Image("bar")
                .resizable()
                .aspectRatio(contentMode: .fit)
            HStack {
                Text(name)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .font(.system(size: 15))
                Spacer()
            }
        }.cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.sRGB, red: 255/255, green: 255/255, blue: 255/255, opacity: 0.1), lineWidth: 1)
        )
            .padding()
    }
}

struct RestaurantRowItem_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantRowItem(name: "nom du resto")
    }
}
