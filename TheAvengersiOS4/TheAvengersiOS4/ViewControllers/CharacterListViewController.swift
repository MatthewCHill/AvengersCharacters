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
    var characters: [Character] = []
    var offset = 0
    
    // MARK: - Functions
    func fetchCharacterList() {
        
        CharacterService.fetchCharacterList(paginationOffset: String(offset)) { [weak self] result in
            switch result {
                
            case .success(let characters):
                self?.characters = characters
                DispatchQueue.main.async {
                    self?.characterListTableView.reloadData()
                }
                
            case .failure(let error):
                print(error.errorDescription ?? "Unknown Error")
            }
        }
    }
    

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
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as? CharacterListTableViewCell else { return UITableViewCell()}
        
        let character = characters[indexPath.row]
        
        return cell
    }
    
    
}
