//
//  SecondViewController.swift
//  NPF-4
//
//  Created by Ellie on 4/14/20.
//  Copyright © 2020 Ellie. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    
    let table: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorColor = UIColor.white
        return tv
    }()
    
    var parks: [Park] = []
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Get all of the parks from the SceneDelegate
        let scene = UIApplication.shared.connectedScenes.first
        if let delegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            parks = delegate.parks
        }
        
        table.delegate = self
        table.dataSource = self
        table.register(ParkTableViewCell.self, forCellReuseIdentifier: "cellId")
        view.addSubview(table)
        
        NSLayoutConstraint.activate([
        table.topAnchor.constraint(equalTo: self.view.topAnchor),
        table.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        table.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        table.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ParkTableViewCell
        cell.label.text = parks[indexPath.row].getParkName()
        cell.subtitle.text = "Distance: " + parks[indexPath.row].getArea()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ParkDetailViewController
        {
            let vc = segue.destination as? ParkDetailViewController
            vc?.setPark(setPark: parks[selectedIndex])
        }
    }
    
    func showMap(park: Park){
        let scene = UIApplication.shared.connectedScenes.first
        if let delegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            delegate.tabBar?.selectedIndex = 0
        }
        let mapView  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        mapView.setLocation(location: park.getLocation()!)
    }
}
