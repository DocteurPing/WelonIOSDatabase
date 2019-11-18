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
    @FetchRequest(fetchRequest: WelonUser.getAllWelonUsers()) var users:FetchedResults<WelonUser>
    
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
    @FetchRequest(fetchRequest: WelonUser.getAllWelonUsers()) var users:FetchedResults<WelonUser>
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
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    if let userToken = json["token"] as? String {
                        let usertopush = WelonUser(context: self.managedObjectContext)
                        usertopush.token = userToken
                        self.saveDataBase()
                        print(usertopush.token ?? "toto")
                        self.getRestaurants()
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func getRestaurants() {
        guard let ressourceURL = URL(string: Constants.apilink + "/restaurant") else {fatalError()}
        var urlRequest = URLRequest(url: ressourceURL)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("x-access-token \(String(describing: self.users[0].token))", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to get restaurants")
                return
            }
            do {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    guard let jsonArray = json as? [[String: Any]] else { return }
                    for dic in jsonArray{
                        guard let name = dic["name"] as? String else { return }
                        guard let address = dic["address"] as? String else { return }
                        guard let serverId = dic["_id"] as? String else { return }
                        let restaurantToPush = Restaurant(context: self.managedObjectContext)
                        restaurantToPush.name = name
                        restaurantToPush.address = address
                        restaurantToPush.serverId = serverId
                        self.saveDataBase()
                    }
                }
                self.isLogin = true
            }
        }
        dataTask.resume()
    }
    
    func saveDataBase() {
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
    }
}

struct AppContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppContentView()
    }
}
