//
//  ReportViewController.swift
//  CoachAssistantApp
//
//  Created by Julieta Ignatova on 2/9/20.
//  Copyright © 2020 Swift FMI. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    let cellReuseId = "reportsCell"
    var events: [Event] = []

    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    //MARK: - Actions
    @IBAction func onTapDoneButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - Table View Data Source
extension ReportViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        let currentEvent = events[indexPath.row]
        cell.textLabel?.text = "\(currentEvent.time)' Player \(currentEvent.playerName): \(currentEvent.type)"
        return cell
    }
    
}

//MARK: - Table View Delegate
extension ReportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
