# HTTPDownload
异步多任务类封装

-----------
* 1.下载管理类作为单例对象，接收url，并分发给下载类进行下载
```
    + (instancetype)sharedManager
    {
    static HTTPDownloadManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;

    }
* 2.下载类进行下载任务，下载完成存入缓存数组，并回调到下载管理类
```
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
