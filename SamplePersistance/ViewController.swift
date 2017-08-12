//
//  ViewController.swift
//  SamplePersistance
//
//  Created by RAJAN on 8/10/17.
//  Copyright © 2017 RAJAN. All rights reserved.
//

import UIKit
import RealmSwift

class People: Object {
    
    public dynamic var name: String = ""
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var people: [People] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        load()
    }

    @IBAction func addName(_ sender: Any) {
    
        let alertV = UIAlertController(title: "New name", message: "Add a new name ", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
        
            (alert: UIAlertAction!) in
            guard let textField = alertV.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
            self.save(name: nameToSave)
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertV.addTextField()
        
        alertV.addAction(saveAction)
        alertV.addAction(cancelAction)
        
        present(alertV, animated: true)
    }
    
    private func save(name: String) {
        
        let entity = People()
        entity.name = name
        
        do {
            try realm.write {
                realm.add(entity)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        people.append(entity)
    }
    
    private func load() {
        
        do {
            
            people = Array(realm.objects(People.self))
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

// MARK: - UITableViewDataSource
extension ViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let person = people[indexPath.row]
        
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        return cell
    }
}

