
import Foundation

class FeedDataFetcher {

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMM 'в' HH:mm"
        
        return dateFormatter
    }()
    
    func getData(response: @escaping ([CellModel]?) -> Void) {
        
        Network.shared.getFeed { data, error in
            guard let data = data else { return }
            
            let decoded = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            
            var responseData = [CellModel]()
            var groups = [Group]()
            var users = [Profile]()
            
            let _ = decoded?.response.groups.map({ group in
                groups.append(group)
            })
            
            let _ = decoded?.response.profiles.map({ profile in
                users.append(profile)
            })
            
            let _ = decoded?.response.items.map({ [weak self] item in
                let profile = self?.returnSourceName(sourseId: item.sourceId, profiles: users, groups: groups)
                
                let date = Date(timeIntervalSince1970: item.date)
                let dateTime = self?.dateFormatter.string(from: date)
                
                let cellLayoutCalculator: PostCellContentLayoutCalculatorProtocol = PostCellContentLayoutCalculator()
                var photoAttachments = [CellModel.PostCellPhotoAttachment]()
                if let photos = self?.photoAttachments(feedItem: item) {
                    photoAttachments = photos
                }
                
                let sizes = cellLayoutCalculator.sizes(postText: item.text, photoAttachment: photoAttachments)                
                let cellItem = CellModel(iconUrlString: profile?.photo ?? "",
                                         sourceName: profile?.name ?? "Пользователь",
                                         date: dateTime ?? "",
                                         text: item.text,
                                         photoAttachements: photoAttachments,
                                         likes: String(item.likes?.count ?? 0),
                                         comments: String(item.comments?.count ?? 0),
                                         shares: String(item.reposts?.count ?? 0),
                                         views: String(item.views?.count ?? 0),
                                         sizes: sizes)
                
                responseData.append(cellItem)
            })
            
            response(responseData)
            
        }
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
    
    
    private func photoAttachments(feedItem: FeedItem) -> [CellModel.PostCellPhotoAttachment] {
        guard let attachments = feedItem.attachments else { return [] }
        
        return attachments.compactMap({ (attachments) -> CellModel.PostCellPhotoAttachment? in
            guard let photo = attachments.photo else { return nil }
            return CellModel.PostCellPhotoAttachment.init(photoUrlString: photo.srcBIG,
                                                          width: photo.width,
                                                          height: photo.height)
        })
    }
}
