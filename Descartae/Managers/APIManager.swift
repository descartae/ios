//
//  FacilitiesDataManager.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 22/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import Foundation
import Apollo
import Reachability

struct DataStore {
    static var wasteTypes: [WasteType] = []
    static var facilities: [DisposalFacility] = []
    static var after: String?

    static func resetFacilities() {
        facilities = []
        after = nil
        StateManager.updateStateFor([.facilities, .nextPageIsUnavailable])
    }
}

struct APIManager {

    // MARK: Properties

    static var isReachable: Bool {
        if let reachability = Reachability() {
            return reachability.connection != .none
        }

        return false
    }
    static var filteringByWasteTypes: [WasteType] = []
    static private let quantity: Int = 7
    static private var firstPageQuery: FacilitiesQuery = {
        return FacilitiesQuery(quantity: quantity)
    }()

    static private var nextPageQuery: FacilitiesQuery = {
        return FacilitiesQuery(quantity: quantity)
    }()

    static private var wasteTypesQuery = WasteTypesQuery()

    // MARK: Init

    private init() { }

    // MARK: Data fetching

    static func loadData(wasteTypesOnly: Bool = false, completionHandler: ((_ error: Error?) -> Void)? = nil) {
        if wasteTypesOnly {
            GraphQL.client.fetch(query: wasteTypesQuery, resultHandler: { (result, error) in
                self.handleWasteTypesQueryFetch(result, error, completionHandler)
            })

            return
        }

        DataStore.after = nil
        firstPageQuery.typesOfWasteToFilter = APIManager.filteringByWasteTypes.map {$0.id}
        GraphQL.client.fetch(query: firstPageQuery) { (result, error) in
            self.handleFacilitiesQueryFetch(result, error, completionHandler, isLoadingMoreData: false)
        }
    }

    static func loadMoreData(completionHandler: ((_ error: Error?) -> Void)?) {
        guard DataStore.after != nil else {
            completionHandler?(nil)
            return
        }

        nextPageQuery.typesOfWasteToFilter = firstPageQuery.typesOfWasteToFilter
        nextPageQuery.after = DataStore.after
        GraphQL.client.fetch(query: nextPageQuery) { (result, error) in
            self.handleFacilitiesQueryFetch(result, error, completionHandler, isLoadingMoreData: true)
        }
    }

    static private func handleFacilitiesQueryFetch(_ result: GraphQLResult<FacilitiesQuery.Data>?, _ error: Error?, _ completionHandler: ((_ error: Error?) -> Void)?, isLoadingMoreData: Bool) {
        guard error == nil else {
            completionHandler?(error)
            return
        }

        let facilitiesQueryFragment = result?.data?.facilities?.items as? [FacilitiesQuery.Data.Facility.Item] ?? []
        let typesOfWasteQueryFragment = result?.data?.typesOfWaste as? [FacilitiesQuery.Data.TypesOfWaste] ?? []

        DataStore.wasteTypes = typesOfWasteQueryFragment.map({ $0.fragments.wasteType })
        let facilities = facilitiesQueryFragment.map({ $0.fragments.disposalFacility })

        if let after = result?.data?.facilities?.cursors.after, facilities.count == self.quantity {
            DataStore.after = after
        } else {
            DataStore.after = nil
        }

        if isLoadingMoreData {
            DataStore.facilities.append(contentsOf: facilities)
        } else {
            DataStore.facilities = facilities
        }

//        if DataStore.after != nil {
//            StateManager.updateStateFor([.nextPageIsAvailable])
//        } else {
//            StateManager.updateStateFor([.nextPageIsUnavailable])
//        }
        let stateUpdates: [ObservableState] = DataStore.after != nil ? [.nextPageIsAvailable, .facilities] : [.nextPageIsUnavailable, .facilities]
        StateManager.updateStateFor(stateUpdates)

        completionHandler?(error)
    }

    static private func handleWasteTypesQueryFetch(_ result: GraphQLResult<WasteTypesQuery.Data>?, _ error: Error?, _ completionHandler: ((_ error: Error?) -> Void)?) {
        guard error == nil else {
            completionHandler?(error)
            return
        }

        let typesOfWasteQueryFragment = result?.data?.typesOfWaste as? [WasteTypesQuery.Data.TypesOfWaste] ?? []
        DataStore.wasteTypes = typesOfWasteQueryFragment.map({ $0.fragments.wasteType })

        completionHandler?(error)
    }

}
