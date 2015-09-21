//
//  HTTPDownload.h
//  04-下载管理类
//
//  Created by Africa on 15/9/21.
//  Copyright (c) 2015年 Africa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTTPDownload;
/**
 *  声明一个下载完成block回调
 */
typedef void(^DownloadFinishBlock) (HTTPDownload * download);
/**
 *  声明一个下载失败回调
 *
 *  @param error <#error description#>
 */
typedef void(^DownloadErrorBlock) (NSError * error);

@interface HTTPDownload : NSObject

/**
 *  下载完成回调的数据
 */
@property(nonatomic,strong) NSMutableData * responseData;
/**
 *  请求数据
 */
@property(nonatomic,strong) NSMutableData * requestData;

/**
 *  初始化方法
 */
- (id)initWithUrl:(NSURL *)url;
/**
 *  开始下载
 */
- (void)startDownload;

/**
 *  下载完成回调
 */
- (void)setHTTPDownloadFinishBlock:(DownloadFinishBlock)block;

/**
 *  下载失败回调
 */
- (void)setHTTPDownloadErrorBlock:(DownloadErrorBlock)block;


@end
