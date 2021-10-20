
import UIKit

class ProfileViewController: UIViewController {
    
    let userInfodataFetcher = UserInfoDataFetcher()
    private var profileHeaderView = ProfileHeaderView()
    
    var userResponse: UserResponse? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let response = self?.userResponse else { return }
                self?.profileHeaderView.profileImageView.set(imageURL: response.photo100)
                self?.profileHeaderView.profileImageView.setupBorderShape()
                self?.profileHeaderView.fullNameLabel.text = response.firstName + " " + response.lastName
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.hidesBarsOnSwipe = false
        tabBarController?.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.navigationController?.hidesBarsOnSwipe = false
        tabBarController?.navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        setupProfileHeaderView()
        userInfodataFetcher.getData { [weak self] data in
            guard let response = data?.response.first else { return }
            self?.userResponse = response
        }
    }
    
    private func setupProfileHeaderView() {
        view.addSubview(profileHeaderView)
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             profileHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             profileHeaderView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
}
