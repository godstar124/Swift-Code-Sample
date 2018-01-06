
//  RecommendationViewController.swift
//  CodeSampleSwift
//
//  Copyright © 2017 godstar124. All rights reserved.
//

import UIKit
import PINRemoteImage

class RecommendationViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var users = [User]()
    fileprivate let topIndex = IndexPath(item: 0, section: 0)
     
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateCollectionView()
        configurateNavigationBar()
        loadRecommendedUsers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: Configuration part
extension RecommendationViewController {
    fileprivate func configurateCollectionView() {
        (collectionView.collectionViewLayout as! SwipeableCollectionFlowLayout).gesturesEnabled = true
        (collectionView.collectionViewLayout as! SwipeableCollectionFlowLayout).delegate = self
    }
    
    fileprivate func configurateNavigationBar() {
        let imageView = UIImageView(image:UIImage(named: "tinder_match.png"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        navigationItem.titleView = imageView
    }
}

//MARK: Logic part
extension RecommendationViewController {
    fileprivate func appendUsers(loadedUsers: [User]) {
        let startIndex = users.count
        var indexes = [IndexPath]()
        
        users.append(contentsOf: loadedUsers)
        for i in startIndex..<users.count {
            indexes.append(IndexPath(item: i, section: 0))
        }
        
        collectionView.performBatchUpdates({ 
            self.collectionView.insertItems(at: indexes)
        }, completion: nil)
    }
    
    fileprivate func removeFirstUser() {
        users.removeFirst()
        collectionView.deleteItems(at: [topIndex])
        if users.count == 2 {
            loadRecommendedUsers()
        }
    }
}

//MARK: API part
extension RecommendationViewController {
    fileprivate func loadRecommendedUsers() {
        MembersService.recommendedUsers(success: { [weak self] (users) in
            self?.appendUsers(loadedUsers: users)
        }) { [weak self] (error) in
            AlertHelper.showMessage(message: error, controller: self)
        }
    }
    
    fileprivate func matchUser(matchType:String, userID:String) {
        UserService.matchUser(matchType: matchType, userID: userID) { [weak self] (error) in
            AlertHelper.showMessage(message: error, controller: self)
        }
    }
}

//MARK: SwipeableCollectionDelegate
extension RecommendationViewController: SwipeableCollectionDelegate {
    func cardDidFinishSwiping(direction: SwipeDirection) {
        switch direction {
        case .left:
            matchUser(matchType: UserMatch.pass.rawValue, userID: (self.users.first?.userID)!)
        case .right:
            matchUser(matchType: UserMatch.like.rawValue, userID: (self.users.first?.userID)!)
        }
        removeFirstUser()
    }
    
    func cardSwipeDidCancel() {
        if let cell = collectionView.cellForItem(at: topIndex) as? UserCollectionViewCell {
            cell.dislikeIcon.alpha = 0
            cell.likeIcon.alpha = 0
        }
    }
    
    func cardDidChangeSwipeProgress(progress: CGFloat, swipeDirection: SwipeDirection) {
        if let cell = collectionView.cellForItem(at: topIndex) as? UserCollectionViewCell {
            switch swipeDirection {
            case .left:
                cell.dislikeIcon.alpha = progress
                cell.likeIcon.alpha = 0
            case .right:
                cell.dislikeIcon.alpha = 0
                cell.likeIcon.alpha = progress
            }
        }
    }
}

//MARK: UICollectionViewDataSource
extension RecommendationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.reuseIdentifier, for: indexPath) as! UserCollectionViewCell
        configurate(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    private func configurate(cell: UserCollectionViewCell, atIndexPath indexPath: IndexPath) {
        let user = users[indexPath.row]
        if let userPhotoPath = user.photos.first?.url {
            if let url = URL(string: userPhotoPath) {
                cell.userAvatar.pin_setImage(from: url)
            }
        }
        cell.userName.text = user.name
        cell.userbio.text = user.bio
    }
}
