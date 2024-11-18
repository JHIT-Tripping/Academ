//
//  Model.swift
//  Academ
//
//  Created by T Krobot on 18/11/23.
//

import Foundation
import SwiftUI

struct Assessment: Identifiable, Codable, Hashable{
    var id = UUID()
    var name: String
    var weightage: Double
    var totalMarks: Double
    var examDone: Bool
    var markAttained: Double
    var examDate: Date
    var haveReminder: Bool
    var reminder: Date
    var percentage: Double{
        return markAttained/totalMarks*100
    }
}
struct Subject: Identifiable, Codable, Equatable{
    var id = UUID()
    var name: String
    var assessments: [Assessment]
    var targetMark: Double
    // var hasGoal: Bool
    var credits: Int
    var numOfAssessments: Int
    //    var isHMT = false
    var isFoundation = false
    var isMTSB = false
    var isCalculated = true
    var customSystem: GradeSystem?
//    func assessmentArray(type:Int)->[Double]{
//        var numArray:[Double] = []
//        for i in assessments{
//            if i.examDone{
//                if type == 0{
//                    numArray.append(i.totalMarks) // maximum number of marks
//                }else if type == 1{
//                    numArray.append(i.markAttained) // number of marks attained
//                }else if type == 2{
//                    numArray.append(i.weightage) // weightage
//                }
//            }else{
//                if type == 3{
//                    numArray.append(i.totalMarks)
//                }
//            }
//        }
//        return numArray
//    }//gets a value from the assessments array (type 0 is totalMarks for done assessments, 1 is marksAttained, 2 is weightage, 3 is totalMarks for not done exams) deprecated in v2
    func arrayPercentage()->[Double]{
        let amountArray = assessments.map{$0.markAttained} // marks attained
        let totaledArray = assessments.map{$0.totalMarks} // max marks
        var percentageArray:[Double] = []
        for i in 0..<amountArray.count{
            percentageArray.append(percentage(amount: amountArray[i], total: totaledArray[i]))
        }
        return percentageArray
    }//calculates percentage and puts it in an array
    func highest()->Double{
        let doubleArray = arrayPercentage()
        var high:Double=0
        for i in doubleArray{
            if i > high{
                high=i
            }
        }
        return high
    }//finds the highest value in an array
    /*func average()->Double{
     let doubleArray = arrayPercentage()
     var sum:Double = 0
     for i in doubleArray{
     sum+=i
     }
     sum/=Double(doubleArray.count)
     return sum
     
     }*///finds the average of doubles in an array (deprecated)
    func currentOverall() -> Double {
        let examWeightages = assessments.map { $0.weightage }
        let arrayPercentages = arrayPercentage()
        
        guard !examWeightages.isEmpty && examWeightages.count == arrayPercentages.count else {
            // Handle the case where either examPercentages is empty or its count is different from arrayPercentages count.
            return 0.0
        }
        
        var total: Double = 0
        
        for i in examWeightages.indices {
            total += examWeightages[i] * arrayPercentages[i]
        }
        
        let totalExamPercentages = examWeightages.reduce(0, +)
        return totalExamPercentages != 0 ? total / totalExamPercentages : 0.0
        
        
    }//finds the current overall based on the percentage
    func weightedGoal()->Double{
        var percentageSum:Double=0
        for i in 0..<arrayPercentage().count{
            percentageSum+=arrayPercentage()[i]/100*assessments.map{$0.weightage}[i]
        }
        var valueSum:Double = 0
        for i in assessments.map({$0.weightage}){
            valueSum+=i
        }
        valueSum=100-valueSum
        let sum = (targetMark-percentageSum)/valueSum*100
        return sum
    }//finds the percentage needed to achieve the goal
    func checkIfSubjectGradeExceeds100() -> Double{
        
        var finalGradeForSubject:Double = 0.0
        // var exceeds100 = false
        for test in  (assessments) {
            finalGradeForSubject += test.weightage
            
            //        if finalGradeForSubject >= 100.0 {
            //             exceeds100 = true
            //         }
        }
        return finalGradeForSubject
    }//pretty self explanatory
    func getUnfinishedAssessments()->[Assessment]{
        var unfinishedArray:[Assessment]=[]
        for i in assessments{
            if !i.examDone{
                unfinishedArray.append(i)
            }
        }
        return unfinishedArray
    }
}
struct GradeSystem: Codable, Identifiable, Equatable, Hashable{
    var id = UUID()
    var name: String
    var grades: [Grade]
    var type: GradeType
}
struct Grade: Codable, Identifiable, Equatable, Hashable{
    var id = UUID()
    var name: String
    var minMark: Double
    var maxMark: Double
    var gradePoint: Double
}
var defaultSystems = [
    [
    GradeSystem(name: "GPA", grades: [
        Grade(name: "A+", minMark: 80, maxMark: 100, gradePoint: 4.0),
        Grade(name: "A", minMark: 70, maxMark: 79, gradePoint: 3.6),
        Grade(name: "B+", minMark: 65, maxMark: 69, gradePoint: 3.2),
        Grade(name: "B", minMark: 60, maxMark: 64, gradePoint: 2.8),
        Grade(name: "C+", minMark: 55, maxMark: 59, gradePoint: 2.4),
        Grade(name: "C", minMark: 50, maxMark: 54, gradePoint: 2.0),
        Grade(name: "D", minMark: 45, maxMark: 49, gradePoint: 1.6),
        Grade(name: "E", minMark: 40, maxMark: 44, gradePoint: 1.2),
        Grade(name: "F", minMark: 0, maxMark: 39, gradePoint: 0.8)
    ], type: .GPA)], //gpa for rgs
    [GradeSystem(name: "MSG", grades: [
        Grade(name: "A1", minMark: 75, maxMark: 100, gradePoint: 1.0),
        Grade(name: "A2", minMark: 70, maxMark: 74, gradePoint: 2.0),
        Grade(name: "B3", minMark: 65, maxMark: 69, gradePoint: 3.0),
        Grade(name: "B4", minMark: 60, maxMark: 64, gradePoint: 4.0),
        Grade(name: "C5", minMark: 55, maxMark: 59, gradePoint: 5.0),
        Grade(name: "C6", minMark: 50, maxMark: 54, gradePoint: 6.0),
        Grade(name: "D7", minMark: 45, maxMark: 49, gradePoint: 7.0),
        Grade(name: "E8", minMark: 40, maxMark: 44, gradePoint: 8.0),
        Grade(name: "F9", minMark: 0, maxMark: 39, gradePoint: 9.0),
    ], type: .MSG),
     GradeSystem(name: "MAG", grades: [
        Grade(name: "A", minMark: 70, maxMark: 100, gradePoint: 1.0),
        Grade(name: "B", minMark: 60, maxMark: 69, gradePoint: 3.0),
        Grade(name: "C", minMark: 50, maxMark: 59, gradePoint: 5.0),
        Grade(name: "D", minMark: 45, maxMark: 49, gradePoint: 7.0),
        Grade(name: "E", minMark: 40, maxMark: 44, gradePoint: 8.0),
        Grade(name: "F", minMark: 0, maxMark: 39, gradePoint: 9.0)], type: .MSG)],// MSG
    [GradeSystem(name: "AL", grades: [
        Grade(name: "AL1", minMark: 90, maxMark: 100, gradePoint: 1.0),
        Grade(name: "AL2", minMark: 85, maxMark: 89, gradePoint: 2.0),
        Grade(name: "AL3", minMark: 80, maxMark: 84, gradePoint: 3.0),
        Grade(name: "AL4", minMark: 75, maxMark: 79, gradePoint: 4.0),
        Grade(name: "AL5", minMark: 65, maxMark: 74, gradePoint: 5.0),
        Grade(name: "AL6", minMark: 45, maxMark: 64, gradePoint: 6.0),
        Grade(name: "AL7", minMark: 20, maxMark: 44, gradePoint: 7.0),
        Grade(name: "AL8", minMark: 0, maxMark: 19, gradePoint: 8.0),
    ], type: .AL),
     GradeSystem(name: "AL (Foundation)", grades: [
        Grade(name: "AL A", minMark: 75, maxMark: 100, gradePoint: 7.0),
        Grade(name: "AL B", minMark: 30, maxMark: 74, gradePoint: 8.0),
        Grade(name: "AL C", minMark: 0, maxMark: 29, gradePoint: 9.0)
     ], type: .AL)],// AL
//    [GradeSystem(name:"Overall Grade", grades: [
//        Grade(name: "A1", minMark: 75, maxMark: 100, gradePoint: 1.0),
//        Grade(name: "A2", minMark: 70, maxMark: 74, gradePoint: 1.0),
//        Grade(name: "B3", minMark: 65, maxMark: 69, gradePoint: 2.0),
//        Grade(name: "B4", minMark: 60, maxMark: 64, gradePoint: 2.0),
//        Grade(name: "C5", minMark: 55, maxMark: 59, gradePoint: 3.0),
//        Grade(name: "C6", minMark: 50, maxMark: 54, gradePoint: 3.0),
//        Grade(name: "D7", minMark: 45, maxMark: 49, gradePoint: 4.0),
//        Grade(name: "E8", minMark: 40, maxMark: 44, gradePoint: 5.0),
//        Grade(name: "F9", minMark: 0, maxMark: 40, gradePoint: 5.0),
//    ], type: .overallGrade)],// Overall grade (1 is distinction, 2 is merit, 3 is credit, 4 is sub-pass and 5 is fail for grade points)
    [GradeSystem(name: "N(A)", grades: [
        Grade(name: "1", minMark: 75, maxMark: 100, gradePoint: 1.0),
        Grade(name: "2", minMark: 70, maxMark: 74, gradePoint: 2.0),
        Grade(name: "3", minMark: 65, maxMark: 69, gradePoint: 3.0),
        Grade(name: "4", minMark: 60, maxMark: 64, gradePoint: 4.0),
        Grade(name: "5", minMark: 50, maxMark: 59, gradePoint: 5.0),
        Grade(name: "6", minMark: 0, maxMark: 49, gradePoint: 6.0),
    ], type: .NA)],//N(A) levels grades (no grade point)
    [GradeSystem(name:"N(T)", grades: [
        Grade(name: "A", minMark: 70, maxMark: 100, gradePoint: 1.0),
        Grade(name: "B", minMark: 65, maxMark: 69, gradePoint: 2.0),
        Grade(name: "C", minMark: 60, maxMark: 64, gradePoint: 3.0),
        Grade(name: "D", minMark: 50, maxMark: 59, gradePoint: 4.0),
        Grade(name: "U", minMark: 0, maxMark: 49, gradePoint: 5.0),
    ], type: .NT)],// N(T) levels grades (no grade point)
    [GradeSystem(name:"O Levels", grades: [
        Grade(name: "A1", minMark: 75, maxMark: 100, gradePoint: 1.0),
        Grade(name: "A2", minMark: 70, maxMark: 74, gradePoint: 2.0),
        Grade(name: "B3", minMark: 65, maxMark: 69, gradePoint: 3.0),
        Grade(name: "B4", minMark: 60, maxMark: 64, gradePoint: 4.0),
        Grade(name: "C5", minMark: 55, maxMark: 59, gradePoint: 5.0),
        Grade(name: "C6", minMark: 50, maxMark: 54, gradePoint: 6.0),
        Grade(name: "D7", minMark: 45, maxMark: 49, gradePoint: 7.0),
        Grade(name: "E8", minMark: 40, maxMark: 44, gradePoint: 8.0),
        Grade(name: "F9", minMark: 0, maxMark: 40, gradePoint: 9.0)
    ], type: .OLevel)],// O levels grades (no grade point)
    [GradeSystem(name: "IB", grades: [
        Grade(name: "7", minMark: 85, maxMark: 100, gradePoint: 7),
        Grade(name: "6", minMark: 69, maxMark: 85, gradePoint: 6),
        Grade(name: "5", minMark: 56, maxMark: 68, gradePoint: 5),
        Grade(name: "4", minMark: 39, maxMark: 55, gradePoint: 4),
        Grade(name: "3", minMark: 28, maxMark: 38, gradePoint: 3),
        Grade(name: "2", minMark: 16, maxMark: 27, gradePoint: 2),
        Grade(name: "1", minMark: 0, maxMark: 15, gradePoint: 1)
    ], type: .IB)]
]
enum GradeType: String, CaseIterable, Codable{
    case none = "Default"
    case GPA = "GPA"
    case MSG = "MSG"
    case AL = "AL"
    case NA = "N(A)"
    case NT = "N(T)"
    case OLevel = "O Levels"
    case IB = "IB"
}

func percentage(amount:Double,total:Double)->Double{
    return amount/total*100
}

struct themeColors: Identifiable{
    var id = UUID()
    var themeName: String
    var mainColor : [Color]
    var secondColor : Color
    var LightMode : Bool
}

//var HMT = GradeSystem(name: "hmt", grades: [
//    Grade(name: "Distinction", minMark: 80, maxMark: 100, gradePoint: 0.0),
//    Grade(name: "Merit", minMark: 65, maxMark: 79, gradePoint: 0.0),
//    //tbc
//])
