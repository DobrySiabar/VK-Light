import Foundation
import VKSdkFramework

protocol AuthenticationServiceDelegate: AnyObject {
    func authenticationServiceShouldShow(viewController: UIViewController)
    func authenticationServiceSignIn()
    func authenticationServiceSignInDidFail()
}

class AuthenticationService: NSObject {
    private let appId = "7899391"
    private let vkSdk: VKSdk
    weak var delegate: AuthenticationServiceDelegate?
    
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    
    var userId: String? {
        return VKSdk.accessToken()?.userId
    }
    
    static let shared = AuthenticationService()
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    func wakeUpSession() {
        let scope = ["offline", "wall", "friends"]
        VKSdk.wakeUpSession(scope) { [weak delegate] state, error in
            if let _ = error { return }
            switch state {
            case .initialized:
                VKSdk.authorize(scope)
            case .authorized:
                delegate?.authenticationServiceSignIn()
            default:
                fatalError(error?.localizedDescription ?? "Ошибки")
            }
        }
    }

}

extension AuthenticationService: VKSdkDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            delegate?.authenticationServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        delegate?.authenticationServiceSignInDidFail()
    }
}

extension AuthenticationService: VKSdkUIDelegate {
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        delegate?.authenticationServiceShouldShow(viewController: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {

    }
}
