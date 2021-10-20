
import UIKit

protocol PostCellViewModel {
    var iconUrlString: String { get }
    var sourceName: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    var photoAttachements: [PostCellPhotoAttachementViewModel] { get }
    var sizes: PostCellContentSizes { get }
}

protocol PostCellContentSizes {
    var topLabelSize: CGSize { get }
    var textLabelSize: CGSize { get }
    var minifiedTextLabelSize: CGSize? { get }
    var attachmentSize: CGSize { get }
    var bottomViewSize: CGSize { get }
    var minifiedHeight: CGFloat? { get }
    var totalHeight: CGFloat { get }
}

protocol PostCellPhotoAttachementViewModel {
    var photoUrlString: String? { get }
    var width: Int { get }
    var height: Int { get }
}

struct Sizes: PostCellContentSizes {
    var topLabelSize: CGSize
    var textLabelSize: CGSize
    var minifiedTextLabelSize: CGSize?
    var attachmentSize: CGSize
    var bottomViewSize: CGSize
    var minifiedHeight: CGFloat?
    var totalHeight: CGFloat
}

protocol PostCellContentLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachment: [PostCellPhotoAttachementViewModel]) -> PostCellContentSizes
}

final class PostCellContentLayoutCalculator: PostCellContentLayoutCalculatorProtocol {
    
    let postLabelFont = PostCell.textFont
    let recommendedButtonSize = CGSize(width: 170, height: 30)
    
    // Максимальное количество линий текста в посте
    let postLimitLines: CGFloat = 8
    let minifiedpPostLines: CGFloat = 6

    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }

    func sizes(postText: String?, photoAttachment: [PostCellPhotoAttachementViewModel]) -> PostCellContentSizes {
        
        let topViewHeight = PostCell.topViewHeight
        let bottomViewHeight = PostCell.bottomViewHeight

        // размер экрана устройства
        let screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        // Изначальная позиция вставки
        let cardInsets = UIEdgeInsets(top: 0, left: 8, bottom: 4, right: 8)
        // Ширина фрейма ячейки
        let postViewWidth = screenWidth - cardInsets.left - cardInsets.right

        // Расчет всех frame
        let topLabelSize = CGSize(width: postViewWidth, height: topViewHeight)
        var textLabelSize = CGSize(width: 0, height: 0)
        var minifiedTextLabelSize: CGSize?
        var attachmentSize = CGSize(width: 0, height: 0)
        var bottomViewSize = CGSize(width: postViewWidth, height: bottomViewHeight)
        
        // MARK: Работа с text frame size
        if let text = postText, !text.isEmpty {
            let width = postViewWidth - 16
            var height = text.height(width: width, font: postLabelFont)
            
            let limitedHeight = postLabelFont.lineHeight * postLimitLines
            
            textLabelSize = CGSize(width: width, height: height)
            
            if height > limitedHeight {
                height = postLabelFont.lineHeight * minifiedpPostLines
                minifiedTextLabelSize = CGSize(width: width, height: height)
            }
        }
        
        // MARK: Работа с attachment frame size
        if let attachment = photoAttachment.first {
            let photoHeight: Float = Float(attachment.height)
            let photoWidth: Float = Float(attachment.width)
            let ratio = CGFloat(photoHeight / photoWidth)
            
            attachmentSize = CGSize(width: postViewWidth, height: postViewWidth * ratio)
        }

        // MARK: Работа с bottom frame size
        bottomViewSize = CGSize(width: postViewWidth, height: bottomViewHeight)

        // MARK: Работа с totalHeight
        let totalHeight = topViewHeight + textLabelSize.height + attachmentSize.height + bottomViewHeight

        var minifiedHeight: CGFloat?
        if minifiedTextLabelSize != nil  {
            minifiedHeight = topViewHeight + minifiedTextLabelSize!.height + attachmentSize.height + bottomViewHeight + PostCell.moreTextButtonSize.height
        }

        return Sizes(topLabelSize: topLabelSize,
                     textLabelSize: textLabelSize,
                     minifiedTextLabelSize: minifiedTextLabelSize,
                     attachmentSize: attachmentSize,
                     bottomViewSize: bottomViewSize,
                     minifiedHeight: minifiedHeight,
                     totalHeight: totalHeight)
        
    }
    

}
