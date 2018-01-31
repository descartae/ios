//
//  IntroContentView.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 31/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit

class IntroContentView: UIView {

    // MARK: Properties

    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var startButton: UIButton!

    var start: (() -> Void)?

    // MARK: Actions

    @IBAction func start(_ sender: Any) {
        start?()
    }
}
