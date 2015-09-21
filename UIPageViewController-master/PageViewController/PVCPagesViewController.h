//
//  PVCPagesViewController.h
//  PageViewController
//
//  Created by Jay Chulani on 10/26/13.
//  Copyright (c) 2013 Jay Chulani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVCPagesViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

/**
 *  翻页控制
 */
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
