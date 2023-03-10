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
        fetchCharacterList()
        setUpActivityIndicator()
        stopAnimatingAndReloadData()
    }
    
    // MARK: - Properties
    var topLevel: CharacterListTopLevelDictionary?
    var characters: [Character] = []
    var offset = 0
    var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Functions
    func fetchCharacterList() {
        
        CharacterService.fetchCharacterList(paginationOffset: String(offset)) { [weak self] result in
            switch result {
                
            case .success(let topLevel):
                self?.topLevel = topLevel
                self?.characters = topLevel.data.results.filter({ character in
                    !character.characterImage.path.contains("image_not_available") && !character.characterImage.imageExtension.contains("gif")
                })
                DispatchQueue.main.async {
                    self?.characterListTableView.reloadData()
                }
                
            case .failure(let error):
                print(error.errorDescription ?? "Unknown Error")
            }
        }
    }
    
    func setUpActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        self.view.addSubview(activityIndicator)
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    func stopAnimatingAndReloadData() {
        DispatchQueue.main.async {
            self.characterListTableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "characterDetailVC" {
            guard let index = characterListTableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? CharacterDetailViewController else {return}
            let characterToSend = characters[index.row]
            destinationVC.character = characterToSend
        }
    }
    

}
// MARK: - Extension
extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as? CharacterListTableViewCell else { return UITableViewCell()}
        
        let character = characters[indexPath.row]
        cell.fetchCharacterImage(forCharacter: character)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            
            if indexPath.row == characters.count - 1 {
                offset += 20
                CharacterService.fetchCharacterList(paginationOffset: String(offset)) { [weak self] result in
                    switch result {
                    case .success(let topLevel):
                        self?.topLevel = topLevel
                        let newCharacters = topLevel.data.results.filter({ character in
                            !character.characterImage.path.contains("image_not_available") && !character.characterImage.imageExtension.contains("gif")
                        })
                        self?.characters.append(contentsOf: newCharacters)
                        DispatchQueue.main.async {
                            self?.characterListTableView.reloadData()
                        }
                    case .failure(let error):
                        print(error.errorDescription ?? "Unknown Error")
                    }
                }
            }
        }
}
