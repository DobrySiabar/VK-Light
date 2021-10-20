
import UIKit

final class ProfileNameLabel: UILabel {
    
  // MARK: - Properties
  override var text: String? {
    didSet {
      guard let words = text?
        .components(separatedBy: .whitespaces)
        else { return }
      let joinedWords = words.joined(separator: " ")
      guard text != joinedWords else { return }
      DispatchQueue.main.async { [weak self] in
        self?.text = joinedWords
      }
    }
  }

  // MARK: - Initializers
  init(fullName: String? = "") {
    super.init(frame: .zero)
    setTextAttributes()
    text = fullName
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: - Setup Views
  private func setTextAttributes() {
    numberOfLines = 0
    textAlignment = .left
    font = UIFont.boldSystemFont(ofSize: 24)
  }
}
