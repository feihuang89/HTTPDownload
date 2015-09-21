//
//  PVCPagesViewController.m
//  PageViewController
//
//  Created by Jay Chulani on 10/26/13.
//  Copyright (c) 2013 Jay Chulani. All rights reserved.
//

#import "PVCPagesViewController.h"

@interface PVCPagesViewController ()

@property (strong, nonatomic) NSArray * pages; //存储页面

@property (strong, nonatomic) UIPageViewController * pageController; //翻页控制器


@end

@implementation PVCPagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //从stroyboard中加载视图控制器
    UIViewController *page1 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"page1"];

    UIViewController *page2 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"page2"];

    UIViewController *page3 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"page3"];

    UIViewController *page4 = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"page4"];

    //从数组中加载视图控制器
    self.pages = [[NSArray alloc] initWithObjects:page1, page2, page3, page4, nil];
    //初始化翻页控制器
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    //设置代理对象
    [self.pageController setDelegate:self];
    [self.pageController setDataSource:self];
    
    //设置翻页的范围
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    //设置默认页面为第一页
    NSArray *viewControllers = [NSArray arrayWithObject:[self.pages objectAtIndex:0]];
    
    [self.pageControl setCurrentPage:0];
    //设置监听翻页
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];

    //设置翻页的方向
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    //添加子视图控制器
    [self addChildViewController:self.pageController];
    
    //把翻页的视图加入该视图控制器的视图中显示
    [[self view] addSubview:[self.pageController view]];
    
    //子视图控制器转换到父视图控制器
    [self.pageController didMoveToParentViewController:self];
    //把所有的子视图控制器的view移到背后
    [self.view sendSubviewToBack:[self.pageController view]];
}
#pragma mark - UIPageViewControllerDataSource
//返回上一个ViewController对象
- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    //获取当前索引页
    NSUInteger currentIndex = [self getCurrectIndex:viewController];
    
    //设置当前页码
    [self.pageControl setCurrentPage:self.pageControl.currentPage-1];
    
    //判断当前页是否 > 1
    if ( currentIndex > 0) {
        
        return [self.pages objectAtIndex:currentIndex-1];
        
    } else {
        return nil;
    }
}

//返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    //获取当前视图控制器的索引
    NSUInteger currentIndex = [self getCurrectIndex:viewController];
    
    //页码＋1
    [self.pageControl setCurrentPage:self.pageControl.currentPage+1];
    
    //判断是否是最后一页
    if ( currentIndex < [self.pages count]-1) {
        
        return [self.pages objectAtIndex:currentIndex+1];
        
    } else {
        return nil;
    }
}

//获取当前索引值
- (NSUInteger)getCurrectIndex:(UIViewController *)vc
{
    //获取当前视图控制器的索引
    return [self.pages indexOfObject:vc];
}


//监听翻页
- (void)changePage:(id)sender {
    
    UIViewController *visibleViewController = self.pageController.viewControllers[0];
    NSUInteger currentIndex = [self.pages indexOfObject:visibleViewController];
    
    NSArray *viewControllers = [NSArray arrayWithObject:[self.pages objectAtIndex:self.pageControl.currentPage]];
    
    if (self.pageControl.currentPage > currentIndex) {
        //水平方向：从右往左翻
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    } else {
        //从左往右翻
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        
    }
}





@end
