import Foundation

class UserInfoDataFetcher {
    
    func getData(response: @escaping (UserResponseWrapped?) -> Void) {
        getUserInfo { data, error in
            guard let data = data else { return }
            let decoded = self.decodeJSON(type: UserResponseWrapped.self, from: data)
            response(decoded)
        }
    }
    
    private func getUserInfo(completion: @escaping (Data?, Error?) -> Void) {
        guard let userId = AuthenticationService.shared.userId else { return }
        let params = ["user_ids" : userId, "fields" : "photo_100"]
        let url = url(urlParams: params, to: API.usersQuery)
        let request = URLRequest(url: url)
        
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }

    private func url(urlParams: [String : String], to path: String) -> URL {
        var components = URLComponents()
        
        var params = urlParams
        params["access_token"] = AuthenticationService.shared.token
        params["v"] = API.version
        
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        
        components.queryItems = params.map {  URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
    
    private func returnSourceName(sourseId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresenatable {
        let profilesOrGroups: [ProfileRepresenatable] = sourseId >= 0 ? profiles : groups
        let normalSourseId = sourseId >= 0 ? sourseId : -sourseId
        let profileRepresenatable = profilesOrGroups.first { (myProfileRepresenatable) -> Bool in
            myProfileRepresenatable.id == normalSourseId
        }
        return profileRepresenatable!
    }
    
    private func photoAttachments(feedItem: FeedItem) -> [NewsfeedViewModel.PhotoAttachment] {
        guard let attachments = feedItem.attachments else { return [] }
        
        return attachments.compactMap({ (attachment) -> NewsfeedViewModel.PhotoAttachment? in
            guard let photo = attachment.photo else { return nil }
            return NewsfeedViewModel.PhotoAttachment.init(
                photoUrlString: photo.srcBIG,
                width: photo.width,
                height: photo.height
            )
        })
    }
}
