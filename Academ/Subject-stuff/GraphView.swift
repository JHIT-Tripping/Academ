//
//  GraphView.swift
//  Academ
//
//  Created by Raditya Aryo Wahyudi on 18/11/24.
//

import SwiftUI
import Charts

struct GraphView: View {
    var sub: Subject
    @ObservedObject var userData: UserData
    var body: some View {
        VStack{
            if sub.assessments.map({$0.markAttained}).count <= 1 {
                HStack{
                    Spacer()
                    VStack{
                        DonutChartView(subject: sub, userData: userData, width: 30)
                            .padding(4)
                            .frame(width: 200, height: 220)
                        Text(sub.name)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
            } else {
                
                Text("\(sub.name)")
                    .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                Chart(sub.assessments, id: \.self) { assessment in
                    if assessment.examDone{
                        LineMark(x: .value("Assessment", assessment.name), y: .value("Mark", percentage(amount: assessment.markAttained, total: assessment.totalMarks)))
                            .foregroundStyle(.red)
                        LineMark(x: .value("Assessment", assessment.name), y: .value("Mark", sub.targetMark),series: .value("blank", "smth"))
                            .foregroundStyle(.green)
                        LineMark(x: .value("Assessment", assessment.name), y: .value("Mark", sub.currentOverall()),series: .value("blank", "ded"))
                            .foregroundStyle(Color(hex:"0096FF"))
                    }
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                .chartYScale(domain:0...100)
                
            }
            if sub.assessments.map({$0.markAttained}).count > 1{
                HStack{
                    Image(systemName: "circle.fill")
                        .foregroundColor(.red)
                    Text("Marks per WA")
                    Text("        ")
                    Image(systemName: "circle.fill")
                        .foregroundColor(.green)
                    Text("Goal marks")
                    Text("  ")
                    Image(systemName: "circle.fill")
                        .foregroundColor(Color(hex:"0096FF"))
                    Text("Overall marks")
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
            }
            
        }
        
        
    }
}
