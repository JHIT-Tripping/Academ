import Foundation
import Observation

@Observable class SubjectManager {
    var subjects: [Subject] = [
            Subject(name: "Mathematics", assessments: [
                Assessment(name: "WA1", weightage: 10, totalMarks: 20, examDone: true, markAttained: 12, examDate: Date(), haveReminder: false, reminder: Date()),
                Assessment(name: "WA2", weightage: 15, totalMarks: 30, examDone: true, markAttained: 23, examDate: Date(), haveReminder: false, reminder: Date()),
                Assessment(name: "WA3", weightage: 15, totalMarks: 45, examDone: true, markAttained: 37, examDate: Date(), haveReminder: false, reminder: Date()),
                Assessment(name: "EYE", weightage: 60, totalMarks: 120, examDone: false, markAttained: 93, examDate: Date(), haveReminder: true, reminder: Date())
            ], targetMark: 80, credits: 0, numOfAssessments: 4),
            Subject(name: "English", assessments: [Assessment(name: "WA1", weightage: 10, totalMarks: 30, examDone: true, markAttained: 23, examDate: Date(), haveReminder: false, reminder: Date())], targetMark: 75, credits: 0, numOfAssessments: 4),
            Subject(name: "Science", assessments: [Assessment(name: "WA1", weightage: 10, totalMarks: 10, examDone: true, markAttained: 8, examDate: Date(), haveReminder: false, reminder: Date())], targetMark: 75, credits: 0, numOfAssessments: 4),
            Subject(name: "History", assessments: [Assessment(name: "WA1", weightage: 10, totalMarks: 20, examDone: true, markAttained: 13, examDate: Date(), haveReminder: false, reminder: Date())], targetMark: 75, credits: 0, numOfAssessments: 4),
            Subject(name: "Geography", assessments: [Assessment(name: "WA1", weightage: 10, totalMarks: 40, examDone: true, markAttained: 31, examDate: Date(), haveReminder: false, reminder: Date())], targetMark: 75, credits: 0, numOfAssessments: 4)
        ] {
        didSet {
            save()
        }
    }
    
    init() {
        load()
    }
    
    private func getArchiveURL() -> URL {
        URL.documentsDirectory.appending(path: "subjects.json")
    }
    
    private func save() {
        let archiveURL = getArchiveURL()
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        let encodedSubjects = try? jsonEncoder.encode(subjects)
        try? encodedSubjects?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func load() {
        let archiveURL = getArchiveURL()
        let jsonDecoder = JSONDecoder()
        
        if let retrievedSubjectData = try? Data(contentsOf: archiveURL),
           let subjectsDecoded = try? jsonDecoder.decode([Subject].self, from: retrievedSubjectData) {
            subjects = subjectsDecoded
        }
    }
//    func export(){
//        
//    }
    func compute(isTarget: Bool, gradeType: GradeType, haveCredits: Bool, systemManager: SystemManager) -> Double {
        var gradePointArray: [Double] = []
        var creditArray: [Int] = []
        var weightedGradeSum: Double = 0
        var totalCredits: Int = 0
        var resultComputation: Double = 0.0
        
        // Iterate over subjects to populate grade points and credits
        for subject in subjects where subject.isCalculated {
            if haveCredits {
                creditArray.append(subject.credits)
            }
            
            let gradePoint = isTarget
            ? systemManager.gradePointCalculate(mark: subject.targetMark, customSys: subject.customSystem)
            : systemManager.gradePointCalculate(mark: subject.currentOverall(), customSys: subject.customSystem)
            
            gradePointArray.append(gradeType != .none ? gradePoint : (isTarget ? subject.targetMark : subject.currentOverall()))
        }
        
        // Calculate weighted or unweighted grade point average
        if haveCredits {
            for (grade, credit) in zip(gradePointArray, creditArray) {
                weightedGradeSum += grade * Double(credit)
            }
            totalCredits = creditArray.reduce(0, +)
            if gradeType == .GPA || gradeType == .MSG || gradeType == .none{
                resultComputation = totalCredits > 0 ? weightedGradeSum / Double(totalCredits) : 0.0
            }else{
                resultComputation = weightedGradeSum
            }
        } else {
            weightedGradeSum = gradePointArray.reduce(0, +)
            if gradeType == .GPA || gradeType == .MSG || gradeType == .none{
                resultComputation = gradePointArray.count > 0 ? weightedGradeSum / Double(gradePointArray.count) : 0.0
            }else{
                resultComputation = weightedGradeSum
            }
        }
        
        return resultComputation
    }
}
