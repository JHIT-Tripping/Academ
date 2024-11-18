//
//  DashboardView.swift
//  Academ
//
//  Created by T Krobot on 18/11/23.
//

import SwiftUI


struct DashboardView: View {
    @EnvironmentObject var subjectmanager: SubjectManager
    @ObservedObject var userData: UserData
    @Environment(SystemManager.self) var systemmanager: SystemManager
    var body: some View {
        NavigationStack{
            Form {
                Section{
                    if subjectmanager.subjects.count == 0 {
                        Text("No subjects")
                            .foregroundColor(.gray)
                        
                    }else{
                        ScrollView(.horizontal){
                            HStack {
                                ForEach($subjectmanager.subjects){ $subject in
                                    NavigationLink{
                                        SubjectDetailView(sub:$subject,userData:userData)
                                    }label:{
                                        VStack{
                                            DonutChartView(subject: subject, userData: userData, width: 6)
                                                .frame(width: 70, height: 50)
                                                .padding(4)
                                            Text(subject.name)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                        .cornerRadius(4)
                    }
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                
                if subjectmanager.subjects.count == 0 {
                    Section{
                        Text("No subjects available. Go add some in the subjects tab!")
                            .foregroundColor(.gray)
                    }
                    .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                }else{
                    ForEach($subjectmanager.subjects){ $subject in
                        Section{
                            NavigationLink{
                                SubjectDetailView(sub:$subject,userData:userData)
                            }label: {
                                GraphView(sub: subject, userData: userData)
                            }
                        }
                        .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
                    }
                    
                }
                
                
                
                
            }
            .background(.linearGradient(colors: userData.themelists[userData.colorSelect].mainColor, startPoint: .top, endPoint: .bottom))
            .scrollContentBackground(.hidden)
            .navigationTitle("Dashboard")
        }
    }
    
}
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(userData: UserData())
            .environmentObject(SubjectManager())
            .environment(SystemManager())
    }
}
