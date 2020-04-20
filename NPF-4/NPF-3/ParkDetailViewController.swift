//
//  ParkDetailViewController.swift
//  NPF-4
//
//  Created by Ellie on 4/14/20.
//  Copyright © 2020 Ellie. All rights reserved.
//

import UIKit

class ParkDetailViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
   
    let table: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorColor = UIColor.white
        return tv
    }()
    
    var park: Park = Park()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setPark(setPark: Park){
        park = setPark;
        
        table.delegate = self
        table.dataSource = self
        table.register(ParkDetailTableViewCell.self, forCellReuseIdentifier: "name")
        table.register(ParkLocationTableViewCell.self, forCellReuseIdentifier: "location")
        table.register(ParkAreaTableViewCell.self, forCellReuseIdentifier: "area")
        table.register(ParkDateTableViewCell.self, forCellReuseIdentifier: "date")
        table.register(ParkImageTableViewCell.self, forCellReuseIdentifier: "img")
        table.register(ParkDescTableViewCell.self, forCellReuseIdentifier: "desc")
        table.register(ParkWikiTableViewCell.self, forCellReuseIdentifier: "wiki")
        table.register(ParkMapTableViewCell.self, forCellReuseIdentifier: "map")
        view.addSubview(table)
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: self.view.topAnchor),
            table.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            table.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            table.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else if indexPath.row == 4 {
            return 300
        } else if indexPath.row == 5 {
            return 150
        } else if indexPath.row == 6 {
            return 50
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = table.dequeueReusableCell(withIdentifier: "name", for: indexPath) as! ParkDetailTableViewCell
            cell.parkName.text = park.getParkName()
            return cell
        } else if indexPath.row == 1 {
            let cell = table.dequeueReusableCell(withIdentifier: "location", for: indexPath) as! ParkLocationTableViewCell
            cell.location.text = park.getParkLocation()
            return cell
        } else if indexPath.row == 2 {
           let cell = table.dequeueReusableCell(withIdentifier: "area", for: indexPath) as! ParkAreaTableViewCell
           cell.area.text = park.getArea()
           return cell
        } else if indexPath.row == 3 {
            let cell = table.dequeueReusableCell(withIdentifier: "date", for: indexPath) as! ParkDateTableViewCell
            cell.dateFormed.text = park.getDateFormed()
            return cell
        } else if indexPath.row == 4 {
            let cell = table.dequeueReusableCell(withIdentifier: "img", for: indexPath) as! ParkImageTableViewCell
            if let url = URL(string: park.getImageLink())
            {
              if let data = try? Data(contentsOf: url)
              {
                cell.imageView?.image = UIImage(data: data)
              }
            }
            return cell
        } else if indexPath.row == 5 {
            let cell = table.dequeueReusableCell(withIdentifier: "desc", for: indexPath) as! ParkDescTableViewCell
            cell.desc.text = park.getParkDescription()
            return cell
        } else if indexPath.row == 6 {
            let cell = table.dequeueReusableCell(withIdentifier: "wiki", for: indexPath) as! ParkWikiTableViewCell
            cell.wiki.text = park.getLink()
            return cell
        } else {
            let cell = table.dequeueReusableCell(withIdentifier: "map", for: indexPath) as! ParkMapTableViewCell
            cell.label.text = "Show on Map"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6 {
            // Open wiki
            if let url = URL(string: park.getLink()) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        } else if indexPath.row == 7 {
            // Open map
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
            let view  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
            view.showMap(park: park)
        }
    }

}
