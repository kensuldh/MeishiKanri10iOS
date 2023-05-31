//
//  ShareViewController.swift
//  MeishiKanri10ShareExtension
//
//  Created by 酒井健輔 on 2023/05/29.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // postName
        let controller: UIViewController = self.navigationController!.viewControllers.first!
        controller.navigationItem.rightBarButtonItem!.title = "登録"
    }
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        
//    override func viewDidLoad() {
//        super.viewDidLoad()
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        let extensionItem: NSExtensionItem = self.extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider

        let puclicURL = String(kUTTypeURL)  // "public.url"
        let suiteName: String = "group.PGM.MeishiKanri10"
        let keyName: String = "shareData"
        
        // shareExtension で NSURL を取得
        if itemProvider.hasItemConformingToTypeIdentifier(puclicURL) {
            itemProvider.loadItem(forTypeIdentifier: puclicURL, options: nil, completionHandler: { (item, error) in
                // item からそれぞれそのページのURLや画像データに変換して UserDefaults で保存する
                
                if let url: NSURL = item as? NSURL {

                    // ----------
                    // 保存処理
                    // ----------
                    let sharedDefaults: UserDefaults = UserDefaults(suiteName: suiteName)!
                    sharedDefaults.set(url.absoluteString!, forKey: keyName)  // そのページのURL保存
                    sharedDefaults.synchronize()
                    print(url)
                }
                
                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
//                self.openUrl(url: URL(string: "myapp://next")!)
                self.openContainerApp()
                
            })
        }
        
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    @objc func openURL(_ url: URL) {}  //#selector(openURL(_:))はこの関数がないと作れない

    func openUrl(url: URL?) {
        let selector = #selector(openURL(_:))
        var responder = (self as UIResponder).next
        while let r = responder, !r.responds(to: selector) {
            responder = r.next
        }
        _ = responder?.perform(selector, with: url)
    }
    
    func openContainerApp() {
        let url = URL(string: "pgmmskr://next") // カスタムスキームを作って指定する
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
            let selector = sel_registerName("openURL:")
                application.perform(selector, with: url)
                break
            }
            responder = responder?.next
        }
    }

}
