import UIKit
import VKSdkFramework

class MainViewController: UIViewController {
    
    var authenticationService: AuthenticationService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticationService = AuthenticationService.shared
        authenticationService.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        authenticationService.wakeUpSession()
//        VKSdk.forceLogout()
    }
}

extension MainViewController: AuthenticationServiceDelegate {
    
    func authenticationServiceShouldShow(viewController: UIViewController) {
        let window = UIApplication.shared.windows.first
        window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func authenticationServiceSignIn() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "TabBar", bundle:nil)
        let mainTabViewController = storyBoard.instantiateViewController(withIdentifier: "tabBar") as! VKTabBarController
        let nav = UINavigationController(rootViewController: mainTabViewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated:true)
    }
    
    func authenticationServiceSignInDidFail() {
    }
}
