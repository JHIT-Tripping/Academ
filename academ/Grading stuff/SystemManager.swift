//
//  SystemManager.swift
//  Academ
//
//  Created by T Krobot on 24/11/23.
//


import Foundation
import Observation

@Observable class SystemManager {
    var systems: [GradeSystem] = [] {
        didSet {
            save()
        }
    }
    
    init() {
        load()
    }
    
    private func getArchiveURL() -> URL {
        URL.documentsDirectory.appending(path: "systems.json")
    }
    func gradeCalculate(mark:Double,formatt:String, customSys: GradeSystem?)->String{
        var resultGrade = ""
        if let syst = customSys{
            for i in syst.grades{
                if mark >= i.minMark && mark <= i.maxMark{
                    resultGrade = i.name
                    break
                }
            }
        }else if !systems.isEmpty{
            for i in systems[0].grades{
                if mark >= i.minMark && mark <= i.maxMark{
                    resultGrade = i.name
                    break
                }
            }
        }else{
            resultGrade = "\(String(format:formatt,mark))%"
        }
        if resultGrade.isEmpty{
            resultGrade = String(format: "%.2f", mark)
        }
        return resultGrade
    }
    func gradePointCalculate(mark:Double, customSys: GradeSystem?)->Double{
        var resultGradePoint:Double = 0
        if let syst = customSys{
            for i in syst.grades{
                if mark >= i.minMark && mark <= i.maxMark{
                    resultGradePoint = i.gradePoint
                    break
                }
            }
        }else if !systems.isEmpty{
            for i in systems[0].grades{
                if mark >= i.minMark && mark <= i.maxMark{
                    resultGradePoint = i.gradePoint
                    break
                }
            }
        }
        return resultGradePoint
    }
    func gradeCalculateFromPoint(point:Double,formatt:String, customSys: GradeSystem?)->String{
        var resultGrade = ""
        if let syst = customSys{
            if !syst.grades.isEmpty{
                let ascending = syst.grades.first!.gradePoint < syst.grades.last!.gradePoint
                for i in syst.grades{
                    if (ascending && point <= i.gradePoint) || (!ascending && point >= i.gradePoint){
                        resultGrade = i.name
                        break
                    }
                }
            }
        }else if !systems.isEmpty{
            if !systems[0].grades.isEmpty{
                let ascending = systems[0].grades.first!.gradePoint < systems[0].grades.last!.gradePoint
                for i in systems[0].grades{
                    if (ascending && point <= i.gradePoint) || (!ascending && point >= i.gradePoint){
                        resultGrade = i.name
                        break
                    }
                }
            }
        }else{
            resultGrade = "\(String(format:formatt,point))%"
        }
        return resultGrade
    }
    private func save() {
        let archiveURL = getArchiveURL()
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        let encodedSystems = try? jsonEncoder.encode(systems)
        try? encodedSystems?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func load() {
        let archiveURL = getArchiveURL()
        let jsonDecoder = JSONDecoder()
        
        if let retrievedSystemData = try? Data(contentsOf: archiveURL),
           let systemsDecoded = try? jsonDecoder.decode([GradeSystem].self, from: retrievedSystemData) {
            systems = systemsDecoded
        }
    }
}
