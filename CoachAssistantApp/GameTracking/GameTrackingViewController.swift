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
    @IBOutlet weak var eventPicker: UIPickerView!
    @IBOutlet weak var tickBtn: UIButton!
    @IBOutlet weak var playersSegmentedControl: UISegmentedControl!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var startStopTimerBtn: UIButton!
    @IBOutlet weak var pickerHeaderView: UIView!
    
    //MARK: - Properties
    var arrayWithPlayers: [String] = []
    private let formatter = DateComponentsFormatter()
    private var secondsLeft = 45 * 60
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
                        self.secondsLeft -= 1
                        self.updateTimerLabel()
                        if self.secondsLeft == 0 {
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
        evenSelectionOutletsAreHidden(true)
        updateTimerLabel()
        pickerHeaderView.layer.borderWidth = 2
        pickerHeaderView.layer.borderColor = UIColor.lightGray.cgColor
        
        for i in 0..<arrayWithPlayers.count {
            playersSegmentedControl.setTitle(arrayWithPlayers[i], forSegmentAt: i)
        }
        
    }
    
    //MARK: - Actions
    @IBAction func onTapTick(_ sender: Any) {
        evenSelectionOutletsAreHidden(true)
        timerIsPaused = false
    }
    
    @IBAction func onTapPlus(_ sender: Any) {
        evenSelectionOutletsAreHidden(false)
        timerIsPaused = true
    }
    
    @IBAction func onTapStartStop(_ sender: UIButton) {
        if timerIsPaused {
            timerIsPaused = false
            sender.setTitle("⏹", for: .normal)
        } else {
            timerIsPaused = true
            sender.setTitle("▶️", for: .normal)
        }
    }
    
    
    //MARK: - Helpers
    private func evenSelectionOutletsAreHidden(_ isHidden: Bool){
        playersSegmentedControl.isHidden = isHidden
        eventPicker.isHidden = isHidden
        pickerHeaderView.isHidden = isHidden
    }
    
    private func updateTimerLabel()
    {
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        
        guard let formattedString = formatter.string(from: TimeInterval(secondsLeft)) else { return }
        timerLabel.text = formattedString
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
