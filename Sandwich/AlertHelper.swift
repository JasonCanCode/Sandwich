//
//  AlertHelper.swift
//  GraphicAudio
//
//  Created by Jason Welch on 5/25/17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit

extension UIAlertAction {
    convenience init(title: String, handler: ((UIAlertAction?) -> Void)? = nil) {
        self.init(title: title, style: .default, handler: handler)
    }
}

struct AlertHelper {

    private static var closeButtonText = "OK"
    private static var cancelButtonText = "Cancel"
    private static var affirmativeButtonText = "Yes"

    // MARK: Actionable Alerts

    static func showSingleButtonAlert(in viewController: UIViewController,
                                      title: String?,
                                      message: String?,
                                      dismissLabel: String = closeButtonText,
                                      completion: @escaping ((Void) -> Void) = {}) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // The completion block of a UIAlertController is called when the alert is displayed, not when it is dismissed.
        // In this way, you cannot dismiss a viewController that has presented the alert until after it is dismissed.
        alert.addAction(UIAlertAction(title: dismissLabel, handler: { _ in
            // Dismiss ViewController that presented the alert here.
            completion()
        }))
        viewController.present(alert, animated: true, completion: nil)
    }

    static func showConfirmationAlert(in viewController: UIViewController,
                                      title: String?,
                                      message: String?,
                                      confirmationActionText actionText: String = affirmativeButtonText,
                                      cancelActionText: String = cancelButtonText,
                                      confirmationActionHandler handler: @escaping (UIAlertAction?) -> Void) {

        let positiveAction = UIAlertAction(title: actionText, style: .default, handler: handler)
        let cancelAction = UIAlertAction(title: cancelActionText, style: .cancel)

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(positiveAction)
        alert.addAction(cancelAction)
        alert.preferredAction = positiveAction

        viewController.present(alert, animated: true) {}
    }

    // MARK: Error Alerts

    static func showAlert(for error: Error,
                          in viewController: UIViewController,
                          title: String? = nil,
                          dismissLabel: String = closeButtonText) {

        let error = error as NSError
        let alertTitle: String
        let alertMessage: String

        if let errorTitle = error.userInfo["title"] as? String, let errorMessage = error.userInfo["detail"] as? String {
            alertTitle = title ?? errorTitle
            alertMessage = errorMessage
        } else {
            alertTitle = title ?? String(format: "Error %i", error.code)
            alertMessage = error.localizedDescription
        }

        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: dismissLabel))
        viewController.present(alert, animated: true)
    }

    // MARK: Private Helpers

    private static func alertTitle(for error: Error) -> String {
        let error = error as NSError
        return String(format: "Error %i", error.code)
    }
}
