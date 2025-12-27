//
//  GradeDetailView.swift
//  Academ
//
//  Created by T Krobot on 24/11/23.
//

import SwiftUI

struct GradeDetailView: View {
    @Binding var grade: Grade
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    @AppStorage("themes") var themeSelect = "Default"
    var body: some View {
        
            AForm{
                Section("Grade Info"){
                    TextField("Name", text: $grade.name)
                    HStack{
                        Text("Min. Mark:")
                        TextField("Number",value: $grade.minMark, formatter: formatter)
                    }
                    HStack{
                        Text("Max. Mark:")
                        TextField("Number",value: $grade.maxMark, formatter: formatter)
                    }
                    HStack{
                        Text("Grade Point:")
                        TextField("Number",value: $grade.gradePoint, formatter: formatter)
                    }
                }
                .lrb(themeSelect)
            }
            
            
            .navigationTitle(grade.name)
        }
    
}

#Preview {
    GradeDetailView(grade: .constant(Grade(name: "A", minMark: 80, maxMark:100 , gradePoint: 4.0)))
}
