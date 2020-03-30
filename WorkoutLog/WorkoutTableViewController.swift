//
//  SecondViewController.swift
//  WorkoutLog
//
//  Created by Kristian Kullmann on 22.03.20.
//  Copyright © 2020 Kristian Kullmann. All rights reserved.
//

import UIKit
import CoreData

class WorkoutTableViewController: UITableViewController {

    var refreshController = UIRefreshControl()
    var workouts: [NSManagedObject]?


    @IBAction func shareButton(_ sender: Any) {
        present(Export.shared.handleMultipleExportUI(), animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.tableView.dataSource = self
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
        workouts = CoreDataManager.sharedInstance.getWorkouts()
        NotificationCenter.default.addObserver(self,
                     selector: #selector(refreshTable),
                     name: NSNotification.Name(rawValue: "refreshWorkoutTable"),
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
    }

    @objc func refreshTable() {
        workouts = CoreDataManager.sharedInstance.getWorkouts()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.sharedInstance.getWorkouts().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "LabelCell")
        let workout = workouts?[indexPath.row]
        let name = workout?.value(forKey: "name") as? String ?? ""
        let date = workout?.value(forKey: "date") as? Date ?? Date()
        let timestamp = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = timestamp

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard
            .instantiateViewController(withIdentifier: "CurrentWorkoutViewController")
            as? CurrentWorkoutViewController
        newViewController?.workout = CoreDataManager.sharedInstance.getWorkouts()[indexPath.row]
        self.navigationController?.pushViewController(newViewController!, animated: true)
        //self.present(newViewController!, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let workout = workouts?[indexPath.row] else { return }
            CoreDataManager.sharedInstance.deleteWorkout(workout: workout)
            //CoreDataManager.sharedInstance.deleteExerciseLog(exercise: exercise)
            workouts?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            refreshTable()
        }
    }
}

