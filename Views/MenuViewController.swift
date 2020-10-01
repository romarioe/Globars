//
//  MenuViewController.swift
//  Globars
//
//  Created by Roman Efimov on 01.10.2020.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var unitsModel: UnitsModel?
    var unit: UnitsData?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    
    func showAlert(){
        let alert = UIAlertController(title: "", message: "Вы уверены, что хотите выйти?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Выход", style: UIAlertAction.Style.default, handler: { action in
            
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)

        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    

    @IBAction func logoutButtonClick(_ sender: Any) {
        showAlert()
    }
    

}



extension MenuViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unitsModel?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = unitsModel?.data[indexPath.row].name ?? ""
        return cell
    }
    
    
}



extension MenuViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        unit = unitsModel?.data[indexPath.row]
        performSegue(withIdentifier: "unwindToMap", sender: self)
    }
    
    
   
}
