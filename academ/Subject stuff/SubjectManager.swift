import Foundation
import Observation

@Observable class SubjectManager {
    var subjects: [Subject] = [] {
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
            if gradeType == .GPA || gradeType == .MSG{
                resultComputation = totalCredits > 0 ? weightedGradeSum / Double(totalCredits) : 0.0
            }else{
                resultComputation = weightedGradeSum
            }
        } else {
            weightedGradeSum = gradePointArray.reduce(0, +)
            if gradeType == .GPA || gradeType == .MSG{
                resultComputation = gradePointArray.count > 0 ? weightedGradeSum / Double(gradePointArray.count) : 0.0
            }else{
                resultComputation = weightedGradeSum
            }
        }
        
        return resultComputation
    }
}
