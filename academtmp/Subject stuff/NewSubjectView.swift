//
//  SubjectSheets.swift
//  Academ
//
//  Created by T Krobot on 20/11/23.
//

import SwiftUI

struct NewSubjectView: View {
    @Environment(SubjectManager.self) var subjectmanager: SubjectManager
    @State private var newSubject:Subject = Subject(name: "", assessments: [], targetMark: 0, credits: 1, numOfAssessments: 4)
    @State private var showNewAssessmentSheet = false
    @Environment(\.dismiss) var dismiss
    @AppStorage("gpaCredits") var haveCredits = false
    @AppStorage("themes") var themeSelect = "Default"
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    @Environment(SystemManager.self) var systemManager: SystemManager
    var body: some View {
        NavigationStack {
            AForm{
                Section("SUBJECT INFO") {
                    TextField("Subject", text:$newSubject.name)
                    HStack{
                        Text("Overall Goal")
                        TextField("Percentage", value: $newSubject.targetMark, formatter: formatter)
                        Text("%")
                    }
                    HStack{
                        Text("No. of assessments")
                        TextField("Number", value: $newSubject.numOfAssessments, formatter: formatter)
                        
                    }
                    if haveCredits{
                        HStack{
                            Text("Credit")
                            TextField("Value",value: $newSubject.credits, formatter: formatter)
                        }
                    }
                    Toggle("Is calculated?", isOn: $newSubject.isCalculated)
                    if !systemManager.systems.isEmpty{
                        Picker("System", selection: $newSubject.customSystem){
                            ForEach(systemManager.systems){system in
                                Text(system.name).tag(system as GradeSystem?)
                            }
                            
                        }
                    }
                    //                    if userData.selection==3{
                    //                        
                    //                        //                        Toggle("Foundation Subject?", isOn: $newSubject.isFoundation)
                    //                        
                    //                        
                    //                        //                        Toggle("Higher Mother Tongue?", isOn: $newSubject.isHMT)
                    //                        
                    //                    }
                    //                    if userData.selection==7{
                    //                        //                        Toggle("Mother Tongue Syllabus B?", isOn:$newSubject.isMTSB)
                    //                        
                    //                    }
                }
                .lrb(themeSelect)
                Section("ASSESSMENTS") {
                    List($newSubject.assessments){$assessm in
                        NavigationLink{
                            AssessmentDetailView(assess: $assessm)
                        }label: {
                            Text(assessm.name)
                        }
                    }
                    if newSubject.numOfAssessments>newSubject.assessments.count{
                        Button {
                            showNewAssessmentSheet = true
                        } label: {
                            HStack{
                                Image(systemName: "plus")
                                Text("Add an assessment")
                            }
                        }
                    }
                }
                .lrb(themeSelect)
                Section{
                    Button("Save"){
                        subjectmanager.subjects.append(newSubject)
                        dismiss()
                    }
                    Button("Cancel", role:.destructive){
                        dismiss()
                    }
                }
                .lrb(themeSelect)
            }
            .sheet(isPresented: $showNewAssessmentSheet){
                NewAssessmentView(sub: $newSubject)
                    .presentationDetents([.fraction(0.6)])
            }
            
        }
        
    }
    
}


struct NewSubjectView_Previews: PreviewProvider {
    static var previews: some View {
        NewSubjectView()
            .environment(SubjectManager())
            .environment(SystemManager())
    }
}

