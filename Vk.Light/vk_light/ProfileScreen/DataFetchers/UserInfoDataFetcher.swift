
import Foundation

class UserInfoDataFetcher {

    func getData(response: @escaping (UserResponseWrapped?) -> Void) {
        Network.shared.getUserInfo { data, error in
            guard let data = data else { return }
            let decoded = self.decodeJSON(type: UserResponseWrapped.self, from: data)
            response(decoded)
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
