import Alamofire


class TimeTrackingStore {
    
    static let shared = TimeTrackingStore()
    
    
    func getTimeTrackings(completion: @escaping ([TimeTracking]) -> Void) {
        Alamofire.request("\(config().0)/timetracking", headers: ["Api-Key": config().1])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(response.result.error)")
                    completion([TimeTracking]())
                    return
                }
                guard let timeTrackingJson = response.result.value as? [[String:AnyObject]] else {
                    print("Invalid Json received from service")
                    completion([TimeTracking]())
                    return
                }
                let times = timeTrackingJson.map({ p in TimeTracking.read(json: p as! [String : AnyObject]) })
                completion(times)
        }

    }
    
    
    func getProjects(completion: @escaping ([Project]) -> Void) {
        Alamofire.request("\(config().0)/projects", headers: ["Api-Key": config().1])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(response.result.error)")
                    completion([Project]())
                    return
                }
                guard let projectsJson = response.result.value as? [Any] else {
                    print("Invalid tag information received from service")
                    completion([Project]())
                    return
                }
                let projects = projectsJson.map({ p in Project.read(json: p as! [String : Any]) })
                completion(projects)
        }
    }
    
    func saveTimeTracking(timeTracking: TimeTracking, completion: @escaping  (Bool) -> Void) {
        Alamofire.request("\(config().0)/timetracking", method: .post, parameters: timeTracking.toJsonMap(),
                          encoding: JSONEncoding.default, headers: ["Api-Key": config().1])
            .responseData { response in
                print(NSString(data: (response.request?.httpBody)!, encoding: String.Encoding.utf8.rawValue))
                if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
            }
            .responseJSON { response in
                completion(response.result.isSuccess)
        }
    }
    
    func config() -> (String, String) {
        guard let serverUrl = TimyData.shared.loadServerUrl()?.absoluteString else {
                print("Error, server url not configured")
                return ("foo","bar")
        }
        guard let apiKey = TimyData.shared.loadApiKey() else {
                print("Error, api key not configured")
                return ("foo","bar")
        }
        return (serverUrl, apiKey)
    }
    
}
