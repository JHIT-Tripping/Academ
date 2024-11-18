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
    
    @State var systemManager = SystemManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(SubjectManager())
                .environment(systemManager)
        }
    }
}
class UserData: ObservableObject{
    @AppStorage("gradeType") var gradeType = GradeType.none
    @AppStorage("gpaCredits") var haveCredits = false
    @AppStorage("passingGrade") var pass:Double = 50
    @AppStorage("themes") var colorSelect = 0
    let themelists = [
        themeColors(themeName: "Dark", mainColor: [.black], secondColor: Color(hex: "121212"), LightMode: false),
        
        themeColors(themeName: "Emerald Green", mainColor: [Color(hex: "16271C")], secondColor: Color(hex: "1F332C"), LightMode: false),
        
        themeColors(themeName: "Velvet Purple", mainColor: [Color(hex: "210F29")], secondColor: Color(hex: "29132F"), LightMode: false),
        
        themeColors(themeName: "Charcoal", mainColor: [Color(hex: "101314")], secondColor: Color(hex: "36454f"), LightMode: false),
        
        themeColors(themeName: "Navy Blue", mainColor: [Color(hex: "181B3C")], secondColor: Color(hex: "1b1f46"), LightMode: false),
        
        themeColors(themeName: "Crimson Red", mainColor: [Color(hex: "410611")], secondColor: Color(hex: "4B0714"), LightMode: false),
        
        themeColors(themeName: "Midnight", mainColor: [Color(hex: "191970"), .black], secondColor: Color(hex: "121212"), LightMode: false),
        
        themeColors(themeName: "Light", mainColor: [.white], secondColor: Color(hex: "f2f2f7"), LightMode: true),
        
        themeColors(themeName: "Beach", mainColor: [Color(hex: "05c3dd"), Color(hex: "ecd379"), Color(hex: "ecd379")], secondColor: .white, LightMode: true),
        
        themeColors(themeName: "Winter", mainColor: [Color(hex: "bddeec"), Color(hex: "f2f2f7"), Color(hex: "f2f2f7")], secondColor: .white, LightMode: true),
        
        themeColors(themeName: "Lemon", mainColor: [Color(hex: "ffff9f")], secondColor: .white, LightMode: true),
        
        themeColors(themeName: "Lavender", mainColor: [Color(hex: "d0bdf4")], secondColor: .white, LightMode: true),
        
        themeColors(themeName: "Minty", mainColor: [Color(hex: "E1F8DC")], secondColor: .white, LightMode: true),
        
    ]
    
}
