//
//  LoadingViewController.swift
//  Mist
//
//  Created by Jack Cook on 3/12/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import StackBluriOS
import SwiftyJSON
import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet var background: UIImageView!
    @IBOutlet var imageView: UIImageView!
    
    var imageTimer: NSTimer!
    var currentImage = 0
    var animationFinished = false
    var finishedRequests = 0
    
    var forecast: ForecastAPI!
    var photos: [Photo]!
    var firstImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "Background-01")?.stackBlur(85)
        background.image = backgroundImage
        
        loadForecast()
        loadImages()
        
        imageTimer = NSTimer.scheduledTimerWithTimeInterval(0.025, target: self, selector: "updateLoader", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(imageTimer, forMode: NSRunLoopCommonModes)
    }
    
    func loadForecast() {
        ForecastAPI.getCurrentConditions("New York, NY", completion: { (forecast, error) -> Void in
            self.forecast = forecast
            self.finishedRequests += 1
            self.finish()
        })
    }
    
    func loadImages() {
        Flickr.getPhoto("New York, NY") { (photos) -> Void in
            self.photos = photos
            self.finishedRequests += 1
            self.finish()
            
            Mozart.load(self.photos[0].imageURL()).completion { (image) -> Void in
                self.firstImage = image.stackBlur(10)
                self.finishedRequests += 1
                self.finish()
            }
        }
    }
    
    func finish() {
        if (finishedRequests == 3) && animationFinished {
            self.performSegueWithIdentifier("mainSegue", sender: self)
            imageTimer.invalidate()
        }
    }
    
    func updateLoader() {
        let imageName = NSString(format: "%05d", currentImage)
        let image = UIImage(named: imageName)
        imageView.image = image
        
        currentImage += 1
        
        if currentImage == 150 {
            currentImage = 0
            animationFinished = true
            finish()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let mvc = segue.destinationViewController as MainViewController
        mvc.loadData(forecast, photos: photos, firstImage: firstImage)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
