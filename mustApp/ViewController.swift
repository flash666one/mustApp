//
//  ViewController.swift
//  mustApp
//
//  Created by Артём Горюнов on 08.12.2017.
//  Copyright © 2017 Артём Горюнов. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var labelsStack: UIStackView!
    
    @IBOutlet weak var myView: UICollectionView!

    @IBOutlet weak var secondView: UICollectionView!
    
    @IBOutlet weak var shade: UIView!
    
    
    private var activeCell : VideoCell!
    
    let imageArray: [UIImage] = [ #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "5")]
    
    var itemWidth = 150
    var itemHeight = 200
    
    var itemIndicator = true
    var touchIndicator = true
    var secondIndicator = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.dataSource = self
        myView.delegate = self
        secondView.dataSource = self
        secondView.delegate = self
        setUpView()
        itemWidth = Int(self.view.frame.width / 2)
        itemHeight = Int(self.view.frame.width / 4)
    }


    func setUpView() {
        // на ячейку
        let itemRecognizer = UIPanGestureRecognizer(target: self, action: #selector(catchTouch))
        myView.addGestureRecognizer(itemRecognizer)
        
        // на 2й контролер
        let viewRecognizer = UIPanGestureRecognizer(target: self, action: #selector(viewTouch))
        secondView.addGestureRecognizer(viewRecognizer)


        // на лейбл
        let secondViewRecognizer = UIPanGestureRecognizer(target: self, action: #selector(shadeGesture))
        shade.addGestureRecognizer(secondViewRecognizer)

        itemRecognizer.isEnabled = itemIndicator
        viewRecognizer.isEnabled = touchIndicator
        secondViewRecognizer.isEnabled = secondIndicator
        
        
    }
    
    
    
    

    
    @objc func shadeGesture(gesture: UISwipeGestureRecognizer){
        print("шторка")
        let point = gesture.location(in: view)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: point.y - point.y / 4, height: point.y)
        myView.scrollsToTop = true
        myView.collectionViewLayout = layout
        if gesture.state == .changed {
            myView.frame.size.height = point.y
            shade.frame.origin.y = point.y
            secondView.frame.origin.y = point.y + shade.frame.height
            secondView.frame.size.height = view.frame.size.height - point.y
            self.myView.frame.origin.y = self.labelsStack.frame.height
            self.shade.frame.origin.y = self.labelsStack.frame.height + self.myView.frame.height
            self.secondView.frame.origin.y = self.shade.frame.height + self.labelsStack.frame.height + self.myView.frame.height
        } else if gesture.state == .ended  {
            if point.y <= self.view.frame.size.height - self.view.frame.size.height / 3 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.myView.frame.size.height = self.view.frame.size.height / 3
                    self.myView.scrollsToTop = true
                    self.myView.frame.origin.y = self.labelsStack.frame.height
                    self.shade.frame.origin.y = self.labelsStack.frame.height + self.myView.frame.height
                    self.secondView.frame.origin.y = self.shade.frame.height + self.labelsStack.frame.height + self.myView.frame.height
                    
                    self.shade.frame.origin.y = self.view.frame.size.height / 3 + self.shade.frame.size.height
                    self.secondView.frame.size.height = self.view.frame.size.height - self.view.frame.size.height / 3
                    layout.itemSize = CGSize(width: 150, height: 200)
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.myView.frame.size.height = 500
                    self.myView.frame.origin.y = self.labelsStack.frame.height
                    self.shade.frame.origin.y = self.labelsStack.frame.height + self.myView.frame.height
                    self.secondView.frame.origin.y = self.shade.frame.height + self.labelsStack.frame.height + self.myView.frame.height
                    self.secondView.frame.size.height = self.view.frame.size.height - 350
                    layout.itemSize = CGSize(width: 300, height: 400)
                })
            }
        }
        
    }
    
    
    @objc func viewTouch(gesture : UISwipeGestureRecognizer){
        let point = gesture.location(in: secondView)
        print("нижний View + \(point)")
    }
    
    
    
    
    func getCellAtPoint(point: CGPoint) -> VideoCell? {
        if let indexPath = myView.indexPathForItem(at: point) {
            return myView.cellForItem(at: indexPath) as? VideoCell
        }
        return nil
    }
    
    
    @objc func catchTouch(gesture: UIPanGestureRecognizer){
        print("ячейка")
        if gesture.state == .changed {
            let point = gesture.location(in: myView)
            if let cell = getCellAtPoint(point: point) {
                cell.frame.origin.y = point.y - cell.frame.height / 2
            }
            resetLabels()
            selectLabel(for: point)
        } else if gesture.state == .ended {
            let point = gesture.location(in: myView)
            if let cell = getCellAtPoint(point: point) {
                UIView.animate(withDuration: 0.3, animations: {
                    cell.frame.origin.y = 0
                })
            }
            resetLabels()
        }
    }
    
    func resetLabels() {
        for view in labelsStack.arrangedSubviews {
            let label = view as? UILabel
            label?.textColor = .darkGray
        }
    }
    
    func selectLabel(for point: CGPoint) {
        let ratio = point.y / myView.frame.height
        if ratio < 1/3 {
            let label = labelsStack.arrangedSubviews[0] as? UILabel
            label?.textColor = .black
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        } else if ratio < 2/3 {
            let label = labelsStack.arrangedSubviews[1] as? UILabel
            label?.textColor = .black
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        } else {
            let label = labelsStack.arrangedSubviews[2] as? UILabel
            label?.textColor = .black
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = myView.cellForItem(at: indexPath)
        if activeCell != nil && activeCell != cell {
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == myView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! VideoCell
            
            cell.myImageView.image = imageArray[indexPath.row]
            cell.tag = indexPath.row
            
            return cell
        } else { if collectionView == secondView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath as IndexPath) as! SecondVideoViewCell
            
            cell.myImageView.image = imageArray[indexPath.row]
            cell.tag = indexPath.row
            
            return cell
            }
            
        }
        return UICollectionViewCell()
    }
    
    
}


