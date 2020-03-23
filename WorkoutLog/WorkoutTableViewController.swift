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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.

        NotificationCenter.default.addObserver(self,
                     selector: #selector(refreshTable),
                     name: NSNotification.Name(rawValue: "refreshWorkoutTable"),
                     object: nil)
    }

    @objc func refreshTable() {
        self.tableView.reloadData()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.sharedInstance.getWorkouts().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "LabelCell")

        let workout = CoreDataManager.sharedInstance.getWorkouts()[indexPath.row]

        let name = workout.value(forKey: "name") as? String ?? ""
        let date = workout.value(forKey: "date") as? Date ?? Date()

        let timestamp = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)

        cell.textLabel?.text = name
        cell.detailTextLabel?.text = timestamp

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard
            .instantiateViewController(withIdentifier: "WorkoutView")
            as? WorkoutView
        newViewController?.workout = CoreDataManager.sharedInstance.getWorkouts()[indexPath.row]
        self.navigationController?.pushViewController(newViewController!, animated: true)
        //self.present(newViewController!, animated: true, completion: nil)
    }
}

