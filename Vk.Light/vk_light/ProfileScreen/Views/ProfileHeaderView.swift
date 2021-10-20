
import UIKit

final class ProfileHeaderView: UIView {
    
    // MARK: - Properties
     var profileImageView = ProfileImageView(borderShape: .circle)

    let fullNameLabel = ProfileNameLabel()
    private let leftSpacerView = UIView()
    private let rightSpacerView = UIView()
    
    private lazy var profileImageStackView = UIStackView(arrangedSubviews: [profileImageView])
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupStackView()
    }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layouts
  private func setupStackView() {
    addSubview(profileImageView)
    addSubview(fullNameLabel)
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
        [
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            fullNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 20),
            fullNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
        ])
  }
}

private extension UIButton {
  static func createSystemButton(withTitle title: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    return button
  }
}
