//
//  TableViewController.swift
//  RickAndMoryt2
//
//  Created by Anton Redkozubov on 26.08.2020.
//  Copyright © 2020 Anton Redkozubov. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchResultsUpdating {
    
    var data: [Character] = [
//        ["name": "Rick", "species": "Human", "image" : "noimage"],
//        ["name": "Morty", "species": "Human", "image" : "noimage"],
//        ["name": "Test", "species": "Test", "image" : "noimage"]
    ]
    var searchData : [Character] = []
    var info: CharacterList.Info?
    var searchController = UISearchController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        
        self.refreshControl?.addTarget(self, action: #selector(startLoad), for: .valueChanged)
        self.refreshControl?.beginRefreshing()
        startLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadCharacters(_ urlString: String) {
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            let decoder = JSONDecoder()
            let d = try! decoder.decode(CharacterList.self, from: data!)
            DispatchQueue.main.async {
                self.data += d.results!
                self.info = d.info
                self.dataLoaded()
            }
        }.resume()
    }
    
    @objc func startLoad() {
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(dataLoaded), userInfo: nil, repeats: false)
        loadCharacters("https://rickandmortyapi.com/api/character/")
    }
    
    @objc func dataLoaded() {
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
//        return (self.refreshControl!.isRefreshing) ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
  
        return (searchController.isActive ? searchData : data).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if self.searchController.isActive{
            cell.textLabel?.text = searchData[indexPath.row].name
            cell.detailTextLabel?.text = searchData[indexPath.row].species
            //            cell.imageView?.image = UIImage(data: data)
            URLSession.shared.dataTask(with: URL(string: searchData[indexPath.row].image)!) { (data, response, error) in
                DispatchQueue.main.async {
                    if cell.tag == indexPath.row{
                        cell.imageView?.image = UIImage(data: data!)
                    }
                }
            }
        }
        else {
            cell.textLabel?.text = data[indexPath.row].name
            cell.detailTextLabel?.text = data[indexPath.row].species
            cell.tag = indexPath.row
            URLSession.shared.dataTask(with: URL(string: data[indexPath.row].image)!) { (data, response, error) in
                DispatchQueue.main.async {
                    if cell.tag == indexPath.row {
                        cell.imageView?.image = UIImage(data: data!)
                    }
                }
            }.resume()
            cell.imageView?.image = UIImage(named:"noimage")
            
            if indexPath.row == data.count - 2 {
                loadCharacters(info!.next!)
            }
        }
        
        return cell
    }
        

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK - UISearchResultUpdatio
    func updateSearchResults(for searchController: UISearchController) {
        if let hero = searchController.searchBar.text {
            if hero.count >= 3 {
                if let url = URL(string: "https://rickandmortyapi.com/api/character/?name=\(hero)") {
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        let decoder = JSONDecoder()
                        let d = try! decoder.decode(CharacterList.self, from: data!)
                        DispatchQueue.main.async {
                            self.searchData = (d.error == nil ? d.results! : [])
                            //self.info = d.info
                            self.dataLoaded()
                        }
                    }.resume()
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
