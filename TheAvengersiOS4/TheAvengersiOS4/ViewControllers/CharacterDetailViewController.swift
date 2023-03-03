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
    var comicDic: ComicTopLevelDict?
    var comics: [Comic] = []
    var offset = 0
    
    
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
        fetchComicList(forCharacter: character)
    }
    
    func fetchComicList(forCharacter character: Character) {
        ComicService.fetchComicList(paginationOffset: String(offset), forCharacter: character) { [weak self] result in
            switch result {
                
            case .success(let topLevel):
                self?.comicDic = topLevel
                self?.comics = topLevel.topLevelDict.comics
                DispatchQueue.main.async {
                    self?.comicListTableView.reloadData()
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
        return comics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = comicListTableView.dequeueReusableCell(withIdentifier: "comicCell", for: indexPath) as? CharacterComicListTableViewCell else {return UITableViewCell()}
        
        let comic = comics[indexPath.row]
        cell.fetchComicImage(forComic: comic)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let character = character else { return }
        guard let comicDic = comicDic else { return }
        
        if indexPath.row == comics.count - 1 && comics.count <= comicDic.topLevelDict.count {
            offset += 50
            ComicService.fetchComicList(paginationOffset: String(offset), forCharacter: character) { [weak self] result in
                switch result {
                    
                case .success(let topLevel):
                    self?.comicDic = topLevel
                    self?.comics.append(contentsOf: topLevel.topLevelDict.comics)
                    DispatchQueue.main.async {
                        self?.comicListTableView.reloadData()
                    }
                case .failure(let error):
                    print(error.errorDescription ?? "Uknown Error")
                }
            }
        }
    }
}
