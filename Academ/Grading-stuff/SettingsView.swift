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
    @ObservedObject var userData: UserData
    @State private var showAlert = false
    @State private var showSheet = false
    @EnvironmentObject var subjectmanager: SubjectManager
    @Environment(SystemManager.self) var systemmanager: SystemManager
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    var body: some View {
        @Bindable var systemmanager = systemmanager
        
        NavigationStack{
            
            Form {
                Section("Grading system") {
                    Picker("Grading System Type", selection: $userData.gradeType) {
                        
                        // Enum cases
                        ForEach(GradeType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                        
                    }
                    .pickerStyle(.menu)
                    .onChange(of: userData.gradeType){
                        if userData.gradeType != .none {
                            if let matchingSystem = defaultSystems.first(where: { !$0.isEmpty && userData.gradeType == $0[0].type }) {
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
                    }
                    Toggle(isOn: $userData.haveCredits) {
                        Text("Have credits?")
                    }
                    HStack{
                        Text("Passing mark:")
                        TextField("Mark", value: $userData.pass, formatter: formatter)
                    }
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                if userData.gradeType != .none{
                    if systemmanager.systems.isEmpty{
                        Text("An error occurred")
                            .onAppear(){
                                if userData.gradeType != .none {
                                    if let matchingSystem = defaultSystems.first(where: { !$0.isEmpty && userData.gradeType == $0[0].type }) {
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
                        Section(header: Text("Systems"), footer: Text("The first system is the default")){
                            List($systemmanager.systems, editActions: .all){$system in
                                NavigationLink{
                                    SystemDetailView(system: $system, userData: userData)
                                }label: {
                                    HStack{
                                        Text(system.name)
                                    }
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
                        .sheet(isPresented: $showSheet){
                            NewSystemView(userData: userData)
                        }
                        .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                    }
                }
                
                Section("Themes") {
                    Picker("Set Theme", selection: $userData.colorSelect) {
                        
                        if colorScheme == .light{
                            ForEach(userData.themelists.indices) { index in
                                if
                                    userData.themelists[index].LightMode == true{
                                    Text(userData.themelists[index].themeName)
                                    
                                }
                            }
                            //userData.colorSelect = userData.themelists[0]
                            
                        } else {
                            ForEach(userData.themelists.indices) { index in
                                if userData.themelists[index].LightMode == false{
                                    Text(userData.themelists[index].themeName)
                                    
                                }
                                
                            }
                            // userData.colorSelect = userData.themelists[3]
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                Section{
                    Button("Reset to new year", role: .destructive){
                        showAlert = true
                    }
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                        .padding(.trailing, 8)
                        .background(userData.themelists[userData.colorSelect].secondColor)
                        .mask{
                            RoundedRectangle(cornerRadius: 10)
                        }
                }
            }
            .background(.linearGradient(colors: userData.themelists[userData.colorSelect].mainColor, startPoint: .top, endPoint: .bottom))
            .scrollContentBackground(.hidden)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(userData: UserData())
            .environmentObject(SubjectManager())
            .environment(SystemManager())
        //.colorScheme(.dark)
    }
}
