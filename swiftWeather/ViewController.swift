//
//  ViewController.swift
//  swiftWeather
//
//  Created by Bezaliel Marvel on 10/05/2019.
//  Copyright © 2019 Bezaliel Marvel. All rights reserved.
//

import UIKit
import Weather

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let whiteGradient = UIImageView(frame: UIScreen.main.bounds)
        whiteGradient.image = UIImage(named: "white-gradient")
        whiteGradient.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(whiteGradient, at: 1)
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "clear-bg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

