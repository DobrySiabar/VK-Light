
import UIKit

protocol PostCellDelegate: AnyObject {
    func revealPost(for cell: PostCell)
}

class PostCell: UITableViewCell {

    var isRevealed = false
    
    weak var delegate: PostCellDelegate?
    
    let bottomViewViewsIconSize: CGFloat = 24
    let bottomViewViewWidth: CGFloat = 80
    let bottomViewViewHeight: CGFloat = 44

    static let textFont = UIFont.systemFont(ofSize: 17)
    static let moreTextButtonSize = CGSize(width: 170, height: 30)
    static let reuseId = "PostCell"
    
    static let topViewHeight: CGFloat = 44
    static let bottomViewHeight: CGFloat = 44
    
    let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
            
    let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let imagePostImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let sourcePostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Xcode"
        return label
    }()
    
    let datePostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "21.07.2017"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let separatorTopLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let postTextLabel: UILabel = {
        let label = UILabel()
        label.font = textFont
        label.numberOfLines = 0
        return label
    }()
    
    let attachmentPhoto: UIImageView = {
        let photoView = UIImageView()
        return photoView
    }()
    
    var showMoreTextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(#colorLiteral(red: 0.4691804051, green: 0.688806355, blue: 0.8642641902, alpha: 1), for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.setTitle("Show more..", for: .normal)
        return button
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    let separatorBottomLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var likesView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    var commentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var sharesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var totalViewsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var likesLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
   
    var commentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
   
   var sharesLabel: UILabel = {
       let label = UILabel()
       return label
   }()
   
    var totalViewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let photoGridView = PhotoGridPostCollectionView()
    
    override func prepareForReuse() {
        imagePostImageView.set(imageURL: nil)
    }
    
    func set(viewModel: CellModel) {
        imagePostImageView.set(imageURL: viewModel.iconUrlString)
        sourcePostLabel.text = viewModel.sourceName
        datePostLabel.text = viewModel.date
        postTextLabel.text = viewModel.text
        
        photoGridView.set(photos: viewModel.photoAttachements)
        
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        sharesLabel.text = viewModel.shares
        totalViewsLabel.text = viewModel.views
        
        let cellElementsSizes = viewModel.sizes
        topView.frame.size = cellElementsSizes.topLabelSize
        
        var realTextFrameSize = CGSize.zero
        var realButtonSize = CGSize.zero
        if !viewModel.isRevealed, let minifiedTextLabelSize = viewModel.sizes.minifiedTextLabelSize {
            realTextFrameSize = minifiedTextLabelSize
            realButtonSize = PostCell.moreTextButtonSize
        } else {
            realTextFrameSize = cellElementsSizes.textLabelSize
            
        }

        postTextLabel.frame = CGRect(origin: CGPoint(x: 8, y: topView.frame.maxY), size: realTextFrameSize)
        showMoreTextButton.frame = CGRect(origin: CGPoint(x: 8, y: postTextLabel.frame.maxY), size: realButtonSize)
        photoGridView.frame = CGRect(origin: CGPoint(x: 0, y: showMoreTextButton.frame.maxY), size: cellElementsSizes.attachmentSize)
        bottomView.frame = CGRect(origin: CGPoint(x: 0, y: photoGridView.frame.maxY), size: cellElementsSizes.bottomViewSize)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        selectionStyle = .none
        contentView.addSubview(cellView)
        
        imagePostImageView.layer.cornerRadius = PostCell.topViewHeight / 2
        imagePostImageView.clipsToBounds = true
        
        cellView.backgroundColor = .white
        cellView.layer.cornerRadius = 10
        cellView.clipsToBounds = true
        
        showMoreTextButton.addTarget(self, action: #selector(showMoreText), for: .touchUpInside)
        
        NSLayoutConstraint.activate(
          [cellView.leadingAnchor.constraint(
            equalTo: leadingAnchor, constant: 8),
           cellView.trailingAnchor.constraint(
            equalTo: trailingAnchor, constant: -8),
           cellView.topAnchor.constraint(
            equalTo: topAnchor, constant: 0),
           cellView.bottomAnchor.constraint(
            equalTo: bottomAnchor, constant: -6)])
       
        cellView.addSubview(topView)
        
        
        topView.addSubview(imagePostImageView)
        topView.addSubview(sourcePostLabel)
        topView.addSubview(datePostLabel)
        firstViewLayout()
        
        cellView.addSubview(postTextLabel)
        cellView.addSubview(showMoreTextButton)
        cellView.addSubview(photoGridView)
        
        cellView.addSubview(bottomView)
        bottomViewLayout()
    }
    
    @objc func showMoreText() {
        delegate?.revealPost(for: self)
    }
    
    func firstViewLayout() {
        topView.topAnchor.constraint(equalTo: cellView.topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
        imagePostImageView.clipsToBounds = true
        imagePostImageView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        imagePostImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
        imagePostImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imagePostImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        sourcePostLabel.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        sourcePostLabel.leadingAnchor.constraint(equalTo: imagePostImageView.trailingAnchor, constant: 3).isActive = true
        sourcePostLabel.widthAnchor.constraint(equalTo: topView.widthAnchor, constant: -40).isActive = true
        sourcePostLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        datePostLabel.topAnchor.constraint(equalTo: sourcePostLabel.bottomAnchor).isActive = true
        datePostLabel.leadingAnchor.constraint(equalTo: imagePostImageView.trailingAnchor, constant: 3).isActive = true
        datePostLabel.widthAnchor.constraint(equalTo: topView.widthAnchor, constant: -40).isActive = true
        datePostLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func bottomViewLayout() {
        generateBottomLabelWithButton(view: likesView, label: likesLabel,leading: bottomView.leadingAnchor, withImage: "like")
        generateBottomLabelWithButton(view: commentsView, label: commentsLabel, leading: likesView.trailingAnchor, withImage: "comment")
        generateBottomLabelWithButton(view: sharesView, label: sharesLabel,leading: commentsView.trailingAnchor, withImage: "share")
        generateBottomLabelWithButton(view: totalViewsView, label: totalViewsLabel,trailing: bottomView.trailingAnchor, withImage: "eye")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateBottomLabelWithButton(view: UIView,
                                       label: UILabel,
                                       leading: NSLayoutXAxisAnchor? = nil,
                                       bottom: NSLayoutYAxisAnchor? = nil,
                                       trailing: NSLayoutXAxisAnchor? = nil,
                                       withImage imageName: String) {
        
        let imageView = UIImageView()
        
        bottomView.addSubview(view)
        view.addSubview(imageView)
        view.addSubview(label)

        var padding = UIEdgeInsets()
        if trailing != nil {
            padding.right = 10
        }
        
        view.anchor(top: bottomView.topAnchor,
                         leading: leading,
                         bottom: bottom,
                         trailing: trailing,
                         padding: padding,
                         size: CGSize(width: bottomViewViewWidth, height: bottomViewViewHeight))
  
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "457K"
        label.textAlignment = .left
        
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // imageView constraints
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: bottomViewViewsIconSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: bottomViewViewsIconSize).isActive = true
        imageView.image = UIImage(named: imageName)
        
        // label constraints
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    }
}

 
