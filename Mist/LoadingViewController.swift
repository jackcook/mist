//
//  LoadingViewController.swift
//  Mist
//
//  Created by Jack Cook on 3/12/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import StackBluriOS
import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet var background: UIImageView!
    @IBOutlet var imageView: UIImageView!
    
    var imageTimer: NSTimer!
    var currentImage = 0
    var canSegue = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "Background-01")?.stackBlur(85)
        background.image = backgroundImage
        
        imageTimer = NSTimer.scheduledTimerWithTimeInterval(0.035, target: self, selector: "updateLoader", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(imageTimer, forMode: NSRunLoopCommonModes)
        
        println(Keys.openWeatherKey())
    }
    
    func updateLoader() {
        let imageName = NSString(format: "%05d", currentImage)
        let image = UIImage(named: imageName)
        imageView.image = image
        
        currentImage += 1
        
        if currentImage == 150 {
            currentImage = 0
            canSegue = true
        }
    }
}
