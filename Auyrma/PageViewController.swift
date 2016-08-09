//
//  PageViewController.swift
//  Auyrma
//
//  Created by MacBOOK PRO on 09.08.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    var words: [String]!
    var indexGlobal = 0
    var wordsDelegate: WordsIndexDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        if words.last != nil {
            setViewControllers([newContentViewController(0)], direction: .Forward, animated: true, completion: nil)
        }
    }

    
    func newContentViewController(index: Int) -> ContentViewController {
        let contentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        contentViewController.text = words[index]
        indexGlobal = index
        return contentViewController
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let contentVC = viewController as! ContentViewController
        let word = contentVC.text
        
        guard let viewControllerIndex = words.indexOf(word) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return newContentViewController(words.count - 1)
        }
        
        guard words.count > previousIndex else {
            return nil
        }
        
        return newContentViewController(previousIndex)

    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let contentVC = viewController as! ContentViewController
        let word = contentVC.text
        
        guard let viewControllerIndex = words.indexOf(word) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let contentViewControllerCount = words.count
        
        guard contentViewControllerCount != nextIndex else {
            return newContentViewController(0)
        }
        
        guard contentViewControllerCount > nextIndex else {
            return nil
        }
        
        return newContentViewController(nextIndex)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let contentVC = viewControllers?.first as? ContentViewController {
            let index = words.indexOf(contentVC.text)
            self.wordsDelegate.didUpdatePageIndex(index!)
        }
    }
}