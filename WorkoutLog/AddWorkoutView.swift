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

    @IBAction func addButton(_ sender: Any) {
        guard let name = nameTextField.text else { return  }
        CoreDataManager.sharedInstance.createWorkout(name: name)
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var nameTextField: UITextField!

    override func viewDidLoad() {
         super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
         // Do any additional setup after loading the view.
     }


    
}
