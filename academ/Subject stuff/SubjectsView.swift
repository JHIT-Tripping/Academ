//
//  SubjectsView.swift
//  Academ
//
//  Created by T Krobot on 18/11/23.
//

import SwiftUI

struct SubjectsView: View {
    @Environment(SubjectManager.self) var subjectmanager
    @Environment(SystemManager.self) var systemmanager
    
    @State private var displaySheet = false
    @State private var isFormatted = false
    @AppStorage("gradeType") var gradeType = GradeType.none
    @AppStorage("gpaCredits") var haveCredits = false
    @AppStorage("passingGrade") var pass:Double = 50
    @AppStorage("themes") var themeSelect = "Default"
    var body: some View {
        @Bindable var settings = subjectmanager
        NavigationStack {
            AForm {
                
                if !settings.subjects.isEmpty {
                    Section {
                        HStack {
                            Text("Target")
                            Spacer()
                            Text(
                                isFormatted
                                ? systemmanager.gradeCalculateFromPoint(
                                    point: subjectmanager.compute(isTarget: true, gradeType: gradeType, haveCredits: haveCredits, systemManager: systemmanager),
                                    formatt: "%.2f",
                                    customSys: nil
                                )
                                : String(format: "%.2f", subjectmanager.compute(isTarget: true, gradeType: gradeType, haveCredits: haveCredits, systemManager: systemmanager))
                            )
                        }
                        
                        HStack {
                            Text("Current")
                            Spacer()
                            Text(
                                isFormatted
                                ? systemmanager.gradeCalculateFromPoint(
                                    point: settings.compute(isTarget: false, gradeType: gradeType, haveCredits: haveCredits, systemManager: systemmanager),
                                    formatt: "%.2f",
                                    customSys: nil
                                )
                                : String(format: "%.2f", settings.compute(isTarget: false, gradeType: gradeType, haveCredits: haveCredits, systemManager: systemmanager))
                            )
                        }
                    } footer: {
                        if gradeType == .GPA || gradeType == .MSG {
                            Button("Toggle formatting") {
                                isFormatted.toggle()
                            }
                            .font(.footnote)
                        }
                    }
                    .lrb(themeSelect)
                }
                
                Section {
                    if settings.subjects.isEmpty {
                        Text("No subjects")
                            .foregroundColor(.gray)
                    } else {
                        List($settings.subjects, editActions: .all) { $subject in
                            NavigationLink {
                                SubjectDetailView(sub: $subject)
                            } label: {
                                HStack {
                                    Text(subject.name)
                                    if subject.assessments.map({ $0.markAttained }).count > 0 {
                                        Spacer()
                                        Text(String(format: "%.0f", subject.currentOverall()) + "%")
                                    }
                                }
                            }
                        }
                    }
                }
                .lrb(themeSelect)
            }
            .navigationTitle("Subjects")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    HStack {
                        EditButton()
                        Button {
                            displaySheet = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    .padding(.trailing, 8)
                    .mask {
                        RoundedRectangle(cornerRadius: 10)
                    }
                }
            }
            .sheet(isPresented: $displaySheet) {
                NewSubjectView()
                    .presentationDetents([.fraction(0.8)])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

struct SubjectsView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectsView()
            .environment(SubjectManager())
            .environment(SystemManager())
    }
}





