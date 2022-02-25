//
//  JSONParseLearnApp.swift
//  JSONParseLearn
//
//  Created by Peter Hartnett on 2/24/22.
//

import SwiftUI
import CoreData

@main
struct JSONParseLearnApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
