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

    @IBOutlet weak var filterTitle: UILabel! {
        didSet {
            filterTitle.text = localized("filter_facilities_title")
        }
    }
    @IBOutlet weak var filterSubtitle: UILabel! {
        didSet {
            filterSubtitle.text = localized("filter_facilities_subtitle")
        }
    }
    @IBOutlet weak var cleanButton: UIButton! {
        didSet {
            cleanButton.setTitle(localized("clear_filter_button_title"), for: .normal)
        }
    }
    
    var wasteTypesToFilter: [WasteType] = APIManager.filteringByWasteTypes
    var applyFilters: (() -> Void)?
    let locationManager = LocationManager.shared

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        if DataStore.wasteTypes.count == 0 {
            SVProgressHUD.show()
            APIManager.loadData(wasteTypesOnly: true, completionHandler: { _ in
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
        tableView.estimatedRowHeight = TypeOfWasteFilterTableViewCell.rowHeight

        tableView.register(TypeOfWasteFilterTableViewCell.nib, forCellReuseIdentifier: TypeOfWasteFilterTableViewCell.identifier)
    }

    // MARK: Actions

    @objc func applySelection() {
        guard locationManager.location != nil, !locationManager.shouldAskForAuthorization, !locationManager.isLocationDenied else {
            let activateLocation = UIAlertController(title: "Ops!", message: "Você precisa permitir acesso a sua localização para que nós possamos buscar ou filtrar os pontos de coleta mais próximos.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Tudo bem", style: .default, handler: nil)
            activateLocation.addAction(okAction)

            present(activateLocation, animated: true, completion: nil)

            return
        }

        APIManager.filteringByWasteTypes = wasteTypesToFilter
        applyFilters?()
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
        return DataStore.wasteTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let wasteTypeCell = tableView.dequeueReusableCell(withIdentifier: TypeOfWasteFilterTableViewCell.identifier, for: indexPath) as? TypeOfWasteFilterTableViewCell {
            let wasteType = DataStore.wasteTypes[indexPath.row]
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

        let wasteType = DataStore.wasteTypes[indexPath.row]

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
