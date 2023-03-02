//
//  CharacterDetailViewController.swift
//  TheAvengersiOS4
//
//  Created by Matthew Hill on 3/1/23.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var characterPictureImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var comicsLabel: UILabel!
    @IBOutlet weak var comicListTableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        comicListTableView.dataSource = self
        comicListTableView.delegate = self
        updateUI()
    }
    
    // MARK: - Properties
    var character: Character?
    
    
    // MARK: - Functions
    
    func updateUI() {
        guard let character = character else {return}
        CharacterService.fetchCharacterImage(for: character) { [weak self] result in
            switch result {
                
            case .success(let image):
                DispatchQueue.main.async {
                    self?.characterPictureImageView.image = image
                    self?.characterNameLabel.text = character.characterName
                    self?.comicsLabel.text = "Appears in \(character.comicsAppearingIn.available) Comics"
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Extension
extension CharacterDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return character?.comicsAppearingIn.available ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = comicListTableView.dequeueReusableCell(withIdentifier: "comicCell", for: indexPath)
        
        
        return cell
    }
    
    
}
