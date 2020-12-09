//
//  ViewController.swift
//  FlashLight
//
//  Created by Станислав Лемешаев on 09.12.2020.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var result: UIImageView!
    
    var activeCells = [IndexPath]()
    var flashSequence = [IndexPath]()
    var levelCounter = 1
    
    let levels = [
        [6, 7, 8], // 3 lights
        [1, 3, 11, 13], // 4
        [5, 6, 7, 8, 9], // 5
        [0, 4, 5, 9, 10, 14], // 6
        [1, 2, 3, 7, 11, 12, 13], // 7
        [0, 2, 4, 5, 9, 10, 12, 14] // 8
    ]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createLevel()
    }

}

// MARK: - CollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
}

// MARK: - CollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    
}

// MARK: - Extension for ViewController
extension ViewController {
    
    func createLevel() {
        // 1
        guard levelCounter < levels.count else { return }
        result.alpha = 0
        collectionView.visibleCells.forEach { $0.isHidden = true }
        activeCells.removeAll()
        
        // 2
        for item in levels[levelCounter] {
            let indexPath = IndexPath(item: item, section: 0)
            activeCells.append(indexPath)
            
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.isHidden = false
        }
        
        // 3
        activeCells = (activeCells as NSArray).shuffled() as! [IndexPath]
        flashSequence = Array(activeCells.dropFirst())
    }
    
}
