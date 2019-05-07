//
//  AlbmsDataController.swift
//  Albms
//
//  Created by Cody Garvin on 5/6/19.
//  Copyright © 2019 Cody Garvin. All rights reserved.
//

import Foundation
import CoreData

typealias WorkBlock = (_ context: NSManagedObjectContext) -> Void

////////////////////////////////////////////////////////////////////////////////
// MARK: - ALBDataController

/// The main Core Data data controller. Sets up a store and adds convenience
/// methods. Make sure to use save with mainObjectContext and
/// processOnBackgroundWorkBlock with privateObjectContext.
class AlbmsDataController: NSObject {
    
    /// Our context which we can access if needed to introspect.
    let mainObjectContext: NSManagedObjectContext
    
    /// Our context to do background data source tasks.
    let privateObjectContext: NSManagedObjectContext
    
    /// A flag to let others know if we are done loading or not
    var initialized = false
    
    /// Used to track locations being aggregated
    private var _locationCounter: Int = 0
    
    /**
     The designation initializer to set up the store and get a
     callback once the core data stack is finished setting up;.
     
     - Parameter callback: A block that will be called after set-up has finished.
     - Returns: A fully set up controller ready to use our persistant store.
     */
    init(completionClosure: (() -> Void)?) {
        
        // This resource is the same name as your xcdatamodeld contained in your project
        guard let modelURL = Bundle.main.url(forResource: "Albms", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. Fail if we can't find it
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        // Get the coordinator going and associate it with the model
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        // Our main context, which will be a main queue and UI safe
        mainObjectContext =
            NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        
        mainObjectContext.persistentStoreCoordinator = coordinator
        
        // Add a private context because we will be doing a lot of processing on the
        // background...
        privateObjectContext =
            NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        
        privateObjectContext.parent = mainObjectContext
        
        super.init()
        
        ALBUtility.executeInBackground { [weak self] in
            
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Unable to resolve document directory")
            }
            let storeURL = docURL.appendingPathComponent("DataModel.sqlite")
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                   configurationName: nil,
                                                   at: storeURL,
                                                   options: nil)
                // The callback block is expected to complete the User Interface
                // and therefore should be presented back on the main queue so
                // that the user interface does not need to be concerned with
                // which queue this call is coming from.
                ALBUtility.executeOnMainQueueAndWait {
                    self?.initialized = true
                    if let completion = completionClosure {
                        completion()
                    }
                }
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    /**
     Save any pending changes to the main context only.
     */
    func save() {
        if mainObjectContext.hasChanges {
            do {
                try mainObjectContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
    /**
     Used to manipulate managed objects on a background thread and immediately save
     the results. The worker block is the code you wish you work, such as building
     out managed objects from json. The success block is called once done, with an
     error if an issue came to be.
     
     - Parameter workBlock: The block that is executed that works with managed objects.
     - Parameter success: The block that is executed once the worker block is done and the
     saving has commenced.
     */
    func processOnBackgroundWorkBlock(_ workBlock: @escaping WorkBlock, success: ((_ success: Bool) -> Void)?) {
        privateObjectContext.perform { [weak self] in
            
            // Make sure we have a private context to use, otherwise bail
            guard let poc = self?.privateObjectContext else { return }
            
            // Where the actual creating, fetching / updating, deleting is done.
            workBlock(poc)
            
            do {
                try self?.privateObjectContext.save()
            } catch {
                print("Failed to save: \(error.localizedDescription)")
                ALBUtility.executeOnMainQueue {
                    success?(false)
                }
                return
            }
            
            // FIXME: This seems odd we are calling save on main context as well
            self?.mainObjectContext.performAndWait({
                do {
                    try self?.mainObjectContext.save()
                    ALBUtility.executeOnMainQueue {
                        success?(true)
                    }
                } catch {
                    print("Failed to save: \(error.localizedDescription)")
                    ALBUtility.executeOnMainQueue {
                        success?(false)
                    }
                }
            })
        }
    }
    
    
    /// Reset the database to it's original glory so we don't keep appending
    /// albums every time we go a new fetch.
    func clearStorage() {
        let contextToUse = self.mainObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            let _ = try contextToUse.execute(batchDeleteRequest)
        } catch {
            // Create a new one
            print("Could not delete entities")
        }
    }
    
    
    /// Looks up all albums. This grabs all albums that were last downloaded.
    ///
    /// - Parameters:
    ///   - context: Background or main contexts.
    /// - Returns: Returns the session that was found, otherwise nil.
    func lookupAlbums(context: NSManagedObjectContext?) -> [Album]? {
        // Check the context, if it is NULL lets use the default context
        var contextToUse = self.mainObjectContext
        if let tempContext = context {
            contextToUse = tempContext
        }
        
        // TODO: Develop a cleaner way to do this so we have type checking and less
        // manual code. Perhaps cycle a bridge map.
        var albums: [Album]?
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        request.sortDescriptors = [NSSortDescriptor(key: "sortNumber", ascending: true)]
        request.returnsObjectsAsFaults = false
        do {
            let results = try contextToUse.fetch(request)
            if let tempResult = results as? [Album] {
                albums = tempResult
            }
        } catch {
            // Create a new one
            print("Could not find session")
        }
        
        return albums
    }
}
