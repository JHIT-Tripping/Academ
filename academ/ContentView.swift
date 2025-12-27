//
//  ContentView.swift
//  Academ testing maybe
//
//  Created by yoeh iskandar on 9/10/23.
//

import SwiftUI
//to clean file errors just do command + shift + k

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("themes") var themeSelect = "Default"
    @State private var selection = 1
    @State private var lastDark = ""
    @State private var lastLight = ""
    var body: some View {
        TabView(selection: $selection){
            SubjectsView()
                .tabItem {
                    Label("Subjects", systemImage: "books.vertical")
                        .ignoresSafeArea(.all)
                }.tag(0)
             DashboardView()
                .tabItem{
                    Label("Dashboard", systemImage: "gauge.open.with.lines.needle.33percent")
                }.tag(1)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                        .ignoresSafeArea(.all)
                }.tag(2)
            
        }
        .onAppear(){
            print("boom")
            if colorScheme == .light && getTheme(themeSelect).lightMode == false{
                print(themeSelect)
                themeSelect = "Default"
                print("set light")
            } else if colorScheme == .dark && getTheme(themeSelect).lightMode == true{
                print(themeSelect)
                themeSelect = "Default"
                print("set dark")
            }
        }
        .onChange(of: colorScheme) { oldValue, newValue in
            
            print("from \(oldValue) to \(newValue)")
            if colorScheme == .light && getTheme(themeSelect).lightMode == false{
                lastDark = themeSelect
                if lastLight != ""{
                    themeSelect = lastLight
                }else{
                    themeSelect = "Default"
                }
                print("set light")
            } else if colorScheme == .dark && getTheme(themeSelect).lightMode == true{
                lastLight = themeSelect
                if lastDark != ""{
                    themeSelect = lastDark
                }else{
                    themeSelect = "Default"
                }
                print("set dark")
            }
        }
    }
}

#Preview{
    ContentView()
        .environment(SubjectManager())
        .environment(SystemManager())
    
}

extension Section where Parent: View, Content: View, Footer: View {
    @ViewBuilder
    func lrb(_ themeSelect: String) -> some View {
        if themeSelect != "Default" {
            self
                .listRowBackground(getTheme(themeSelect).secondColor)
        } else {
            self
        }
    }
}
