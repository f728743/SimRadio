//
//  SimRadioApp.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 02.01.2021.
//

import SwiftUI

@main
struct SimRadioApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        UINavigationBar.appearance().tintColor = .systemRed
    }

    var body: some Scene {
        WindowGroup {
            LibraryView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
