//
//  LoadingViewController.swift
//  Mist
//
//  Created by Jack Cook on 3/12/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet var background: UIImageView!
    @IBOutlet var imageView: UIImageView!
    
    var imageTimer: NSTimer!
    var currentImage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = UIImage(named: "Background-01")
        
        imageTimer = NSTimer.scheduledTimerWithTimeInterval(0.035, target: self, selector: "updateLoader", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(imageTimer, forMode: NSRunLoopCommonModes)
    }
    
    func updateLoader() {
        let imageName = NSString(format: "%05d", currentImage)
        let image = UIImage(named: imageName)
        imageView.image = image
        
        currentImage += 1
    }
}
