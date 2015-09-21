//
//  HTTPDownloadManager.m
//  04-下载管理类
//
//  Created by Africa on 15/9/21.
//  Copyright (c) 2015年 Africa. All rights reserved.
//

#import "HTTPDownloadManager.h"
#import "HTTPDownload.h"
@implementation HTTPDownloadManager

#pragma mark - 懒加载
- (NSMutableArray *)downloadFinishLists
{
    if (_downloadFinishLists == nil) {
        
        _downloadFinishLists = [NSMutableArray array];
    }
    return _downloadFinishLists;
}

- (NSMutableArray *)downloadingLists
{
    if (_downloadingLists == nil) {
        
        _downloadingLists = [NSMutableArray array];
    }
    return _downloadingLists;
}


#pragma mark - 单例对象
+ (instancetype)sharedManager
{
#if 0
    static HTTPDownloadManager * manager = nil;
    
    //使用对象锁，保证线程安全（即使在子线程中创建也是安全的），当一个线程进来，加锁，创建完毕之后自动解锁，不会造成创建多个manager对象
    @synchronized(self)
    {
        if (!manager) {
            
            manager = [[self alloc]init];
        }
        return manager;
    }
#endif
    
    static HTTPDownloadManager * manager = nil;
    //用于记录是否执行过，如果执行过，就不需要再执行（保证只执行一次）
    static dispatch_once_t onceToken;
    //dispatch_once是线程安全的，能够做到在多线程的环境下Block中的代码只会被执行一次
    //相当于原子操作，在运行到dispatch_once的会为这段代码加锁（互斥锁），采用线程同步技术（多个线程按顺序执行任务），避免了多个线程同时抢夺资源造成数据安全问题
    //如果被多个线程调用，该函数会同步等等直至代码块完成。
    dispatch_once(&onceToken, ^{
        
        //使用HTTPDownloadManager不安全，如果有继承关系，那么子类创建的就是父类的对象
        manager = [[self alloc]init];
    });
    return manager;

}

#pragma mark - 添加下载任务
/**
 *  添加下载任务
 */
- (void)addDownloadWithUrl:(NSURL *)url
{
    
    //把url传给download类进行下载  
    HTTPDownload * download = [[HTTPDownload alloc]initWithUrl:url
    ];
    //开始下载
    [download startDownload];
    
    //把当前正在下载的url存进数组
    [self.downloadingLists addObject:url];
    
    //下载完成回调
    [download setHTTPDownloadFinishBlock:^(HTTPDownload *download) {
        
        NSLog(@"download---%@",download.responseData);
        //删除任务列表中的数据
        [self.downloadingLists removeObject:url];
        
        //创建一个数组用于保存下载的data数据
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        
        [dict setValue:download.responseData forKey:[url absoluteString]];
        
        //往下载完成列表中保存数据
        [self.downloadFinishLists addObject:dict];
        
        //下载完成发送通知给控制器
        [[NSNotificationCenter defaultCenter] postNotificationName:@"data" object:nil];
        
    }];
    
}

#pragma mark - 判断下载状态
//下载完成
- (BOOL)isExistInDownloadFinishListWithUrl:(NSURL *)url
{
    //遍历下载完成列表
    for (NSMutableDictionary * dic in self.downloadFinishLists) {
        
        if ([dic objectForKey:[url absoluteString]]) {
            
            return YES;
        };
    }
    return NO;
}
//正在下载
- (BOOL)isExistInDownloadingListsWithUrl:(NSURL *)url
{
    for (id obj in self.downloadingLists) {
        
        if ([[obj absoluteString] isEqualToString:[url absoluteString]]) {
            
            return YES;
        }
    }
    return NO;
    
}
//获取数据
- (NSData *)getDataWithDownUrl:(NSURL *)url
{
    for (NSMutableDictionary * dic in self.downloadFinishLists) {
        
        //服务器返回的是图片类型  只能用data接收，不能转换为str
        //data转换为str
//        NSString * str = [[NSString alloc]initWithData:obj encoding:NSUTF8StringEncoding];
//        //str转换为url
//        NSURL * urlStr = [NSURL URLWithString:str];
//        if (urlStr == url) {
//            
//            return obj;
//        }
        
       return [dic objectForKey:[url absoluteString]];
        
    }
    return nil;
}

@end
