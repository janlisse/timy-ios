
struct Project : JSONSerializable {
    
    let projectId: Int
    let number: String
    let description: String
}

extension Project: Equatable {
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        return
            lhs.projectId == rhs.projectId
    }
    
    static func read(json: [String: Any]) -> Project {
        let number = json["number"] as? String
        let description = json["description"] as? String
        return Project(projectId: 1, number: number!, description: description!)
    }
}

