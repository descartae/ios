//  This file was automatically generated and should not be edited.

import Apollo

public enum DayOfWeek: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case sunday
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "SUNDAY": self = .sunday
      case "MONDAY": self = .monday
      case "TUESDAY": self = .tuesday
      case "WEDNESDAY": self = .wednesday
      case "THURSDAY": self = .thursday
      case "FRIDAY": self = .friday
      case "SATURDAY": self = .saturday
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .sunday: return "SUNDAY"
      case .monday: return "MONDAY"
      case .tuesday: return "TUESDAY"
      case .wednesday: return "WEDNESDAY"
      case .thursday: return "THURSDAY"
      case .friday: return "FRIDAY"
      case .saturday: return "SATURDAY"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
    switch (lhs, rhs) {
      case (.sunday, .sunday): return true
      case (.monday, .monday): return true
      case (.tuesday, .tuesday): return true
      case (.wednesday, .wednesday): return true
      case (.thursday, .thursday): return true
      case (.friday, .friday): return true
      case (.saturday, .saturday): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

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
        GraphQLField("openHours", type: .list(.object(OpenHour.selections))),
        GraphQLField("website", type: .scalar(String.self)),
        GraphQLField("telephone", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, location: Location, typesOfWaste: [TypesOfWaste?]? = nil, openHours: [OpenHour?]? = nil, website: String? = nil, telephone: String? = nil) {
        self.init(snapshot: ["__typename": "Center", "_id": id, "name": name, "location": location.snapshot, "typesOfWaste": typesOfWaste.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "openHours": openHours.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "website": website, "telephone": telephone])
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

      /// The center's operating hours
      public var openHours: [OpenHour?]? {
        get {
          return (snapshot["openHours"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { OpenHour(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "openHours")
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

      public struct OpenHour: GraphQLSelectionSet {
        public static let possibleTypes = ["OpenTime"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("dayOfWeek", type: .nonNull(.scalar(DayOfWeek.self))),
          GraphQLField("startTime", type: .nonNull(.scalar(Int.self))),
          GraphQLField("endTime", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(dayOfWeek: DayOfWeek, startTime: Int, endTime: Int) {
          self.init(snapshot: ["__typename": "OpenTime", "dayOfWeek": dayOfWeek, "startTime": startTime, "endTime": endTime])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var dayOfWeek: DayOfWeek {
          get {
            return snapshot["dayOfWeek"]! as! DayOfWeek
          }
          set {
            snapshot.updateValue(newValue, forKey: "dayOfWeek")
          }
        }

        /// The hour representing the start of the timespan
        public var startTime: Int {
          get {
            return snapshot["startTime"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "startTime")
          }
        }

        /// The hour representing the end of the timespan
        public var endTime: Int {
          get {
            return snapshot["endTime"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "endTime")
          }
        }
      }
    }
  }
}

public struct Facility: GraphQLFragment {
  public static let fragmentString =
    "fragment Facility on Center {\n  __typename\n  _id\n  name\n  location {\n    __typename\n    address\n    municipality\n    coordinates {\n      __typename\n      latitude\n      longitude\n    }\n  }\n  typesOfWaste {\n    __typename\n    _id\n    name\n    icon\n  }\n  openHours {\n    __typename\n    dayOfWeek\n    startTime\n    endTime\n  }\n  website\n  telephone\n}"

  public static let possibleTypes = ["Center"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
    GraphQLField("location", type: .nonNull(.object(Location.selections))),
    GraphQLField("typesOfWaste", type: .list(.object(TypesOfWaste.selections))),
    GraphQLField("openHours", type: .list(.object(OpenHour.selections))),
    GraphQLField("website", type: .scalar(String.self)),
    GraphQLField("telephone", type: .scalar(String.self)),
  ]

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(id: GraphQLID, name: String, location: Location, typesOfWaste: [TypesOfWaste?]? = nil, openHours: [OpenHour?]? = nil, website: String? = nil, telephone: String? = nil) {
    self.init(snapshot: ["__typename": "Center", "_id": id, "name": name, "location": location.snapshot, "typesOfWaste": typesOfWaste.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "openHours": openHours.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "website": website, "telephone": telephone])
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

  /// The center's operating hours
  public var openHours: [OpenHour?]? {
    get {
      return (snapshot["openHours"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { OpenHour(snapshot: $0) } } }
    }
    set {
      snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "openHours")
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

  public struct OpenHour: GraphQLSelectionSet {
    public static let possibleTypes = ["OpenTime"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("dayOfWeek", type: .nonNull(.scalar(DayOfWeek.self))),
      GraphQLField("startTime", type: .nonNull(.scalar(Int.self))),
      GraphQLField("endTime", type: .nonNull(.scalar(Int.self))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(dayOfWeek: DayOfWeek, startTime: Int, endTime: Int) {
      self.init(snapshot: ["__typename": "OpenTime", "dayOfWeek": dayOfWeek, "startTime": startTime, "endTime": endTime])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    public var dayOfWeek: DayOfWeek {
      get {
        return snapshot["dayOfWeek"]! as! DayOfWeek
      }
      set {
        snapshot.updateValue(newValue, forKey: "dayOfWeek")
      }
    }

    /// The hour representing the start of the timespan
    public var startTime: Int {
      get {
        return snapshot["startTime"]! as! Int
      }
      set {
        snapshot.updateValue(newValue, forKey: "startTime")
      }
    }

    /// The hour representing the end of the timespan
    public var endTime: Int {
      get {
        return snapshot["endTime"]! as! Int
      }
      set {
        snapshot.updateValue(newValue, forKey: "endTime")
      }
    }
  }
}