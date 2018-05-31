//
//  addSearchTableViewController.swift
//  flowOfTheDay
//
//  Created by Alexis Benoliel on 28/05/2018.
//  Copyright © 2018 Alexis Benoliel. All rights reserved.
//

import UIKit

class addSearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var tableSearch: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var animalArray = [Animal]()
    
    var currentAnimalArray = [Animal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAnimals()
        setUpSearchBar()

    }
    
    private func setUpAnimals() {
        animalArray.append(Animal(name: "style1", category: .style))
        animalArray.append(Animal(name: "style2", category: .style))
        
        animalArray.append(Animal(name: "sexe1", category: .sexe))
        animalArray.append(Animal(name: "sexe2", category: .sexe))
        
        animalArray.append(Animal(name: "saison1", category: .saison))
        animalArray.append(Animal(name: "saison2", category: .saison))
        
        animalArray.append(Animal(name: "général1", category: .general))
        animalArray.append(Animal(name: "général2", category: .general))
        
        currentAnimalArray = animalArray

    }
    
    private func setUpSearchBar() {
        
//        tableSearch.dataSource = self
//        tableSearch.delegate = self
        searchBar.delegate = self
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // data

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentAnimalArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? addSearchTableViewCell else {
            return UITableViewCell();
        }
        
        cell.tagBtn.setTitle(currentAnimalArray[indexPath.row].name, for: .normal)
        return cell
        
    }
    
    // collection
    
    // search bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            currentAnimalArray = animalArray
            tableSearch.reloadData()
            return
        }
        
        currentAnimalArray = animalArray.filter({ animal -> Bool in
//            return animal.name.localizedCaseInsensitiveContains(searchText)
            
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty {return true}
                return animal.name.localizedCaseInsensitiveContains(searchText)
            case 1:
                if searchText.isEmpty {return animal.category == .general}
                return animal.name.localizedCaseInsensitiveContains(searchText) && animal.category == .general
            case 2:
                if searchText.isEmpty {return animal.category == .sexe}
                return animal.name.localizedCaseInsensitiveContains(searchText)  && animal.category == .sexe
            case 3:
                if searchText.isEmpty {return animal.category == .style}
                return animal.name.localizedCaseInsensitiveContains(searchText) && animal.category == .style
            case 4:
                if searchText.isEmpty {return animal.category == .saison}
                return animal.name.localizedCaseInsensitiveContains(searchText) && animal.category == .saison
            default:
                return false
            }
        })
        
        tableSearch.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            currentAnimalArray = animalArray
        case 1:
            currentAnimalArray = animalArray.filter({ animal -> Bool in
                animal.category == AnimalType.general
            })
        case 2:
            currentAnimalArray = animalArray.filter({ animal -> Bool in
                animal.category == AnimalType.sexe
            })
        case 3:
            currentAnimalArray = animalArray.filter({ animal -> Bool in
                animal.category == AnimalType.style
            })
        case 4:
            currentAnimalArray = animalArray.filter({ animal -> Bool in
                animal.category == AnimalType.saison
            })
        default:
            break
        }
        tableSearch.reloadData()
    }

}

class Animal {
    let name: String
    let category: AnimalType
    let selected: Bool
    
    init(name: String, category: AnimalType) {
        self.name = name
        self.category = category
        self.selected = false
    }
}

enum AnimalType: String {
    case style = "style"
    case sexe = "sexe"
    case saison = "saison"
    case general = "general"
}
