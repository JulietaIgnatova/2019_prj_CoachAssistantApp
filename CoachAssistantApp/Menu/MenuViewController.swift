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
    private let gameReportSegueId = "gameReportSegue"
    
    //MARK: - Actions
    @IBAction func editBtn(_ sender: UIBarButtonItem) {
        if tableViewForAllGames.isEditing {
            tableViewForAllGames.isEditing = false
            sender.title = "Edit"
        } else {
            tableViewForAllGames.isEditing = true
            sender.title = "Done"
            
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var tableViewForAllGames: UITableView!
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewForAllGames.delegate = self
        tableViewForAllGames.dataSource = self
        tableViewForAllGames.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchDataOrDisplayAlert()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == gameReportSegueId,
            let vc = segue.destination as? ReportViewController,
        let cell = sender as? UITableViewCell,
        let cellIndexPath = tableViewForAllGames.indexPath(for: cell) else {
            return
        }
        
        vc.events = arrayWithGames[cellIndexPath.row].events
    }
    
    // MARK: - Helpers
    func fetchDataOrDisplayAlert() {
        Networking.shared.fetchGames(completion: {
            [weak self] games in
            guard let self = self else { return }
            
            guard let games = games else {
                print("Fetch failure.")
                let alert = UIAlertController(title: "Error⚠️", message: "Cannot connect to server. 😓", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default) {
                    [weak self] _ in
                    self?.fetchDataOrDisplayAlert()
                })
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            self.arrayWithGames = games
            self.arrayWithGames.sort(by: {
                (g1,g2) -> Bool in
                g1.name > g2.name
            })
            self.tableViewForAllGames?.reloadData()
        })
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            arrayWithGames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        // TODO: remove from database
        default:
            break
        }
    }
}

//MARK: - Table View Delegate
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
