//
//  SpotifyAuthViewController.swift
//  MusicMind
//
//  Created by Ryan Boyd on 3/17/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class SpotifyAuthViewController: UIViewController {
    
    @IBAction func onSpotifyButtonPress(_ sender: UIButton) {
        if let auth = SPTAuth.defaultInstance() {
            auth.clientID = "85374bf3879843d6a7b6fd4e62030d97"
            auth.redirectURL = URL(string: "musicmind://returnAfterLogin")
            auth.sessionUserDefaultsKey = "currentKey"
            auth.requestedScopes = [SPTAuthStreamingScope]
            
            if auth.session != nil {
                //TODO Store session in UserDefaults
                print(auth.session.accessToken)
                print(auth.session.canonicalUsername)
            }
            else {
                if let spotifyUrl = auth.spotifyWebAuthenticationURL() {
                    UIApplication.shared.open(spotifyUrl, options: [:])
                }
            }
        }

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
