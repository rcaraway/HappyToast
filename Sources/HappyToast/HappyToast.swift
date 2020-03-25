#if !os(macOS)
import UIKit
import HappyColors

public enum ToastType {
    case neutral
    case success
    case warning
    case failure
}

private class Toast: UIView {
    static let shared = Toast()
    let label = UILabel()
    
    init() {
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        super.init(frame: .zero)
        backgroundColor = colorFor(type: .neutral)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        label.frame = bounds
        label.center = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0)
    }
    
    func colorFor(type: ToastType) -> UIColor {
        switch type {
        case .neutral:
            return .flatGray
        case .success:
            return .flatGreen
        case .failure:
            return .flatRed
        default:
            return .flatOrange
        }
    }
}

public extension UIView {
    
    func showToast(message: String, type: ToastType) {
        let toast = Toast.shared
        toast.label.text = message
        toast.backgroundColor = toast.colorFor(type: type)
        if let nav = findNavBar() {
            toast.frame = nav.frame
            insertSubview(toast, belowSubview: nav)
        }else {
            toast.frame = CGRect(x: 0, y: -44, width: UIScreen.main.bounds.width, height: 44)
            addSubview(toast)
        }
        animateToast(show: true)
    }
    
    func showToast(message: String) {
        showToast(message: message, type: .neutral)
    }
    
    private func animateToast(show: Bool) {
        let toast = Toast.shared
        UIView.animate(withDuration: 0.3, animations: {
            toast.transform = show ?
                CGAffineTransform(translationX: 0, y: 44) :
                .identity
            toast.layoutIfNeeded()
        }) { _ in
            if show {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                    self.animateToast(show: false)
                }
            } else {
                toast.removeFromSuperview()
            }
        }
    }
    
    private func findNavBar() -> UINavigationBar? {
        var minYBar: UINavigationBar?
        for view in subviews where view.isKind(of: UINavigationBar.self) {
            if let bar = minYBar,
                view.frame.minY < bar.frame.minY{
                minYBar = view as? UINavigationBar ?? bar
            }else {
                minYBar = view as? UINavigationBar
            }
        }
        return minYBar
    }
}

public extension UIViewController {
    
    func showToast(message: String, type: ToastType) {
        if let nav = navigationController {
            nav.view.showToast(message: message, type: type)
        }else {
            view.showToast(message: message, type: type)
        }
    }
    
    func showToast(message: String) {
        if let nav = navigationController {
            nav.view.showToast(message: message)
        }else {
            view.showToast(message: message)
        }
    }
}
#endif
