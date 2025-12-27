import SwiftUI

struct AssessmentDetailView: View {
    @Binding var assess: Assessment
    @State private var isDisplayed = false
    @State var NotificationSet =  true
    @ObservedObject var userData: UserData
    @State private var showAlert = false
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
        NavigationStack{
            Form{
                Section{
                    TextField("Name",text: $assess.name)
                    //TextField()
                    HStack{
                        Text("Weightage:")
                        TextField("Percentage", value: $assess.weightage, formatter: formatter)
                        Text("%")
                        
                        
                    }
                    //                    HStack {
                    //                        Text("Total marks:")
                    //                        TextField("Marks", value: $assess.totalMarks, formatter: NumberFormatter())
                    //
                    //                    }
                    HStack {
                        Text("Total marks:")
                        TextField("Marks", value: $assess.totalMarks, formatter: formatter)
                            .onChange(of: assess.totalMarks) { oldValue, newValue in
                                if let value = Double?(newValue), value < assess.markAttained || value <= 0 {
                                    
                                    assess.totalMarks = oldValue
                                    //     .foregroundColor(.red)
                                }
                            }
                    }
                    
                    HStack{
                        Text("Exam done?")
                        Toggle(isOn: $assess.examDone){
                            Text("")
                        }
                        
                    }
                    if assess.examDone {
                        HStack{
                            Text("Marks attained:")
                            TextField("Marks", value: $assess.markAttained, formatter: formatter)
                            //Text($totaledMarks)
                        }
                    } else{
                        
                        DatePicker(
                            "Exam Date:",
                            selection: $assess.examDate,
                            displayedComponents: [.date]
                        )
                        HStack{
                            Text("Have reminder?")
                            Toggle(isOn: $assess.haveReminder){
                                Text("")
                            }
                        }
                        .onChange(of: assess.haveReminder) {
                            //                        requestNotificationAuthorization()
                            scheduleNotification(at: assess.reminder, body: "Your exam is on \(assess.examDate)", title: assess.name)
                        }
                        if assess.haveReminder && NotificationSet{
                            DatePicker("Reminder:",selection: $assess.reminder,displayedComponents: [.date, .hourAndMinute])
                            //    requestNotificationAuthorization()
                        }
                    } // else bracket
                }
                .listRowBackground(userData.themelists[userData.colorSelect].secondColor)
            }
            .background(.linearGradient(colors: userData.themelists[userData.colorSelect].mainColor, startPoint: .top, endPoint: .bottom))
            .scrollContentBackground(.hidden)
            .navigationTitle($assess.name)
            //            .background(.green)
            //            .scrollContentBackground(.hidden)
            
        }
    }
}
struct AssessmentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        AssessmentDetailView(assess: .constant(Assessment(name: "WA1", weightage: 10, totalMarks: 20, examDone: false, markAttained: 13, examDate: Date(),   haveReminder: true, reminder: Date())),userData: UserData())
            .environmentObject(SubjectManager())
        
    }
}
