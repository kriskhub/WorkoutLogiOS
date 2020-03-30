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

class OptionExWoViewController: UIViewController {


    var sender: CurrentWorkoutViewController?
    var workout: NSManagedObject?

    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self,
        selector: #selector(dismissView),
        name: NSNotification.Name(rawValue: "dismissOptionView"),
        object: nil)
    }
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
