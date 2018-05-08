//
//  IntroContentView.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 31/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit
import Device_swift

class IntroContentView: UIView {

    // MARK: Properties

    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var startButton: UIButton! {
        didSet {
            startButton.setTitle(localized("start_button_title"), for: .normal)
        }
    }
    @IBOutlet weak var onboardingImageHeight: NSLayoutConstraint!
    @IBOutlet weak var onboardingImageWidth: NSLayoutConstraint!
    @IBOutlet weak var onboardingImageTop: NSLayoutConstraint!
    @IBOutlet weak var titleTop: NSLayoutConstraint!
    @IBOutlet weak var startButtonTop: NSLayoutConstraint!

    var start: (() -> Void)?

    // MARK: Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        let smallDevices: [DeviceType] = [
            .iPhone3G,
            .iPhone3GS,
            .iPhone4,
            .iPhone4S,
            .iPad,
            .iPad2,
            .iPad3,
            .iPad4,
            .iPadMini,
            .iPadMiniRetina,
            .iPadMini3,
            .iPadMini4,
            .iPadAir,
            .iPadAir2,
            .iPadPro9Inch,
            .iPadPro10p5Inch,
            .iPadPro12Inch,
            .simulator,
            .notAvailable
        ]

        switch DeviceType.current {
        case _ where smallDevices.contains(DeviceType.current):
            onboardingImageHeight.constant = 160
            onboardingImageWidth.constant = 160
            onboardingImageTop.constant -= 20
            titleTop.constant -= 16
            startButtonTop.constant -= 8
        case .iPhoneSE, .iPhone5:
            onboardingImageHeight.constant = 200
            onboardingImageWidth.constant = 200
            onboardingImageTop.constant -= 24
            titleTop.constant -= 20
            startButtonTop.constant -= 8
        case .iPhone6Plus, .iPhone7Plus, .iPhone8Plus, .iPhoneX:
            onboardingImageTop.constant += 24
            titleTop.constant += 8
            startButtonTop.constant += 24
        default:
            break
        }
    }

    // MARK: Actions

    @IBAction func start(_ sender: Any) {
        start?()
    }
}
