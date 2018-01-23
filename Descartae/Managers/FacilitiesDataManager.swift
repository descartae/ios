//
//  FacilitiesDataManager.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 22/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import Foundation
import Apollo

let facilitiesDataUpdatedNotification = NSNotification.Name(rawValue: "facilitiesDataUpdatedNotification")

struct FacilitiesData {
    var wasteTypes: [WasteType] = []
    var filteringByWasteTypes: [WasteType] = []
    var facilities: [DisposalFacility] = [] {
        didSet {
            NotificationCenter.default.post(name: facilitiesDataUpdatedNotification, object: nil)
        }
    }
    var after: String?
}

class FacilitiesDataManager {

    static let shared: FacilitiesDataManager = FacilitiesDataManager()

    private let quantity: Int = 10
    var isLoading = false
    var data = FacilitiesData()

    lazy private var firstPageQuery: AllFacilitiesQuery = {
        return AllFacilitiesQuery(quantity: quantity)
    }()
    lazy private var nextPageQuery: AllFacilitiesQuery = {
        return AllFacilitiesQuery(quantity: quantity)
    }()

    func loadData(completionHandler: ((_ error: Error?) -> Void)?) {
        firstPageQuery.typesOfWasteToFilter = self.data.filteringByWasteTypes.map {$0.id}
        isLoading = true
        GraphQL.client.fetch(query: firstPageQuery) { (result, error) in
            self.isLoading = false
            self.handleFetchResponse(result, error, completionHandler, isLoadingMoreData: false)
        }
    }

    func loadMoreData(completionHandler: ((_ error: Error?) -> Void)?) {
        guard data.after != nil else {
            completionHandler?(nil)
            return
        }

        nextPageQuery.typesOfWasteToFilter = firstPageQuery.typesOfWasteToFilter
        nextPageQuery.after = data.after
        GraphQL.client.fetch(query: nextPageQuery) { (result, error) in
            self.handleFetchResponse(result, error, completionHandler, isLoadingMoreData: true)
        }
    }

    private func handleFetchResponse(_ result: GraphQLResult<AllFacilitiesQuery.Data>?, _ error: Error?, _ completionHandler: ((_ error: Error?) -> Void)?, isLoadingMoreData: Bool) {
        guard error == nil else {
            completionHandler?(error)
            return
        }

        let facilitiesQueryFragment = result?.data?.facilities?.items as? [AllFacilitiesQuery.Data.Facility.Item] ?? []
        let typesOfWasteQueryFragment = result?.data?.typesOfWaste as? [AllFacilitiesQuery.Data.TypesOfWaste] ?? []

        self.data.after = result?.data?.facilities?.cursors.after
        self.data.wasteTypes = typesOfWasteQueryFragment.map({ $0.fragments.wasteType })
        let facilities = facilitiesQueryFragment.map({ $0.fragments.disposalFacility })

        if isLoadingMoreData {
            self.data.facilities.append(contentsOf: facilities)
        } else {
            self.data.facilities = facilities
        }

        completionHandler?(error)
    }

}
