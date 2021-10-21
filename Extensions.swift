//
//  Extensions.swift
//  TCL
//
//  Created by Mirza Ahmer Baig on 02/08/2018.
//  Copyright © 2018 Mirza Ahmer Baig. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftValidator
import NotificationBannerSwift
import FCAlertView
import SKActivityIndicatorView


extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
}

extension UITableViewCell {
    static func setupTableViewCell() {
        // self.appearance().selectionStyle = .none
    }
    
    func animateCellScaleTransform() {
        self.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8)
        UIView.animate(withDuration: 0.3) {
            self.layer.transform = CATransform3DIdentity
        }
    }
}

extension UICollectionViewCell {
    func animateCellScaleTransform() {
        self.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8)
        UIView.animate(withDuration: 0.3) {
            self.layer.transform = CATransform3DIdentity
        }
    }
}

extension UINavigationController {
    
    func goBackViewControllers(n: Int) {
        if n <= self.viewControllers.count && n > 0 {
            let index = self.viewControllers.count - n - 1
            _ = self.popToViewController(self.viewControllers[index], animated: true)
        }
    }
}

extension UINavigationBar {
    
    static func setupNavigationBar() {
        self.appearance().barTintColor = Theme.primaryColor
        self.appearance().tintColor = UIColor.white
        self.appearance().isTranslucent = false
        if #available(iOS 11.0, *) {
            self.appearance().prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
        self.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                 NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 17)!]
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                     NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 17)!]
        } else {
            // Fallback on earlier versions
        }
    }
}

extension Notification.Name {
    static let NotificationFireName = Notification.Name(rawValue: "TCLNotifications")
    static let TCLLocationUpdates = Notification.Name(rawValue: "TCLLocationUpdatesNotifications")
    static let TCLEnterFence = Notification.Name(rawValue: "TCLEnterFenceNotifications")
    static let TCLExitFence = Notification.Name(rawValue: "TCLExitFenceNotifications")
    static let dismissCategoriesDetail = Notification.Name("dismissCategoriesDetail")
    static let openCartTab = Notification.Name("openCartTab")
    static let featureTagTappedNotification = Notification.Name("featureTagTapped")
    static let imagePreviewNotification = Notification.Name("ImagePreview")
}

extension UIViewController:  UIGestureRecognizerDelegate {
    
    static var banner: StatusBarNotificationBanner?
    
    static var isAnimatingLoader: Bool = false
    
    func showBanner(title: String, style: BannerStyle) {
        UIViewController.banner?.dismiss()
        UIViewController.banner = StatusBarNotificationBanner(title: title.lowercased().capitalizingFirstLetter(), style: style, colors: nil)
        UIViewController.banner?.show()
        UIViewController.banner?.duration = 1
    }
    
