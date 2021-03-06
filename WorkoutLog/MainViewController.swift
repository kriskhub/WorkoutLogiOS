//
//  MainViewController.swift
//  WorkoutLog
//
//  Created by Kristian Kullmann on 22.03.20.
//  Copyright © 2020 Kristian Kullmann. All rights reserved.
//

import UIKit
import CoreData

var exercises: [NSManagedObject] = []
class MainViewController: UITableViewController {
    var refreshController = UIRefreshControl()
    var workout: NSManagedObject!

    static let shared = MainViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.reloadData()
        self.hideKeyboardWhenTappedAround()
        // -----
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editWorkout))
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItems = [editButton]
        // -----
        if CoreDataManager.sharedInstance.getLatestWorkout() != nil && workout == nil {
            workout = CoreDataManager.sharedInstance.getLatestWorkout()
            exercises = CoreDataManager.sharedInstance.getExercises(workout: workout) ?? []
        } else {
            exercises = CoreDataManager.sharedInstance.getExercises(workout: workout) ?? []
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-YYYY"
            let date = workout.value(forKey: "date") as? Date ?? Date()
            self.title = workout.value(forKey: "name") as? String ?? dateFormatter.string(from: date)
        }

        NotificationCenter.default.addObserver(self,
        selector: #selector(refreshTable),
        name: NSNotification.Name(rawValue: "refreshCurrentWorkoutTable"),
        object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setToToday(notification:)),
                                               name: .today,
                                               object: nil)

        // Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.addSubview(refreshControl!)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl ?? refreshController)
        }
        tableView.rowHeight = 100
    }

    override func viewWillAppear(_ animated: Bool) {
        if workout == nil || CoreDataManager.sharedInstance.getLatestWorkout() == nil {
            let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
            dateFormatter.dateFormat = "dd-MM-YYYY"
            CoreDataManager.sharedInstance.createWorkout(name: dateFormatter.string(from: date), date: date)
            workout = CoreDataManager.sharedInstance.getLatestWorkout()
            exercises = CoreDataManager.sharedInstance.getExercises(workout: workout) ?? []
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.popViewController(animated: false)
    }

    @IBAction func exportWorkout(_ sender: Any) {
        present(Export.shared.handleSingleExportUI(workout: workout), animated: true)
    }

    @objc func setToToday(notification: NSNotification) {
         workout = CoreDataManager.sharedInstance.getLatestWorkout()
         exercises = CoreDataManager.sharedInstance.getExercises(workout: workout) ?? []
    }

    @objc func refreshTable() {
        if CoreDataManager.sharedInstance.getLatestWorkout() != nil {
            exercises = CoreDataManager.sharedInstance.getExercises(workout: workout) ?? []
        }
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "editWorkoutSegue" {
            if let viewController = segue.destination as? AddWorkoutView {
                viewController.workout = self.workout
                viewController.sender = self
            }
        }
        if segue.identifier == "optionSegue" {
            if let viewController = segue.destination as? OptionExWoViewController {
                viewController.workout = self.workout
                viewController.sender = self
            }
        }

    }

   @objc func editWorkout() {
        performSegue(withIdentifier: "editWorkoutSegue", sender: self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! CustomExerciseCell
        let workout = exercises[indexPath.row]

        let name = workout.value(forKey: "name") as? String ?? ""
        // let date = workout.value(forKey: "date") as? Date ?? Date()
        let amount = workout.value(forKey: "amount") as? Int ?? 0
        let rate = workout.value(forKey: "rate") as? Int ?? 0
        cell.titleLabel.text = name
        cell.subtitleLabel.text = "Rate: \(rate)"
        cell.amountLabel.text = String(amount)
        cell.minusButton.tag = indexPath.row
        cell.plusButton.tag = indexPath.row

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let exercise = exercises[indexPath.row]
            CoreDataManager.sharedInstance.deleteExerciseLog(exercise: exercise)
            exercises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            refreshTable()
        }
    }
}

class CustomExerciseCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!

    @IBAction func plusButton(_ sender: UIButton) {
        let exercise = exercises[sender.tag]
        let newValue = CoreDataManager.sharedInstance.incrementAmount(exercise: exercise)
        self.amountLabel.text = String(newValue)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshCurrentWorkoutTable"), object: nil)
    }
    @IBAction func minusButton(_ sender: UIButton) {
        let exercise = exercises[sender.tag]
        let newValue = CoreDataManager.sharedInstance.decrementAmount(exercise: exercise)
        self.amountLabel.text = String(newValue)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshCurrentWorkoutTable"), object: nil)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension Notification.Name {
     static let today = Notification.Name("today")
     static let workout = Notification.Name("workout")
}
