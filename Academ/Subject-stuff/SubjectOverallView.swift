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
    @ObservedObject var userData: UserData
    var body: some View {
        NavigationStack{
            Form{
                Section(header: Text("Statistics").font(.footnote)){
                    HStack{
                        Text("Current Overall:")
                        Text("\(systemmanager.gradeCalculate(mark: subje.currentOverall(), formatt: "%.2f", userData: userData, customSys: subje.customSystem))")
                        if userData.gradeType != .none{
                            Spacer()
                            Text("\(String(format:"%.2f",subje.currentOverall()))%")
                        }
                    }//current overall
                    HStack{
                        Text("Highest:")
                        Text("\(systemmanager.gradeCalculate(mark: subje.highest(), formatt: "%.2f", userData: userData, customSys: subje.customSystem))")
                        if userData.gradeType != .none{
                            Spacer()
                            Text("\(String(format:"%.2f",subje.highest()))%")
                        }
                    }//highest
                    
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                Section(header: Text("Goals").font(.footnote)){
                    if subje.assessments.map({$0.markAttained}).count == subje.numOfAssessments{
                        HStack{
                            Text("Goal achieved?")
                            if subje.currentOverall() >= subje.targetMark {
                                Text("✅")
                            } else {
                                Text("❌")
                            }
                        }//goal achieved
                        if subje.currentOverall() == subje.targetMark {
                            Text("Goal already achieved. Well done! 😁")
                        }//goal message
                    }else {
                        HStack{
                            Text("Percentage needed:")
                            Spacer()
                            Text("\(String(format:"%.2f",subje.weightedGoal())) %")
                        }
                        List(subje.getUnfinishedAssessments()){assessme in
                            HStack{
                                Text("\(assessme.name) target marks:")
                                Spacer()
                                Text(String(format:"%.1f",assessme.totalMarks*subje.weightedGoal()/100))
                                Text("/\(Int(assessme.totalMarks))")
                            }
                        }
                    }
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
            }
            .background(.linearGradient(colors: userData.themelists[userData.colorSelect].mainColor, startPoint: .top, endPoint: .bottom))
            .scrollContentBackground(.hidden)
            .navigationTitle(subje.name)
            .onAppear{
                if (subje.assessments.count == subje.numOfAssessments)&&(subje.checkIfSubjectGradeExceeds100()>Double(100)){
                    showAlert=true
                }
            }
            .alert("Your inputted weightage is higher than 100%.",isPresented: $showAlert){
                
            }message: {
                Text("Please change your assessment's weightage")
            }
        }
    }
}



struct SubjectOverallView_Previews: PreviewProvider {
    static var previews: some View {
        
        SubjectOverallView(subje: .constant(Subject(name: "Mathematics", assessments: [
            Assessment(name: "WA1", weightage: 10, totalMarks: 20, examDone: true, markAttained: 12, examDate: Date(), haveReminder: false, reminder: Date()),
            //  Assessment(name: "WA2", weightage: 15, totalMarks: 30, examDone: true, markAttained: 23, examDate: Date(), haveReminder: false, reminder: Date()),
            //     Assessment(name: "WA3", weightage: 15, totalMarks: 45, examDone: true, markAttained: 37, examDate: Date(), haveReminder: false, reminder: Date()),
            //       Assessment(name: "EYE", weightage: 60, totalMarks: 120, examDone: false, markAttained: 0, examDate: Date(), haveReminder: true, reminder: Date())
        ], targetMark: 80, credits: 0, numOfAssessments: 4)),userData: UserData())
        .environment(SystemManager())
    }
}
