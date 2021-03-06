//
//  GameViewController.swift
//  Jump!
//
//  Created by Kyle Minshall on 12/11/14.
//  Copyright (c) 2014 tmg. All rights reserved.
//

import UIKit
import SpriteKit
import iAd
import GameKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as StartScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

var adBannerView: ADBannerView!

class GameViewController: UIViewController, ADBannerViewDelegate, GKGameCenterControllerDelegate {
    
    var leaderboardIdentifier: String = ""
    var gameCenterEnabled: Bool = false
    
    func loadAds() {
        adBannerView = ADBannerView(frame: CGRectZero)
        adBannerView.hidden = true
        adBannerView.delegate = self
        view.addSubview(adBannerView)
    }
    
    func authenticate() {
        
        var player = GKLocalPlayer.localPlayer()
        player.authenticateHandler = {(var gameCenterVC: UIViewController!, var gameCenterError: NSError!) -> Void in
            
            if ((gameCenterVC) != nil) {
                self.presentViewController(gameCenterVC, animated: true, completion: nil)
            } else {
                
                if player.authenticated
                {
                    player.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (var leaderboardIdentifier: String!, var error: NSError!) -> Void in
                        if((error) != nil) {
                            NSLog("\(error.localizedDescription)")
                        } else {
                            self.leaderboardIdentifier = leaderboardIdentifier
                        }
                   })
                } else {
                    
                    println("not able to authenticate fail")
                    self.gameCenterEnabled = false
                    
                    if (gameCenterError != nil) {
                        println("\(gameCenterError.description)")
                    }
                    else {
                        println( "error is nil")
                    }
                }
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = StartScene(size: view.frame.size)
        // Configure the view.
        let skView = self.view as SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    
        loadAds()
    
        authenticate()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        adBannerView.center = CGPoint(x: adBannerView.center.x, y: view.bounds.size.height - adBannerView.frame.size.height/2)
        adBannerView.hidden = false
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        adBannerView.center = CGPoint(x: adBannerView.center.x, y: -100)
    }
}
