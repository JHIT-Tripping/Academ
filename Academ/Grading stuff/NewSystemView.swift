import SwiftUI

struct NewSystemView: View{
    @State private var newSystem = GradeSystem(name: "", grades: [
        Grade(name: "", minMark: 50, maxMark: 100, gradePoint: 1),
        Grade(name: "", minMark: 0, maxMark: 49, gradePoint: 0)
    ], type: .none)
    @Environment(\.dismiss) var dismiss
    @Environment(SystemManager.self) var systemmanager: SystemManager
    @AppStorage("themes") var themeSelect = "Default"
    @AppStorage("gradeType") var gradeType = GradeType.none
    @State private var showSheet = false
    var body: some View{
        let _: () = Self._printChanges() 
        NavigationStack{
            AForm{
                Section("Info"){
                    TextField("Name", text: $newSystem.name)
                }
                .lrb(themeSelect)
                Section("Grades"){
                    List($newSystem.grades){$grade in
                        if grade == newSystem.grades.last{
                            Button{
                                newSystem.grades.insert(Grade(name: "", minMark: 0, maxMark: newSystem.grades[newSystem.grades.count - 2].minMark-1, gradePoint: 0), at: newSystem.grades.count - 1)
                            }label: {
                                HStack{
                                    Image(systemName: "plus")
                                    Text("Add a grade")
                                }
                            }
                        }
                        HStack{
                            Text("")
                            TextField("Name", text: $grade.name)
                            NumberField(titleKey: "Min", value:  $grade.minMark, disabled: grade == newSystem.grades.last)
                                .onChange(of: grade.minMark) { oldValue, newValue in
                                    let ourIndex = newSystem.grades.firstIndex(of: grade) ?? 0
                                    if newSystem.grades[ourIndex + 1].maxMark != grade.minMark-1{
                                        newSystem.grades[ourIndex + 1].maxMark = grade.minMark-1
                                    }
                                }
                            Text("to")
                            NumberField(titleKey: "Max", value:  $grade.maxMark, disabled: true)
                            Text("Pts:")
                            NumberField(titleKey: "Num", value:  $grade.gradePoint)
                        }
                    }
                    
                }
                .lrb(themeSelect)
                .sheet(isPresented: $showSheet){
                    NewGradeView(system: $newSystem)
                }
                Section{
                    Button("Save"){
                        systemmanager.systems.append(newSystem)
                        dismiss()
                    }
                    Button("Cancel", role: .destructive){
                        dismiss()
                    }
                }
                .lrb(themeSelect)
            }
            
            
            .onAppear(){
                newSystem.type = gradeType
            }
        }
    }
}
#Preview{
    NewSystemView()
        .environment(SystemManager())
}
