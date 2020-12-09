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
    var flashSpeed = 0.25
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1 - disable user interaction on our view
        view.isUserInteractionEnabled = false
        
        // 2 - make the result image appear
        result.alpha = 1
        
        // 3 - if the user chose the correct answer
        if indexPath == activeCells[0] {
            // 4 - make result show the correct image, add 1 to levelCounter, then call createLevel()
            result.image = UIImage(named: "correct")
            levelCounter += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.createLevel()
            }
        } else {
            // 5 - otherwise the user chose wrongly, so show he "wrong" image then call gameOver()
            result.image = UIImage(named: "wrong")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.gameOver()
            }
        }
    }
    
    
}

// MARK: - Extension for ViewController
extension ViewController {
    
    // функция создания уровня
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.flashLight()
        }
    }
    
    // функция создания flashlight
    func flashLight() {
        
        // try to remove an item from the flash sequence
        if let indexPath = flashSequence.popLast() {
            
            // pull out the light at that position
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            
            // find the image
            guard let imageView = cell.contentView.subviews.first as? UIImageView else { return }
            
            // give it a green light
            imageView.image = UIImage(named: "greenLight")
            
            // make it slightly smaller
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            
            // start our animation
            UIView.animate(withDuration: flashSpeed, animations: {
                // make it return to normal size
                cell.transform = .identity
            }) { _ in
                
                // once the animation finishes make the light red again
                imageView.image = UIImage(named: "redLight")
                
                // wait a tiny amount of time
                DispatchQueue.main.asyncAfter(deadline: .now() + self.flashSpeed) {
                    // call ourselves again
                    self.flashLight()
                }
            }
        } else {
            // player need to guess
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.view.isUserInteractionEnabled = true
                self.setNeedsFocusUpdate()
            }
        }
    }
    
    // метод окончания игры
    func gameOver() {
        let alert = UIAlertController(title: "Game Over", message: "You made it to level \(levelCounter)", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Start again", style: .default) { _ in
            self.levelCounter = 1
            self.createLevel()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}
