//
//  NewGradeView.swift
//  Academ
//
//  Created by T Krobot on 24/11/23.
//

import SwiftUI

struct NewGradeView: View {
    @State private var newGrade = Grade(name: "", minMark: 0, maxMark: 0, gradePoint: 0)
    @Environment(\.dismiss) var dismiss
    @Binding var system: GradeSystem
    @AppStorage("themes") var themeSelect = "Default"
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    var body: some View {
        AForm{
            Section("Grade Info"){
                TextField("Name", text: $newGrade.name)
                HStack{
                    Text("Min. Mark:")
                    TextField("Number",value: $newGrade.minMark, formatter: formatter)
                }
                HStack{
                    Text("Max. Mark:")
                    TextField("Number",value: $newGrade.maxMark, formatter: formatter)
                }
                HStack{
                    Text("Grade Point:")
                    TextField("Number",value: $newGrade.gradePoint, formatter: formatter)
                }
            }
            .lrb(themeSelect)
            Section{
                Button("Save"){
                    system.grades.append(newGrade)
                    dismiss()
                }
                Button("Cancel",role: .destructive){
                    dismiss()
                }
            }
            .lrb(themeSelect)
        }
        
        
    }
}

struct NewGradeView_Previews: PreviewProvider {
    static var previews: some View {
        NewGradeView(system: .constant(GradeSystem(name: "GP", grades: [], type: .GPA)))
    }
}
