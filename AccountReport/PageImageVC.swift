//
//  PageImageVC.swift
//  AccountReport
//
//  Created by 黃德桑 on 2019/11/26.
//  Copyright © 2019 sun. All rights reserved.
//

import UIKit

class PageImageVC: UIViewController ,UIScrollViewDelegate , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var btDelete: UIBarButtonItem!
    var isDetail = false
    var images = [UIImage]()
    var index  = 0
    var ivShows = [UIImageView]()
    var completionHandler:((Int) -> Void)?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        if isDetail {
            btDelete.isEnabled = false
            btDelete.tintColor = .clear
        }
        pageControl.numberOfPages = images.count
//        if !images.isEmpty{
//
//            for ( index ,image ) in images.enumerated(){
////                let uiimage = UIImageView(image: image)
////                uiimage.frame = CGRect(x: 0 + scollView.bounds.width * CGFloat(index), y: 0, width: scollView.bounds.width, height: scollView.bounds.height)
////                uiimage.contentMode = .scaleToFill
//////                uiimage.center = CGPoint(x: view.frame.width * (0.5 + CGFloat(index)),y: view.frame.height * 0.5)
////                ivShows.append(uiimage)
////                scollView.addSubview(ivShows[index])
//            }
//
//
//        }
        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        index = pageControl.currentPage
        pageControl.currentPage = indexPath.row
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if pageControl.currentPage == indexPath.row{
            pageControl.currentPage = index
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = images[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageImageCell", for: indexPath) as! PageImageCell
        cell.ivImage.image = image
        cell.ivImage.contentMode = .scaleAspectFill
        return cell
    }
    @IBAction func pageControl(_ sender: UIPageControl) {
        let indexpath = IndexPath(row: sender.currentPage, section: 0)
        collectionView.scrollToItem(at: indexpath, at: [.centeredHorizontally], animated: true)
    }
    
    @IBAction func clickDelete(_ sender: Any) {
        if !images.isEmpty {
            images.remove(at: pageControl.currentPage)
            completionHandler!(pageControl.currentPage)
            collectionView.reloadData()
            pageControl.numberOfPages = pageControl.numberOfPages - 1
            pageControl.reloadInputViews()
            print("pageControl.currentPage\(pageControl.currentPage)")
            
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
