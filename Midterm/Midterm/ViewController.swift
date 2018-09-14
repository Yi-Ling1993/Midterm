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
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    var isVideoPlaying = false
    
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
        
        let time: CMTime = CMTimeMake(Int64(newTime * 1000), 1000)
        
        player.seek(to: time)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = AVPlayer(url: url! )
        
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
        
//        playerLayer.frame = videoView.bounds

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


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

