//
//  HTTPDownloadManager.h
//  04-下载管理类
//
//  Created by Africa on 15/9/21.
//  Copyright (c) 2015年 Africa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPDownloadManager : NSObject

/**
 *  下载完成列表：保存在内存中
 */
@property(nonatomic,strong) NSMutableArray * downloadFinishLists;
/**
 *  正在下载的列表
 */
@property(nonatomic,strong) NSMutableArray * downloadingLists;

/**
 *  单例对象
 */
+ (instancetype)sharedManager;

/**
 *  添加下载任务
 */
- (void)addDownloadWithUrl:(NSURL *)url;

/**
 *  判断是否已经下载完成    这么写的目的是不想在该类中导入UIKIT（使用UIAlertView），
 */
- (BOOL)isExistInDownloadFinishListWithUrl:(NSURL *)url;
/**
 *  判断是否正在下载
 */
- (BOOL)isExistInDownloadingListsWithUrl:(NSURL *)url;

/**
 *  获取数据
 */
- (NSData *)getDataWithDownUrl:(NSURL *)url;

@end
