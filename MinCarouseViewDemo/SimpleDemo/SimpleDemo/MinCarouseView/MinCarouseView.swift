//
//  MinCarouseView.swift
//  MinImageScroll
//
//  Created by songmin.zhu on 16/4/1.
//  Copyright © 2016年 zhusongmin. All rights reserved.
//

import UIKit

public final class MinCarouseView: UIView {
    
    public typealias TapClosure = (index: Int) -> Void
    
    //MARK: Enum
    enum Direction: Int {
        case None, Left, Right
    }
    
    //MARK: Constant
    struct Constant {
        static let margin: CGFloat = 8.0
        static let pageControlHeigtht: CGFloat = 15.0
        static let pageControlPerDotWidth: CGFloat = 8.0
        static let currentPageDotColor = UIColor.darkGrayColor()
        static let otherPageDotColor = UIColor.lightGrayColor()
    }
    
    //MARK: Private Property
    private var x: CGFloat { return 0.0 }
    private var y: CGFloat { return 0.0 }
    private var width: CGFloat { return self.baseView.bounds.width }
    private var height: CGFloat { return self.baseView.bounds.height }
    
    private lazy var cacheDirectoryPath: String? = {
        if let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(path + "/CarouseImageCache", withIntermediateDirectories: true, attributes: nil)
                return path + "/CarouseImageCache" + "/"
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        return nil
    }()
    private lazy var baseView: UIView = {
        let theView: UIView = UIView()
        theView.backgroundColor = UIColor.whiteColor()
        theView.addSubview(self.scrollView)
        theView.addSubview(self.pageControl)
        return theView
    }()
    private lazy var currentImageView: UIImageView = {
        let theImageView: UIImageView = UIImageView()
        let tap = UITapGestureRecognizer(target: self, action: "tapImageView:")
        theImageView.image = self.placeholderImage
        theImageView.addGestureRecognizer(tap)
        theImageView.userInteractionEnabled = true
        theImageView.contentMode = .ScaleAspectFit
        return theImageView
    }()
    private lazy var otherImageView: UIImageView = {
        let theImageView: UIImageView = UIImageView()
        let tap = UITapGestureRecognizer(target: self, action: "tapImageView:")
        theImageView.addGestureRecognizer(tap)
        theImageView.userInteractionEnabled = true
        theImageView.contentMode = .ScaleAspectFit
        return theImageView
    }()
    private lazy var scrollView: UIScrollView = {
        let theScrollView: UIScrollView = UIScrollView()
        theScrollView.addSubview(self.currentImageView)
        theScrollView.addSubview(self.otherImageView)
        theScrollView.pagingEnabled = true
        theScrollView.bounces = false
        theScrollView.showsHorizontalScrollIndicator = false
        theScrollView.delegate = self
        if self.imageArray.count ==  1 {
            theScrollView.scrollEnabled = false
        }
        return theScrollView
    }()
    private lazy var pageControl: UIPageControl = {
        let count = self.imageArray.count
        let thePageControl: UIPageControl = UIPageControl()
        thePageControl.numberOfPages = count
        thePageControl.currentPageIndicatorTintColor = Constant.currentPageDotColor
        thePageControl.pageIndicatorTintColor = Constant.otherPageDotColor
        thePageControl.currentPage = 0
        thePageControl.hidesForSinglePage = true
        return thePageControl
    }()
    private var timer = NSTimer()
    private var currentIndex: Int = 0
    private var nextIndex: Int = 0
    private var images = [UIImage]()
    /// 占位图片
    private var placeholderImage: UIImage?
    private var direction = Direction.None {
        //监听
        didSet {
            if oldValue == direction { return }// 方向不变.
            if direction == .Right {// 右划
                // 设置下一幅图片位置在右
                self.otherImageView.frame = CGRect(x: self.width * 2, y: self.y, width: self.width, height: self.height)
                // 设置nextIndex，如果currentIndex+1 > 图片数量， 则循环到第一幅图片
                self.nextIndex = (self.currentIndex+1) % self.imageArray.count
            }
            else if direction == .Left {// 左划
                // 设置下一幅图片位置在左
                self.otherImageView.frame = CGRect(x: self.x, y: self.y, width: self.width, height: self.height)
                // 设置nextIndex
                self.nextIndex = self.currentIndex-1
                // nextIndex<0 则循环到最后一幅图片
                if self.nextIndex < 0 {
                    self.nextIndex = self.imageArray.count-1
                }
            }
            // otherImageView应显示的图片
            if !self.images.isEmpty && self.images.count > self.nextIndex {
                self.otherImageView.image = self.images[self.nextIndex]
            }
        }
    }
    
