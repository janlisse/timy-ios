import Alamofire


enum ApiError: Error {
    case JsonParsingError
}


class TimeTrackingStore {
    
    static let shared = TimeTrackingStore()
    
    func getTimeTrackings(completion: @escaping (Result<[TimeTracking]>) -> Void) {
        Alamofire.request("\(config().0)/timetracking", headers: ["Api-Key": config().1])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let timeTrackingJson = response.result.value as? [[String:AnyObject]] else {
                        completion(.failure(ApiError.JsonParsingError))
                        return
                    }
                    let times = timeTrackingJson.map({ p in TimeTracking.read(json: p ) })
                    completion(.success(times))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    
    func getProjects(completion: @escaping (Result<[Project]>) -> Void) {
        Alamofire.request("\(config().0)/projects", headers: ["Api-Key": config().1])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let projectsJson = response.result.value as? [Any] else {
                        completion(.failure(ApiError.JsonParsingError))
                        return
                    }
                    let projects = projectsJson.map({ p in Project.read(json: p as! [String : Any]) })
                    completion(.success(projects))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    func saveTimeTracking(timeTracking: TimeTracking, completion: @escaping  (Result<Any>) -> Void) {
        Alamofire.request("\(config().0)/timetracking", method: .post, parameters: timeTracking.toJsonMap(),
                          encoding: JSONEncoding.default, headers: ["Api-Key": config().1])
                 .validate(statusCode: 200..<300)
                 .responseJSON { response in
                        completion(response.result)
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
