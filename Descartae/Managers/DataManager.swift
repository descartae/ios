//
//  FacilitiesDataManager.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 22/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import Foundation
import Apollo

let facilitiesDataUpdated = NSNotification.Name(rawValue: "facilitiesDataUpdatedNotification")

struct DataStore {
    var wasteTypes: [WasteType] = []
    var filteringByWasteTypes: [WasteType] = []
    var facilities: [DisposalFacility] = [] {
        didSet {
            NotificationCenter.default.post(name: facilitiesDataUpdated, object: nil)
        }
    }
    var after: String?
}

class DataManager {

    // MARK: Properties

    static let shared: DataManager = DataManager()

    private let quantity: Int = 10
    var data = DataStore()

    lazy private var firstPageQuery: FacilitiesQuery = {
        return FacilitiesQuery(quantity: quantity)
    }()

    lazy private var nextPageQuery: FacilitiesQuery = {
        return FacilitiesQuery(quantity: quantity)
    }()

    lazy private var wasteTypesQuery = WasteTypesQuery()

    // MARK: Init

    private init() { }

    // MARK: Data fetching

    func loadData(wasteTypesOnly: Bool = false, completionHandler: ((_ error: Error?) -> Void)? = nil) {
        if wasteTypesOnly {
            GraphQL.client.fetch(query: wasteTypesQuery, resultHandler: { (result, error) in
                self.handleWasteTypesQueryFetch(result, error, completionHandler)
            })

            return
        }

        firstPageQuery.typesOfWasteToFilter = self.data.filteringByWasteTypes.map {$0.id}
        GraphQL.client.fetch(query: firstPageQuery) { (result, error) in
            self.handleFacilitiesQueryFetch(result, error, completionHandler, isLoadingMoreData: false)
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
            self.handleFacilitiesQueryFetch(result, error, completionHandler, isLoadingMoreData: true)
        }
    }

    private func handleFacilitiesQueryFetch(_ result: GraphQLResult<FacilitiesQuery.Data>?, _ error: Error?, _ completionHandler: ((_ error: Error?) -> Void)?, isLoadingMoreData: Bool) {
        guard error == nil else {
            completionHandler?(error)
            return
        }

        let facilitiesQueryFragment = result?.data?.facilities?.items as? [FacilitiesQuery.Data.Facility.Item] ?? []
        let typesOfWasteQueryFragment = result?.data?.typesOfWaste as? [FacilitiesQuery.Data.TypesOfWaste] ?? []

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

    private func handleWasteTypesQueryFetch(_ result: GraphQLResult<WasteTypesQuery.Data>?, _ error: Error?, _ completionHandler: ((_ error: Error?) -> Void)?) {
        guard error == nil else {
            completionHandler?(error)
            return
        }

        let typesOfWasteQueryFragment = result?.data?.typesOfWaste as? [WasteTypesQuery.Data.TypesOfWaste] ?? []
        self.data.wasteTypes = typesOfWasteQueryFragment.map({ $0.fragments.wasteType })

        completionHandler?(error)
    }

}
