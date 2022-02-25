//
//  DataController.swift
//  JSONParseLearn
//
//  Created by Peter Hartnett on 2/25/22.
//

//When setting up the DataController like this it needs to be injected into the xxxxxApp.swift file  xxxx being the program name
// This is how it is injected in this app
//struct JSONParseLearnApp: App {
//    @StateObject private var dataController = DataController()    <------ this line
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, dataController.container.viewContext)   <------- this line
//        }
//    }
//}

import CoreData
import SwiftUI


class DataController: ObservableObject{
    let container = NSPersistentContainer(name: "JSONParseLearn")
    
    init(){
        print("DataController init run")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
                return
            }
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
        }
    }
}
