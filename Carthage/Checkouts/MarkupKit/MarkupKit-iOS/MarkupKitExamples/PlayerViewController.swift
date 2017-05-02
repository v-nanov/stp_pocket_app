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
import AVFoundation
import MarkupKit

class PlayerViewController: LMTableViewController, LMPlayerViewDelegate {
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var playerView: LMPlayerView!
    @IBOutlet var playButton: UIButton!

    override func loadView() {
        view = LMViewBuilder.view(withName: "PlayerViewController", owner: self, root: nil)

        tableView.dataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Player View"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        activityIndicatorView.startAnimating()

        playButton.isEnabled = false

        playerView.delegate = self

        playerView.layer.player = AVPlayer(url: Bundle.main.url(forResource: "sample", withExtension: "mov")!)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        playButton.isEnabled = false

        playerView.layer.player?.pause()

        playerView.delegate = nil
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (playerView.layer.player?.status == .readyToPlay) ? super.numberOfSections(in: tableView) : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (playerView.layer.player?.status == .readyToPlay) ? super.tableView(tableView, numberOfRowsInSection: section) : 0
    }

    func playerView(_ playerView: LMPlayerView, isReadyForDisplay readyForDisplay: Bool) {
        activityIndicatorView.stopAnimating()

        tableView.reloadData()
        
        togglePlay()

        playButton.isEnabled = true
    }

    @IBAction func togglePlay() {
        let player = playerView.layer.player!

        if (player.rate > 0) {
            player.pause()

            playButton.title = "Play"
        } else {
            player.play()

            playButton.title = "Pause"
        }
    }
}
