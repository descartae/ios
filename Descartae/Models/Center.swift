//
//  Center.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 20/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import Foundation
import Apollo

extension Center: Equatable {

    public static func == (lhs: Center, rhs: Center) -> Bool {
        return lhs.id == rhs.id
    }

    static func collection<T: GraphQLSelectionSet>(fromQueryResult result: [T]) -> [Center] {
        return result.flatMap { centerFromQueryResult in
            guard let typeName = centerFromQueryResult.snapshot["__typename"] as? String, typeName == Center.possibleTypes.first else {
                return nil
            }

            return Center(snapshot: centerFromQueryResult.snapshot)
        }
    }

}
