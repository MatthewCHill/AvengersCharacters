//
//  CharacterComicListTableViewCell.swift
//  TheAvengersiOS4
//
//  Created by Matthew Hill on 3/2/23.
//

import UIKit

class CharacterComicListTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var comicTitleLabel: UILabel!
    
    // MARK: - Functions
    override func prepareForReuse() {
        super.prepareForReuse()
        comicTitleLabel.text = nil
        comicImageView.image = nil
    }
    
    func fetchComicImage(forComic comic: Comic) {
        comicTitleLabel.text = comic.title
        ComicService.fetchComicImage(forComic: comic) { [weak self] result in
            switch result {
                
            case .success(let image):
                DispatchQueue.main.async {
                    self?.comicImageView.image = image
                }
            case .failure(let error):
                print(error.errorDescription ?? "Unknown Error")
            }
        }
        
    }

}
