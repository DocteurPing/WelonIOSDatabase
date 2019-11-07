//
//  LoginView.swift
//  Welon
//
//  Created by Drping on 21/10/2019.
//  Copyright © 2019 Drping. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State var keyboard = KeyboardResponder()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLogin: Int? = nil
    var body: some View {
        NavigationView {
            VStack {
                Image("logo_green").resizable().scaledToFit().padding(.horizontal, 50).padding(.top, -50)
                Image("chef").resizable().scaledToFit().padding(.horizontal, 50)
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
                NavigationLink(destination: DashBoard(), tag: 1, selection: $isLogin) {
                    Button(action: {
                        print("login tapped")
                        self.login(email: self.email, password: self.password)
                    }){
                        Text("SE CONNECTER").padding().foregroundColor(.white).background(Color.init(red: 0.00, green: 0.78, blue: 0.32))
                    }
                    .cornerRadius(40).padding(.top, 80)
                }
            }
        }.padding(.bottom, self.keyboard.currentHeight)
    }
    
    func login(email: String, password: String){
        guard let ressourceURL = URL(string: Constants.apilink + "/auth/login/user") else {fatalError()}
        print(Constants.apilink + "/auth/login/user")
        let body = "email=" + email + "&password=" + password
        var urlRequest = URLRequest(url: ressourceURL)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body.data(using: String.Encoding.utf8)
        print(body)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) {data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                self.isLogin = 0
                return
            }
            do {
                self.isLogin = 1
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
