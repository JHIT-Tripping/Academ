//
//  SubjectDetailView.swift
//  Academ
//
//  Created by yoeh iskandar on 18/11/23.
//

import SwiftUI

struct SubjectDetailView: View {
    @Binding var sub: Subject
    var body: some View {
        
        NavigationStack {
            VStack{
                
            }
        }
        .navigationTitle("Subjects")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
        }
    }
    
    struct SubjectDetailView_Previews: PreviewProvider {
        static var previews: some View {
            SubjectDetailView(sub: .constant(Subject(name: "Mathematics", assessments: [])))
        }
    }
}
