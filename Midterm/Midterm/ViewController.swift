//
//  ViewController.swift
//  Midterm
//
//  Created by 劉奕伶 on 2018/9/14.
//  Copyright © 2018年 Appwork School. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    
   
    @IBAction func search(_ sender: Any) {
    }
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var sliderBar: UISlider!
    @IBOutlet weak var totalDuration: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var screenButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    var isVideoPlaying = false
    var isMuted = false
    var isRotated = false
    
    let url = URL(string: "https://s3-ap-northeast-1.amazonaws.com/mid-exam/Video/taeyeon.mp4")
    
    @IBAction func playVideo(_ sender: Any) {
        
        if isVideoPlaying {
            player.pause()
            playButton.setImage(#imageLiteral(resourceName: "play_button"), for: .normal)
        } else {
            player.play()
            playButton.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
        }
        
        isVideoPlaying = !isVideoPlaying
    }
    
    @IBAction func muteVideo(_ sender: Any) {
        
        if isMuted {
            player.isMuted = true
            soundButton.setImage(#imageLiteral(resourceName: "volume_up"), for: .normal)
        } else {
            player.isMuted = false
            soundButton.setImage(#imageLiteral(resourceName: "volume_off"), for: .normal)
        }
        
        isMuted = !isMuted
    }
    
    
    @IBAction func foward(_ sender: Any) {
        
        guard let duration = player.currentItem?.duration else { return }
        
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime + 10
        
        if newTime < (CMTimeGetSeconds(duration) - 10) {
            let time: CMTime = CMTimeMake(Int64(newTime * 1000), 1000)
            
            player.seek(to: time)
        }
    }
    
    @IBAction func backward(_ sender: Any) {
        
        let currentTime = CMTimeGetSeconds(player.currentTime())
        
        var newTime = currentTime - 10
        
        if newTime < 0 {
            newTime = 0
        }
        
        let time: CMTime = CMTimeMake(Int64(newTime*1000), 1000)
        
        player.seek(to: time)
    }
    
    @IBAction func changeSlider(_ sender: UISlider) {
        
        player.seek(to: CMTimeMake(Int64(sender.value*1000), 1000))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0 {
            
            self.totalDuration.text = getTimeString(from: player.currentItem!.duration)
        }
    }
    
    func getTimeString(from time: CMTime) -> String {
        
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds / 3600)
        let minutes = Int(totalSeconds / 60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", [hours,minutes,seconds])
        } else {
            return String(format: "%02i:%02i", [minutes,seconds])
        }
    }
    
    func addTimeObserver() {
        
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self]
            time in
            
            guard let currentItem = self?.player.currentItem else { return }
            
            self?.sliderBar.maximumValue = Float(currentItem.duration.seconds)
            self?.sliderBar.minimumValue = 0
            self?.sliderBar.value = Float(currentItem.currentTime().seconds)
            self?.currentTime.text = self?.getTimeString(from: currentItem.currentTime())
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = AVPlayer(url: url! )
        
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        addTimeObserver()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        
        playerLayer.frame = videoView.bounds
        
        videoView.layer.addSublayer(playerLayer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playerLayer.frame = videoView.bounds

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        

    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if UIDevice.current.orientation.isLandscape {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            
            screenButton.setImage(#imageLiteral(resourceName: "full_screen_exit"), for: .normal)
            
            let originalPlay = UIImage(named: "play_button")
            let renderedPlay = originalPlay?.withRenderingMode(.alwaysTemplate)
            playButton.setImage(renderedPlay, for: .normal)
            playButton.tintColor = UIColor.white
            
            let originalForward = UIImage(named: "fast_forward")
            let renderedForward = originalForward?.withRenderingMode(.alwaysTemplate)
            forwardButton.setImage(renderedForward, for: .normal)
            forwardButton.tintColor = UIColor.white
            
            let originalBackward = UIImage(named: "rewind")
            let renderedBackward = originalBackward?.withRenderingMode(.alwaysTemplate)
            backwardButton.setImage(renderedBackward, for: .normal)
            backwardButton.tintColor = UIColor.white
            
            let originalSound = UIImage(named: "volume_off")
            let renderedSound = originalSound?.withRenderingMode(.alwaysTemplate)
            soundButton.setImage(renderedSound, for: .normal)
            soundButton.tintColor = UIColor.white
            
            let originalScreen = UIImage(named: "full_screen_exit")
            let renderedScreen = originalScreen?.withRenderingMode(.alwaysTemplate)
            screenButton.setImage(renderedScreen, for: .normal)
            screenButton.tintColor = UIColor.white
            
            totalDuration.textColor = UIColor.white
            currentTime.textColor = UIColor.white

        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            
            playButton.setImage(#imageLiteral(resourceName: "play_button"), for: .normal)
            forwardButton.setImage(#imageLiteral(resourceName: "fast_forward"), for: .normal)
            backwardButton.setImage(#imageLiteral(resourceName: "rewind"), for: .normal)
            soundButton.setImage(#imageLiteral(resourceName: "volume_off"), for: .normal)
            screenButton.setImage(#imageLiteral(resourceName: "full_screen_button"), for: .normal)
            
            totalDuration.textColor = UIColor.black
            currentTime.textColor = UIColor.black

        }
    }
    
    
    @IBAction func toFullScreen(_ sender: Any) {
        
        if isRotated {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
            screenButton.setImage(#imageLiteral(resourceName: "full_screen_exit"), for: .normal)
            
        } else {
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
            screenButton.setImage(#imageLiteral(resourceName: "full_screen_button"), for: .normal)
        }
        
    }
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .landscapeLeft
//    }
//
//    override var shouldAutorotate: Bool {
//        return true
//    }
    

}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }}
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }}
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }}}

