//
//  OfflineStateViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 29/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit

class OfflineStateViewController: UIViewController {

    // MARK: Properties

    static let identifier = String(describing: OfflineStateViewController.self)
    var tryAgain: (() -> Void)?

    // MARK: Actions

    @IBAction func tryAgain(_ sender: Any) {
        tryAgain?()
    }
}
