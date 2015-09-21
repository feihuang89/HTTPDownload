//
//  HTTPDownload.m
//  04-下载管理类
//
//  Created by Africa on 15/9/21.
//  Copyright (c) 2015年 Africa. All rights reserved.
//

#import "HTTPDownload.h"

@interface HTTPDownload()<NSURLConnectionDataDelegate>
{
    DownloadFinishBlock _downloadFinishBlock; //下载完成回调
    DownloadErrorBlock _downloadErrorBlock; //下载失败回调
    NSURL * _url; //保存控制器传过来的url
}

@end
@implementation HTTPDownload

#pragma mark - 懒加载
- (NSMutableData *)requestData
{
    if (_requestData == nil) {
        
        _requestData = [NSMutableData data];
    }
    return _requestData;
}
- (NSMutableData *)responseData
{
    if (_responseData == nil) {
        
        _responseData = [NSMutableData data];
    }
    return _responseData;
}

//初始化方法
- (id)initWithUrl:(NSURL *)url
{
    if (self = [super init]) {
        
        _url = url;
    }
    return self;
}

/**
 *  开始下载
 */
- (void)startDownload
{
    //这么写是有好处的
    if (!_url) {
        
        return;
    }
    
    //开始下载
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:_url] delegate:self];
 
#if 0
    //而不是这么写   不然会写很多代码在括号里面
    if (_url) {
        
        [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:_url] delegate:self];
    }
#endif
    
}

#pragma mark - NSURLConnectionDataDelegate
//接收到服务器响应的时候调用
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //清空数据
    self.requestData.length = 0;

}
//接收到服务器返回的数据的时候调用
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //追加数据
    [self.requestData appendData:data];
}
//下载完成调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //赋值
    self.responseData = self.requestData;
    
    NSLog(@"responseData---%@",self.responseData);
    
    //如果block不为空  把类自身传出
    if (_downloadFinishBlock) {
        
        _downloadFinishBlock(self);
    }
    
}
//下载失败调用
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //block不为空，把error传出
    if (_downloadErrorBlock) {
        
        _downloadErrorBlock(error);
    }
    
}


#pragma mark - setter方法
//下载完成回调
- (void)setHTTPDownloadFinishBlock:(DownloadFinishBlock)block
{
    //保存全局变量
    _downloadFinishBlock = block;
    
}
//下载失败回调
- (void)setHTTPDownloadErrorBlock:(DownloadErrorBlock)block
{
    _downloadErrorBlock = block;
    
}


@end
