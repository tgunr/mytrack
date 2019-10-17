//
//  LocalNotification.swift
//  myTrack
//
//  Created by Dave Carlton on 10/17/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import Foundation
import UserNotifications

struct Notification {
    var id: String
    var title: String
}

class LocalNotificationManager {
    var notifications = [Notification]()

    func requestPermission() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    UserData.shared.permission = true
                    self.scheduleNotifications()
                }
            }
    }

    func addNotification(title: String) {
        notifications.append(Notification(id: UUID().uuidString, title: title))
    }

    func scheduleNotifications() {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 65, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id)")
            }
        }
    }

    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                self.scheduleNotifications()
            case .denied:
                UserData.shared.permission = false
            default:
                break
            }
        }
    }
}
