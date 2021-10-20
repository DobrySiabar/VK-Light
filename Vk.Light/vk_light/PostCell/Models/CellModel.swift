
import Foundation

struct CellModel: PostCellViewModel {
    var iconUrlString: String
    var sourceName: String
    var date: String
    var text: String?
    var photoAttachements: [PostCellPhotoAttachementViewModel]
    var likes: String?
    var comments: String?
    var shares: String?
    var views: String?
    var sizes: PostCellContentSizes
    var isRevealed = false
    
    struct PostCellPhotoAttachment: PostCellPhotoAttachementViewModel {
       var photoUrlString: String?
       var width: Int
       var height: Int
   }
}
