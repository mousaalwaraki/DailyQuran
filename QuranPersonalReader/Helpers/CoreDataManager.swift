//
//  CoreDataManager.swift
//  QuranPersonalReader
//
//  Created by Mousa Alwaraki on 11/3/20.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    func save() {
        
        deleteAll()
        let entity = NSEntityDescription.entity(forEntityName: "UserValues",
                                                in: AppDelegate.viewContext)!
        
        let userValuesEntity = NSManagedObject(entity: entity,
                                               insertInto: AppDelegate.viewContext)
        
        userValuesEntity.setValue(UserDefaults.standard.value(forKey: "CurrentStreak"), forKey: "currentStreak")
        userValuesEntity.setValue(UserDefaults.standard.value(forKey: "MaxStreak"), forKey: "maxStreak")
        userValuesEntity.setValue(UserDefaults.standard.value(forKey: "lastDate"), forKey: "lastDate")
        userValuesEntity.setValue(UserDefaults.standard.value(forKey: "readToday"), forKey: "readToday")
        userValuesEntity.setValue(UserDefaults.standard.value(forKey: "todaysDate"), forKey: "todaysDate")
        userValuesEntity.setValue(UserDefaults.standard.value(forKey: "dailyPages"), forKey: "dailyPages")
        userValuesEntity.setValue(UserDefaults.standard.value(forKey: "pagesRead"), forKey: "pagesRead")
        userValuesEntity.setValue(UserDefaults.standard.value(forKey: "currentPage"), forKey: "currentPage")
        
        do {
          try AppDelegate.viewContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAll() {
        
        let context = AppDelegate.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserValues")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch
        {
            print ("There was an error")
        }
    }
    
    func load(completion: @escaping ([NSManagedObject]) -> ()) {
        
        let managedContext = AppDelegate.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserValues")
        
        do {
            let fetch = try managedContext.fetch(fetchRequest)
            completion(fetch)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
