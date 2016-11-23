import Foundation


struct TimeTracking : JSONSerializable {
    
    let projectId: Int
    let description: String
    let startTime: Date
    let endTime: Date
    let breakTime: Int?
}

extension TimeTracking: Equatable {
    
    static func == (lhs: TimeTracking, rhs: TimeTracking) -> Bool {
        return
            lhs.projectId == rhs.projectId
    }
    
    static func read(json: [String: Any]) -> TimeTracking {
        let projectId = json["projectId"] as! Int
        let description = json["description"] as! String
        let breakTime = json["breakTime"] as? Int
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        let startTime =  formatter.date(from: json["startTime"] as! String)!
        let endTime =  formatter.date(from: json["endTime"] as! String)!
        
        return TimeTracking(projectId: projectId, description: description, startTime: startTime, endTime: endTime, breakTime: breakTime)
    }
}
