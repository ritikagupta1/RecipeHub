import UIKit

extension UIViewController {
    
    func showLoadingView() -> UIView {
        print("SHOW - \(self)")
        let containerView = UIView(frame: self.view.bounds)
        view.addSubview(containerView)
        containerView.alpha = 0
        containerView.backgroundColor = .systemBackground
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        activityIndicator.startAnimating()
        return containerView
    }
    
    func add(_ child: UIViewController, toView: UIView? = nil, position: Int? = nil) {
        addChild(child)

        let viewToAddTo: UIView = toView ?? view

        child.view.frame = viewToAddTo.bounds

        if let position = position {
            viewToAddTo.insertSubview(child.view, at: position)
        } else {
            viewToAddTo.addSubview(child.view)
        }

        child.didMove(toParent: self)
    }

    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func showAlertonMainThread(alertTitle: String,message: String,buttonTitle: String) {
            let alertVC = RecipeAlertViewController(alertTitle: alertTitle, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            present(alertVC, animated: true, completion: nil)
    }
    
    
}
