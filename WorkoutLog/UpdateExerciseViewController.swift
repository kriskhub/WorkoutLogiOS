//
//  UpdateExerciseViewController.swift
//  WorkoutLog
//
//  Created by Kristian Kullmann on 23.03.20.
//  Copyright © 2020 Kristian Kullmann. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UpdateExerciseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var ratePicker: UIPickerView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var activeSwitch: UISwitch!
    @IBAction func updateButton(_ sender: Any) {
        let rate = chosenRate as? String ?? "10"
        guard let name = titleTextField.text else {return}
        guard let exercise = self.exercise else {return}
        let image = imageView.image ?? UIImage()
        let status = activeSwitch.isOn
        CoreDataManager.sharedInstance.updateExercise(exercise: exercise, name: name, rate: Int64(rate) ?? 10, status: status)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshExerciseTable"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    var chosenRate: Any?
    var exercise: NSManagedObject?
    var pickerData: [Any] = []

    override func viewDidLoad() {
         super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.ratePicker.delegate = self
        self.ratePicker.dataSource = self
        var arr = [Int]()
        arr += 0...99
        // Input the data into the array
        pickerData = arr.map { String($0) }
        titleTextField.text = exercise?.value(forKey: "name") as? String ?? ""
        activeSwitch.isOn = exercise?.value(forKey: "active") as? Bool ?? false
     }

    override func viewDidAppear(_ animated: Bool) {
        let rate = exercise?.value(forKey: "rate") as? Int ?? 0
            ratePicker.selectRow(rate, inComponent: 0, animated: true)
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
        chosenRate = pickerData[row]
    }


}
