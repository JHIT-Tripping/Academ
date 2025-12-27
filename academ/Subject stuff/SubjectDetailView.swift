//
//  SubjectDetailView.swift
//  Academ
//
//  Created by yoeh iskandar on 18/11/23.
//

import SwiftUI

struct SubjectDetailView: View {
    @Binding var sub: Subject
    @State private var displaySheet = false
    @State private var showAlert = false
    @AppStorage("gradeType") var gradeType = GradeType.none
    @AppStorage("gpaCredits") var haveCredits = false
    @AppStorage("passingGrade") var pass:Double = 50
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
                Section("subject info") {
                    TextField("Name",text:$sub.name)
                    HStack{
                        Text("No. of Assessments")
                        TextField("Num",value:$sub.numOfAssessments, formatter: formatter)
                    }
                    HStack{
                        Text("Overall Goal:")
                        TextField("Percentage",value:$sub.targetMark,formatter: formatter)
                        Text("%")
                    }//overall goal
                    if sub.assessments.map({$0.markAttained}).count>0{
                        NavigationLink{
                            SubjectOverallView(subje: $sub)
                        }label: {
                            Text("Overall")
                        }
                    }
                    if haveCredits{
                        HStack{
                            Text("Credit")
                            TextField("Hours",value: $sub.credits, formatter: formatter)
                        }
                    }
                    Toggle("Is calculated?", isOn: $sub.isCalculated)
                    if !systemManager.systems.isEmpty{
                        Picker("System", selection: $sub.customSystem){
                            ForEach(systemManager.systems){system in
                                Text(system.name).tag(system as GradeSystem?)
                            }
                            
                        }
                    }
                }
                .lrb(themeSelect)
                Section("Assessments") {
                    List($sub.assessments,editActions:.all){$assessment in
                        NavigationLink(destination: AssessmentDetailView(assess: $assessment)){
                            HStack{
                                Text(assessment.name)
                                Spacer()
                                if assessment.examDone{
                                    Text(String(format:"%.0f",assessment.percentage)+"%")
                                }else{
                                    Text(assessment.examDate, style: .relative)
                                    if Date.now>assessment.examDate{
                                        Text("ago")
                                    }else{
                                        Text("from now")
                                    }
                                }
                            }
                            
                        }
                    }
                    if !(sub.assessments.count >= sub.numOfAssessments){
                        Button {
                            print("sooon")
                            displaySheet = true
                        } label: {
                            Text("+  Add an assessment")
                        }
                    }
                    
                }
                .lrb(themeSelect)
                if sub.assessments.map({$0.markAttained}).count>0{
                    Section("Subject trends (%)"){
                        GraphView(sub: sub)
                    }
                    .lrb(themeSelect)
                }
            }
            
            .navigationTitle($sub.name)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                        .padding(.trailing, 8)
                        .mask{
                            RoundedRectangle(cornerRadius: 10)
                        }
                }
            }
            .onAppear{
                if (sub.assessments.count == sub.numOfAssessments || sub.numOfAssessments == 0)&&(sub.assessments.reduce(0){$0+$1.weightage}>Double(100)){
                    showAlert=true
                }
            }
            .alert("Your inputted weightage is higher than 100%.",isPresented: $showAlert){
                
            }message: {
                Text("Please change your assessment's weightage")
            }
        }
        .sheet(isPresented: $displaySheet) {
            NewAssessmentView(sub:$sub)
        }
        
        
        
        
    }
}
struct SubjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SubjectDetailView(sub: .constant(Subject(name: "Mathematics", assessments: [
            Assessment(name: "WA1", weightage: 10, totalMarks: 20, examDone: true, markAttained: 12, examDate: Date(), haveReminder: false, reminder: Date()),
            Assessment(name: "WA2", weightage: 15, totalMarks: 30, examDone: true, markAttained: 23, examDate: Date(), haveReminder: false, reminder: Date()),
            Assessment(name: "WA3", weightage: 15, totalMarks: 45, examDone: true, markAttained: 37, examDate: Date(), haveReminder: false, reminder: Date()),
            Assessment(name: "EYE", weightage: 60, totalMarks: 120, examDone: false, markAttained: 0, examDate: Date(), haveReminder: true, reminder: Date())
        ], targetMark: 80, credits: 0, numOfAssessments: 4)))
        .environment(SystemManager())
    }
}
