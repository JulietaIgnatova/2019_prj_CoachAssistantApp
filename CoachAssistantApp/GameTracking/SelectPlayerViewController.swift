//
//  SelectPlayerViewController.swift
//  CoachAssistantApp
//
//  Created by Julieta Ignatova on 2/8/20.
//  Copyright © 2020 Swift FMI. All rights reserved.
//

import UIKit

class SelectPlayerViewController: UIViewController {
    
    // MARK: - Properties
    let segueId = "startGameSegue"
    var selectedPlayerButtons: [UIButton] = []
    
    // MARK: - Outlets
    
    @IBOutlet var playerButtons: [UIButton]!
    
    // MARK: - Actions
    
    @IBAction func onTapDoneBtn(_ sender: Any) {
        guard selectedPlayerButtons.count == 3 else {
            let alert = UIAlertController(title: "Error⚠️", message: "Please select only three players.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
    
        performSegue(withIdentifier: segueId, sender: self)
    }
    
    @IBAction func onTapPlayerBtn(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            selectedPlayerButtons.append(sender)
        } else {
            sender.isSelected = false
            selectedPlayerButtons.removeAll { $0 === sender }
        }
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in playerButtons {
            button.setTitleColor(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), for: .selected)
        }
    }
   
    // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == segueId, let vc = segue.destination as? GameTrackingViewController else {
            return
        }
        
        vc.arrayWithPlayers = selectedPlayerButtons.map { $0.title(for: .normal)! }
    }
    

}
