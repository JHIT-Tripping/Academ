import SwiftUI
import Charts

struct GraphView: View {
    var sub: Subject
    @AppStorage("themes") var themeSelect = "Default"
    var body: some View {
        VStack{
            if sub.assessments.filter({$0.examDone == true}).count <= 1 {
                HStack{
                    Spacer()
                    VStack{
                        DonutChartView(subject: sub, width: 30)
                            .padding(4)
                            .frame(width: 200, height: 220)
                        Text(sub.name)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
            } else {
                
                Text("\(sub.name)")
                Section{
                    Chart(sub.assessments) {
                        if $0.examDone{
                            LineMark(x: .value("Assessment", $0.name), y: .value("Percentage", $0.percentage))
                                .foregroundStyle(by: .value("Type", "Marks"))
                            RuleMark(y: .value("Percentage", sub.targetMark))
                                .foregroundStyle(by: .value("Type", "Goal"))
                            RuleMark(y: .value("Percentage", sub.currentOverall()))
                                .foregroundStyle(by: .value("Type", "Overall"))
                        }
                    }
                }
                .lrb(themeSelect)
                .chartYScale(domain:0...100)
                .chartLegend(position: .bottom)
                .chartForegroundStyleScale([
                    "Marks": .red,
                    "Goal": .green,
                    "Overall": .blue
                ])
            }
            
        }
        
        
    }
}

