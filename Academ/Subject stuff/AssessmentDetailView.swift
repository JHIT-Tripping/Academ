import SwiftUI

struct AssessmentDetailView: View {
    @Binding var assess: Assessment
    @State private var isDisplayed = false
    @State var NotificationSet =  true
    @State private var showAlert = false
    @AppStorage("themes") var themeSelect = "Default"
    let center = UNUserNotificationCenter.current()
    // all data has to be binding or else it would refresh
    func requestNotificationAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge, .provisional]) { granted, error in
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied")
            }
        }
    }
    
    
    
    func scheduleNotification(
        id: UUID,
        at date: Date,
        body: String,
        title: String
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body

        let components = Calendar.current.dateComponents(
            [.year, .month, .day],
            from: date
        )

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "assessment_reminder_\(id.uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
    
    var body: some View {
       // let _: () = Self._printChanges() 
        
            AForm {
                Section {
                    TextField("Name", text: $assess.name)
                    
                    HStack {
                        Text("Weightage:")
                        NumberField(titleKey: "Percentage", value: $assess.weightage)
                        Text("%")
                    }
                    
                    HStack {
                        Text("Total marks:")
                        NumberField(titleKey: "Marks", value: Binding{
                            assess.totalMarks
                        }set:{ newValue in
                            if newValue >= assess.markAttained, newValue > 0{
                                assess.totalMarks = newValue
                            }
                        })
                            
                    }
                    DatePicker(
                        "Exam Date:",
                        selection: $assess.examDate,
                        displayedComponents: [.date]
                    )
                    
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
                        
                        OptionalDatePicker(date: $assess.reminder, name: "reminder")
                            .onChange(of: assess.reminder) { _, newValue in

                                if let reminder = newValue {
                                    scheduleNotification(
                                        id: assess.id,
                                        at: reminder,
                                        body: "Your exam is on \(assess.examDate)",
                                        title: assess.name
                                    )
                                } else {
                                    UNUserNotificationCenter.current()
                                        .removePendingNotificationRequests(withIdentifiers: ["assessment_reminder_\(assess.id.uuidString)"])
                                }
                            }

                        
                    }
                }
                .lrb(themeSelect)
            }
            
            
            .navigationTitle($assess.name)
            
            
        }
}
#Preview{
    @Previewable @State var assessment = Assessment(name: "WA1", weightage: 10, totalMarks: 20, examDone: false, markAttained: 13, examDate: Date(), reminder: Date())
    AssessmentDetailView(assess: $assessment)
}

struct OptionalDatePicker: View {
    @Binding var date: Date?
    var name: String
    var body: some View {
        if let hasDate = date {
            HStack{
                DatePicker(
                    "\(name.capitalized):",
                    selection: Binding(get: {
                        hasDate
                    }, set: { value in
                        date = value
                    }),
                    displayedComponents: [.date, .hourAndMinute]
                )
                Button {
                    date = nil
                }label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundStyle(.red)
                }
                .buttonStyle(.plain)
            }
        } else {
            Button("Add \(name)", systemImage: "plus") {
                date = Date()
            }
        }
    }
}
