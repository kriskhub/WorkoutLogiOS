//
//  ChooseWorkoutViewController.swift
//  WorkoutLog
//
//  Created by Kristian Kullmann on 30.03.20.
//  Copyright © 2020 Kristian Kullmann. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ChooseWorkoutViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var workoutPicker: UIPickerView!

    @IBAction func addWorkout(_ sender: Any) {
        guard let senderWorkout = workout else {return}
        guard let myWorkout = chosenWorkout else {return}

        guard let workoutExercises = CoreDataManager.sharedInstance.getExercises(workout: myWorkout) else { return }

        for exercise in workoutExercises {
            CoreDataManager.sharedInstance.addExerciseToWorkout(workout: senderWorkout, exercise: exercise.value(forKeyPath: "exercise") as! NSManagedObject)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshCurrentWorkoutTable"), object: nil)
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissOptionView"), object: nil)
    }
    
    var chosenWorkout: NSManagedObject?
    var workout: NSManagedObject?
    var workouts: [NSManagedObject] = []
    var sender: OptionExWoViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
        self.workoutPicker.delegate = self
        self.workoutPicker.dataSource = self
        workouts = CoreDataManager.sharedInstance.getWorkouts()
        NotificationCenter.default.addObserver(self,
        selector: #selector(refreshPicker),
        name: NSNotification.Name(rawValue: "refreshWorkoutPicker"),
        object: nil)
        if workouts.count > 0 {
            chosenWorkout = workouts[0]
        }
     }

    @objc func refreshPicker() {
        workouts = CoreDataManager.sharedInstance.getWorkouts()
        workoutPicker.reloadAllComponents();
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

//        if segue.identifier == "createExerciseSegue" {
//            if let viewController = segue.destination as? CreateNewExerciseViewController {
//                viewController.sender = self
//            }
//        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let name = workouts[row].value(forKey: "name") as? String ?? ""
        return name

    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return workouts.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if workouts.count > 0 {
            chosenWorkout = workouts[row]
        }
    }

}
