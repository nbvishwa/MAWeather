//
//  SearchViewController.swift
//  MAWeather
//
//  Created by Vishwavijet on 09/12/18.
//  Copyright © 2018 Tarento. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar:UISearchBar!
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var userEntered: ((_ cityName: String) -> Void)?
    var cities : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cities = ServiceManager().getRecordsFromCoreData()
        self.updateUI()
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        // Do any additional setup after loading the view.
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
//        request.returnsObjectsAsFaults = false
//        do {
//            let result = try context.fetch(request)
//            for data in result as! [NSManagedObject] {
//                print(data.value(forKey: "cityName") as! String)
//            }
//            self.cities = result as! [NSManagedObject]
//            self.updateUI()
//        } catch {
//
//            print("Failed")
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.becomeFirstResponder()
        self.updateUI()
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.labelInfo.isHidden = self.cities.count == 0 ? true : false
            self.tableView.isHidden = self.cities.count > 0 ? false : true
            self.tableView.reloadData()
        }
    }
    
    //UISearchBar delegate Methods
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            self.searchBar.resignFirstResponder()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.userEntered?(searchBar.text!)
            self.dismiss(animated: true, completion: nil)
        }
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell")
        let cityObject = cities[indexPath.row]
        cell?.textLabel?.text = cityObject
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityObject = cities[indexPath.row]
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.userEntered?(cityObject)
        self.dismiss(animated: true, completion: nil)
    }
}
