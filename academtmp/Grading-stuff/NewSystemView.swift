//
//  NewSystemView.swift
//  Academ
//
//  Created by Raditya Aryo Wahyudi on 18/11/24.
//

import SwiftUI

struct NewSystemView: View{
    @State private var newSystem = GradeSystem(name: "", grades: [], type: .none)
    @Environment(\.dismiss) var dismiss
    @Environment(SystemManager.self) var systemmanager: SystemManager
    @ObservedObject var userData: UserData
    @State private var showSheet = false
    var body: some View{
        NavigationStack{
            Form{
                Section("Info"){
                    TextField("Name", text: $newSystem.name)
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                Section("Grades"){
                    List($newSystem.grades){$grade in
                        NavigationLink{
                            GradeDetailView(grade: $grade, userData: userData)
                        }label: {
                            Text(grade.name)
                        }
                    }
                    Button{
                        showSheet = true
                    }label: {
                        HStack{
                            Image(systemName: "plus")
                            Text("Add a grade")
                        }
                    }
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                .sheet(isPresented: $showSheet){
                    NewGradeView(system: $newSystem, userData: userData)
                }
                Section{
                    Button("Save"){
                        systemmanager.systems.append(newSystem)
                        dismiss()
                    }
                    Button("Cancel", role: .destructive){
                        dismiss()
                    }
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
            }
            .background(.linearGradient(colors: userData.themelists[userData.colorSelect].mainColor, startPoint: .top, endPoint: .bottom))
            .scrollContentBackground(.hidden)
            .onAppear(){
                newSystem.type = userData.gradeType
            }
        }
    }
}
#Preview{
    NewSystemView(userData: UserData())
}
