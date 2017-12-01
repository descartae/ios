//  This file was automatically generated and should not be edited.

import Apollo

public final class AllFacilitiesQuery: GraphQLQuery {
  public static let operationString =
    "query allFacilities {\n  centers {\n    __typename\n    ...Facility\n  }\n}"

  public static var requestString: String { return operationString.appending(Facility.fragmentString) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("centers", type: .list(.object(Center.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(centers: [Center?]? = nil) {
      self.init(snapshot: ["__typename": "Query", "centers": centers.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
    }

    /// The list of available centers
    public var centers: [Center?]? {
      get {
        return (snapshot["centers"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Center(snapshot: $0) } } }
      }
      set {
        snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "centers")
      }
    }

    public struct Center: GraphQLSelectionSet {
      public static let possibleTypes = ["Center"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("_id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("location", type: .nonNull(.object(Location.selections))),
        GraphQLField("typesOfWaste", type: .list(.object(TypesOfWaste.selections))),
        GraphQLField("website", type: .scalar(String.self)),
        GraphQLField("telephone", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, location: Location, typesOfWaste: [TypesOfWaste?]? = nil, website: String? = nil, telephone: String? = nil) {
        self.init(snapshot: ["__typename": "Center", "_id": id, "name": name, "location": location.snapshot, "typesOfWaste": typesOfWaste.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "website": website, "telephone": telephone])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["_id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "_id")
        }
      }

      /// The name of the center
      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      /// The location data for a given center
      public var location: Location {
        get {
          return Location(snapshot: snapshot["location"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "location")
        }
      }

      /// The types of waste the recycling center handles
      public var typesOfWaste: [TypesOfWaste?]? {
        get {
          return (snapshot["typesOfWaste"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { TypesOfWaste(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "typesOfWaste")
        }
      }

      /// The responsible's website, if available
      public var website: String? {
        get {
          return snapshot["website"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "website")
        }
      }

      /// The responsible's contact phone number, if available
      public var telephone: String? {
        get {
          return snapshot["telephone"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "telephone")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }

      public struct Fragments {
        public var snapshot: Snapshot

        public var facility: Facility {
          get {
            return Facility(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      public struct Location: GraphQLSelectionSet {
        public static let possibleTypes = ["Location"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("address", type: .nonNull(.scalar(String.self))),
          GraphQLField("municipality", type: .scalar(String.self)),
          GraphQLField("coordinates", type: .object(Coordinate.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(address: String, municipality: String? = nil, coordinates: Coordinate? = nil) {
          self.init(snapshot: ["__typename": "Location", "address": address, "municipality": municipality, "coordinates": coordinates.flatMap { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The readable address
        public var address: String {
          get {
            return snapshot["address"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "address")
          }
        }

        /// The adress' municipality
        public var municipality: String? {
          get {
            return snapshot["municipality"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "municipality")
          }
        }

        /// Exact coordinates to the location
        public var coordinates: Coordinate? {
          get {
            return (snapshot["coordinates"] as? Snapshot).flatMap { Coordinate(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "coordinates")
          }
        }

        public struct Coordinate: GraphQLSelectionSet {
          public static let possibleTypes = ["Coordinates"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("latitude", type: .nonNull(.scalar(Double.self))),
            GraphQLField("longitude", type: .nonNull(.scalar(Double.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(latitude: Double, longitude: Double) {
            self.init(snapshot: ["__typename": "Coordinates", "latitude": latitude, "longitude": longitude])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var latitude: Double {
            get {
              return snapshot["latitude"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "latitude")
            }
          }

          public var longitude: Double {
            get {
              return snapshot["longitude"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "longitude")
            }
          }
        }
      }

      public struct TypesOfWaste: GraphQLSelectionSet {
        public static let possibleTypes = ["TypeOfWaste"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("_id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("icon", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, icon: String) {
          self.init(snapshot: ["__typename": "TypeOfWaste", "_id": id, "name": name, "icon": icon])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["_id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "_id")
          }
        }

        /// The user-readable type name
        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        /// The icon URL
        public var icon: String {
          get {
            return snapshot["icon"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "icon")
          }
        }
      }
    }
  }
}

public struct Facility: GraphQLFragment {
  public static let fragmentString =
    "fragment Facility on Center {\n  __typename\n  _id\n  name\n  location {\n    __typename\n    address\n    municipality\n    coordinates {\n      __typename\n      latitude\n      longitude\n    }\n  }\n  typesOfWaste {\n    __typename\n    _id\n    name\n    icon\n  }\n  website\n  telephone\n}"

  public static let possibleTypes = ["Center"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
    GraphQLField("location", type: .nonNull(.object(Location.selections))),
    GraphQLField("typesOfWaste", type: .list(.object(TypesOfWaste.selections))),
    GraphQLField("website", type: .scalar(String.self)),
    GraphQLField("telephone", type: .scalar(String.self)),
  ]

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(id: GraphQLID, name: String, location: Location, typesOfWaste: [TypesOfWaste?]? = nil, website: String? = nil, telephone: String? = nil) {
    self.init(snapshot: ["__typename": "Center", "_id": id, "name": name, "location": location.snapshot, "typesOfWaste": typesOfWaste.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "website": website, "telephone": telephone])
  }

  public var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: GraphQLID {
    get {
      return snapshot["_id"]! as! GraphQLID
    }
    set {
      snapshot.updateValue(newValue, forKey: "_id")
    }
  }

  /// The name of the center
  public var name: String {
    get {
      return snapshot["name"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "name")
    }
  }

  /// The location data for a given center
  public var location: Location {
    get {
      return Location(snapshot: snapshot["location"]! as! Snapshot)
    }
    set {
      snapshot.updateValue(newValue.snapshot, forKey: "location")
    }
  }

  /// The types of waste the recycling center handles
  public var typesOfWaste: [TypesOfWaste?]? {
    get {
      return (snapshot["typesOfWaste"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { TypesOfWaste(snapshot: $0) } } }
    }
    set {
      snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "typesOfWaste")
    }
  }

  /// The responsible's website, if available
  public var website: String? {
    get {
      return snapshot["website"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "website")
    }
  }

  /// The responsible's contact phone number, if available
  public var telephone: String? {
    get {
      return snapshot["telephone"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "telephone")
    }
  }

  public struct Location: GraphQLSelectionSet {
    public static let possibleTypes = ["Location"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("address", type: .nonNull(.scalar(String.self))),
      GraphQLField("municipality", type: .scalar(String.self)),
      GraphQLField("coordinates", type: .object(Coordinate.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(address: String, municipality: String? = nil, coordinates: Coordinate? = nil) {
      self.init(snapshot: ["__typename": "Location", "address": address, "municipality": municipality, "coordinates": coordinates.flatMap { $0.snapshot }])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    /// The readable address
    public var address: String {
      get {
        return snapshot["address"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "address")
      }
    }

    /// The adress' municipality
    public var municipality: String? {
      get {
        return snapshot["municipality"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "municipality")
      }
    }

    /// Exact coordinates to the location
    public var coordinates: Coordinate? {
      get {
        return (snapshot["coordinates"] as? Snapshot).flatMap { Coordinate(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "coordinates")
      }
    }

    public struct Coordinate: GraphQLSelectionSet {
      public static let possibleTypes = ["Coordinates"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("latitude", type: .nonNull(.scalar(Double.self))),
        GraphQLField("longitude", type: .nonNull(.scalar(Double.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(latitude: Double, longitude: Double) {
        self.init(snapshot: ["__typename": "Coordinates", "latitude": latitude, "longitude": longitude])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var latitude: Double {
        get {
          return snapshot["latitude"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "latitude")
        }
      }

      public var longitude: Double {
        get {
          return snapshot["longitude"]! as! Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "longitude")
        }
      }
    }
  }

  public struct TypesOfWaste: GraphQLSelectionSet {
    public static let possibleTypes = ["TypeOfWaste"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("_id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("icon", type: .nonNull(.scalar(String.self))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(id: GraphQLID, name: String, icon: String) {
      self.init(snapshot: ["__typename": "TypeOfWaste", "_id": id, "name": name, "icon": icon])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: GraphQLID {
      get {
        return snapshot["_id"]! as! GraphQLID
      }
      set {
        snapshot.updateValue(newValue, forKey: "_id")
      }
    }

    /// The user-readable type name
    public var name: String {
      get {
        return snapshot["name"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "name")
      }
    }

    /// The icon URL
    public var icon: String {
      get {
        return snapshot["icon"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "icon")
      }
    }
  }
}