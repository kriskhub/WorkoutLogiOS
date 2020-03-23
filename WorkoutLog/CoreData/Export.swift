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

    func handleExportUI(workout: NSManagedObject) -> UIActivityViewController{
       let fileURL = createCSVFile(workout: workout)
       let objectsToShare = [fileURL]
       let activityController = UIActivityViewController(
            activityItems: objectsToShare as [Any],
           applicationActivities: nil)
       return activityController
    }

    func createCSVFile(workout: NSManagedObject) -> URL? {

        var destUrl: URL!
        dateFormatter.dateFormat = "dd-MM-yyyy'T'HH:mm:ss"

        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {

            let string = NSMutableString()

           //Id,Name,Type,Color,Size,Gender,Optional,Price
            let workoutName = workout.value(forKey: "name") as? String ?? ""

            string.append("name, rate, amount")
            let filename = "Export-"
                + workoutName + "-"
                + dateFormatter.string(from: Date()).description
                + ".csv"
            destUrl = documentsDirectory.appendingPathComponent(filename)

            //var coreDataResultsList: [NSManagedObject] = []

            guard let exercises = CoreDataManager.sharedInstance.getExercises(workout: workout) else { return nil }
            // Make sure we have some data to export
            guard exercises.count > 0 else {
                return nil
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
}