    func showAlert(title: String, message: String, type: Constants.alertType, _ doneActionBlock: (() -> ())? = nil) {
        let alertView = FCAlertView()
        alertView.titleFont = Theme.largeTextFont
        alertView.subtitleFont = Theme.textFont
        alertView.colorScheme = Theme.primaryColor
        alertView.titleColor = UIColor.gray
        alertView.doneActionBlock {
            doneActionBlock?()
        }
        alertView.showAlert(withTitle: title, withSubtitle: message, withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
        switch type {
        case .success:
            alertView.makeAlertTypeSuccess()
            return
        case .info:
            alertView.makeAlertTypeCaution()
            alertView.colorScheme = Theme.primaryColor
            return
        case .warning:
            alertView.makeAlertTypeWarning()
            return
        }
    }
    
    class func showLoader(text: String) {
        if UIViewController.isAnimatingLoader == false {
            UIViewController.isAnimatingLoader = true
            GeneralUtility.getAppKeyWindow()?.isUserInteractionEnabled = false
            
            SKActivityIndicator.show(text)
        }
    }
    
    class func hideLoader() {
        UIViewController.isAnimatingLoader = false
        GeneralUtility.getAppKeyWindow()?.isUserInteractionEnabled = true
        SKActivityIndicator.dismiss()
    }
    
    func registerLocalNotification(id: String, date: Date, title: String, body: String) {
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.subtitle = date.humanReadableDate
        content.body = body
        content.badge = 0
        
        let timeInterval = Date().timeIntervalSince(date) - (5 * 60)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (timeInterval < 0) ? 60 : timeInterval, repeats: false)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        //adding the notification to notification center
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func isValidFieldInput(validator: Validator, textField: UITextField, errorMessage: String?) -> Bool {
        let textField = textField as! TCLTextField
        var isValidInput = false
        validator.validateField(textField) { (error) in
            if let err = error {
                if let errorMessage = errorMessage {
                    textField.errorMessage = errorMessage
                } else {
                    textField.errorMessage = err.errorMessage
                }
                isValidInput = false
            } else {
                textField.errorMessage = nil
                isValidInput = true
            }
        }
        return isValidInput
    }
    
    func validateFieldInput(validator: Validator, textField: UITextField) {
        let textField = textField as! TCLTextField
        validator.validateField(textField) { (error) in
            if let err = error {
                textField.errorMessage = err.errorMessage
            } else {
                textField.errorMessage = nil
            }
        }
    }
    
    func validateFields(validator: Validator, completionHandler: @escaping (Bool) -> ()) {
        validator.validate { (errors) in
            var fields: [TCLTextField] = []
            for (field, error) in errors {
                if let field = field as? TCLTextField {
                    field.errorMessage = error.errorMessage
                    fields.append(field)
                }
            }
            for (_, rule) in validator.validations {
                if let field = rule.field as? TCLTextField {
                    if !fields.contains(field) {
                        field.errorMessage = nil
                    }
                }
            }
            completionHandler(fields.count == 0)
        }
    }
    
    func setupBackButtonItem() {
        let leftBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back"), style: .done, target: self, action: #selector(backButtonAction(_:)))
        self.navigationItem.leftBarButtonItem = leftBarItem
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc fileprivate func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setLeftLogoItem() {
        let logoBarItem = UIBarButtonItem(customView: UIImageView(image: #imageLiteral(resourceName: "logo")))
        self.navigationItem.leftBarButtonItem = logoBarItem
    }
    
    func setupBackButtonDismissItem() {
        let leftBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_clear_white"), style: .done, target: self, action: #selector(backButtonDismissAction(_:)))
        self.navigationItem.leftBarButtonItem = leftBarItem
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @objc fileprivate func backButtonDismissAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setCostLabelValues(label: UILabel ,costTitles: [String]) {
        let titles = costTitles
        let fonts = [Theme.lightHeaderFont, Theme.boldTextFont]
        let colors = [UIColor.gray, Theme.primaryColor]
        let seperators = [" ", ""]
        
        label.numberOfLines = 0
        label.attributedText = GeneralUtility.getAttributedText(Titles: titles, Font: fonts, Colors: colors, seperator: seperators, Spacing: 3, atIndex: 0, alignment: .center)
    }
}

extension UIView {
    
    static var banner: StatusBarNotificationBanner?
    
    func showBanner(title: String, style: BannerStyle) {
        UIView.banner?.dismiss()
        UIView.banner = StatusBarNotificationBanner(title: title, style: style, colors: nil)
        UIView.banner?.show()
    }
    
    func getAspectedSize(Width:CGFloat, aspectRatio:CGFloat, padding:CGFloat) -> CGSize {
        
        let cellWidth = (Width ) - padding
        let cellHeight = cellWidth / aspectRatio
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func isValidFieldInput(validator: Validator, textField: UITextField, errorMessage: String?) -> Bool {
        let textField = textField as! TCLTextField
        var isValidInput = false
        validator.validateField(textField) { (error) in
            if let err = error {
                if let errorMessage = errorMessage {
                    textField.errorMessage = errorMessage
                } else {
                    textField.errorMessage = err.errorMessage
                }
                isValidInput = false
            } else {
                textField.errorMessage = nil
                isValidInput = true
            }
        }
        return isValidInput
    }
    
    func validateFieldInput(validator: Validator, textField: UITextField) {
        let textField = textField as! TCLTextField
        validator.validateField(textField) { (error) in
            if let err = error {
                textField.errorMessage = err.errorMessage
            } else {
                textField.errorMessage = nil
            }
        }
    }
    
    func validateFields(validator: Validator, completionHandler: @escaping (Bool) -> ()) {
        validator.validate { (errors) in
            var fields: [TCLTextField] = []
            for (field, error) in errors {
                if let field = field as? TCLTextField {
                    field.errorMessage = error.errorMessage
                    fields.append(field)
                }
            }
            for (_, rule) in validator.validations {
                if let field = rule.field as? TCLTextField {
                    if !fields.contains(field) {
                        field.errorMessage = nil
                    }
                }
            }
            completionHandler(fields.count == 0)
        }
    }
    
    func setBorder( width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func underline(_ color:UIColor){
        let border = CALayer()
        let borderWidth = CGFloat(0.5)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 5.0, y: self.frame.size.height - borderWidth, width: self.frame.size.width - 10.0, height: self.frame.size.height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        
    }
    
    func getRounded(cornerRaius:CGFloat) {
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = cornerRaius
        self.clipsToBounds = true
    }
    
    func giveShadow(cornerRaius:CGFloat) {
        
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRaius).cgPath
        self.layer.shadowOpacity = 0.3
    }
    
    public func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        _ = anchorWithReturnAnchors(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant, widthConstant: widthConstant, heightConstant: heightConstant)
    }
    
    public func anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
    
    public func anchorWithReturnAnchors(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
}

extension UIButton {
    
    func alignTextUnderImage(spacing:CGFloat) {
        let imageSize = self.imageView!.frame.size
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
        let titleSize = self.titleLabel!.frame.size
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }
    
    func adjustImageRightOfTitle(padding:CGFloat) {
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -self.imageView!.frame.width + 10, bottom: 0, right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.width - self.imageView!.frame.width, bottom: 0 , right: 0)
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        self.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isUserInteractionEnabled = true
        }
    }
    
}

// uiimage extension (package)
extension UIImage{
    
    func resizeImage(newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func getURL(filename: String) ->  String? {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        if let imagePath = documentsPath?.appendingPathComponent("\(filename).jpg") {
            let data = self.jpegData(compressionQuality: 0.5)!
            try! data.write(to: imagePath)
            return imagePath.absoluteString
        }
        return nil
    }
    
}

extension String {
    
    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func age() -> Int {
        return Calendar.current.dateComponents([.year], from: Formatter.humanReadableDatewoTime.date(from: self)!, to: Date()).year!
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: 1000)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.size
    }
    
    var dateFromISO8601: Date? {
        var date = self
        if !date.contains(".") {
            date = date.appending(".000")
        }
        print("Date: \(self) --> \(date)")
        return Formatter.iso8601.date(from: date)   // "Mar 22, 2017, 10:22 AM"
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}


extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Calendar.current.locale
        formatter.timeZone = Calendar.current.timeZone
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return formatter
    }()
    
    
    static let humanReadableDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    
    static let humanReadableTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()
    
    static let humanReadableDatewoTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddyyyy"
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static let serverDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
}

extension Data {
    var format: String {
        let array = [UInt8](self)
        let ext: String
        switch (array[0]) {
        case 0xFF:
            ext = "jpg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D :
            ext = "tiff"
        default:
            ext = "unknown"
        }
        return ext
    }
}

extension Double {
    func getRounded(uptoPlaces: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .halfUp
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension Date {
    
    var timeZone: String {
        return self.description.components(separatedBy: " ").last ?? "+0000"
    }
    
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
    
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
    
    var humanReadableDate: String {
        return Formatter.humanReadableDate.string(from: self)
    }
    
    var humanReadableDatewoTime: String {
        return Formatter.humanReadableDatewoTime.string(from: self)
    }
    
    var humanReadableTime: String {
        return Formatter.humanReadableTime.string(from: self)
    }
    
    
    var serverSideDate: String {
        return Formatter.serverDateFormatter.string(from: self)
    }
    
    func getReadableDateDifference(toDate: Date) -> DateComponents {
        let components = Set<Calendar.Component>([.minute, .hour])
        return Calendar.current.dateComponents(components, from: self, to: toDate)
    }
    
    func getComponents() -> DateComponents {
        let components = Set<Calendar.Component>([.year, .month, .day])
        return Calendar.current.dateComponents(components, from: self)
    }
}

extension UILabel {
    func from(html: String) {
        if let htmlData = html.data(using: String.Encoding.unicode) {
            do {
                self.attributedText = try NSAttributedString(data: htmlData,
                                                             options: [.documentType :NSAttributedString.DocumentType.html],
                                                             documentAttributes: nil)
            } catch let e as NSError {
                print("Couldn't parse \(html): \(e.localizedDescription)")
            }
        }
    }
    
    func giveShadow(of color: UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.masksToBounds = false
    }
}

extension Notification.Name {
    static let userLoggedInNotification = Notification.Name("UserLoggedIn")
    static let userLoggedOutNotification = Notification.Name("UserLoggedOut")
    static let fetchedCartItemsNotification = Notification.Name("cartItemsFetched")
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
