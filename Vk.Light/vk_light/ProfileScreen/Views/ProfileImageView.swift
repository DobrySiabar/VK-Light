
import UIKit

final class ProfileImageView: UIImageView {
    
    // MARK: - Value Types
    enum BorderShape: String {
        case circle
        case squircle
        case none
    }
    
    override var image: UIImage? {
        didSet {
            setupBorderShape()
        }
    }
    
    // MARK: - Properties
    let boldBorder: Bool
    
    var hasBorder: Bool = false {
        didSet {
            guard hasBorder else { return layer.borderWidth = 0 }
            layer.borderWidth = boldBorder ? 10 : 2
        }
    }
    
    private let borderShape: BorderShape
    
    // MARK: - Initializers
    init(borderShape: BorderShape, boldBorder: Bool = true, image: UIImage = UIImage()) {
        self.borderShape = borderShape
        self.boldBorder = boldBorder
        super.init(frame: CGRect.zero)
        backgroundColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBorderShape()
    }
    
    convenience init() {
        self.init(borderShape: .none)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.borderShape = .none
        self.boldBorder = false
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layouts
    func setupBorderShape() {
        hasBorder = false//borderShape != .none
        let width = bounds.size.width
        let divisor: CGFloat
        switch borderShape {
        case .circle:
            divisor = 2
        case .squircle:
            divisor = 4
        case .none:
            divisor = width
        }
        let cornerRadius = width / divisor
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}
