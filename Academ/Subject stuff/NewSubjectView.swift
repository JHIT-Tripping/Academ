//
//  SubjectSheets.swift
//  Academ
//
//  Created by T Krobot on 20/11/23.
//

import SwiftUI

struct NewSubjectView: View {
    @Environment(SubjectManager.self) var subjectmanager: SubjectManager
    @State private var newSubject:Subject = Subject(name: "", assessments: [], targetMark: 0, credits: 1)
    @State private var showNewAssessmentSheet = false
    @Environment(\.dismiss) var dismiss
    @AppStorage("gpaCredits") var haveCredits = false
    @AppStorage("themes") var themeSelect = "Default"
    @Environment(SystemManager.self) var systemManager: SystemManager
    var body: some View {
        NavigationStack {
            AForm{
                Section("Subject Info") {
                    TextField("Subject", text:$newSubject.name)
                    HStack{
                        Text("Overall Goal")
                        NumberField(titleKey: "Percentage", value: $newSubject.targetMark)
                        Text("%")
                    }
//                    HStack{
//                        Text("No. of assessments:")
//                        TextField("Number", value: $newSubject.numOfAssessments, formatter: NumberFormatter())
//                        
//                    }
                    if haveCredits{
                        HStack{
                            Text("Credit")
                            TextField("Value",value: $newSubject.credits, formatter: NumberFormatter())
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
                Section("Assessments") {
                    List($newSubject.assessments){$assessm in
                        NavigationLink{
                            AssessmentDetailView(assess: $assessm)
                        }label: {
                            Text(assessm.name)
                        }
                    }
                    if newSubject.weightageSum() < 100{
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
            }
            .sheet(isPresented: $showNewAssessmentSheet){
                NewAssessmentView(sub: $newSubject)
                    .presentationDetents([.fraction(0.8)])
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(role: .close) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Save",role: .confirm){
                        subjectmanager.subjects.append(newSubject)
                        dismiss()
                    }
                }
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

