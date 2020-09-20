//
//  ShareViewController.swift
//  URLShareExt
//
//  Created by Jin Lee on 18/9/20.
//  Copyright © 2020 Jin Lee. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import os.log

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1: Set the background and call the function to create the navigation bar
        self.view.backgroundColor = .systemGray6
        setupNavBar()
        setupViews()
        getURL()

    }
    
    private func getURL() -> URL? {
        var webURL: URL?
        guard let items = extensionContext?.inputItems as? [NSExtensionItem] else { return nil }

        for item in items {
            for itemProvider in item.attachments! {
                
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                    itemProvider.loadItem(forTypeIdentifier: kUTTypeURL as String) { (url, error) in
                        if let url = url as? URL {
                            webURL = url
                            
                            DispatchQueue.main.sync { [weak self] in
                                os_log("kUTTypeURL: %s", log: OSLog.data, type: .info, webURL?.absoluteString ?? "")
                                self?.textField.text = url.absoluteString
                            }
                        }
                    }
                } else if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePlainText as String) {
                    itemProvider.loadItem(forTypeIdentifier: kUTTypePlainText as String) { (urlStr, error) in
                        if let urlStr = urlStr as? String {
                            webURL = URL(string: urlStr)

                            DispatchQueue.main.sync { [weak self] in
                                os_log("kUTTypePlainText: %s", log: OSLog.data, type: .info, webURL?.absoluteString ?? "")
                                self?.textField.text = urlStr
                            }
                        }
                    }
                }
            }
        }
        
        return webURL
    }
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.text = "some value"
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private func setupViews() {
        self.view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // 2: Set the title and the navigation items
    private func setupNavBar() {
        self.navigationItem.title = "My app"
        
        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.setLeftBarButton(itemCancel, animated: false)
        
        let itemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        self.navigationItem.setRightBarButton(itemDone, animated: false)
    }
    
    // 3: Define the actions for the navigation items
    @objc private func cancelAction () {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }
    
    @objc private func doneAction() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

}

@objc(ShareNavigationController)
class ShareNavigationController: UINavigationController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // 2: set the ViewControllers
        self.setViewControllers([ShareViewController()], animated: false)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

