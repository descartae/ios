//
//  AppStateManager.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 31/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import Foundation
import UIKit

enum ObservableState: String {
    case facilities = "facilitiesDataUpdatedNotification", nextPageIsAvailable = "nextPageAvailableNotification", nextPageIsUnavailable = "nextPageUnavailableNotification"

    var notification: NSNotification.Name {
        return NSNotification.Name(rawValue: self.rawValue)
    }
}

struct StateManager {

    // MARK: Properties

    static private let userDefaults = UserDefaults.standard
    static private let notificationCenter = NotificationCenter.default
    static private let appIntroKey = "AppIntroKey"
    static var appIntroHasBeenPresented: Bool {
        get {
            return userDefaults.bool(forKey: appIntroKey)
        }

        set(newValue) {
            userDefaults.set(newValue, forKey: appIntroKey)
        }
    }

    // MARK: State update notifications

    static func updateStateFor(_ statesToNotify: [ObservableState]) {
        _ = statesToNotify.map { notificationCenter.post(name: $0.notification, object: nil) }
    }

}
