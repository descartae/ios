//
//  FacilitiesViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 18/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit

final class FacilitiesViewController: UIViewController {

    var facilities: [Facility] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let allCentersQuery = AllCentersQuery()
        GraphQL.client.fetch(query: allCentersQuery) { (result, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }

            guard let centersQueryFragment = result?.data?.centers as? [AllCentersQuery.Data.Center] else {
                return
            }

            self.facilities = centersQueryFragment.map({ $0.fragments.facility })
        }
    }

}

extension FacilitiesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facilities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
