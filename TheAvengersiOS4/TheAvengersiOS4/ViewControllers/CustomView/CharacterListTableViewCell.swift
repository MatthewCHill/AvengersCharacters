//
//  CharacterListTableViewCell.swift
//  TheAvengersiOS4
//
//  Created by Matthew Hill on 3/1/23.
//

import UIKit



class CharacterListTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var avengerImageLabel: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    
    // MARK: - Functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterNameLabel.text = nil
        avengerImageLabel.image = nil
    }
    
    func fetchCharacterImage(forCharacter character: Character) {
        CharacterService.fetchCharacterImage(for: character) { [weak self] result in
            switch result {
                
            case .success(let character):
                DispatchQueue.main.async {
                    self?.avengerImageLabel.image = character
                }
            case .failure(let error):
                print(error.errorDescription ?? "Unknown Error")
            }
        }
    }
    
    func updateUI(forCharacter character: Character) {
        CharacterService.fetchCharacter(forCharacter: character) { [weak self] result in
            switch result {
                
            case .success(let character):
                DispatchQueue.main.async {
                    self?.characterNameLabel.text = character.characterName
                }
            case .failure(let error):
                print(error.errorDescription ?? "Unknown Error")
            }
        }
    }
    
    
    
}
