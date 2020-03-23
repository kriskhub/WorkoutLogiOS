//
//  ExercisesTableViewController.swift
//  WorkoutLog
//
//  Created by Kristian Kullmann on 23.03.20.
//  Copyright © 2020 Kristian Kullmann. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ExercisesTableViewController: UITableViewController {

    var refreshController = UIRefreshControl()
    var exercises: [NSManagedObject]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.reloadData()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        exercises = CoreDataManager.sharedInstance.getExercises()
        NotificationCenter.default.addObserver(self,
                     selector: #selector(refreshTable),
                     name: NSNotification.Name(rawValue: "refreshExerciseTable"),
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
        exercises = CoreDataManager.sharedInstance.getExercises()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "LabelCell")
        let exercise = exercises?[indexPath.row]
        let name = exercise?.value(forKey: "name") as? String ?? ""
        let date = exercise?.value(forKey: "date") as? Date ?? Date()
        let status = exercise?.value(forKey: "active") as? Bool ?? false
        let timestamp = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)

        cell.textLabel?.text = name
        cell.detailTextLabel?.text = timestamp

        if !status {
            cell.backgroundColor = .systemGray6
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard
            .instantiateViewController(withIdentifier: "UpdateExerciseViewController")
            as? UpdateExerciseViewController
        newViewController?.exercise = CoreDataManager.sharedInstance.getExercises()[indexPath.row]
        self.navigationController?.pushViewController(newViewController!, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let exercise = self.exercises?[indexPath.row] else { return }
            CoreDataManager.sharedInstance.updateExercise(exercise: exercise, status: false)
            refreshTable()
        }
    }
}

