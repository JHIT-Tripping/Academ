//
//  DashboardView.swift
//  Academ
//
//  Created by T Krobot on 18/11/23.
//

import SwiftUI
import Charts

struct DashboardView: View {
    @Environment(SubjectManager.self) var subjectmanager: SubjectManager
    @Environment(SystemManager.self) var systemmanager: SystemManager
    var upcomingAssessments: [(Assessment, Subject)]{
        var upc: [(Assessment, Subject)] = []
        for i in subjectmanager.subjects{
            upc.append(contentsOf: i.assessments.filter{$0.examDate>Date.now && $0.examDone == false}.map{($0,i)})
        }
        return upc.sorted(by: {$0.0.examDate<$1.0.examDate})
    }
    var doneAssessments: [(Assessment, Subject)]{
        var don: [(Assessment, Subject)] = []
        for i in subjectmanager.subjects{
            don.append(contentsOf: i.assessments.filter{$0.examDate<Date.now && $0.examDone == false}.map{($0,i)})
        }
        return don.sorted(by: {$0.0.examDate<$1.0.examDate})
    }
    @State private var chartType = 0
    @AppStorage("themes") var themeSelect = "Default"
    var body: some View {
        @Bindable var subjectmanager = subjectmanager
        NavigationStack{
            AForm {
                Section {
                    if subjectmanager.subjects.isEmpty {
                        Text("No subjects")
                            .foregroundColor(.gray)
                    } else {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach($subjectmanager.subjects) { $subject in
                                    if !subject.assessments.map({ $0.markAttained }).isEmpty {
                                        NavigationLink {
                                            SubjectDetailView(sub: $subject)
                                        } label: {
                                            VStack {
                                                DonutChartView(subject: subject, width: 6)
                                                    .frame(width: 70, height: 50)
                                                    .padding(4)
                                                Text(subject.name)
                                                    .foregroundColor(.primary)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .cornerRadius(4)
                    }
                }
                .lrb(themeSelect)
                if !upcomingAssessments.isEmpty{
                    Section("Upcoming"){
                        ForEach(upcomingAssessments, id: \.0.id){assessment in
                            NavigationLink{
                                AssessmentDetailView(assess: $subjectmanager.subjects.first(where: {$0.id == assessment.1.id})!.assessments.first(where: {$0.id == assessment.0.id})!)
                            }label:{
                                HStack{
                                    Text(assessment.1.name + ": " + assessment.0.name)
                                    Spacer()
                                    Text(assessment.0.examDate, style: .date)
                                }
                            }
                        }
                    }
                    .lrb(themeSelect)
                }
                if !doneAssessments.isEmpty{
                    Section("Finished"){
                        ForEach(doneAssessments, id: \.0.id){assessment in
                            NavigationLink{
                                AssessmentDetailView(assess: $subjectmanager.subjects.first(where: {$0.id == assessment.1.id})!.assessments.first(where: {$0.id == assessment.0.id})!)
                            }label:{
                                Text(assessment.1.name + ": " + assessment.0.name)
                            }
                        }
                    }
                    .lrb(themeSelect)
                    
                }
                Section("Charts"){
                    Picker("Type", selection: $chartType){
                        Text("Overall").tag(0)
                        Text("Last").tag(1)
                        Text("Trend").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                        
                        if chartType == 0{
                            Chart(subjectmanager.subjects){
                                BarMark(
                                    x: .value("Subject", $0.name),
                                    y: .value("Overall %", $0.currentOverall())
                                )
                                .cornerRadius(25)
                                .foregroundStyle(by: .value("Type", "Overall"))
                                RuleMark(y: .value("Average", subjectmanager.subjects.reduce(0){
                                    $0+$1.currentOverall()
                                }/Double(subjectmanager.subjects.count)))
                                .foregroundStyle(by: .value("Type", "Average"))
                            }
                            .chartYScale(domain: 0...100)
                        }else if chartType == 1{
                            Chart(subjectmanager.subjects){
                                BarMark(
                                    x: .value("Subject", $0.name),
                                    y: .value("Last %", $0.assessments.last(where: {$0.examDone == true})?.percentage ?? 0)
                                )
                                .cornerRadius(25)
                                .foregroundStyle(by: .value("Type", "Last"))
                                RuleMark(y: .value("Average", subjectmanager.subjects.reduce(0){
                                    $0+($1.assessments.last(where: {$0.examDone == true})?.percentage ?? 0)
                                }/Double(subjectmanager.subjects.count)))
                                .foregroundStyle(by: .value("Type", "Average"))
                            }
                            .chartYScale(domain: 0...100)
                        }else if chartType == 2{
                            Chart(subjectmanager.subjects) { subject in
                                
                                    ForEach(subject.assessments.indices, id: \.self) { index in
                                        let assessment = subject.assessments[index]
                                        if assessment.examDone {
                                            LineMark(x: .value("Assessment", Double(index)/Double(subject.numOfAssessments)), y: .value("Percentage", assessment.percentage))
                                                .foregroundStyle(by: .value("Subject", subject.name))
                                        }
                                    
                                }
                            }
                            .chartXScale(domain: 0...1)
                            .chartXAxis{AxisMarks{_ in}}
                        }
                    
                        
                }
                .lrb(themeSelect)
            }
            
            
            .navigationTitle("Dashboard")
        }
    }
    
}
#Preview{
    DashboardView()
        .environment(SubjectManager())
        .environment(SystemManager())
    
}

