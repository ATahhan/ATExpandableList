//
//  Extensions.swift
//  ClasseraSP
//
//  Created by Ammar AlTahhan on 16/05/2018.
//  Copyright © 2018 Ammar AlTahhan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    static func instantiateVC(_ withIdentifier: String, _ fromStoryboardName: String = "Main") -> UIViewController {
        return UIStoryboard(name: fromStoryboardName, bundle: nil).instantiateViewController(withIdentifier: withIdentifier)
    }
    
    func showMessage(title: String, message: String, completion: (()->Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default) { (action) -> Void in
            completion?()
        }
        
        alertController.addAction(dismissAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPromptMessage(title: String, message: String, approveMessage: String = "OK", approveInteractionStyle: UIAlertActionStyle = UIAlertActionStyle.default, completionHandler: @escaping (Bool) -> ()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: approveInteractionStyle) { (action) -> Void in
            completionHandler(true)
        }
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            completionHandler(false)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UINavigationController {
    func pushViewController(_ withIdentifier: String, _ fromStoryboardName: String = "New") -> UIViewController {
        let viewController = UIStoryboard(name: fromStoryboardName, bundle: nil).instantiateViewController(withIdentifier: withIdentifier)
        self.pushViewController(viewController, animated: true)
        return viewController
    }
}

extension UITableView {
    func reloadAllSections(with animation: UITableViewRowAnimation = .automatic) {
        self.reloadSections(IndexSet(integersIn: Range(0..<self.numberOfSections)), with: animation)
    }
}

extension UITableViewCell {
    func animateSelection(color: UIColor = UIColor.gray.withAlphaComponent(0.3)) {
        let currentColor = self.backgroundColor
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.backgroundColor = color
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0.25, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.backgroundColor = currentColor
            }, completion: nil)
        }
    }
}

extension UIView {
    
    var rootSuperView: UIView {
        var view = self
        while let s = view.superview {
            view = s
        }
        return view
    }
    
    var currentHeightVisibilityPercentage: CGFloat {
        let visibleRect = self.bounds.intersection((superview?.bounds)!)
        let visibleHeight = visibleRect.height
        return visibleHeight/self.frame.height
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
    
    func hasConstraint(withAttribute attribute: NSLayoutAttribute) -> Bool {
        for constraint in self.constraints {
            if constraint.firstAttribute == attribute || constraint.secondAttribute == attribute {
                return true
            }
        }
        return false
    }
    
    func getConstraint(withAttribute attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        for constraint in self.constraints {
            if constraint.firstAttribute == attribute || constraint.secondAttribute == attribute {
                return constraint
            }
        }
        return nil
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
}

extension UIView {
    
    /** This is the function to get subViews of a view of a particular type
     */
    func subViews<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }
    
    
    /** This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T */
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}

extension UIFont {
    
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    var bold: UIFont {
        return withTraits(traits: .traitBold)
    }
}

extension TimeInterval {
    var minutes: Double {
        return self / 60
    }
    var hours: Double {
        return self / 3600
    }
}

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
    
    func setClearButtonTintColor(_ color: UIColor) {
        let clearButton = self.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = color
    }
}

public extension UIWindow {
    
    /** @return Returns the current Top Most ViewController in hierarchy.   */
    func topMostWindowController()->UIViewController? {
        
        var topController = rootViewController
        
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        
        return topController
    }
    
    /** @return Returns the topViewController in stack of topMostWindowController.    */
    func currentViewController()->UIViewController? {
        
        var currentViewController = topMostWindowController()
        
        while currentViewController != nil && currentViewController is UINavigationController && (currentViewController as! UINavigationController).topViewController != nil {
            currentViewController = (currentViewController as! UINavigationController).topViewController
        }
        
        return currentViewController
    }
}

class TextField: UITextField {
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
}


extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

extension UIScrollView {
    func isShowing(view: UIView) -> Bool {
        return view.frame.intersects(bounds)
    }
}

public protocol CaseIterable {
    associatedtype AllCases: Collection where AllCases.Element == Self
    static var allCases: AllCases { get }
}
extension CaseIterable where Self: Hashable {
    static var allCases: [Self] {
        return [Self](AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            var first: Self?
            return AnyIterator {
                let current = withUnsafeBytes(of: &raw) { $0.load(as: Self.self) }
                if raw == 0 {
                    first = current
                } else if current == first {
                    return nil
                }
                raw += 1
                return current
            }
        })
    }
}
