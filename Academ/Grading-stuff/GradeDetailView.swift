//
//  GradeDetailView.swift
//  Academ
//
//  Created by T Krobot on 24/11/23.
//

import SwiftUI

struct GradeDetailView: View {
    @Binding var grade: Grade
    @ObservedObject var userData: UserData
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    var body: some View {
        NavigationStack{
            Form{
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
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
            }
            .background(.linearGradient(colors: userData.themelists[userData.colorSelect].mainColor, startPoint: .top, endPoint: .bottom))
            .scrollContentBackground(.hidden)
            .navigationTitle(grade.name)
        }
    }
}

struct GradeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GradeDetailView(grade: .constant(Grade(name: "A", minMark: 80, maxMark:100 , gradePoint: 4.0)), userData: UserData())
    }
}
