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

class SelectionViewController: UIViewController, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    let colorPickerViewController = ColorPickerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        title = "Selection View"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Color", style: UIBarButtonItemStyle.plain,
            target: self, action: #selector(showColorPicker))

        colorPickerViewController.modalPresentationStyle = .popover
        colorPickerViewController.tableView.delegate = self
    }

    func showColorPicker() {
        let colorPickerPresentationController = colorPickerViewController.presentationController as! UIPopoverPresentationController

        colorPickerPresentationController.barButtonItem = navigationItem.rightBarButtonItem
        colorPickerPresentationController.backgroundColor = UIColor.white
        colorPickerPresentationController.delegate = self

        present(colorPickerViewController, animated: true)
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)

        view.backgroundColor = LMViewBuilder.colorValue(cell!.value as! String)

        dismiss(animated: true)
    }
}
