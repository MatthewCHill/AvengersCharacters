//
//  CharacterListViewController.swift
//  TheAvengersiOS4
//
//  Created by Matthew Hill on 3/1/23.
//

import UIKit

class CharacterListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var characterListTableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        characterListTableView.delegate = self
        characterListTableView.dataSource = self
    }
    
    // MARK: - Properties
    
    
    
    // MARK: - Functions
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination. "characterDetailVC"
        // Pass the selected object to the new view controller.
    }
    */

}

extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath)
        
        return cell
    }
    
    
}
