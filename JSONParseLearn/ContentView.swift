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
//Day 61, put core data to use so that we need only retrieve the data once


//Data plan, Pull Data from Web (fail check) > parse json data and put it into the users @State > Save the changes to data to CoreData (on first run this would be everything, subsequent runs just save changes)
//If *fail check* , load information into users @State from CoreData and run that way.

import SwiftUI
//import CoreData


struct User: Codable{
    enum CodingKeys: CodingKey{
        case id, isActive, name, age, company, email, address, about, registered,  tags, friends
    }
    
    var id: String
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [Friend]
}

struct Friend: Codable{
    enum CodingKeys: CodingKey{
        case id, name
    }
    var id: String
    var name: String
}


struct detailView: View{
    let user: User
    var body: some View{
        VStack{
            Text(user.name)
            Text("Age \(user.age)")
            Text(user.company)
            Text(user.email)
            Text(user.address)
            Text("About: \(user.about)")
            
            List(user.friends, id: \.id){ friend in
                Text(friend.name)
            }
        }
    }
}



struct ContentView: View {
    
    func loadData() async{
        
        //TODO make a network check that lets the app run off the cached data if new data can not be retrieved.
        if users.isEmpty {
            print("Load data started")
            guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
                print("Invalid URL")
                return
            }
            do {
                print(url)
                let (data, _) = try await URLSession.shared.data(from: url)
                print("data \(data)")
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                if let decodedResponse = try? decoder.decode([User].self, from: data){
                    users = decodedResponse
                    print("users loaded with [decodedResponse]")
                }
            } catch {
                print("invalid data")
            }
        }
        
    }
    
    func saveUsersToCoreData() {
        //check for changes to the data and then save those changes
        for user in users{
            let newUser = CachedUser(context: moc)
            newUser.id = user.id
            newUser.isActive = user.isActive
            newUser.name = user.name
            newUser.age = Int16(user.age)
            newUser.company = user.company
            newUser.email = user.email
            newUser.address = user.address
            newUser.about = user.about
            newUser.registered = user.registered
            newUser.tags = user.tags.joined(separator: ",")
            for friend in user.friends {
                let newFriend = CachedFriend(context: moc)
                newFriend.id = friend.id
                newFriend.name = friend.name
            }
            
            try? moc.save()
        }
        
//        let newFriend = CachedFriend(context: moc)
//        newFriend.id = "\(Int.random(in: 0...1300))"
//        newFriend.name = "Bob"
//        let newTage = CachedTag(context: moc)
//        newTage.name = "Word"
        
        
    }
    
    func networkFailLoadData(){
        //Fetch data from core data and load it into users
        //provide default data to core data that is a note saying, hey network failed and nothing is cached... need to find how to purge the data to check this process, I could add a button to clear data perhaps?
    }
    
    @Environment(\.managedObjectContext) var moc
    @State private var users = [User]()
    
    @FetchRequest(sortDescriptors: []) var cachedUser: FetchedResults<CachedUser>
    @FetchRequest(sortDescriptors: []) var cachedFriend: FetchedResults<CachedFriend>
  //  @FetchRequest(sortDescriptors: []) var cachedTag: FetchedResults<CachedTag>
    
    var body: some View {
        NavigationView{
            List{
                Button("Purge data"){
                    for item in cachedUser {
                        moc.delete(item)
                        try? moc.save()
                    }
//                    for item in cachedTag {
//                        moc.delete(item)
//                        try? moc.save()
//                    }
                    for item in cachedFriend {
                        moc.delete(item)
                        try? moc.save()
                    }
                    
                    
                }
                Button("Add user"){
                    let newUser = CachedUser(context: moc)
                    newUser.id = "\(Int.random(in: 0...1300))"
                    newUser.isActive = false
                    newUser.name = "Hi!"
                    newUser.age = 14
                    newUser.company = "Company"
                    newUser.email = "Boring@frog.email"
                    newUser.address = "A place address"
                    newUser.about = "Lorem te ipsum froggy pants"
                    newUser.registered = Date.now
                    let newFriend = CachedFriend(context: moc)
                    newFriend.id = "\(Int.random(in: 0...1300))"
                    newFriend.name = "Bob"
           
                    
                    try? moc.save()
                    
                }
                Section(header:
                            VStack(alignment: .leading){
                    Text("cachedUser count: \(cachedUser.count)")
                    Text("cachedFriend count: \(cachedFriend.count)")
           //         Text("cachedTag count: \(cachedTag.count)")
                }
                ){
//                    ForEach(users, id: \.id){ user in
//                        NavigationLink{
//                            //Put the detail view here
//                            detailView(user: user)
//                        } label: {
//                            HStack{
//                                Text(user.name)
//                                Spacer()
//                                Text(user.isActive ? "🟢" : "🔴")
//                            }
//                        }
//                    }
                    ForEach(cachedUser){ user in
                        NavigationLink{
                            
                        } label: {
                            Text(user.name ?? "Unknown Name")
                        }
                    }
                    
                    
                }
                .task {
                    await loadData()
                    await MainActor.run {
                        //put save code function call here?
                        saveUsersToCoreData()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
