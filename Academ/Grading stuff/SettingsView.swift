//
//  SettingsView.swift
//  Academ
//
//  Created by T Krobot on 18/11/23.
//

import SwiftUI

struct SettingsView: View {
    //@State private var isLightTheme = true // true is for light mode
    @Environment(\.colorScheme) var colorScheme
    @State private var showAlert = false
    @State private var showSheet = false
    @Environment(SubjectManager.self) var subjectmanager: SubjectManager
    @Environment(SystemManager.self) var systemmanager: SystemManager
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    @AppStorage("gradeType") var gradeType = GradeType.none
    @AppStorage("gpaCredits") var haveCredits = false
    @AppStorage("passingGrade") var pass:Double = 50
    @AppStorage("themes") var themeSelect = "Default"
    var body: some View {
        @Bindable var systemmanager = systemmanager
        
        NavigationStack{
            
            AForm {
                Section("Grading System") {
                    Picker("Grading System Type", selection: $gradeType) {
                        
                        // Enum cases
                        ForEach(GradeType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                        
                    }
                    .pickerStyle(.menu)
                    .onChange(of: gradeType){
                        if gradeType != .none {
                            if let matchingSystem = defaultSystems.first(where: { !$0.isEmpty && gradeType == $0[0].type }) {
                                systemmanager.systems = matchingSystem
                            } else {
                                print("No matching system found")
                                systemmanager.systems = [] // or handle this case appropriately
                            }
                        } else {
                            systemmanager.systems = []
                        }
                        for i in subjectmanager.subjects.indices{
                            subjectmanager.subjects[i].customSystem = nil
                        }
                        print(systemmanager.systems)
                    }
                    Toggle(isOn: $haveCredits) {
                        Text("Have credits?")
                    }
                    HStack{
                        Text("Passing mark:")
                        TextField("Mark", value: $pass, formatter: formatter)
                    }
                }
                .lrb(themeSelect)
                if gradeType != .none{
                    if systemmanager.systems.isEmpty{
                        Text("An error occurred")
                            .onAppear(){
                                if gradeType != .none {
                                    if let matchingSystem = defaultSystems.first(where: { !$0.isEmpty && gradeType == $0[0].type }) {
                                        systemmanager.systems = matchingSystem
                                    } else {
                                        print("No matching system found")
                                        systemmanager.systems = [] // or handle this case appropriately
                                    }
                                } else {
                                    systemmanager.systems = []
                                }
                            }
                    }else{
                        Section(header: HStack{
                            Text("Systems")
                            Spacer()
                            EditButton()
                        }, footer: Text("The first system is the default\nSwipe actions: right to duplicate, left to delete")){
                            ForEach($systemmanager.systems, editActions: .all){$system in
                                NavigationLink{
                                    SystemDetailView(system: $system)
                                }label: {
                                    HStack{
                                        Text(system.name)
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button("Duplicate"){
                                        systemmanager.systems.append(GradeSystem(name: system.name, grades: system.grades, type: system.type))
                                    }
                                    .tint(.accent)
                                }
                            }
                            
                            Button{
                                showSheet = true
                            }label: {
                                HStack{
                                    Image(systemName: "plus")
                                    Text("Add a system")
                                }
                            }
                        }
                        .lrb(themeSelect)
                        .sheet(isPresented: $showSheet){
                            NewSystemView()
                        }
                    }
                }
                
                Section("Themes") {
                    Picker("Set Theme", selection: $themeSelect) {
                        Text("Default").tag("Default")
                        ForEach(themeList.sorted(by: { $0.key < $1.key }).filter({
                                $0.value.lightMode == (colorScheme == .light)
                            }), id: \.key) { name, theme in
                            Text(name).tag(name)
                        }
                        
                    }
                    .pickerStyle(.menu)
                }
                
                .lrb(themeSelect)
                Section{
                    Button("Reset to new year", role: .destructive){
                        showAlert = true
                    }
                }
                .lrb(themeSelect)
                .alert("Are you sure you want to reset to a new year?", isPresented: $showAlert){
                    Button("Confirm", role: .destructive){
                        subjectmanager.subjects = []
                    }
                    Button("Cancel", role: .cancel){}
                }message: {
                    Text("This cannot be undone.")
                }
            }
            .navigationTitle("Settings")
            
            
        }
    }
}

#Preview{
    SettingsView()
        .environment(SubjectManager())
        .environment(SystemManager())
}

