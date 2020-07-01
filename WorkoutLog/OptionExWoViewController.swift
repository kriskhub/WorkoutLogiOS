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
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.info)
        view.configureDropShadow()
        let iconText = "ℹ️"
        view.button?.isHidden = true
        view.configureContent(title: "Information", body: "Choose to add a single exercise to this workout.", iconText: iconText)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        self.view.bringSubviewToFront(view)
        SwiftMessages.show(view: view)
    }
    @IBAction func informationWorkout(_ sender: Any) {
        let view = MessageView.viewFromNib(layout: .tabView)
        view.configureTheme(.info)
        view.configureDropShadow()
        let iconText = "ℹ️"
        view.button?.isHidden = true
        view.configureContent(title: "Information", body: "Choose to add the same exercises of a previous workout.", iconText: iconText)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        SwiftMessages.show(view: view)
        self.view.bringSubviewToFront(view)
    }
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
