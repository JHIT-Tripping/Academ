//
//  SubjectManager.swift
//  Academ
//
//  Created by T Krobot on 18/11/23.
//

import Foundation
import SwiftUI

class SubjectManager: ObservableObject {
    @Published var subjects: [Subject] = [] {
        didSet {
            save()
        }
    }
    
    init() {
        load()
    }
    
    func compute(isTarget: Bool, userData: UserData, systemManager: SystemManager) -> Double {
        var gradePointArray: [Double] = []
        var creditArray: [Int] = []
        var weightedGradeSum: Double = 0
        var totalCredits: Int = 0
        var resultComputation: Double = 0.0
        
        // Iterate over subjects to populate grade points and credits
        for subject in subjects where subject.isCalculated {
            if userData.haveCredits {
                creditArray.append(subject.credits)
            }
            
            let gradePoint = isTarget
            ? systemManager.gradePointCalculate(mark: subject.targetMark, userData: userData, customSys: subject.customSystem)
            : systemManager.gradePointCalculate(mark: subject.currentOverall(), userData: userData, customSys: subject.customSystem)
            
            gradePointArray.append(userData.gradeType != .none ? gradePoint : (isTarget ? subject.targetMark : subject.currentOverall()))
        }
        
        // Calculate weighted or unweighted grade point average
        if userData.haveCredits {
            for (grade, credit) in zip(gradePointArray, creditArray) {
                weightedGradeSum += grade * Double(credit)
            }
            totalCredits = creditArray.reduce(0, +)
            if userData.gradeType == .GPA || userData.gradeType == .MSG{
                resultComputation = totalCredits > 0 ? weightedGradeSum / Double(totalCredits) : 0.0
            }else{
                resultComputation = weightedGradeSum
            }
        } else {
            weightedGradeSum = gradePointArray.reduce(0, +)
            if userData.gradeType == .GPA || userData.gradeType == .MSG{
                resultComputation = gradePointArray.count > 0 ? weightedGradeSum / Double(gradePointArray.count) : 0.0
            }else{
                resultComputation = weightedGradeSum
            }
        }
        
        return resultComputation
    }
    func getArchiveURL() -> URL {
        let plistName = "subjects.plist"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return documentsDirectory.appendingPathComponent(plistName)
    }
    
    func save() {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedSubjects = try? propertyListEncoder.encode(subjects)
        try? encodedSubjects?.write(to: archiveURL, options: .noFileProtection)
    }
    
    func load() {
        let archiveURL = getArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
        
        if let retrievedSubjectData = try? Data(contentsOf: archiveURL),
           let subjectsDecoded = try? propertyListDecoder.decode([Subject].self, from: retrievedSubjectData) {
            subjects = subjectsDecoded
        }
    }
}
