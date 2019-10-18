//
//  LocalNotification.swift
//  myTrack
//
//  Created by Dave Carlton on 10/17/19.
//  Copyright © 2019 Dave Carlton. All rights reserved.
//

import Foundation
import UserNotifications

struct Notification: Identifiable {
    var id: String
    var title: String
    var interval: TimeInterval
    var repeats: Bool
}

struct NotificationGroup: Identifiable {
    var id: String
    var starttime: Date
    var interval: Int
    var medications: [Medication]
    
    mutating func add(medication: Medication) {
        medications.append(medication)
    }
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

    // Medications are sorted by their startime and placed into groups so that a single notification
    // will issued for multiple meds taken at the same time
    // As Needed will be handled differently, A notice at end of day will issued to ask if any were taken
    // in order to reduce the count for refill notice
    func createNotifications() {
        var medications = UserData.shared.medications
        var medGroups: [NotificationGroup] = []
        var medTimeGroup: NotificationGroup?
        var startTime: Date?
        let sortedMeds = medications.sorted { first, second in first.startTime > second.startTime }

        func newGroup(med: Medication) -> NotificationGroup {
            let meds = [med]
            let uuid = UUID().uuidString
//            print("group: \(uuid) med: \(med.id)")
            medTimeGroup = NotificationGroup(id: uuid, starttime: med.startTime, interval: med.interval, medications: meds)
            medGroups.append(medTimeGroup!)
            print("group: \(String(describing: medTimeGroup?.id)) med: \(med.name) med count: \(String(describing: medTimeGroup?.medications.count))")
            return medTimeGroup!
        }

        for aMed in sortedMeds {
            if medTimeGroup == nil {
                medTimeGroup = newGroup(med: aMed)
                continue
            }
            if aMed.startTime == medTimeGroup?.starttime {
                medTimeGroup?.add(medication: aMed)
                print("group: \(String(describing: medTimeGroup?.id)) med: \(aMed.name) med count: \(String(describing: medTimeGroup?.medications.count))")
            } else {
                medTimeGroup = newGroup(med: aMed)
            }
        }
        print("---")
        print("groups: \(medGroups.count)")
        for aGroup in medGroups {
            print("group: \(aGroup.id) med count: \(aGroup.medications.count)")
            for aMed in aGroup.medications {
                print("med: \(aMed.name)")
            }
        }
    }
}