    //MARK: Public Property
    /// 图片数组，接收UIImage或者String(网络地址)
    public var imageArray = [AnyObject]() {
        didSet {
            imagesHandle(imageArray)
            updateUI()
        }
    }
    /// 是否开启自动滚动，默认true
    public var isAutoScroll = true {
        didSet {
            resetTimer()
        }
    }
    /// 自动滚动间隔时间，默认3秒
    public var scrollInterVal: Double = 3.0 {
        didSet {
            resetTimer()
        }
    }
    
    /// 设置pageControl当前圆点颜色
    @IBInspectable public var currentPageDotColor: UIColor = Constant.currentPageDotColor {
        didSet {
            pageControl.currentPageIndicatorTintColor = currentPageDotColor
        }
    }
    /// 设置pageControl其他圆点颜色
    @IBInspectable public var otherPageDotColor: UIColor = Constant.otherPageDotColor {
        didSet {
            pageControl.pageIndicatorTintColor = otherPageDotColor
        }
    }
    
    /// 点击闭包
    public var tapClosure: TapClosure?

    //MARK: Lift Cycle
    public init() {
        super.init(frame: CGRectZero)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience public init(frame: CGRect, imageArray: [AnyObject], placeholder: UIImage?) {
        self.init(frame: frame)
        self.placeholderImage = placeholder
        self.imageArray = imageArray
        self.imagesHandle(imageArray)
        self.addSubview(baseView)
        resetTimer()
    }
    
    convenience public init(frame: CGRect, imageArray: [AnyObject]) {
        self.init(frame: frame, imageArray: imageArray, placeholder: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(baseView)
        resetTimer()
    }

    deinit {
        timer.invalidate()
        print(__FUNCTION__)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }

    //MARK: Private Method
    private func updatePageControl() {
        let count = self.imageArray.count
        let pageWidth = Constant.pageControlPerDotWidth * CGFloat(count)
        pageControl.frame = CGRect(
            x: self.width - 2*Constant.margin - pageWidth,
            y: self.height - Constant.margin - Constant.pageControlHeigtht,
            width: pageWidth,
            height: Constant.pageControlHeigtht)
        pageControl.numberOfPages = count
        pageControl.currentPage = currentIndex
    }
    
    private func updateScrollView() {
        scrollView.scrollEnabled = (imageArray.count == 1) ? false : true
        scrollView.frame = CGRect(x: x, y: y, width: width, height: height)
        scrollView.contentSize = CGSize(width: self.width * 3, height: self.height)
        scrollView.contentOffset = CGPoint(x: width, y: y)
    }
    
    private func updateImageView() {
        currentImageView.frame = CGRect(x: width, y: y, width: width, height: height)
        otherImageView.frame = CGRect(x: width*2, y: y, width: width, height: height)
    }
    
    /// 更新UI
    private func updateUI() {
        baseView.frame = CGRect(x: x, y: y, width: self.frame.width, height: self.frame.height)
        updatePageControl()
        updateScrollView()
        updateImageView()
        isAutoScroll ? resetTimer() : timer.invalidate()
        imageArray.count == 1 ? timer.invalidate() : resetTimer()
    }
    
    private func imagesHandle(array: [AnyObject]) {
        images.removeAll()
        for (index, value) in array.enumerate() {
            if let tempVlaue = value as? UIImage {// 图片
                images.append(tempVlaue)
            } else {// 下载路径
                // 先添加占位图片
                if let temp = placeholderImage {
                    images.append(temp)
                }
                // 下载图片
                downLoadImages(index)
            }
        }
        if !images.isEmpty && images.count > currentIndex {
            currentImageView.image = images[currentIndex]
        }
    }
    
    private var imageDict = [String: UIImage]()
    private var operationDict = [String: NSBlockOperation]()
    private func downLoadImages(index: Int) {
        if let key = imageArray[index] as? String {
            // 缓存中有图片
            if let image = imageDict[key] {
                images.removeAtIndex(index)
                images.insert(image, atIndex: index)
            }
            else {
                // 获取沙盒路径
                if let tempPath = cacheDirectoryPath {
                    if let lastPathComponent = NSURL(string: key)?.lastPathComponent {
                        let imagePath = tempPath + lastPathComponent
                        // 沙盒中有图片，替换占位图片并添加到缓存字典中
                        if let tempImageData = NSData(contentsOfFile: imagePath) {
                            if let image = UIImage(data: tempImageData) {
                                images.removeAtIndex(index)
                                images.insert(image, atIndex: index)
                                imageDict[key] = image
                            }
                        } else { // 沙盒中无图片，下载
                            if let _ = operationDict[key] {// 查看是否有正在下载的操作
                                // 正在下载，不处理
                            } else { // 无则新建一个
                                let queue = NSOperationQueue()
                                let download = NSBlockOperation {
                                    if let url = NSURL(string: key) {
                                        let downloadData = NSData(contentsOfURL: url)
                                        if let imageData = downloadData {// 下载完成
                                            if let image = UIImage(data: imageData) {
                                                self.imageDict[key] = image
                                                self.images.removeAtIndex(index)
                                                self.images.insert(image, atIndex: index)
                                                if self.imageArray.count == 1 || self.currentIndex == index {
                                                    // 主线程修改图片
                                                    self.currentImageView.performSelectorOnMainThread("setImage:", withObject: image, waitUntilDone: false)
                                                }
                                                // 保存图片到沙盒中
                                                if imageData.writeToFile(imagePath, atomically: true) {
                                                    print("success")
                                                }
                                                self.operationDict.removeValueForKey(key)
                                            }
                                        }
                                    }
                                }
                                queue.addOperation(download)
                                operationDict[key] = download
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// 重设定时器
    private func resetTimer() {
        timer.invalidate()
        if isAutoScroll {
            if images.count > 1 {
                timer = NSTimer(timeInterval: scrollInterVal, target: self, selector: "nextPage", userInfo: nil, repeats: true)
                NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
            }
        }
    }
    
    @objc private func nextPage() {
        scrollView.setContentOffset(CGPoint(x: width*2, y: y), animated: true)
    }
    
    @objc private func tapImageView(sender: UIImageView) {
        if let theClosure = tapClosure {
            theClosure(index: currentIndex)
        }
    }
}

//MARK: UIScrollViewDelegate
extension MinCarouseView: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        // 确定滑动方向
        direction = scrollView.contentOffset.x > width ? .Right : .Left
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollEnd()
    }
    
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        scrollEnd()
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        timer.invalidate()
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        resetTimer()
    }
    
    /// 滑动停止，修改当前位置
    private func scrollEnd() {
        direction = .None
        let index: UInt = UInt(scrollView.contentOffset.x / width)
        if index == 1 { return }
        currentIndex = nextIndex
        pageControl.currentPage = currentIndex
        currentImageView.image = otherImageView.image
        scrollView.contentOffset = CGPoint(x: width, y: y)
    }
}















