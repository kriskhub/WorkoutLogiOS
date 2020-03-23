//
//  CoreDataManager.swift
//  WorkoutLog
//
//  Created by Kristian Kullmann on 22.03.20.
//  Copyright © 2020 Kristian Kullmann. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    static let sharedInstance = CoreDataManager()

    func deleteWorkout(workout: NSManagedObject) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Sets")
        let predicate = NSPredicate(format: "workout = %@", workout)
        deleteFetch.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try managedContext?.execute(deleteRequest)
            managedContext?.delete(workout)
            appDelegate?.saveContext()
        }
        catch
        {
            print ("There was an error")
        }


    }

    func getWorkouts() -> [NSManagedObject] {
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Workout")
        fetchRequest.resultType = .managedObjectResultType
        do {
            guard let objects = try managedContext?.fetch(fetchRequest) else { return [] }
            return objects as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }

    func getLatestWorkout() -> NSManagedObject? {
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Workout")
        fetchRequest.resultType = .managedObjectResultType
        fetchRequest.fetchLimit =  1
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        do {
            guard let item = try managedContext?.fetch(fetchRequest) else { return nil }
            return item.first as? NSManagedObject
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }


    func getExercises() -> [NSManagedObject] {
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Exercises")
        fetchRequest.resultType = .managedObjectResultType
        do {
            guard let objects = try managedContext?.fetch(fetchRequest) else { return [] }
            return objects as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }

    func getActiveExercises() -> [NSManagedObject] {
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Exercises")
        let predicate = NSPredicate(format: "active = \(true)")
        fetchRequest.predicate = predicate
        fetchRequest.resultType = .managedObjectResultType
        do {
            guard let objects = try managedContext?.fetch(fetchRequest) else { return [] }
            return objects as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }



    func getExercises(workout: NSManagedObject) -> [NSManagedObject]? {
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Sets")
        fetchRequest.resultType = .managedObjectResultType
        let predicate = NSPredicate(format: "workout = %@", workout)
        fetchRequest.predicate = predicate
        do {
            guard let objects = try managedContext?.fetch(fetchRequest) else { return [] }
            return objects as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }


    func addExerciseLog(workout: NSManagedObject, exercise: NSManagedObject) {
        let managedContext = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Sets", in: managedContext!)
        let log = NSManagedObject(entity: entity!, insertInto: managedContext)
        log.setValue(0, forKey: "amount")
        log.setValue(workout, forKey: "workout")
        log.setValue(exercise, forKey: "exercise")
        do {
            try managedContext?.save()
        } catch {
            print("Failed saving")
        }
    }

    func updateExerciseLog(exercise: NSManagedObject, amount: Int64) {
        guard let currentRepetitions =  exercise.value(forKey: "amount") as? Int64 else { return }
        exercise.setValue(String(currentRepetitions + amount), forKey: "amount") // Increase stock
        let managedContext = appDelegate?.persistentContainer.viewContext
        do {
            try managedContext?.save()
        } catch {
            print("Failed saving")
        }
    }

    func deleteExerciseLog(exercise: NSManagedObject) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        managedContext?.delete(exercise)
        appDelegate?.saveContext()
    }

    func createExercise(name: String, rate: Int64, image: UIImage, status: Bool) {
        let managedContext = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Exercises", in: managedContext!)
        let newExercise = NSManagedObject(entity: entity!, insertInto: managedContext)
        newExercise.setValue(name, forKey: "name")
        newExercise.setValue(Date(), forKey: "date")
        newExercise.setValue(rate, forKey: "rate")
        newExercise.setValue(image.pngData(), forKey: "image")
        newExercise.setValue(status, forKey: "active")
        do {
            try managedContext?.save()
        } catch {
            print("Failed saving")
        }
    }

    func updateExercise(exercise: NSManagedObject, name: String, rate: Int64, status: Bool) {

        exercise.setValue(name, forKey: "name")
        exercise.setValue(rate, forKey: "rate")
        exercise.setValue(status, forKey: "active")
        let managedContext = appDelegate?.persistentContainer.viewContext
        do {
            try managedContext?.save()
        } catch {
            print("Failed saving")
        }
    }

    func updateExercise(exercise: NSManagedObject, status: Bool) {
        exercise.setValue(status, forKey: "active")
        let managedContext = appDelegate?.persistentContainer.viewContext
        do {
            try managedContext?.save()
        } catch {
            print("Failed saving")
        }
    }

    func createWorkout(name: String) {
        let managedContext = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Workout", in: managedContext!)
        let newWorkout = NSManagedObject(entity: entity!, insertInto: managedContext)
        newWorkout.setValue(name, forKey: "name")
        newWorkout.setValue(Date(), forKey: "date")
        do {
            try managedContext?.save()
        } catch {
            print("Failed saving")
        }
    }

    func createSet(name: String, rate: Int, workout: NSManagedObject) {
        let managedContext = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Sets", in: managedContext!)
        let newSet = NSManagedObject(entity: entity!, insertInto: managedContext)
        newSet.setValue(name, forKey: "name")
        newSet.setValue(Date(), forKey: "date")
        newSet.setValue(0, forKey: "amount")
        newSet.setValue(workout, forKey: "workout")
        newSet.setValue(rate, forKey: "rate")
        do {
            try managedContext?.save()
        } catch {
            print("Failed saving")
        }
    }
    /*
    func deleteSet(date: String, finished: () -> Void) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Scans")
        let predicate = NSPredicate(format: "date = '\(date)'")
        fetchRequest.predicate = predicate
        do {
            let object = try managedContext?.fetch(fetchRequest)
            if object?.count ?? 0 > 0 {
                guard let objectDelete = object?.first as? NSManagedObject else { return  }
                managedContext?.delete(objectDelete)
                appDelegate?.saveContext()
            }
            finished()
        } catch {
            print(error)
            finished()
        }
    }
     */

    func addExerciseToWorkout(workout: NSManagedObject, exercise: NSManagedObject) {
        let managedContext = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Sets", in: managedContext!)
        let newSet = NSManagedObject(entity: entity!, insertInto: managedContext)
        newSet.setValue(exercise.value(forKey: "name") as? String ?? "-", forKey: "name")
        newSet.setValue(workout, forKey: "workout")
        newSet.setValue(exercise, forKey: "exercise")

        let rate = exercise.value(forKey: "rate") as? Int ?? 0
        newSet.setValue(rate, forKey: "rate")

        do {
            try managedContext?.save()
        } catch {
            print("Failed saving")
        }
    }

    func incrementAmount(exercise: NSManagedObject) -> Int {
        guard let rate =  exercise.value(forKey: "rate") as? Int else { return  0}
        let managedContext = appDelegate?.persistentContainer.viewContext
        let amount = exercise.value(forKey: "amount") as? Int ?? 0
        let newValue = amount + rate
        exercise.setValue(newValue, forKey: "amount") // Increase stock
        do {
            try managedContext?.save()
            return newValue
        } catch {
            print("Failed saving")
            return amount
        }
    }

    func decrementAmount(exercise: NSManagedObject) -> Int {
        guard let rate =  exercise.value(forKey: "rate") as? Int else { return 0 }
        let managedContext = appDelegate?.persistentContainer.viewContext
        let amount = exercise.value(forKey: "amount") as? Int ?? 0
        let newValue = amount - rate
        if newValue < 0 {
            exercise.setValue(0, forKey: "amount")
        } else {
            exercise.setValue(newValue, forKey: "amount")
        }
        do {
            try managedContext?.save()
            return newValue
        } catch {
            print("Failed saving")
            return amount
        }
    }

}
