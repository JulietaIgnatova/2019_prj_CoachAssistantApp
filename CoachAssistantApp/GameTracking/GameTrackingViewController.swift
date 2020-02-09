//
//  GameTrackingViewController.swift
//  CoachAssistantApp
//
//  Created by Julieta Ignatova on 2/9/20.
//  Copyright © 2020 Swift FMI. All rights reserved.
//

import UIKit

class GameTrackingViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var successMsg: UILabel!
    @IBOutlet weak var eventPicker: UIPickerView!
    @IBOutlet weak var tickBtn: UIButton!
    @IBOutlet weak var playersSegmentedControl: UISegmentedControl!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var startStopTimerBtn: UIButton!
    @IBOutlet weak var pickerHeaderView: UIView!
    
    //MARK: - Properties
    var arrayWithPlayers: [String] = []
    
    private let endGameSegueId = "endGameSegue"

    private var currSelectedEvent = EventType.allCases[0]
    private var arrayWithEvents: [Event] = []
    private let formatter = DateComponentsFormatter()
    
    private let endTime = 45*60
    private var secondsPassed = 0
    
    private var timer: Timer?
    private var timerIsPaused = true {
        didSet {
            if !timerIsPaused {
                plusBtn.isHidden = false
                timer = Timer.scheduledTimer(
                    withTimeInterval: TimeInterval(1),
                    repeats: true,
                    block: { [weak self] _ in
                        guard let self = self else { return }
                        self.secondsPassed += 1
                        self.updateTimerLabel()
                        if self.secondsPassed == self.endTime {
                            self.onTapStartStop(self.startStopTimerBtn)
                        }
                    }
                )
            } else {
                timer?.invalidate()
                plusBtn.isHidden = true
            }
        }
    }
    
    //MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTimerLabel()
        pickerHeaderView.layer.borderWidth = 2
        pickerHeaderView.layer.borderColor = UIColor.lightGray.cgColor
        plusBtn.isHidden = true
        
        eventPicker.dataSource = self
        eventPicker.delegate = self
        
        for i in 0..<arrayWithPlayers.count {
            playersSegmentedControl.setTitle(arrayWithPlayers[i], forSegmentAt: i)
        }
        
    }
    
    //MARK: - Actions
    @IBAction func onTapTick(_ sender: Any) {
        successMsg.isHidden = false
        eventSelectionOutletsAreHidden(true)
        let minute = secondsPassed / 60 + 1
        let newEvent = Event(
            time: minute,
            type: currSelectedEvent.rawValue,
            playerName: arrayWithPlayers[playersSegmentedControl.selectedSegmentIndex]
        )
        arrayWithEvents.append(newEvent)
    }
    
    @IBAction func onTapPlus(_ sender: Any) {
        successMsg.isHidden = true
        eventSelectionOutletsAreHidden(false)
        
    }
    
    @IBAction func onTapStartStop(_ sender: UIButton) {
        if timerIsPaused {
            timerIsPaused = false
            sender.setTitle("⏹", for: .normal)
        } else {
            timerIsPaused = true
            sender.setTitle("▶️", for: .normal)
            performSegue(withIdentifier: endGameSegueId, sender: self)
        }
    }
    
    
    //MARK: - Helpers
    private func eventSelectionOutletsAreHidden(_ areHidden: Bool){
        playersSegmentedControl.isHidden = areHidden
        eventPicker.isHidden = areHidden
        pickerHeaderView.isHidden = areHidden
    }
    
    private func updateTimerLabel()
    {
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        guard let formattedString = formatter.string(from: TimeInterval(secondsPassed)) else { return }
        timerLabel.text = formattedString
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == endGameSegueId, let vc = segue.destination as? ReportViewController else {
            return
        }
        
        vc.events = arrayWithEvents
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let formattedDate = formatter.string(from: Date())
        
        let gameName = "Game \(formattedDate)"
        
        let newGame = Game(
            players: arrayWithPlayers,
            events: arrayWithEvents,
            duration: secondsPassed,
            name: gameName
        )
        Networking.shared.addGame(newGame)
    }
}

// MARK: - Picker View Data Source
extension GameTrackingViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return EventType.allCases.count
    }
}

// MARK: - Picker View Delegate
extension GameTrackingViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return EventType.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currSelectedEvent = EventType.allCases[row]
    }
}


