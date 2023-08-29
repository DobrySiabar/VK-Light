import UIKit

enum Newsfeed {
    enum Model {
        struct Request {
            enum RequestType {
                case getNewsfeed
                case getUser
                case revealPostIds(postId: Int)
                case getNextBatch
            }
        }
        struct Response {
            enum ResponseType {
                case presentNewsfeed(newsfeed: FeedResponse, revealdedPostIds: [Int])
                case presentUserInfo(user: UserResponse?)
                case presentFooterLoader
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayNewsfeed(newsfeedViewModel: NewsfeedViewModel)
                case displayUser(userViewModel: UserViewModel)
                case displayFooterLoader
            }
        }
    }
}

struct UserViewModel: TitleViewViewModel {
  var photoUrlString: String?
}

struct NewsfeedViewModel {
  struct Cell: NewsfeedCellViewModel {
      var postId: Int
      var iconUrlString: String
      var name: String
      var date: String
      var text: String?
      var likes: String?
      var comments: String?
      var shares: String?
      var views: String?
      var photoAttachements: [NewsfeedCellPhotoAttachementViewModel]
      var sizes: NewsfeedCellSizes
  }
  
   struct PhotoAttachment: NewsfeedCellPhotoAttachementViewModel {
      var photoUrlString: String?
      var width: Int
      var height: Int
  }
  let cells: [Cell]
  let footerTitle: String?
}
