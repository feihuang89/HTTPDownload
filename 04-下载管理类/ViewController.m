//
//  ViewController.m
//  04-下载管理类
//
//  Created by Africa on 15/9/21.
//  Copyright (c) 2015年 Africa. All rights reserved.
//

#import "ViewController.h"
#import "HTTPDownloadManager.h"
@interface ViewController ()
@property(nonatomic,strong) NSURL * url;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation ViewController

- (IBAction)btnClick:(id)sender {
    
    /**
     *  调用addDownload:开始下载之前：
     1.判断是否下载完成
     2.判断是否正在下载
     */
    NSURL * url = [NSURL URLWithString:@"http://allseeing-i.com/ASIHTTPRequest/tests/images/large-image.jpg"];
    self.url = url;
    
    //创建下载管理类
    HTTPDownloadManager * manager = [HTTPDownloadManager sharedManager];
    
    if ([manager isExistInDownloadFinishListWithUrl:url]) {
        
        [self showAlertViewWithTitle:@"下载完成" andMessage:@"已经下载完成，无需重复下载"];
        
    }else if ([manager isExistInDownloadingListsWithUrl:url])
    {
        [self showAlertViewWithTitle:@"正在下载" andMessage:@"正在下载,无需重复下载"];
    }else
    {
        //订阅通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownload) name:@"data" object:nil];
        //添加下载任务
        [manager addDownloadWithUrl:url];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}
#pragma mark - 辅助方法：显示alertView
- (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (void)didFinishDownload
{
    NSData * data = [[HTTPDownloadManager sharedManager] getDataWithDownUrl:self.url];
    NSLog(@"data---%@",data);
    
    self.imageView.image = [UIImage imageWithData:data];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
