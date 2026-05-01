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
    "Beach": Theme(mainColor: [Color(hex: "05c3dd"), Color(hue: 47/360, saturation: 0.5, brightness: 1)], secondColor: Color(hue: 47/360, saturation: 0.25, brightness: 1), lightMode: true),
    "Winter": Theme(mainColor: [Color(hex: "bddeec"), Color(hex: "f2f2f7")], secondColor: Color.white, lightMode: true),
    "Lemon": Theme(mainColor: [Color(hue: 1/6, saturation: 0.3, brightness: 1)], secondColor: Color(hue: 1/6, saturation: 0.1, brightness: 1), lightMode: true),
    "Lavender": Theme(mainColor: [Color(hue: 261/360, saturation: 0.24, brightness: 1)], secondColor: Color(hue: 261/360, saturation: 0.12, brightness: 1), lightMode: true),
    "Minty": Theme(mainColor: [Color(hue: 109/360, saturation: 0.16, brightness: 1)], secondColor: Color(hue: 109/360, saturation: 0.08, brightness: 1), lightMode: true),
    "Emerald Green": Theme(mainColor: [Color(hex: "16271C")], secondColor: Color(hex: "1F332C"), lightMode: false),
    "Velvet Purple": Theme(mainColor: [Color(hex: "210F29")], secondColor: Color(hex: "29132F"), lightMode: false),
    "Charcoal": Theme(mainColor: [Color(hex: "101314")], secondColor: Color(hex: "36454f"), lightMode: false),
    "Navy Blue": Theme(mainColor: [Color(hex: "181B3C")], secondColor: Color(hex: "1b1f46"), lightMode: false),
    "Crimson Red": Theme(mainColor: [Color(hex: "410611")], secondColor: Color(hex: "4B0714"), lightMode: false),
    "Midnight": Theme(mainColor: [Color.black, Color(hex: "191970")], secondColor: Color(hex: "3C3C6D"), lightMode: false),
    "Sakura": Theme(mainColor: [Color(hue: 1, saturation: 0.24, brightness: 1)], secondColor: Color(hue: 1, saturation: 0.12, brightness: 1), lightMode: true),
    "Sunset": Theme(mainColor: [Color(hue: 195/360, saturation: 1, brightness: 0.3), Color(hue: 20/360, saturation: 1, brightness: 0.6)], secondColor: Color(hue: 40/360, saturation: 1, brightness: 0.3, opacity: 0.5), lightMode: false),
    "Tangerine": Theme(mainColor: [Color(hue: 34/360, saturation: 0.6, brightness: 1)], secondColor: Color(hue: 34/360, saturation: 0.3, brightness: 1), lightMode: true),
    "Sunrise": Theme(mainColor: [Color(hue: 29/360, saturation: 0.1, brightness: 0.8), Color(hue: 29/360, saturation: 0.7, brightness: 1)], secondColor: Color(hue: 45/360, saturation: 0.3, brightness: 1), lightMode: true),
    "Caramel": Theme(mainColor: [Color(red: 0.231373, green: 0.141176, blue: 0)], secondColor: Color(red: 0.36078, green: 0.21569, blue: 0.039216), lightMode: false)
]
func getTheme(_ themeName: String)->Theme{
    if let theme = themeList[themeName] {
        return theme
    }else{
        return Theme(mainColor: [Color(hex: "f2f2f7")], secondColor: .white, lightMode: true)
    }
}
