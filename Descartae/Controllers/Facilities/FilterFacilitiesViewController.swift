//
//  FilterFacilitiesViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 16/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit
import SVProgressHUD

class FilterFacilitiesViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var tableView: UITableView!

    let dataManager = DataManager.shared
    var wasteTypesToFilter: [WasteType] = DataManager.shared.data.filteringByWasteTypes
    var updateFilterIconBadge: (() -> Void)?

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
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
        tableView.estimatedRowHeight = TypeOfWasteFilterTableViewCell.rowHeight

        tableView.register(TypeOfWasteFilterTableViewCell.nib, forCellReuseIdentifier: TypeOfWasteFilterTableViewCell.identifier)
    }

    // MARK: Actions

    @objc func applySelection() {
        dataManager.data.filteringByWasteTypes = wasteTypesToFilter
        updateFilterIconBadge?()

        SVProgressHUD.show()
        DataManager.shared.loadData(completionHandler: { (_) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
        })

        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func clearSelection(_ sender: Any) {
        wasteTypesToFilter = []
        tableView.reloadData()
    }

    @IBAction func close(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

}

extension FilterFacilitiesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.data.wasteTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let wasteTypeCell = tableView.dequeueReusableCell(withIdentifier: TypeOfWasteFilterTableViewCell.identifier, for: indexPath) as? TypeOfWasteFilterTableViewCell {
            let wasteType = dataManager.data.wasteTypes[indexPath.row]
            wasteTypeCell.wasteType = wasteType

            if wasteTypesToFilter.contains(wasteType) {
                wasteTypeCell.accessoryType = .checkmark
            } else {
                wasteTypeCell.accessoryType = .none
            }

            return wasteTypeCell
        }

        return UITableViewCell()
    }

}

extension FilterFacilitiesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let wasteTypeCell = tableView.cellForRow(at: indexPath) as? TypeOfWasteFilterTableViewCell else {
            return
        }

        let wasteType = dataManager.data.wasteTypes[indexPath.row]

        if let wasteTypeIndex = wasteTypesToFilter.index(of: wasteType) {
            wasteTypesToFilter.remove(at: wasteTypeIndex)
            wasteTypeCell.accessoryType = .none
        } else {
            wasteTypesToFilter.append(wasteType)
            wasteTypeCell.accessoryType = .checkmark
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return FilterWasteTypesSectionFooter.height
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = FilterWasteTypesSectionFooter.instantiateFromNib() else {
            return nil
        }

        footerView.applySelection.addTarget(self, action: #selector(applySelection), for: .touchUpInside)

        return footerView
    }

}
