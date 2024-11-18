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
    @ObservedObject var userData: UserData
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    var body: some View {
        Form{
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
            .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
            Section{
                Button("Save"){
                    system.grades.append(newGrade)
                    dismiss()
                }
                Button("Cancel",role: .destructive){
                    dismiss()
                }
            }
            .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
        }
        .background(.linearGradient(colors: userData.themelists[userData.colorSelect].mainColor, startPoint: .top, endPoint: .bottom))
        .scrollContentBackground(.hidden)
    }
}

struct NewGradeView_Previews: PreviewProvider {
    static var previews: some View {
        NewGradeView(system: .constant(GradeSystem(name: "GP", grades: [], type: .GPA)), userData: UserData())
    }
}
