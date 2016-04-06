# MinCarouseView
a custom picture carouse view
---- 
# Installation
## CocoaPods
pod 'MinCarouseView'
# How to use
## Storyboard or xib setup
1.use storyboard or xib setup
2.set the imageArray property, you can use UIImage or String of url

	let imageArray = [
	UIImage(named: "bamboo")!,
	UIImage(named: "plum blossom")!,
	UIImage(named: "lotus")!
	 ]
	 carouse.imageArray = imageArray  

## Manual setup

	let urlArray = [
	"http://d.lanrentuku.com/down/png/1307/jiqiren-wall-e/jiqiren-wall-e-04.png",
	"http://d.lanrentuku.com/down/png/1307/jiqiren-wall-e/jiqiren-wall-e-05.png",
	"http://d.lanrentuku.com/down/png/1307/jiqiren-wall-e/jiqiren-wall-e-03.png"
	]
	let carouse = MinCarouseView(frame: aFrame, imageArray: urlArray)
	self.view.addSubview(carouse)

# Note
1. imageArray: just accept UIImage or String of URL
2. isAutoScroll: default is true, and the carouse will autoscroll
3. scrollInterVal: default is 3.0 seconds, the interval of scroll
4. currentPageDotColor: set the pageControl current dot color. Support storyboard attributes inspector
5. otherPageDotColor: set the pageControl other dots color. Support storyboard attributes inspector
6. tapClosure: callback when tap the imageView 

		carouse.tapClosure = { index in
			// do something
		}

Here you go