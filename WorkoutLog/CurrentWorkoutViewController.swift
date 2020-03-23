//
//  CurrentWorkoutViewController.swift
//  WorkoutLog
//
//  Created by Kristian Kullmann on 22.03.20.
//  Copyright © 2020 Kristian Kullmann. All rights reserved.
//

import UIKit
import CoreData

var exercises: [NSManagedObject] = []
class CurrentWorkoutViewController: UITableViewController {
    var refreshController = UIRefreshControl()
    var workout: NSManagedObject!

    static let shared = CurrentWorkoutViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.reloadData()
        self.hideKeyboardWhenTappedAround()

        if CoreDataManager.sharedInstance.getLatestWorkout() != nil {
            workout = CoreDataManager.sharedInstance.getLatestWorkout()
            exercises = CoreDataManager.sharedInstance.getExercises(workout: workout) ?? []
        }

        NotificationCenter.default.addObserver(self,
        selector: #selector(refreshTable),
        name: NSNotification.Name(rawValue: "refreshCurrentWorkoutTable"),
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

    @objc func refreshTable() {
        if CoreDataManager.sharedInstance.getLatestWorkout() != nil {
            exercises = CoreDataManager.sharedInstance.getExercises(workout: workout) ?? []
        }
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "chooseExerciseSegue" {
            if let viewController = segue.destination as? ChooseExerciseViewController {
                viewController.workout = self.workout
                viewController.sender = self
            }
        }
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

        cell.titleLabel.text = name
        cell.subtitleLabel.text = "Description" // TODO:
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

    @objc func decrementAmount(_ sender: UIButton) {
        let exercise = exercises[sender.tag]
        let newValue = CoreDataManager.sharedInstance.decrementAmount(exercise: exercise)
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? CustomExerciseCell
        cell?.amountLabel.text = String(newValue)
        refreshTable()
    }

    @objc func incrementAmount(_ sender: UIButton) {
        let exercise = exercises[sender.tag]
        let newValue = CoreDataManager.sharedInstance.incrementAmount(exercise: exercise)
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? CustomExerciseCell
        cell?.amountLabel.text = String(newValue)
        refreshTable()
    }
}

class CustomExerciseCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton! {
        didSet {
            plusButton.addTarget(CurrentWorkoutViewController.shared, action: #selector(CurrentWorkoutViewController.shared.incrementAmount(_:)), for: .touchUpInside)
        }
    }

    @IBOutlet weak var minusButton: UIButton! {
        didSet {
            minusButton.addTarget(CurrentWorkoutViewController.shared, action: #selector(CurrentWorkoutViewController.shared.decrementAmount(_:)), for: .touchUpInside)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
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
