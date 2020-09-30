//
//  OptionExWoViewController.swift
//  WorkoutLog
//
//  Created by Kristian Kullmann on 30.03.20.
//  Copyright © 2020 Kristian Kullmann. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SwiftMessages

class OptionExWoViewController: UIViewController {


    var sender: MainViewController?
    var workout: NSManagedObject?

    @IBAction func informationExercise(_ sender: Any) {
        exerciseInfoText.text = "Choose a single exercise and add it to this workout."
        exerciseInfoText.backgroundColor = .gray
    }
    @IBAction func informationWorkout(_ sender: Any) {
        workoutInfoText.text = "Copy exercises from a previous workout."
        workoutInfoText.backgroundColor = .gray
    }
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self,
        selector: #selector(dismissView),
        name: NSNotification.Name(rawValue: "dismissOptionView"),
        object: nil)
    }

    @IBOutlet weak var exerciseInfoText: UITextView!
    @IBOutlet weak var workoutInfoText: UITextView!

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "chooseExerciseSegue" {
            if let viewController = segue.destination as? ChooseExerciseViewController {
                viewController.workout = self.workout
                viewController.sender = self
            }
        }
        if segue.identifier == "chooseWorkoutSegue" {
            if let viewController = segue.destination as? ChooseWorkoutViewController {
                viewController.workout = self.workout
                viewController.sender = self
            }
        }
    }
}
