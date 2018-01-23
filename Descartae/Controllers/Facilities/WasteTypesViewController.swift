//
//  WasteTypesViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 17/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit
import SVProgressHUD

class WasteTypesViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var tableView: UITableView!

    var wasteTypes: [WasteType] = DataManager.shared.data.wasteTypes

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        setupTableView()

        if wasteTypes.count == 0 {
            SVProgressHUD.show()
            DataManager.shared.loadData(wasteTypesOnly: true, completionHandler: { (error) in
                self.wasteTypes = DataManager.shared.data.wasteTypes

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
            })
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPathOfSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathOfSelectedRow, animated: true)
        }
    }

    // MARK: Initial setups

    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = WasteTypeTableViewCell.rowHeight

        tableView.register(WasteTypeTableViewCell.nib, forCellReuseIdentifier: WasteTypeTableViewCell.identifier)
    }
}

extension WasteTypesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wasteTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let wasteTypeCell = tableView.dequeueReusableCell(withIdentifier: WasteTypeTableViewCell.identifier, for: indexPath) as? WasteTypeTableViewCell {
            let wasteType = wasteTypes[indexPath.row]
            wasteTypeCell.wasteType = wasteType

            return wasteTypeCell
        }

        return UITableViewCell()
    }

}
