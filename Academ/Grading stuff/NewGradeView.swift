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
    var body: some View {
        AForm{
            Section("Grade Info"){
                TextField("Name", text: $newGrade.name)
                HStack{
                    Text("Min. Mark:")
                    NumberField(titleKey: "Number",value: $newGrade.minMark)
                }
                HStack{
                    Text("Max. Mark:")
                    NumberField(titleKey: "Number",value: $newGrade.maxMark)
                }
                HStack{
                    Text("Grade Point:")
                    NumberField(titleKey: "Number",value: $newGrade.gradePoint)
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
