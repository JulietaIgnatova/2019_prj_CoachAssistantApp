//
//  MenuViewController.swift
//  CoachAssistantApp
//
//  Created by Julieta Ignatova on 2/8/20.
//  Copyright © 2020 Swift FMI. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    //MARK: - Properties
    var arrayWithGames: [Game] = []
    let cellGameId = "gameCell"
    private let gameReportSegueSegueId = "gameReportSegue"
    
    //MARK: - Outlets
    @IBOutlet weak var tableViewForAllGames: UITableView!
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewForAllGames.delegate = self
        tableViewForAllGames.dataSource = self
        arrayWithGames = Networking.shared.fetchGames(for: "dT")
        tableViewForAllGames.dataSource = self
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == gameReportSegueSegueId,
            let vc = segue.destination as? ReportViewController,
        let cell = sender as? UITableViewCell,
        let cellIndexPath = tableViewForAllGames.indexPath(for: cell) else {
            return
        }
        
        vc.events = arrayWithGames[cellIndexPath.row].events
    }
    
}

//MARK: - Table View Data Source
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayWithGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewForAllGames.dequeueReusableCell(withIdentifier: cellGameId, for: indexPath)
        let currentGame = arrayWithGames[indexPath.row]
        cell.textLabel?.text = currentGame.name
        return cell
    }
}
//MARK: - Table View Delegate
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
