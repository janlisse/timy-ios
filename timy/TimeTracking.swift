import Foundation


struct TimeTracking : JSONSerializable {
    
    let projectId: Int
    let description: String
    let startTime: Date
    let endTime: Date
    let breakTime: Int?
}
