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
    var interval: TimeInterval
    var repeats: Bool
}

class LocalNotificationManager {
    var notifications = [Notification]()
    static var shared = LocalNotificationManager()
    
    // TODO: Need to recheck permission setting periodically
    func requestPermission() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    UserData.shared.permission = false
                    self.scheduleNotifications()
                }
            }
    }

    func addNotification(title: String) {
        notifications.append(Notification(id: UUID().uuidString, title: title, interval: 30, repeats: false))
    }
    
    func addNotifcation(title: String, interval: TimeInterval, repeating: Bool) {
        notifications.append(Notification(id: UUID().uuidString, title: title, interval: interval, repeats: repeating))
    }

    func scheduleNotifications() {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notification.interval, repeats: notification.repeats)
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
    
    func createNotifications()  {
        
    }
}
