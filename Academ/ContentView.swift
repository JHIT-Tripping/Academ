//
//  ContentView.swift
//  Academ testing maybe
//
//  Created by yoeh iskandar on 9/10/23.
//

import SwiftUI
//to clean file errors just do command + shift + k

struct ContentView: View {
    @StateObject private var userData = UserData()
    @Environment(\.colorScheme) var colorScheme
    @State var systemManager = SystemManager()
    var body: some View {
        @Bindable var systemManager = systemManager
        TabView{
            SubjectsView(userData: userData)
                .tabItem {
                    Label("Subjects", systemImage: "books.vertical")
                        .ignoresSafeArea(.all)
                }
            // DashboardView(userData:userData)
            //     .tabItem{
            //        Label("Dashboard", systemImage: "gauge.open.with.lines.needle.33percent")
            
            //            .ignoresSafeArea(.all)
            //     }.tag(2)
            SettingsView(userData: userData)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                        .ignoresSafeArea(.all)
                }
            
        }
        .onAppear(){
            //print(colorScheme)
            if colorScheme == .light{
                if userData.themelists[userData.colorSelect].LightMode == false{
                    userData.colorSelect = 7
                    print(userData.colorSelect)
                }
                
            } else if colorScheme == .dark{
                
                if userData.themelists[userData.colorSelect].LightMode == true{
                    userData.colorSelect = 0
                    print(userData.colorSelect)
                }
                
            }
        }
        .onChange(of: colorScheme){
            //print(colorScheme)
            if colorScheme == .light{
                if userData.themelists[userData.colorSelect].LightMode == false{
                    userData.colorSelect = 7
                    print(userData.colorSelect)
                }
                
            } else if colorScheme == .dark{
                
                if userData.themelists[userData.colorSelect].LightMode == true{
                    userData.colorSelect = 0
                    print(userData.colorSelect)
                }
                
            }
        }
    }
}

#Preview{
    ContentView()
        .environmentObject(SubjectManager())
        .environment(SystemManager())
        .preferredColorScheme(.light)
    
}
