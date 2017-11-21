//
//  CentersViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 18/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit

final class CentersViewController: UIViewController {

    var centers: [CenterData] = []

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

            self.centers = centersQueryFragment.map({ $0.fragments.centerData })
        }
    }

}
