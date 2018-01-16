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
    "query allFacilities($quantity: Int!, $next: Cursor, $prev: Cursor, $typesOfWasteToFilter: [ID]) {\n  typesOfWaste {\n    __typename\n    ...WasteType\n  }\n  facilities(filters: {cursor: {after: $next, before: $prev, quantity: $quantity}, hasTypesOfWaste: $typesOfWasteToFilter}) {\n    __typename\n    cursors {\n      __typename\n      after\n      before\n    }\n    items {\n      __typename\n      ...DisposalFacility\n    }\n  }\n}"

  public static var requestString: String { return operationString.appending(WasteType.fragmentString).appending(DisposalFacility.fragmentString) }

  public var quantity: Int
  public var next: String?
  public var prev: String?
  public var typesOfWasteToFilter: [GraphQLID?]?

  public init(quantity: Int, next: String? = nil, prev: String? = nil, typesOfWasteToFilter: [GraphQLID?]? = nil) {
    self.quantity = quantity
    self.next = next
    self.prev = prev
    self.typesOfWasteToFilter = typesOfWasteToFilter
  }

  public var variables: GraphQLMap? {
    return ["quantity": quantity, "next": next, "prev": prev, "typesOfWasteToFilter": typesOfWasteToFilter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("typesOfWaste", type: .list(.object(TypesOfWaste.selections))),
      GraphQLField("facilities", arguments: ["filters": ["cursor": ["after": GraphQLVariable("next"), "before": GraphQLVariable("prev"), "quantity": GraphQLVariable("quantity")], "hasTypesOfWaste": GraphQLVariable("typesOfWasteToFilter")]], type: .object(Facility.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(typesOfWaste: [TypesOfWaste?]? = nil, facilities: Facility? = nil) {
      self.init(snapshot: ["__typename": "Query", "typesOfWaste": typesOfWaste.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "facilities": facilities.flatMap { $0.snapshot }])
    }

    /// All the types of waste that a facility can receive
    public var typesOfWaste: [TypesOfWaste?]? {
      get {
        return (snapshot["typesOfWaste"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { TypesOfWaste(snapshot: $0) } } }
      }
      set {
        snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "typesOfWaste")
      }
    }

    /// The list of available facilities
    public var facilities: Facility? {
      get {
        return (snapshot["facilities"] as? Snapshot).flatMap { Facility(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "facilities")
      }
    }

    public struct TypesOfWaste: GraphQLSelectionSet {
      public static let possibleTypes = ["TypeOfWaste"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("_id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("icons", type: .nonNull(.object(Icon.selections))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, description: String, icons: Icon) {
        self.init(snapshot: ["__typename": "TypeOfWaste", "_id": id, "name": name, "description": description, "icons": icons.snapshot])
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

      /// The user-readable type description
      public var description: String {
        get {
          return snapshot["description"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      /// The icons for this type
      public var icons: Icon {
        get {
          return Icon(snapshot: snapshot["icons"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "icons")
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

        public var wasteType: WasteType {
          get {
            return WasteType(snapshot: snapshot)
          }
          set {
            snapshot += newValue.snapshot
          }
        }
      }

      public struct Icon: GraphQLSelectionSet {
        public static let possibleTypes = ["IconSet"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("iosSmallURL", type: .nonNull(.scalar(String.self))),
          GraphQLField("iosMediumURL", type: .nonNull(.scalar(String.self))),
          GraphQLField("iosLargeURL", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(iosSmallUrl: String, iosMediumUrl: String, iosLargeUrl: String) {
          self.init(snapshot: ["__typename": "IconSet", "iosSmallURL": iosSmallUrl, "iosMediumURL": iosMediumUrl, "iosLargeURL": iosLargeUrl])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var iosSmallUrl: String {
          get {
            return snapshot["iosSmallURL"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "iosSmallURL")
          }
        }

        public var iosMediumUrl: String {
          get {
            return snapshot["iosMediumURL"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "iosMediumURL")
          }
        }

        public var iosLargeUrl: String {
          get {
            return snapshot["iosLargeURL"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "iosLargeURL")
          }
        }
      }
    }

    public struct Facility: GraphQLSelectionSet {
      public static let possibleTypes = ["FacilitiesPage"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("cursors", type: .nonNull(.object(Cursor.selections))),
        GraphQLField("items", type: .list(.object(Item.selections))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(cursors: Cursor, items: [Item?]? = nil) {
        self.init(snapshot: ["__typename": "FacilitiesPage", "cursors": cursors.snapshot, "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Cursor information for the next possible requests
      public var cursors: Cursor {
        get {
          return Cursor(snapshot: snapshot["cursors"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "cursors")
        }
      }

      /// The items found according to the query
      public var items: [Item?]? {
        get {
          return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
        }
      }

      public struct Cursor: GraphQLSelectionSet {
        public static let possibleTypes = ["PageCursors"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("after", type: .scalar(String.self)),
          GraphQLField("before", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(after: String? = nil, before: String? = nil) {
          self.init(snapshot: ["__typename": "PageCursors", "after": after, "before": before])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The cursor used to get items from before this page
        public var after: String? {
          get {
            return snapshot["after"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "after")
          }
        }

        /// The cursor used to get items from after this page
        public var before: String? {
          get {
            return snapshot["before"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "before")
          }
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Facility"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("_id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("location", type: .nonNull(.object(Location.selections))),
          GraphQLField("typesOfWaste", type: .nonNull(.list(.object(TypesOfWaste.selections)))),
          GraphQLField("openHours", type: .nonNull(.list(.object(OpenHour.selections)))),
          GraphQLField("website", type: .scalar(String.self)),
          GraphQLField("telephone", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, location: Location, typesOfWaste: [TypesOfWaste?], openHours: [OpenHour?], website: String? = nil, telephone: String? = nil) {
          self.init(snapshot: ["__typename": "Facility", "_id": id, "name": name, "location": location.snapshot, "typesOfWaste": typesOfWaste.map { $0.flatMap { $0.snapshot } }, "openHours": openHours.map { $0.flatMap { $0.snapshot } }, "website": website, "telephone": telephone])
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

        /// The name of the facility
        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        /// The location data for a given facility
        public var location: Location {
          get {
            return Location(snapshot: snapshot["location"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "location")
          }
        }

        /// The types of waste the recycling facility handles
        public var typesOfWaste: [TypesOfWaste?] {
          get {
            return (snapshot["typesOfWaste"] as! [Snapshot?]).map { $0.flatMap { TypesOfWaste(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "typesOfWaste")
          }
        }

        /// The facility's operating hours
        public var openHours: [OpenHour?] {
          get {
            return (snapshot["openHours"] as! [Snapshot?]).map { $0.flatMap { OpenHour(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "openHours")
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

          public var disposalFacility: DisposalFacility {
            get {
              return DisposalFacility(snapshot: snapshot)
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
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("_id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("description", type: .nonNull(.scalar(String.self))),
            GraphQLField("icons", type: .nonNull(.object(Icon.selections))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, name: String, description: String, icons: Icon) {
            self.init(snapshot: ["__typename": "TypeOfWaste", "_id": id, "name": name, "description": description, "icons": icons.snapshot])
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

          /// The user-readable type description
          public var description: String {
            get {
              return snapshot["description"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "description")
            }
          }

          /// The icons for this type
          public var icons: Icon {
            get {
              return Icon(snapshot: snapshot["icons"]! as! Snapshot)
            }
            set {
              snapshot.updateValue(newValue.snapshot, forKey: "icons")
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

            public var wasteType: WasteType {
              get {
                return WasteType(snapshot: snapshot)
              }
              set {
                snapshot += newValue.snapshot
              }
            }
          }

          public struct Icon: GraphQLSelectionSet {
            public static let possibleTypes = ["IconSet"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("iosSmallURL", type: .nonNull(.scalar(String.self))),
              GraphQLField("iosMediumURL", type: .nonNull(.scalar(String.self))),
              GraphQLField("iosLargeURL", type: .nonNull(.scalar(String.self))),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(iosSmallUrl: String, iosMediumUrl: String, iosLargeUrl: String) {
              self.init(snapshot: ["__typename": "IconSet", "iosSmallURL": iosSmallUrl, "iosMediumURL": iosMediumUrl, "iosLargeURL": iosLargeUrl])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var iosSmallUrl: String {
              get {
                return snapshot["iosSmallURL"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "iosSmallURL")
              }
            }

            public var iosMediumUrl: String {
              get {
                return snapshot["iosMediumURL"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "iosMediumURL")
              }
            }

            public var iosLargeUrl: String {
              get {
                return snapshot["iosLargeURL"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "iosLargeURL")
              }
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
}

public final class AddFeedbackMutation: GraphQLMutation {
  public static let operationString =
    "mutation AddFeedback($facilityId: ID!, $feedback: String!) {\n  addFeedback(input: {facility: $facilityId, contents: $feedback}) {\n    __typename\n    success\n  }\n}"

  public var facilityId: GraphQLID
  public var feedback: String

  public init(facilityId: GraphQLID, feedback: String) {
    self.facilityId = facilityId
    self.feedback = feedback
  }

  public var variables: GraphQLMap? {
    return ["facilityId": facilityId, "feedback": feedback]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("addFeedback", arguments: ["input": ["facility": GraphQLVariable("facilityId"), "contents": GraphQLVariable("feedback")]], type: .nonNull(.object(AddFeedback.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(addFeedback: AddFeedback) {
      self.init(snapshot: ["__typename": "Mutation", "addFeedback": addFeedback.snapshot])
    }

    /// Creates a new feedback entry
    public var addFeedback: AddFeedback {
      get {
        return AddFeedback(snapshot: snapshot["addFeedback"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "addFeedback")
      }
    }

    public struct AddFeedback: GraphQLSelectionSet {
      public static let possibleTypes = ["AddFeedbackPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("success", type: .nonNull(.scalar(Bool.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(success: Bool) {
        self.init(snapshot: ["__typename": "AddFeedbackPayload", "success": success])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Indicates whether the operation was successful
      public var success: Bool {
        get {
          return snapshot["success"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "success")
        }
      }
    }
  }
}

public struct DisposalFacility: GraphQLFragment {
  public static let fragmentString =
    "fragment DisposalFacility on Facility {\n  __typename\n  _id\n  name\n  location {\n    __typename\n    address\n    municipality\n    coordinates {\n      __typename\n      latitude\n      longitude\n    }\n  }\n  typesOfWaste {\n    __typename\n    ...WasteType\n  }\n  openHours {\n    __typename\n    dayOfWeek\n    startTime\n    endTime\n  }\n  website\n  telephone\n}"

  public static let possibleTypes = ["Facility"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
    GraphQLField("location", type: .nonNull(.object(Location.selections))),
    GraphQLField("typesOfWaste", type: .nonNull(.list(.object(TypesOfWaste.selections)))),
    GraphQLField("openHours", type: .nonNull(.list(.object(OpenHour.selections)))),
    GraphQLField("website", type: .scalar(String.self)),
    GraphQLField("telephone", type: .scalar(String.self)),
  ]

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(id: GraphQLID, name: String, location: Location, typesOfWaste: [TypesOfWaste?], openHours: [OpenHour?], website: String? = nil, telephone: String? = nil) {
    self.init(snapshot: ["__typename": "Facility", "_id": id, "name": name, "location": location.snapshot, "typesOfWaste": typesOfWaste.map { $0.flatMap { $0.snapshot } }, "openHours": openHours.map { $0.flatMap { $0.snapshot } }, "website": website, "telephone": telephone])
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

  /// The name of the facility
  public var name: String {
    get {
      return snapshot["name"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "name")
    }
  }

  /// The location data for a given facility
  public var location: Location {
    get {
      return Location(snapshot: snapshot["location"]! as! Snapshot)
    }
    set {
      snapshot.updateValue(newValue.snapshot, forKey: "location")
    }
  }

  /// The types of waste the recycling facility handles
  public var typesOfWaste: [TypesOfWaste?] {
    get {
      return (snapshot["typesOfWaste"] as! [Snapshot?]).map { $0.flatMap { TypesOfWaste(snapshot: $0) } }
    }
    set {
      snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "typesOfWaste")
    }
  }

  /// The facility's operating hours
  public var openHours: [OpenHour?] {
    get {
      return (snapshot["openHours"] as! [Snapshot?]).map { $0.flatMap { OpenHour(snapshot: $0) } }
    }
    set {
      snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "openHours")
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
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("_id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("description", type: .nonNull(.scalar(String.self))),
      GraphQLField("icons", type: .nonNull(.object(Icon.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(id: GraphQLID, name: String, description: String, icons: Icon) {
      self.init(snapshot: ["__typename": "TypeOfWaste", "_id": id, "name": name, "description": description, "icons": icons.snapshot])
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

    /// The user-readable type description
    public var description: String {
      get {
        return snapshot["description"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "description")
      }
    }

    /// The icons for this type
    public var icons: Icon {
      get {
        return Icon(snapshot: snapshot["icons"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "icons")
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

      public var wasteType: WasteType {
        get {
          return WasteType(snapshot: snapshot)
        }
        set {
          snapshot += newValue.snapshot
        }
      }
    }

    public struct Icon: GraphQLSelectionSet {
      public static let possibleTypes = ["IconSet"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("iosSmallURL", type: .nonNull(.scalar(String.self))),
        GraphQLField("iosMediumURL", type: .nonNull(.scalar(String.self))),
        GraphQLField("iosLargeURL", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(iosSmallUrl: String, iosMediumUrl: String, iosLargeUrl: String) {
        self.init(snapshot: ["__typename": "IconSet", "iosSmallURL": iosSmallUrl, "iosMediumURL": iosMediumUrl, "iosLargeURL": iosLargeUrl])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var iosSmallUrl: String {
        get {
          return snapshot["iosSmallURL"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "iosSmallURL")
        }
      }

      public var iosMediumUrl: String {
        get {
          return snapshot["iosMediumURL"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "iosMediumURL")
        }
      }

      public var iosLargeUrl: String {
        get {
          return snapshot["iosLargeURL"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "iosLargeURL")
        }
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

public struct WasteType: GraphQLFragment {
  public static let fragmentString =
    "fragment WasteType on TypeOfWaste {\n  __typename\n  _id\n  name\n  description\n  icons {\n    __typename\n    iosSmallURL\n    iosMediumURL\n    iosLargeURL\n  }\n}"

  public static let possibleTypes = ["TypeOfWaste"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("_id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("name", type: .nonNull(.scalar(String.self))),
    GraphQLField("description", type: .nonNull(.scalar(String.self))),
    GraphQLField("icons", type: .nonNull(.object(Icon.selections))),
  ]

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(id: GraphQLID, name: String, description: String, icons: Icon) {
    self.init(snapshot: ["__typename": "TypeOfWaste", "_id": id, "name": name, "description": description, "icons": icons.snapshot])
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

  /// The user-readable type description
  public var description: String {
    get {
      return snapshot["description"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "description")
    }
  }

  /// The icons for this type
  public var icons: Icon {
    get {
      return Icon(snapshot: snapshot["icons"]! as! Snapshot)
    }
    set {
      snapshot.updateValue(newValue.snapshot, forKey: "icons")
    }
  }

  public struct Icon: GraphQLSelectionSet {
    public static let possibleTypes = ["IconSet"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("iosSmallURL", type: .nonNull(.scalar(String.self))),
      GraphQLField("iosMediumURL", type: .nonNull(.scalar(String.self))),
      GraphQLField("iosLargeURL", type: .nonNull(.scalar(String.self))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(iosSmallUrl: String, iosMediumUrl: String, iosLargeUrl: String) {
      self.init(snapshot: ["__typename": "IconSet", "iosSmallURL": iosSmallUrl, "iosMediumURL": iosMediumUrl, "iosLargeURL": iosLargeUrl])
    }

    public var __typename: String {
      get {
        return snapshot["__typename"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "__typename")
      }
    }

    public var iosSmallUrl: String {
      get {
        return snapshot["iosSmallURL"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "iosSmallURL")
      }
    }

    public var iosMediumUrl: String {
      get {
        return snapshot["iosMediumURL"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "iosMediumURL")
      }
    }

    public var iosLargeUrl: String {
      get {
        return snapshot["iosLargeURL"]! as! String
      }
      set {
        snapshot.updateValue(newValue, forKey: "iosLargeURL")
      }
    }
  }
}