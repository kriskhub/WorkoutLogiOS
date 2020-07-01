//
//  Export.swift
//  WorkoutLog
//
//  Created by Kristian Kullmann on 23.03.20.
//  Copyright © 2020 Kristian Kullmann. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Export {
    let dateFormatter = DateFormatter()
    static let shared = Export()

    func handleSingleExportUI(workout: NSManagedObject) -> UIActivityViewController{
        let fileURL = createSingleWorkoutCSV(workout: workout)
        let objectsToShare = [fileURL]
        let activityController = UIActivityViewController(
            activityItems: objectsToShare as [Any],
           applicationActivities: nil)
        return activityController
    }

    func handleMultipleExportUI() -> UIActivityViewController{
        let fileURL = createMultipleWorkoutCSV()
        let objectsToShare = [fileURL]
        let activityController = UIActivityViewController(
            activityItems: objectsToShare as [Any],
           applicationActivities: nil)
        return activityController
    }

    func createSingleWorkoutCSV(workout: NSManagedObject) -> URL? {
        var destUrl: URL!
        dateFormatter.dateFormat = "dd-MM-yyyy_HH-mm-ss"

        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let string = NSMutableString()
           //Id,Name,Type,Color,Size,Gender,Optional,Price
            var workoutName = workout.value(forKey: "name") as? String ?? ""
            workoutName = workoutName.replacingOccurrences(of: " ", with: "_")
            workoutName = workoutName.replacingOccurrences(of: "w/", with: "with")
            workoutName = workoutName.replacingOccurrences(of: "/", with: "_")
            string.append("name, rate, amount")
            let filename = "Export-"
                + workoutName + "-"
                + dateFormatter.string(from: Date()).description
                + ".csv"
            destUrl = documentsDirectory.appendingPathComponent(filename)
            guard let exercises = CoreDataManager.sharedInstance.getExercises(workout: workout) else {
                destUrl = documentsDirectory.appendingPathComponent("no_data_avilable.csv")
                let data = "Sorry. Theres no data to export.".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)
                do {
                    try data?.write(to: destUrl)
                } catch {/* error handling here */}
                return destUrl
            }
            // Make sure we have some data to export
            guard exercises.count > 0 else {
                destUrl = documentsDirectory.appendingPathComponent("no_data_avilable.csv")
                let data = "Sorry. Theres no data to export.".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)
                do {
                    try data?.write(to: destUrl)
                } catch {/* error handling here */}
                return destUrl
            }
            for exercise in exercises {
                var row = "\n\(exercise.value(forKey: "name")!),"
                row += "\(exercise.value(forKey: "rate") ?? ""),"
                row += "\(exercise.value(forKey: "amount") ?? ""),"
                string.append(row)
            }
            let data = string.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)
            do {
                try data?.write(to: destUrl)
            } catch {/* error handling here */}
        }
        return destUrl
    }

    func createMultipleWorkoutCSV() -> URL? {
        var destUrl: URL!
        dateFormatter.dateFormat = "dd-MM-yyyy-HH-mm-ss"

        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let string = NSMutableString()
            string.append("name; rate; amount; workout; date")
            let filename = "Export-WorkoutLog-"
                + dateFormatter.string(from: Date()).description
                + ".csv"
            destUrl = documentsDirectory.appendingPathComponent(filename)

            let workouts = CoreDataManager.sharedInstance.getWorkouts()

            for workout in workouts {
                guard let exercises = CoreDataManager.sharedInstance.getExercises(workout: workout) else {
                    destUrl = documentsDirectory.appendingPathComponent("no_data_avilable.csv")
                    let data = "Sorry. Theres no data to export.".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)
                    do {
                        try data?.write(to: destUrl)
                    } catch {/* error handling here */}
                    return destUrl
                }
                // Make sure we have some data to export
                guard exercises.count > 0 else {
                    destUrl = documentsDirectory.appendingPathComponent("no_data_avilable.csv")
                    let data = "Sorry. Theres no data to export.".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)
                    do {
                        try data?.write(to: destUrl)
                    } catch {/* error handling here */}
                    return destUrl
                }
                for exercise in exercises {
                    var row = "\n\(exercise.value(forKey: "name")!);"
                    row += "\(exercise.value(forKey: "rate") ?? "");"
                    row += "\(exercise.value(forKey: "amount") ?? "");"
                    row += "\(workout.value(forKey: "name") ?? "");"
                    row += "\(workout.value(forKey: "date") ?? "");"
                    string.append(row)
                }
                let data = string.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)
                do {
                    try data?.write(to: destUrl)
                } catch {/* error handling here */}
            }
        }
        return destUrl
    }
}
