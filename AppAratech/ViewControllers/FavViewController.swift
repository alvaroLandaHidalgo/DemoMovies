//
//  FavViewController.swift
//  AppAratech
//
//  Created by alvaro Landa Hidalgo on 8/8/21.
//

import Foundation
import UIKit
import SDWebImage

class FavViewController: UIViewController, UITableViewDelegate,UITableViewDataSource , UITabBarDelegate, UITabBarControllerDelegate {
    
    @IBOutlet weak var FavTableView: UITableView!
    
    @IBOutlet weak var FavTabBar: UITabBar!
    
    var FavArray = [Movie]()
    
    override func viewDidLoad() {
        
        FavTabBar.delegate = self
        FavTabBar.tintColor = .red
        
        FavTableView.delegate = self
        FavTableView.dataSource = self
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "FavTableViewCell"
        let firstparturl = "https://image.tmdb.org/t/p/w500/"
        
        let cell: FavMovieCell = tableView.dequeueReusableCell(withIdentifier: identifier,  for:indexPath) as! FavMovieCell
        let posterPath = firstparturl + self.FavArray[indexPath.row].poster_path
        
        cell.FavImageCell.sd_setImage(with: URL(string: posterPath))
        cell.FavTitleCell.text = self.FavArray[indexPath.row].title
        cell.FavDescription.text = self.FavArray[indexPath.row].overview
        
        return cell
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        print("ñam \(item.tag)")

        if item.tag == 0 {

            
            self.dismiss(animated: true, completion: {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                vc.moviesFav = self.FavArray
                self.present(vc, animated: true)
            })
        }else if item.tag == 1 {
            /*
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FavViewController") as! FavViewController
            vc.FavArray = moviesFav
            self.present(vc, animated: true)
             */
        }
    }
    
}
