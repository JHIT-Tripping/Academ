import SwiftUI

struct NewSystemView: View{
    @State private var newSystem = GradeSystem(name: "", grades: [], type: .none)
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
                        NavigationLink{
                            GradeDetailView(grade: $grade)
                        }label: {
                            Text(grade.name)
                        }
                    }
                    Button{
                        showSheet = true
                    }label: {
                        HStack{
                            Image(systemName: "plus")
                            Text("Add a grade")
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
}
