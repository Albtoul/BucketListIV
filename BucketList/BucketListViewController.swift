//
//  ViewController.swift
//  BucketList
//
//  Created by Hell on 11/12/2021.
//

import UIKit

class BucketListViewController: UITableViewController, AddButtonsDelegate{
    
    func cancelButtonPressed(by controller: AddItemViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveButtonPressed(by controller:AddItemViewController, with text:String, indexPath:IndexPath?){
        
        if let ip = indexPath {
            list[ip.row] = text
            
        }else{
            list.append(text)
        }
        
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
    var list : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath)
        
        cell.textLabel?.text = list[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            let navigationController = segue.destination as! UINavigationController
            let addItemTableViewController = navigationController.topViewController as! AddItemViewController
            addItemTableViewController.delegate = self
        }else if segue.identifier == "EditItemSegue" {
            let navigationController = segue.destination as! UINavigationController
            let addItemTableViewController = navigationController.topViewController as! AddItemViewController
            addItemTableViewController.delegate = self
            let indexPath = sender as! IndexPath
            let item = list[indexPath.row]
            addItemTableViewController.item = item
            addItemTableViewController.index = indexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "EditItemSegue", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        list.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
}

