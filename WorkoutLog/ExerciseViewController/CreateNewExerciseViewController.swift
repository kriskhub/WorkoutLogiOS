//
//  CreateNewExerciseViewController.swift
//  WorkoutLog
//
//  Created by Kristian Kullmann on 22.03.20.
//  Copyright © 2020 Kristian Kullmann. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CreateNewExerciseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ratePicker: UIPickerView!
    @IBOutlet weak var activeSwitch: UISwitch!

    @IBAction func addButton(_ sender: Any) {
        let rate = chosenRate as? String ?? "10"
        guard let name = nameTextField.text else {return}
        let image = imageView.image ?? UIImage()
        let status = activeSwitch.isOn
        CoreDataManager.sharedInstance.createExercise(name: name, rate: Int64(rate) ?? 10, image: image, status: status)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshExercisePicker"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshExerciseTable"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    var chosenRate: Any?
    var workout: NSManagedObject?
    var pickerData: [Any] = []
    var sender: ChooseExerciseViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
         // Do any additional setup after loading the view.
        self.ratePicker.delegate = self
        self.ratePicker.dataSource = self
        var arr = [Int]()
        arr += 0...99
        // Input the data into the array
        pickerData = arr.map { String($0) }
     }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerData[row])"
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerData.count > 0 {
            chosenRate = pickerData[row]
        }
    }


}
