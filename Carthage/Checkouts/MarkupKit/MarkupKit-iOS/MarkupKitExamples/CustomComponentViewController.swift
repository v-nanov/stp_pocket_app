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

class CustomComponentViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let dynamicComponentName = "dynamic"

    @IBOutlet var pickerView: UIPickerView!

    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!

    override func loadView() {
        view = LMViewBuilder.view(withName: "CustomComponentViewController", owner: self, root: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Custom Component View"

        pickerView.dataSource = self
        pickerView.delegate = self

        edgesForExtendedLayout = UIRectEdge()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateLabel()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerView.numberOfComponents(in: pickerView)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let n: Int
        if (pickerView.name(forComponent: component) == dynamicComponentName) {
            n = 5
        } else {
            n = pickerView.pickerView(pickerView, numberOfRowsInComponent: component)
        }

        return n
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title: String
        if (pickerView.name(forComponent: component) == dynamicComponentName) {
            title = String(row + 1)
        } else {
            title = pickerView.title(forRow: row, forComponent:component)!
        }

        return title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }

    func updateLabel() {
        sizeLabel.text = pickerView.value(forRow: pickerView.selectedRow(inComponent: 0), forComponent: 0) as? String
        colorLabel.text = pickerView.value(forRow: pickerView.selectedRow(inComponent: 1), forComponent: 1) as? String

        numberLabel.text = pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 2), forComponent: 2)
    }
}
