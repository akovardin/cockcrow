//
// Created by Artem Kovardin on 19.01.2020.
// Copyright (c) 2020 Artem Kovardin. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationManager {
    var notifications = [Notification]()

    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in

            for notification in notifications {
                print(notification)
            }
        }
    }

    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in

            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
    }

    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in

            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break // Do nothing
            }
        }
    }

    private func scheduleNotifications() {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            if let sound = notification.sound {
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: sound))
            } else {
                content.sound = .default
            }

            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)

            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else {
                    return
                }

                print("Notification scheduled! --- ID = \(notification.id)")
            }
        }
    }
}