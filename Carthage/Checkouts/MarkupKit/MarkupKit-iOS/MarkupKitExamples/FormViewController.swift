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
import MarkupKit

class FormViewController: UIViewController {
    class Address: NSObject {
        dynamic var name: String?
        dynamic var street: String?
        dynamic var city: String?
        dynamic var state: String?
    }

    var address = Address()

    @IBOutlet var notesTextView: UITextView!

    override func loadView() {
        view = LMViewBuilder.view(withName: "FormViewController", owner: self, root: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Form View"

        edgesForExtendedLayout = UIRectEdge()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain,
            target: self, action: #selector(submitForm))
    }

    deinit {
        unbindAll()
    }

    func submitForm() {
        view.endEditing(true)

        // Simulate form submission
        let form: [String: Any?] = [
            "address": [
                "name": address.name,
                "street": address.street,
                "city": address.city,
                "state": address.state
            ],
            "notes": notesTextView.text
        ]

        let data = try! JSONSerialization.data(withJSONObject: form, options: JSONSerialization.WritingOptions.prettyPrinted)

        print(String(data: data, encoding: String.Encoding.utf8)!)

        // Display "form submitted" message
        let alertController = UIAlertController(title: "Status", message: "Form submitted.", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))

        present(alertController, animated: true, completion: nil)
    }
}
