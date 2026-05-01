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
    @State private var addSubject = false
    @State private var zoomOut = true
    var body: some View {
        @Bindable var subjectmanager = subjectmanager
        NavigationStack{
            AForm {
                Section("Subjects") {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach($subjectmanager.subjects) { $subject in
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
                            Button{
                                addSubject = true
                            }label: {
                                VStack {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 70, height: 57)
                                    Text("Add")
                                }
                            }
                            .sheet(isPresented: $addSubject) {
                                NewSubjectView()
                            }
                        }
                    }
                    .cornerRadius(4)
                    
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
                            if let s = subjectmanager.subjects.first(where: {$0.id == assessment.1.id}), let _ = s.assessments.first(where: {$0.id == assessment.0.id}){
                                NavigationLink{
                                    AssessmentDetailView(assess: $subjectmanager.subjects.first(where: {$0.id == assessment.1.id})!.assessments.first(where: {$0.id == assessment.0.id})!)
                                }label:{
                                    Text(assessment.1.name + ": " + assessment.0.name)
                                }
                            }
                        }
                    }
                    .lrb(themeSelect)
                    
                }
                Section{
                    Picker("Type", selection: $chartType){
                        Text("Overall").tag(0)
                        Text("Last").tag(1)
                        if !subjectmanager.subjects.allSatisfy({$0.doneAssessments.count <= 1}){
                            Text("Trend").tag(2)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    if subjectmanager.subjects.filter({!$0.doneAssessments.isEmpty}).isEmpty {
                        Text("No data to show")
                            .foregroundStyle(.gray)
                    }else{
                        Group{
                            if chartType == 0{
                                ZStack{
                                    Chart(subjectmanager.subjects.sorted(by: {$0.currentOverall() > $1.currentOverall()})){
                                        BarMark(
                                            x: .value("Subject", $0.name),
                                            y: .value("Goal", $0.targetMark)
                                        )
                                        .cornerRadius(10)
                                        .foregroundStyle(by: .value("Type", " "))
                                        
                                    }
                                    .chartYScale(domain: 0...100).chartForegroundStyleScale([
                                        " ": .green
                                    ])
                                    .chartYAxis {
                                        AxisMarks {
                                            AxisGridLine()
                                                .foregroundStyle(.clear)
                                            AxisValueLabel()
                                                .foregroundStyle(.clear)
                                        }
                                    }
                                    .chartXAxis{
                                        AxisMarks {
                                            AxisGridLine()
                                                .foregroundStyle(.clear)
                                            AxisValueLabel()
                                                .foregroundStyle(.clear)
                                        }
                                    }
                                    Chart(subjectmanager.subjects.sorted(by: {$0.currentOverall() > $1.currentOverall()})){
                                        
                                        BarMark(
                                            x: .value("Subject", $0.name),
                                            y: .value("Overall %", $0.currentOverall())
                                        )
                                        .cornerRadius(10)
                                        .foregroundStyle(by: .value("Type", "Overall"))
                                        
                                        RuleMark(y: .value("Average", subjectmanager.subjects.reduce(0){
                                            $0+$1.currentOverall()
                                        }/Double(subjectmanager.subjects.count)))
                                        .foregroundStyle(by: .value("Type", "Average"))
                                    }
                                    .chartYScale(domain: 0...100)
                                    .chartForegroundStyleScale([
                                        "Overall": .blue,
                                        "Goal": .green,
                                        "Average": .orange
                                    ])
                                }
                            }else if chartType == 1{
                                Chart(subjectmanager.subjects.sorted(by: {$0.doneAssessments.last?.percentage ?? 0 > $1.doneAssessments.last?.percentage ?? 0})){
                                    BarMark(
                                        x: .value("Subject", $0.name),
                                        y: .value("Last %", $0.doneAssessments.last?.percentage ?? 0)
                                    )
                                    .cornerRadius(10)
                                    .foregroundStyle(by: .value("Type", "Last"))
                                    RuleMark(y: .value("Average", subjectmanager.subjects.reduce(0){
                                        $0+($1.doneAssessments.last?.percentage ?? 0)
                                    }/Double(subjectmanager.subjects.count)))
                                    .foregroundStyle(by: .value("Type", "Average"))
                                }
                                .chartYScale(domain: 0...100)
                                .chartForegroundStyleScale([
                                    "Last": .blue,
                                    "Average": .orange
                                ])
                            }else if chartType == 2{
                                Chart(subjectmanager.subjects.sorted(by: {$0.assessments.count < $1.assessments.count})) { subject in
                                    if subject.doneAssessments.count > 0{
                                        if subject.doneAssessments.count == 1, let first = subject.doneAssessments.first{
                                            RuleMark(y: .value("Percentage", first.percentage))
                                                .foregroundStyle(by: .value("Subject", subject.name))
                                            
                                        }else{
                                            ForEach(subject.assessments.indices, id: \.self) { index in
                                                let assessment = subject.assessments[index]
                                                if assessment.examDone {
                                                    LineMark(x: .value("Assessment", Double(index)/Double(subject.assessments.count-1)), y: .value("Percentage", assessment.percentage))
                                                        .foregroundStyle(by: .value("Subject", subject.name))
                                                        .lineStyle(StrokeStyle(lineWidth: 3))
                                                }
                                            }
                                        }
                                    }
                                }
                                .chartXScale(domain: 0...1)
                                .chartXAxis{AxisMarks{_ in}}
                                .chartYScale(domain: zoomOut ? 0...100 : subjectmanager.subjects.chartRange())
                                .chartYAxis{AxisMarks(values: [0,25,50,75,100]){_ in
                                    AxisGridLine()
                                    AxisValueLabel()
                                }}
                                .onTapGesture {
                                    withAnimation {
                                        zoomOut.toggle()
                                    }
                                }
                            }
                        }
                        .frame(minHeight: 200)
                    }
                    
                }header: {
                    HStack{
                        Text("Charts")
                        Spacer()
                        if chartType == 2{
                            Button{
                                withAnimation {
                                    zoomOut.toggle()
                                }
                            }label: {
                                if zoomOut{
                                    Image(systemName: "plus.magnifyingglass")
                                }else{
                                    Image(systemName: "minus.magnifyingglass")
                                }
                            }
                        }
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
extension [Subject]{
    func chartRange() -> ClosedRange<Double>{
        let min = self.flatMap{$0.assessments.filter{$0.examDone}.map{$0.percentage}}.min() ?? 0
        let max = self.flatMap{$0.assessments.filter{$0.examDone}.map{$0.percentage}}.max() ?? 100
        let intervals: [Double] = [0,25,50,75,100]
        let x = intervals.first(where: {$0 > max}) ?? 100
        let n = intervals.last(where: {$0 < min}) ?? 0
        return n...x
    }
}
