//
//  ViewController.swift
//  MAWeather
//
//  Created by Vishwavijet on 09/12/18.
//  Copyright © 2018 Tarento. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let manager = ServiceManager()
    @IBOutlet weak var cityName : UILabel!
    @IBOutlet weak var cityTemp : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickOnSearch(_ sender: UIBarButtonItem) {
        guard let searchVC = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else {
            return
        }
        searchVC.userEntered = { (cityName) in
            self.manager.getWeatherData(for: cityName) { (data, error) in
                if (error != nil) {
                    let alert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                        self.cityName.text = data?.name
                        let font:UIFont? = UIFont(name: "Menlo", size:80)
                        let fontSuper:UIFont? = UIFont(name: "Menlo", size:30)
                        let tempInString = String(format: "%.0f", data!.temp!)
                        let attString:NSMutableAttributedString = NSMutableAttributedString(string: tempInString + "O", attributes: [.font:font!])
                        attString.setAttributes([.font:fontSuper!,.baselineOffset:40], range: NSRange(location:tempInString.count,length:1))
                        self.cityTemp.attributedText = attString
                    }
                }
                
            }
        }
    
        self.present(searchVC, animated: true, completion: nil)
    }


}

