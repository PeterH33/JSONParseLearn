//
//  ContentView.swift
//  JSONParseLearn
//
//  Created by Peter Hartnett on 2/24/22.
//
//your job is to use URLSession to download some JSON from the internet, use Codable to convert it to Swift types, then use NavigationView, List, and more to display it to the user.
//Fetch the data and parse it into User and Friend structs.
//Display a list of users with a little information about them, such as their name and whether they are active right now.
//Create a detail view shown when a user is tapped, presenting more information about them, including the names of their friends.
//Before you start your download, check that your User array is empty so that you don’t keep starting the download every time the view is shown.


import SwiftUI

struct User{
    var id = ""
    var isActive = false
    var name = ""
    var age = 0
    var company = ""
    var email = ""
    var address = ""
    var about = ""
    var registered = Date.now
    var tags: [String]
    var friends: [Friend]
}

struct Friend{
    var id = ""
    var name = ""
}

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
