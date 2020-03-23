//
//  ChooseExerciseViewController.swift
//  WorkoutLog
//
//  Created by Kristian Kullmann on 22.03.20.
//  Copyright © 2020 Kristian Kullmann. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ChooseExerciseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var exercisePicker: UIPickerView!
    @IBAction func addButton(_ sender: Any) {
        guard let myWorkout = workout else {return}
        guard let myExercise = chosenExercise else {return}
        CoreDataManager.sharedInstance.addExerciseToWorkout(workout: myWorkout, exercise: myExercise)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshCurrentWorkoutTable"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func createNewButton(_ sender: Any) {
         //self.dismiss(animated: true, completion: nil)
    }

    var chosenExercise: NSManagedObject?
    var workout: NSManagedObject?
    var exercises: [NSManagedObject] = []
    var sender: CurrentWorkoutViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
        self.exercisePicker.delegate = self
        self.exercisePicker.dataSource = self
        exercises = CoreDataManager.sharedInstance.getActiveExercises()
        NotificationCenter.default.addObserver(self,
        selector: #selector(refreshPicker),
        name: NSNotification.Name(rawValue: "refreshExercisePicker"),
        object: nil)
     }

    @objc func refreshPicker() {
        exercises = CoreDataManager.sharedInstance.getActiveExercises()
        exercisePicker.reloadAllComponents();
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "createExerciseSegue" {
            if let viewController = segue.destination as? CreateNewExerciseViewController {
                viewController.sender = self
            }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let name = exercises[row].value(forKey: "name") as? String ?? ""
        return name

    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exercises.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if exercises.count > 0 {
            chosenExercise = exercises[row]
        }
    }

}
