import SwiftUI

struct AssessmentDetailView: View {
    @Binding var assess: Assessment
    @State private var isDisplayed = false
    @State var NotificationSet =  true
    @State private var showAlert = false
    @AppStorage("themes") var themeSelect = "Default"
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    // all data has to be binding or else it would refresh
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied")
            }
        }
    }
    
    
    
    func scheduleNotification(at date: Date, body: String, title: String) {
        // Remove all pending notifications
        requestNotificationAuthorization()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    var body: some View {
       // let _: () = Self._printChanges() 
        
            AForm {
                Section {
                    TextField("Name", text: $assess.name)
                    
                    HStack {
                        Text("Weightage:")
                        TextField("Percentage", value: $assess.weightage, formatter: formatter)
                        Text("%")
                    }
                    
                    HStack {
                        Text("Total marks:")
                        TextField("Marks", value: Binding{
                            assess.totalMarks
                        }set:{ newValue in
                            if newValue >= assess.markAttained, newValue > 0{
                                assess.totalMarks = newValue
                            }
                        }, formatter: formatter)
                            
                    }
                    
                    
                    Toggle(isOn: $assess.examDone) {
                        Text("Exam done?")
                    }
                    
                    
                    if assess.examDone {
                        HStack {
                            Text("Result:")
                            NumberField(titleKey: "Marks", value: Binding{
                                assess.markAttained
                            }set:{ newValue in
                                assess.markAttained = newValue
                            })
                            Text("marks or")
                            NumberField(titleKey: "Percentage", value: Binding{
                                assess.percentage
                            }set:{ newValue in
                                assess.markAttained = newValue * assess.totalMarks / 100
                                
                            })
                            Text("%")
                            
                        }
                    } else {
                        DatePicker(
                            "Exam Date:",
                            selection: $assess.examDate,
                            displayedComponents: [.date]
                        )
                        
                        HStack {
                            Text("Have reminder?")
                            Toggle(isOn: $assess.haveReminder) {
                                Text("")
                            }
                        }
                        .onChange(of: assess.haveReminder) { oldValue, newValue in
                            if newValue {
                                print("schedule")
                                scheduleNotification(at: assess.reminder, body: "Your exam is on \(assess.examDate)", title: assess.name)
                            }
                        }
                        
                        if assess.haveReminder && NotificationSet {
                            DatePicker(
                                "Reminder:",
                                selection: $assess.reminder,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                        }
                    }
                }
                .lrb(themeSelect)
            }
            
            
            .navigationTitle($assess.name)
            
            
        }
}
#Preview{
    @Previewable @State var assessment = Assessment(name: "WA1", weightage: 10, totalMarks: 20, examDone: false, markAttained: 13, examDate: Date(),   haveReminder: true, reminder: Date())
    AssessmentDetailView(assess: $assessment)
}

