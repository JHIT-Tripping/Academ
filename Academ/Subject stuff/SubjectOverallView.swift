//
//  SubjectOverallView.swift
//  Academ
//
//  Created by yoeh iskandar on 18/11/23.
//

import SwiftUI


struct SubjectOverallView: View {
    @Binding var subje: Subject
    @State private var showAlert = false
    @Environment(SystemManager.self) var systemmanager: SystemManager
    @AppStorage("gradeType") var gradeType = GradeType.none
    @AppStorage("themes") var themeSelect = "Default"
    var body: some View {
            AForm{
                Section("Statistics"){
                    HStack{
                        Text("Current Overall:")
                        Text("\(systemmanager.gradeCalculate(mark: subje.currentOverall(), formatt: "%.2f", customSys: subje.customSystem))")
                        if gradeType != .none{
                            Spacer()
                            Text("\(String(format:"%.2f",subje.currentOverall()))%")
                        }
                    }//current overall
                    HStack{
                        Text("Highest:")
                        Text("\(systemmanager.gradeCalculate(mark: subje.highest(), formatt: "%.2f", customSys: subje.customSystem))")
                        if gradeType != .none{
                            Spacer()
                            Text("\(String(format:"%.2f",subje.highest()))%")
                        }
                    }//highest
                    
                }
                .lrb(themeSelect)
                Section("Goals"){
                    if subje.doneAssessments.count == subje.numOfAssessments{
                        HStack{
                            Text("Goal achieved?")
                            if subje.currentOverall() >= subje.targetMark {
                                Text("✅")
                            } else {
                                Text("❌")
                            }
                        }//goal achieved
                    }else {
                        if subje.currentOverall() >= subje.targetMark{
                            Text("Goal has been achieved, keep up the good work!")
                            List(subje.unfinishedAssessments){assessme in
                                HStack{
                                    Text("\(assessme.name) target marks:")
                                    Spacer()
                                    Text(String(format:"%.1f",assessme.totalMarks*subje.targetMark/100))
                                    Text("/\(Int(assessme.totalMarks))")
                                }
                            }
                        }else{
                            HStack{
                                Text("Percentage needed:")
                                Spacer()
                                Text("\(String(format:"%.2f",subje.weightedGoal())) %")
                            }
                            List(subje.unfinishedAssessments){assessme in
                                HStack{
                                    Text("\(assessme.name) target marks:")
                                    Spacer()
                                    Text(String(format:"%.1f",assessme.totalMarks*subje.weightedGoal()/100))
                                    Text("/\(Int(assessme.totalMarks))")
                                }
                            }
                        }
                    }
                }
                .lrb(themeSelect)
            }
            .navigationTitle(subje.name)
            .onAppear{
                if (subje.assessments.count == subje.numOfAssessments)&&(subje.assessments.reduce(0){$0+$1.weightage}>Double(100)){
                    showAlert=true
                }
            }
            .alert("Your inputted weightage is higher than 100%.",isPresented: $showAlert){
                
            }message: {
                Text("Please change your assessment's weightage")
            }
        
    }
}



struct SubjectOverallView_Previews: PreviewProvider {
    static var previews: some View {
        
        SubjectOverallView(subje: .constant(Subject(name: "Mathematics", assessments: [
            Assessment(name: "WA1", weightage: 10, totalMarks: 20, examDone: true, markAttained: 12, examDate: Date(), haveReminder: false, reminder: Date()),
              Assessment(name: "WA2", weightage: 15, totalMarks: 30, examDone: true, markAttained: 23, examDate: Date(), haveReminder: false, reminder: Date()),
                 Assessment(name: "WA3", weightage: 15, totalMarks: 45, examDone: true, markAttained: 37, examDate: Date(), haveReminder: false, reminder: Date()),
                   Assessment(name: "EYE", weightage: 60, totalMarks: 120, examDone: false, markAttained: 0, examDate: Date(), haveReminder: true, reminder: Date())
        ], targetMark: 80, credits: 0, numOfAssessments: 4)))
        .environment(SystemManager())
    }
}
