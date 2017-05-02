//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import WebKit
import MarkupKit

class WebViewController: UIViewController {
    @IBOutlet var webView: WKWebView!
    @IBOutlet var urlTextField: UITextField!
    
    override func loadView() {
        view = LMViewBuilder.view(withName: "WebViewController", owner: self, root: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Web View"

        edgesForExtendedLayout = UIRectEdge()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaultNotificationCenter = NotificationCenter.default
        
        defaultNotificationCenter.addObserver(self,
            selector: #selector(keyboardWillShow(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)

        defaultNotificationCenter.addObserver(self,
            selector: #selector(keyboardWillHide(_:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)
        
        urlTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let defaultNotificationCenter = NotificationCenter.default
        
        defaultNotificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        defaultNotificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        (view as! LMColumnView).bottomSpacing = ((notification as NSNotification).userInfo![UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size.height
    }
    
    func keyboardWillHide(_ notification: Notification) {
        (view as! LMColumnView).bottomSpacing = 0
    }
    
    @IBAction func loadURL() {
        webView.load(URLRequest(url: URL(string: urlTextField.text!)!))
    }
}
