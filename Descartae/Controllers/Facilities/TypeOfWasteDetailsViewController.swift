//
//  TypeOfWasteDetailsViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 09/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit

class TypeOfWasteDetailsViewController: UIViewController {

    // MARK: Properties

    static let identifier = String(describing: TypeOfWasteDetailsViewController.self)

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var typeOfWasteDescription: UILabel!

    var typeOfWaste: DisposalFacility.TypesOfWaste!

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        bindTypeOfWasteData()
    }

    // MARK: Setup

    func bindTypeOfWasteData() {
        name.textColor = UIColor(hexString: typeOfWaste.color)
        name.text = typeOfWaste.name
        typeOfWasteDescription.text = typeOfWaste.description

        if let iconURL = URL(string: typeOfWaste.icons.iosLargeUrl) {
            icon.sd_setShowActivityIndicatorView(true)
            icon.sd_setIndicatorStyle(.gray)
            icon.sd_setImage(with: iconURL, placeholderImage: UIImage(named: "icWasteEmptyLarge"), completed: nil)
        }
    }

    // MARK: Actions

    @IBAction func close(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
