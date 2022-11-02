//
//  DataController.swift
//  Bookworm
//
//  Created by Paul Hudson on 21/05/2022.
//

import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Bookworm")
    var saveTask: Task<Void, Error>?
    
    @Published var selectedReview: Review?

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }

    func save() {
        guard container.viewContext.hasChanges else { return }
        try? container.viewContext.save()
    }

    func enqueueSave(_ change: Any) {
        saveTask?.cancel()

        saveTask = Task { @MainActor in
            try await Task.sleep(for: .seconds(5))
            save()
        }
    }
}
