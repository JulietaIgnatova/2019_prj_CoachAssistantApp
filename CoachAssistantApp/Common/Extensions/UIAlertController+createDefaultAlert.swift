//
//  UIAlertController+createDefaultAlert.swift
//  CoachAssistantApp
//
//  Created by Dimitar Parapanov on 20.02.20.
//  Copyright © 2020 Swift FMI. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func createDefaultAlert(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alertController
    }
}
