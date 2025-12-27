//
//  AcademApp.swift
//  Academ
//
//  Created by T Krobot on 1/10/23.
//

import SwiftUI
import UserNotifications

class AppDelegate: NSObject, UNUserNotificationCenterDelegate, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied")
            }
        }
        
        return true
    }
}
@main
struct AcademApp: App {
    var body: some Scene {
        @State var subjectManager = SubjectManager()
        @State var systemManager = SystemManager()
        WindowGroup {
            ContentView()
                .environment(subjectManager)
                .environment(systemManager)
        }
    }
}
//class UserData: ObservableObject{
//    @AppStorage("gradeType") var gradeType = GradeType.none
//    @AppStorage("gpaCredits") var haveCredits = false
//    @AppStorage("passingGrade") var pass:Double = 50
//    @AppStorage("themes") var themeSelect = "Default"
//}
let themeList: [String: Theme] = [
    "Beach": Theme(mainColor: [Color(hex: "05c3dd"), Color(hex: "ecd379"), Color(hex: "ecd379")], secondColor: Color.white, lightMode: true),
    "Winter": Theme(mainColor: [Color(hex: "bddeec"), Color(hex: "f2f2f7"), Color(hex: "f2f2f7")], secondColor: Color.white, lightMode: true),
    "Lemon": Theme(mainColor: [Color(hex: "ffff9f")], secondColor: Color.white, lightMode: true),
    "Lavender": Theme(mainColor: [Color(hex: "d0bdf4")], secondColor: Color.white, lightMode: true),
    "Minty": Theme(mainColor: [Color(hex: "E1F8DC")], secondColor: Color.white, lightMode: true),
    "Emerald Green": Theme(mainColor: [Color(hex: "16271C")], secondColor: Color(hex: "1F332C"), lightMode: false),
    "Velvet Purple": Theme(mainColor: [Color(hex: "210F29")], secondColor: Color(hex: "29132F"), lightMode: false),
    "Charcoal": Theme(mainColor: [Color(hex: "101314")], secondColor: Color(hex: "36454f"), lightMode: false),
    "Navy Blue": Theme(mainColor: [Color(hex: "181B3C")], secondColor: Color(hex: "1b1f46"), lightMode: false),
    "Crimson Red": Theme(mainColor: [Color(hex: "410611")], secondColor: Color(hex: "4B0714"), lightMode: false),
    "Midnight": Theme(mainColor: [Color.black, Color(hex: "191970")], secondColor: Color(hex: "121212"), lightMode: false)
]
func getTheme(_ themeName: String)->Theme{
    if let theme = themeList[themeName] {
        return theme
    }else{
        return Theme(mainColor: [Color.white], secondColor: Color(hex: "f2f2f7"), lightMode: true)
    }
}
