
import Foundation

final class Network {
    
    let scheme = "https"
    let host = "api.vk.com"
    let version = "5.131"
    let newsfeedQuery = "/method/newsfeed.get"
    let usersQuery = "/method/users.get"
    let wallQuery = "/method/wall.get"

    static let shared = Network()
    
    func getFeed(compliton: @escaping (Data?, Error?) -> Void) {
        
        let params = ["filters" : "post,photo"]
        let url = url(urlParams: params, to: newsfeedQuery)
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, compliton: compliton)
        task.resume()
    }
    
    func getUserInfo(compliton: @escaping (Data?, Error?) -> Void) {
        
        guard let userId = AuthenticationService.shared.userId else { return }
        
        let params = ["user_ids" : userId, "fields" : "photo_100"]
        let url = url(urlParams: params, to: usersQuery)
        let request = URLRequest(url: url)
        
        let task = createDataTask(from: request, compliton: compliton)
        task.resume()
    }
    
    func getWallUser(compliton: @escaping (Data?, Error?) -> Void) {
        
        guard let userId = AuthenticationService.shared.userId else { print("INVALID USER ID"); return }
        let params = ["owner_id" : userId, "filter" : "all"]
        let url = url(urlParams: params, to: wallQuery)
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, compliton: compliton)
        task.resume()
    }
    
    func request() {
        
    }
    
    private func createDataTask(from request: URLRequest, compliton: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                compliton(data, error)
            }
        }
    }
    
    private func url(urlParams: [String : String], to path: String) -> URL {
        guard let token = AuthenticationService.shared.token else { return URL(fileURLWithPath: "") }
        var components = URLComponents()
        
        var params = urlParams
        params["access_token"] = token
        params["v"] = version
        
        components.scheme = scheme
        components.host = host
        components.path = path
        
        components.queryItems = params.map {  URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
}
