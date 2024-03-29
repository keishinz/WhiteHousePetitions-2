//
//  ViewController.swift
//  WhiteHousePetitions-2
//
//  Created by Keishin CHOU on 2019/11/01.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var petitionResults = [Petition]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchBar.delegate = self
        
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self.parse(json: data)
                    return
                }
            }
            self.showError()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        return petitions.count
        return petitionResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

//        let petition = petitions[indexPath.row]
//        cell.textLabel?.text = petition.title
//        cell.detailTextLabel?.text = petition.body
        let petition = petitionResults[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetailViewController()
//        vc.detailItem = petitions[indexPath.row]
        vc.detailItem = petitionResults[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
//        DispatchQueue.main.async {
            self.searchBar.resignFirstResponder()
//        }
    }
    
    func parse(json: Data) {
        
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            petitionResults = jsonPetitions.results
            
//            for petition in petitions {
//                if petition.title.contains("Trump") || petition.body.contains("Trump") {
//                    petitionResults.append(petition)
//                }
//            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }

}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let keyWord = searchBar.text {
            petitionResults.removeAll()
            for petition in petitions {
                if petition.title.contains(keyWord) || petition.body.contains(keyWord) {
                    petitionResults.append(petition)
                }
            }
            tableView.reloadData()
        }
    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//
//        petitionResults = petitions
//        print(petitionResults)
//        tableView.reloadData()
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text!.isEmpty {
            
            petitionResults = petitions
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
}
