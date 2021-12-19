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
        
        // Using The method in TaskModel to make request to localhost server to get tasks and add them in list array to display them in table
        TaskModel.getAllTasks() {
            data, response, error in
            do {
                if let tasks = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                    for task in tasks {
                        if let task = task as? NSDictionary{
                            self.list.append(task["objective"] as! String)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Something went wrong")
            }
        }
        super.viewDidLoad()
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
        if sender is UIBarButtonItem {
            let navigationController = segue.destination as! UINavigationController
            let addItemTableViewController = navigationController.topViewController as! AddItemViewController
            addItemTableViewController.delegate = self
        }else if sender is IndexPath {
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

