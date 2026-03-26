//
//  NewAssessmentView.swift
//  Academ
//
//  Created by yoeh iskandar on 20/11/23.
//

import SwiftUI
import UserNotifications

func requestNotificationAuthorization() {
    print("glory to soon")
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            print("Notification authorization granted")
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            print("Notification authorization denied")
        }
    }
}


struct NewAssessmentView: View {
    @State private var newAssessment = Assessment(name: "", weightage: 0, totalMarks: 0, examDone: false, markAttained: 0, examDate: Date())
    @State var alert2 = false
    @State var alert3 = false
    @Environment(\.dismiss) var dismiss
    @Binding var sub: Subject
    @State var NotificationSet =  true
    @AppStorage("themes") var themeSelect = "Default"
    func scheduleNotification(at date: Date, body: String, title: String) {
        
        requestNotificationAuthorization()
        
        // Remove all pending notifications
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully at \(components)")
            }
        }
    }
    
    var body: some View {
        NavigationStack{
        AForm{
            Section("Assessment Info"){
                TextField("Name",text: $newAssessment.name)
                //TextField()
                HStack{
                    Text("Weightage:")
                    NumberField(titleKey: "Percentage", value: Binding{
                        newAssessment.weightage
                    }set:{newValue in
                        if sub.assessments.reduce(0, {$0+$1.weightage}) + newValue > 100 || newValue == 0 {
                            
                            newAssessment.weightage = 100 - sub.assessments.reduce(0, {$0+$1.weightage})
                        }else{
                            newAssessment.weightage = newValue
                        }
                    })
                    Text("%")
                    
                    
                }
                HStack{
                    Text("Total marks:")
                    NumberField(titleKey: "Marks", value: $newAssessment.totalMarks)
                    
                }
                
                HStack{
                    Text("Exam done?")
                    Toggle(isOn: $newAssessment.examDone){
                        Text("")
                    }
                    
                }
                if newAssessment.examDone {
                    HStack {
                        Text("Result:")
                        NumberField(titleKey: "Marks", value: Binding{
                            newAssessment.markAttained
                        }set:{ newValue in
                            newAssessment.markAttained = newValue
                        })
                        Text("marks or")
                        NumberField(titleKey: "Percentage", value: Binding{
                            newAssessment.percentage
                        }set:{ newValue in
                            newAssessment.markAttained = newValue * newAssessment.totalMarks / 100
                            
                        })
                        Text("%")
                        
                    }
                } else{
                    DatePicker(
                        "Exam Date",
                        selection: $newAssessment.examDate,
                        displayedComponents: [.date]
                    )
                    OptionalDatePicker(date: $newAssessment.reminder, name: "reminder")
                        .onChange(of: newAssessment.reminder) { oldValue, newValue in
                            if let reminder = newAssessment.reminder {
                                print("schedule")
                                scheduleNotification(at: reminder, body: "Your exam is on \(newAssessment.examDate)", title: newAssessment.name)
                            }
                        }
                }
            }
            .lrb(themeSelect)
        }
        
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading){
                Button(role: .close) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing){
                Button("Save",role: .confirm){
                    
                    if newAssessment.totalMarks == 0 {
                        alert2 = true
                    }
                    else if newAssessment.totalMarks < newAssessment.markAttained {
                        alert3 = true
                    }
                    
                    else {
                        sub.assessments.append(newAssessment)
                        dismiss()
                        if let reminder = newAssessment.reminder, NotificationSet{
                            //                            requestNotificationAuthorization()
                            print("ASKING FOR NOTIFICATION")
                            scheduleNotification(at: reminder, body: "Your exam is on \(newAssessment.examDate)h", title: newAssessment.name)
                            NotificationSet = false
                        }
                    }
                }
            }
        }
        
        
        .alert("The total marks cannot be 0.",isPresented: $alert2){}
        
        
        .alert("Marks attained cannot exceed total marks of an assessment",isPresented: $alert3){}
        
        
    }
            
        
        
        
    }
}
#Preview {
    NewAssessmentView(sub: .constant(Subject(name: "Mathematics", assessments: [], targetMark: 75, credits: 0, numOfAssessments: 4)))
}


