import Foundation
import VKSdkFramework

protocol AuthenticationServiceDelegate: AnyObject {
    func authenticationServiceShouldShow(viewController: UIViewController)
    func authenticationServiceSignIn()
    func authenticationServiceSignInDidFail()
}

final class AuthenticationService: NSObject {
    private let appId = "51415502"
    private let vkSdk: VKSdk
    
    static let shared = AuthenticationService()
    weak var delegate: AuthenticationServiceDelegate?
    
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    
    var userId: String? {
        return VKSdk.accessToken()?.userId
    }
    
    private override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
//        print("VKSdk.initialize")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    func wakeUpSession() {
        let scope = ["offline", "wall", "friends"]
        VKSdk.wakeUpSession(scope) { [weak delegate] state, error in
            if let _ = error { return }
            switch state {
            case .initialized:
                print("initialized")
                VKSdk.authorize(scope)
            case .authorized:
                print("authorized")
                delegate?.authenticationServiceSignIn()
            default:
                fatalError(error?.localizedDescription ?? "Ошибки")
            }
        }
    }

}

extension AuthenticationService: VKSdkDelegate, VKSdkUIDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print("vkSdkAccessAuthorizationFinished")
        if result.token != nil {
            delegate?.authenticationServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("vkSdkUserAuthorizationFailed")
        delegate?.authenticationServiceSignInDidFail()
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print("AuthenticationService")
        delegate?.authenticationServiceShouldShow(viewController: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print("vkSdkNeedCaptchaEnter")
    }
}
