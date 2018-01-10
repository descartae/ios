//
//  TypesOfWastePreviewViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 11/12/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit

class TypesOfWastePreviewViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var collectionView: UICollectionView!

    var typesOfWaste: [DisposalFacility.TypesOfWaste]!

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension TypesOfWastePreviewViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typesOfWaste.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeOfWasteCollectionViewCell.identifier, for: indexPath) as? TypeOfWasteCollectionViewCell {
            let typeOfWaste = typesOfWaste[indexPath.row]
            cell.typeOfWaste = typeOfWaste
            cell.presentTypeOfWasteModal = { [weak self] in
                guard let storyboard = self?.storyboard else {
                    return
                }

                let typesOfWasteDetailsId = TypeOfWasteDetailsViewController.identifier
                guard let typesOfWasteDetails = storyboard.instantiateViewController(withIdentifier: typesOfWasteDetailsId) as? TypeOfWasteDetailsViewController else {
                    return
                }

                typesOfWasteDetails.typeOfWaste = typeOfWaste
                self?.present(typesOfWasteDetails, animated: true, completion: nil)
            }

            return cell
        }

        return UICollectionViewCell()
    }

}

extension TypesOfWastePreviewViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return TypeOfWasteCollectionViewCell.itemSize
    }

}
