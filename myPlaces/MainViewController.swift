//
//  MainViewController.swift
//  myPlaces
//
//  Created by Артем Хребтов on 14.05.2021.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredCoctails: Results<Coctail>!
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    var coctails: Results<Coctail>!
    var ascendingSorting = true
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
   
    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!
    //var coctailsBar = Coctail.getCoctails()
    override func viewDidLoad() {
        super.viewDidLoad()
        coctails = realm.objects(Coctail.self)
        // Setup search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCoctails.count
        }
        return coctails.isEmpty ? 0 : coctails.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        var coctail = Coctail()
        if isFiltering {
            coctail = filteredCoctails[indexPath.row]
        } else {
            coctail = coctails[indexPath.row]
        }
        cell.nameLabel.text = coctail.name
        cell.locationLabel.text = coctail.ingridients
        cell.typeLabel.text = coctail.type
        cell.imageOfPlace.image = UIImage(data: coctail.imageData!)
      



        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace.clipsToBounds = true



        return cell
    }
    
 //MARK: Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let coctail = coctails[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (_,_,_) in
            
            StorageManager.deleteObject(coctail)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    
      //MARK: - Navigation
     
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            var coctail = Coctail()
            if isFiltering {
                coctail = filteredCoctails[indexPath.row]
            } else {
                coctail = coctails[indexPath.row]
            }
            
            let newCoctailVC = segue.destination as! NewPlaceViewController
            newCoctailVC.curentCoctail = coctail
        }
     }
     
    
    @IBAction func unwindSeque (_ segue: UIStoryboardSegue){
        guard let newCoctailVC = segue.source as? NewPlaceViewController else {return}
        newCoctailVC.saveCoctail()
        tableView.reloadData()
    }

    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        sorting()
    }
    
    
    
    @IBAction func reversedSorting(_ sender: Any) {
        ascendingSorting.toggle()
        if ascendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
    }
    
    private func sorting() {
        if segmentControl.selectedSegmentIndex == 0 {
            coctails = coctails.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            coctails = coctails.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
}

extension MainViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText (_ searchText: String){
        filteredCoctails = coctails.filter("name CONTAINS[c] %@ OR ingridients CONTAINS[c] %@", searchText, searchText)
        tableView.reloadData()
    }
}
