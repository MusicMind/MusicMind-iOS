//
//  PagingViewController.swift
//  MusicMind
//
//  Created by Rich Ruais on 5/13/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class PagingViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var tracks = currentTracksInQueue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        self.setViewControllers([getViewControllerAtIndex(0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
    }
   
        
        func goToNextPage(){
            guard let currentViewController = self.viewControllers?.first else { return }
            guard let nextViewController = dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return }
            setViewControllers([nextViewController], direction: .forward, animated: false, completion: nil)
        }
        
        
        func goToPreviousPage(){
            guard let currentViewController = self.viewControllers?.first else { return }
            guard let previousViewController = dataSource?.pageViewController( self, viewControllerBefore: currentViewController ) else { return }
            setViewControllers([previousViewController], direction: .reverse, animated: false, completion: nil)
        }
    
    
    
    func slideToPage(index: Int, completion: (() -> Void)?) {
//        print("In Slide To Page    \(index)")
//        var ctrl = currentController() as! SpotifyPlayerViewController
//        var tempIndex = ctrl.pageIndex
//          print(tempIndex)
//        if tempIndex > index {
//            print("in Temp Index > index")
//            for i in tempIndex..<currentTracksInQueue.count {
//                goToNextPage()
//                if tempIndex == index {
//                    break
//                }
//            }
//            
//        }
//        else if tempIndex < index {
//            for i in tempIndex..<currentTracksInQueue.count {
//                goToPreviousPage()
//                if tempIndex == index {
//                    break
//                }
//            }
//        }
    }
    

    // MARK:- UIPageViewControllerDataSource Methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let pageContent: SpotifyPlayerViewController = viewController as! SpotifyPlayerViewController
        
        var index = pageContent.pageIndex
        
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        
        index -= 1;
        return getViewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let pageContent: SpotifyPlayerViewController = viewController as! SpotifyPlayerViewController
        
        var index = pageContent.pageIndex
        
        if (index == NSNotFound)
        {
            return nil;
        }
        
        index += 1;
        if (index == tracks.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index)
    }
    
    // MARK:- Other Methods
    func getViewControllerAtIndex(_ index: NSInteger) -> SpotifyPlayerViewController
    {
        // Create a new view controller and pass suitable data.
        let SpotifyPlayerViewController = self.storyboard?.instantiateViewController(withIdentifier: "SpotifyPlayerViewController") as! SpotifyPlayerViewController
        
        SpotifyPlayerViewController.bckImage = tracks[index].largeAlbumImage
        SpotifyPlayerViewController.albumImagelrg = tracks[index].largeAlbumImage
        SpotifyPlayerViewController.sngTitle = tracks[index].songTitle
        SpotifyPlayerViewController.artist = tracks[index].artist
        SpotifyPlayerViewController.album = tracks[index].albumName
        SpotifyPlayerViewController.duration = tracks[index].duration
        SpotifyPlayerViewController.pageIndex = index
        
        return SpotifyPlayerViewController
    }
    
    func currentController() -> UIViewController? {
        if (self.viewControllers?.count)! > 0 {
            return self.viewControllers![0]
        }
        return nil
    }
    
    func currentControllerIndex() -> Int {
        
        let pageItemController = self.currentController()
        if let controller = pageItemController as? SpotifyPlayerViewController {
            return controller.pageIndex
        }
        return -1
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
        
    }
    
    func pageViewController(_: UIPageViewController, didFinishAnimating: Bool, previousViewControllers: [UIViewController], transitionCompleted: Bool) {
        
        if transitionCompleted {
            let index = currentControllerIndex()
            currentTrackDetails = currentTracksInQueue[index]
            let spotifyPlayer = SpotifyPlayerViewController()
            spotifyPlayer.playSpotify(uri: currentTrackDetails.uri!)
        }
    }

    
}


