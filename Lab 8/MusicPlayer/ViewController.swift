//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Alikhan on 30.10.2026.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!

    let tracks = TrackLibrary.tracks
    var currentIndex = 0
    var isPlaying = false
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        loadTrack()
        updateUI()
    }

    func loadTrack() {
        let track = tracks[currentIndex]
        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3") else {
            print("File not found: \(track.fileName).mp3")
            player = nil
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
        } catch {
            print("Could not play \(track.fileName): \(error.localizedDescription)")
            player = nil
        }
    }

    func updateUI() {
        let track = tracks[currentIndex]
        coverImageView.image = UIImage(named: track.coverImageName)
        titleLabel.text = track.title
        artistLabel.text = track.artist

        let iconName = isPlaying ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: iconName), for: .normal)
    }

    func changeTrack(to index: Int) {
        player?.stop()
        currentIndex = index
        loadTrack()

        if isPlaying {
            if let player = player {
                player.play()
            } else {
                isPlaying = false
            }
        }
        updateUI()
    }

    @IBAction func playPauseTapped(_ sender: UIButton) {
        guard let player = player else {
            print("Nothing to play, the file is missing or broken")
            return
        }

        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
        updateUI()
    }

    @IBAction func nextTapped(_ sender: UIButton) {
        changeTrack(to: (currentIndex + 1) % tracks.count)
    }

    @IBAction func previousTapped(_ sender: UIButton) {
        changeTrack(to: (currentIndex - 1 + tracks.count) % tracks.count)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        changeTrack(to: (currentIndex + 1) % tracks.count)
    }

}
