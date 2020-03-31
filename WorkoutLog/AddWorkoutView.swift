//
//  AddWorkoutView.swift
//  WorkoutLog
//
//  Created by Kristian Kullmann on 22.03.20.
//  Copyright © 2020 Kristian Kullmann. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddWorkoutView: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButtonOutlet: UIButton!

    @IBAction func datePickerChanged(_ sender: Any) {
        // User changed date
    }
    @IBAction func addButton(_ sender: Any) {
        guard let name = nameTextField.text else { return  }

        if self.workout != nil { // Update Existing Workout
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-YYYY"
            let name = nameTextField.text ?? dateFormatter.string(from: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date())
            let date = datePicker.date
            CoreDataManager.sharedInstance.updateWorkout(workout: self.workout!, name: name, date: date)
        } else { // Create New Workout
            CoreDataManager.sharedInstance.createWorkout(name: name, date: datePicker.date)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshWorkoutTable"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }

    var workout: NSManagedObject?
    var sender: CurrentWorkoutViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.datePicker.maximumDate = Date()

        guard let workout = self.workout else {return}

        nameTextField.text = workout.value(forKey: "name") as? String ?? "Unkown Name"
        addButtonOutlet.setTitle("Update", for: .normal)
        datePicker.date = workout.value(forKey: "date") as? Date ?? Date()
        titleLabel.text = "Update Workout"

     }
}
