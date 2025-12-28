import SwiftUI

struct SystemDetailView: View {
    @Binding var system: GradeSystem
    @AppStorage("themes") var themeSelect = "Default"
    @State private var showSheet = false
    var body: some View {
        //        if let index = systemmanager.systems.firstIndex(where: { $0 == system }) {
        NavigationStack {
            AForm {
                Section("Info") {
                    HStack{
                        Text("Name:")
                        TextField("Enter", text: $system.name)
                    }
                }
                .lrb(themeSelect)
                
                Section("Grades"){
                    
                    ForEach($system.grades, editActions: .delete){$grade in
                        if grade == system.grades.last{
                            Button{
                                system.grades.insert(Grade(name: "", minMark: 0, maxMark: system.grades[system.grades.count - 2].minMark-1, gradePoint: 0), at: system.grades.count - 1)
                            }label: {
                                HStack{
                                    Image(systemName: "plus")
                                    Text("Add a grade")
                                }
                            }
                            .deleteDisabled(true)
                        }
                        HStack{
                            Text("")
                            TextField("Name", text: $grade.name)
                            NumberField(titleKey: "Min", value:  $grade.minMark, disabled: grade == system.grades.last)
                                .onChange(of: grade.minMark) { oldValue, newValue in
                                    let ourIndex = system.grades.firstIndex(of: grade) ?? 0
                                    if system.grades[ourIndex + 1].maxMark != grade.minMark-1{
                                        system.grades[ourIndex + 1].maxMark = grade.minMark-1
                                    }
                                }
                            Text("to")
                            NumberField(titleKey: "Max", value:  $grade.maxMark, disabled: true)
                            Text("Pts:")
                            NumberField(titleKey: "Num", value:  $grade.gradePoint)
                        }
                        .deleteDisabled(grade == system.grades.first || grade == system.grades.last)
                    }
                    .onDelete { offsets in
                        system.grades.remove(atOffsets: offsets)
                        for index in system.grades.indices {
                            if index != 0{
                                if system.grades[index].maxMark != system.grades[index - 1].minMark - 1{
                                    system.grades[index].maxMark = system.grades[index - 1].minMark - 1
                                }
                            }
                        }
                    }
                    
                }
                .lrb(themeSelect)
                .sheet(isPresented: $showSheet){
                    NewGradeView(system: $system)
                }
            }
            .navigationTitle(system.name)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            
        }
        //        }
    }
}
struct NumberField: View {
    var titleKey: LocalizedStringKey
    @Binding var value: Double
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    @AppStorage("themes") var themeSelect = "Default"
    var disabled: Bool?
    var body: some View {
        TextField(titleKey, value: $value, formatter: formatter)
            .padding(5)
            .background(.primary.opacity(disabled ?? false ? 0 : 0.1))
            .mask(RoundedRectangle(cornerRadius: 10))
            .disabled(disabled ?? false)
    }
}
#Preview {
    @Previewable @State var system = GradeSystem(name: "MSG", grades: [
        Grade(name: "A1", minMark: 75, maxMark: 100, gradePoint: 1.0),
        Grade(name: "A2", minMark: 70, maxMark: 74, gradePoint: 2.0),
        Grade(name: "B3", minMark: 65, maxMark: 69, gradePoint: 3.0),
        Grade(name: "B4", minMark: 60, maxMark: 64, gradePoint: 4.0),
        Grade(name: "C5", minMark: 55, maxMark: 59, gradePoint: 5.0),
        Grade(name: "C6", minMark: 50, maxMark: 54, gradePoint: 6.0),
        Grade(name: "D7", minMark: 45, maxMark: 49, gradePoint: 7.0),
        Grade(name: "E8", minMark: 40, maxMark: 44, gradePoint: 8.0),
        Grade(name: "F9", minMark: 0, maxMark: 39, gradePoint: 9.0),
    ], type: .MSG)
    SystemDetailView(
        system: $system
    )
}
