//
//  LoginView.swift
//  Welon
//
//  Created by Drping on 21/10/2019.
//  Copyright © 2019 Drping. All rights reserved.
//

import SwiftUI

struct AppContentView: View {
    
    @State var isLogin = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Restaurant.getAllRestaurants()) var restaurants:FetchedResults<Restaurant>
    
    var body: some View {
        return Group {
            if isLogin {
                DashBoard()
            }
            else {
                LoginView(isLogin: $isLogin)
            }
        }
    }
}


struct LoginView: View {
    @ObservedObject var keyboard = KeyboardResponder()
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var isLogin: Bool
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Restaurant.getAllRestaurants()) var restaurants:FetchedResults<Restaurant>
    
    var body: some View {
        VStack {
            Image("logo_green")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 50).padding(.top, 0)
            Image("chef")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 50)
                .padding(.top, 50)
            TextField("Email", text: $email)
                .padding(.horizontal, 50)
                .padding(.top, 50)
            Divider()
                .padding(.horizontal, 50)
            SecureField("Mot de passe", text: $password)
                .padding(.horizontal, 50)
                .padding(.top, 10)
            Divider()
                .padding(.horizontal, 50)
            Button(action: {
                self.nukeTables()
                let restauranttopush = Restaurant(context: self.managedObjectContext)
                restauranttopush.name = "toto"
                restauranttopush.address = "tata"
                do {
                    try self.managedObjectContext.save()
                } catch {
                    print(error)
                }
                self.login(email: self.email, password: self.password)
            }){
                Text("SE CONNECTER").padding().foregroundColor(.white).background(Color.init(red: 0.00, green: 0.78, blue: 0.32))
            }
            .cornerRadius(40).padding(.top, 80)
        }
        .padding(.bottom, self.keyboard.currentHeight)
        .animation(.easeOut(duration: 0.16))
    }
    
    func nukeTables() {
        for restaurant in self.restaurants {
            managedObjectContext.delete(restaurant)
            do {
                try self.managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    func login(email: String, password: String){
        guard let ressourceURL = URL(string: Constants.apilink + "/auth/login/user") else {fatalError()}
        let body = "email=" + email + "&password=" + password
        var urlRequest = URLRequest(url: ressourceURL)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body.data(using: String.Encoding.utf8)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                self.isLogin = false
                return
            }
            do {
                self.isLogin = true
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    if let token = json["token"] as? String {
                        print(token)
                    }
                }
            }
        }
        dataTask.resume()
    }
}

struct AppContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppContentView()
    }
}
