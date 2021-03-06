//
//  ViewController.swift
//  SleepingOrDead
//
//  Created by Henry Saniuk on 10/10/15.
//  Copyright (c) 2015 Henry Saniuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ZLSwipeableViewDataSource,ZLSwipeableViewDelegate {

    @IBOutlet weak var bttnBack: UIButton!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var swipeableView: ZLSwipeableView!
    var likeImage = UIImageView(image: UIImage(named: "like"))
    var dislikeImage = UIImageView(image: UIImage(named: "dead"))
    var realMid = UIScreen.mainScreen().bounds.width/2
    var styleManager = StyleManager()
    var animationManager = AnimationManager()

    @IBOutlet weak var bttnShare: UIButton!
    var productIndex = 0
    var cellIndexPath:NSIndexPath!
    var currentIndex:Int!
    var deleteCompany:Bool!
    var count = 0
    var newBase = BaseFinishedView()
    var likeCount = 0
    var currentLikeCount:Int!
    var productArray = [Card]()
    
    @IBOutlet weak var companyName: UILabel!
    var companyText:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productArray = addTestData()
        // Do any additional setup after loading the view, typically from a nib.
        self.swipeableView.delegate = self
        self.swipeableView.direction = .Horizontal
        checkCurrent()
        productName.text = self.productArray[count].name
        companyName.text = self.productArray[count].company
        count++
        styleManager.createBlur(view,backImage:backImage)
        styleManager.styleLikeDislikeImages(likeImage,dislikeImage:dislikeImage)
    }
    
    
    func addTestData() ->[Card]
    {
        
        //var productDic = ["1":"Sleeping or Dead?","2":"Sleeping or Dead?","3":"Sleeping or Dead?","4":"Sleeping or Dead?","Recycled Trimmed Tank Top":"Hollister","Cropped Rib Tank Top":"Theory","Crochet-Yoke Printed Dress":"Urban Outfitters","Ecote Clary Godet Trapeze Dress":"Bloomingdales","Mock-Neck Mini Swing Dress":"H&M","Riley Trapeze Dress":"Forever21","Witchy T-Shirt Dress":"Theory"]
        let productDic = ["Submitted by Henry":"Sleeping or Dead?","Submitted by Paul":"Sleeping or Dead?","Submitted by Peter":"Sleeping or Dead?","Submitted by Sneha":"Sleeping or Dead?","Submitted by Stuart":"Sleeping or Dead?","Submitted by Frankie":"Sleeping or Dead?","Submitted by Carl":"Sleeping or Dead?","Submitted by Sophia":"Sleeping or Dead?","Submitted by Andre":"Sleeping or Dead?","Submitted by Charles":"Sleeping or Dead?","Submitted by Pedro":"Sleeping or Dead?","Submitted by Darwin":"Sleeping or Dead?","Submitted by Alexa":"Sleeping or Dead?","Submitted by Sarah":"Sleeping or Dead?","Submitted by Rose":"Sleeping or Dead?","Submitted by Andrew":"Sleeping or Dead?"]
        var cardArray = [Card]()
        
        for (key,value) in productDic{
            let card = Card(name: key, company: value, image: UIImage(named: key)!)
            cardArray.append(card)
        }
        
        return cardArray
    }

    
    func checkCurrent()
    {
        if currentIndex != nil
        {
            productIndex = currentIndex
            count = currentIndex
        }
        if currentLikeCount != nil{
            likeCount = currentLikeCount
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        companyName.text = self.productArray[count-1].company
    }
    
    func swipeableView(swipeableView: ZLSwipeableView!, didSwipeView view: UIView!, inDirection direction: ZLSwipeableViewDirection) {
        productName.alpha = 1
        companyName.alpha = 1
        
        if(direction == ZLSwipeableViewDirection.Right)
        {
            likeCount++
        }
        if(count<productArray.count){
            productName.text = self.productArray[count].name
            companyName.text = self.productArray[count].company

            count++
        }
            
        else{
            self.view.addSubview(newBase)
            bttnShare.hidden = true
            newBase.frame = self.view.frame
            newBase.likeCount.text = String(likeCount)
            newBase.bttnBack.addTarget(self, action: "backBttnClicked:", forControlEvents: .TouchUpInside)
            self.view.bringSubviewToFront(bttnBack)
            deleteCompany = true
            productName.alpha = 0
            companyName.alpha = 0
        }
       
        
    }
    
    func swipeableView(swipeableView: ZLSwipeableView!, didCancelSwipe view: UIView!) {
        productName.alpha = 1
        companyName.alpha = 1
        if(likeImage.alpha > 0)
        {
            UIView.animateWithDuration(0.2, animations: {
                self.likeImage.alpha = 0
            }, completion: nil)
        }
        if(dislikeImage.alpha > 0)
        {
            UIView.animateWithDuration(0.2, animations: {
                self.dislikeImage.alpha = 0
                }, completion: nil)
        }

    }
    
    func swipeableView(swipeableView: ZLSwipeableView!, didStartSwipingView view: UIView!, atLocation location: CGPoint) {
        print("did start swiping at location: x \( location.x), y \(location.y)")
        view.addSubview(dislikeImage)
        view.addSubview(likeImage)
        likeImage.alpha = 0
        dislikeImage.alpha = 0 

    }
    
    @IBAction func shareProduct(sender: AnyObject) {
        let shareImage: UIImage = self.productArray[count-1].image!
        let objectArray : [AnyObject] = [shareImage,"Is this person sleeping or are they dead?"]
        let activityVC : UIActivityViewController = UIActivityViewController(activityItems: objectArray, applicationActivities: nil)

        activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func swipeableView(swipeableView: ZLSwipeableView!, swipingView view: UIView!, atLocation location: CGPoint, translation: CGPoint) {
        
        if(translation.x > 0)
        {
            likeImage.alpha = translation.x/100
            dislikeImage.alpha = 0

        }
        else{
            likeImage.alpha = 0
            dislikeImage.alpha = abs(translation.x)/100
        }
        
        productName.alpha = 1 - abs(translation.x)/250
        companyName.alpha = 1 - abs(translation.x)/250


    }
    
    
   
    
    func popBackToMain()
    {
        if let navController = self.navigationController {
            let control = self.navigationController?.viewControllers.first as! ControlVC
            animationManager.mainTransition(self)
            navController.popViewControllerAnimated(false)
            currentIndex = count - 1
            control.currentLikeCount = likeCount
            control.keepCurrentIndex = currentIndex
            if(deleteCompany != nil)
            {
                control.cardButton.enabled = false
                control.cardButton.layer.borderColor = UIColor.lightGrayColor().CGColor
            }
        }
    }
    
    @IBAction func backBttnClicked(sender: AnyObject) {
        print("Back To Control")
        popBackToMain()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
            self.swipeableView.dataSource = self
    }
    
    
    func nextViewForSwipeableView(swipeableView: ZLSwipeableView!) -> UIView! {
        if (self.productIndex < self.productArray.count){
            let currentProductImage = self.productArray[self.productIndex].image

            let view = CardView(frame:swipeableView.bounds)
            view.cardViewImage.image = currentProductImage
            productIndex++
             return view
        }
       return nil
    }
}

