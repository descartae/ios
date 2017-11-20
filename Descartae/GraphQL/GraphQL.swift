//
//  GraphQL.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 20/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import Foundation
import Apollo

struct GraphQL {

    static let graphQLEndpoint = "http://descartae-api.gcp.planejei.com:7000/graphql"
    static let client = ApolloClient(url: URL(string: graphQLEndpoint)!) // swiftlint:disable:this force_unwrapping

}
