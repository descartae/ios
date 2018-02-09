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

    @IBOutlet weak var offlineTitle: UILabel! {
        didSet {
            offlineTitle.text = localized("offline_state_title")
        }
    }

    @IBOutlet weak var offlineSubtitle: UILabel! {
        didSet {
            offlineSubtitle.text = localized("offline_state_subtitle")
        }
    }

    @IBOutlet weak var tryAgainButton: UIButton! {
        didSet {
            tryAgainButton.setTitle(localized("try_again_button_title"), for: .normal)
        }
    }

    var tryAgain: (() -> Void)?

    // MARK: Actions

    @IBAction func tryAgain(_ sender: Any) {
        tryAgain?()
    }
}
