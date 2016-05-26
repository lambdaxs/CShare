//
//  XSHttpClient.m
//  testRealReachability
//
//  Created by xiaos on 16/3/1.
//  Copyright © 2016年 QCStudio. All rights reserved.
//

#import "XSHttpClient.h"

#define kNetCache @"XSHttpClientCache"  //磁盘缓存的网络数据key

#define UserDict [NSUserDefaults standardUserDefaults]
#define kNetState @"XSHttpClientNetState"   //存网络状况的key 0 1 2 => 无网络 2/3/4G WIFI

/** 主机地址 应用版本路径 */
static NSString *hostAddress;
static NSString *appPath;

/** 静态变量来存储网络状态 0 无网络 1 流量 2 wifi */
static NSString *XSHttpNetState;

@implementation XSHttpClient

singleton_implementation(XSHttpClient)

#pragma mark - 初始化主机地址 以及应用路径
+ (void)initialize {
//    hostAddress = @"http://www.xsdota.com";
//    appPath     = @"weibo/v1";
}

#pragma mark - 配置连接检测与磁盘缓存
- (void)config:(NSString *)hostStr
       appPath:(NSString *)path {
    
    hostAddress = hostStr;
    appPath = path;
    
    //开启网络连接检测
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSString *netState = nil;
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                netState = @"0";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                netState = @"1";
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                netState = @"2";
                break;
            default:
                netState = @"0";
                break;
        }

        XSHttpNetState = netState;
//        [UserDict setObject:netState forKey:kNetState];
//        [UserDict synchronize];
    }];
    
    //开启自带的磁盘缓存
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:kNetCache];
    [NSURLCache setSharedURLCache:URLCache];
}

#pragma mark - HTTP请求管理器
- (AFHTTPSessionManager *)sharedHTTPManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //请求头设置
    //    [manager.requestSerializer setValue:K_PASS_IP forHTTPHeaderField:@"Host"];
    //    [manager.requestSerializer setValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
    //    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    //    [manager.requestSerializer setValue:@"zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    //    [manager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    //    [manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    //    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:35.0) Gecko/20100101 Firefox/35.0" forHTTPHeaderField:@"User-Agent"];
    //忽略内部缓存,每次都请求新的数据
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    return manager;
}

#pragma mark - URLSession管理器
- (AFURLSessionManager *)sharedURLManager {
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *mgr = [[AFURLSessionManager alloc] initWithSessionConfiguration:defaultConfig];
    
    return mgr;
}

#pragma mark - 后台下载管理器
- (AFURLSessionManager *)sharedBackgroundManagerWithId:(NSString *)identifier {
    NSURLSessionConfiguration *backgroundConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSString stringWithFormat:@"com.bonc.%@", identifier]];
    AFURLSessionManager *mgr = [[AFURLSessionManager alloc] initWithSessionConfiguration:backgroundConfig];
    return mgr;
}

#pragma mark - GET请求
- (NSURLSessionDataTask *)GET:(NSString *)requestKey
                       params:(NSDictionary *)params
                      success:(successBlock)success
                      failure:(failureBlock)failure
                     progress:(progressBlock)progress {
    
    if ([HttpClient badNetState]) {
        NSError *error = [NSError errorWithDomain:@"无网络连接" code:300 userInfo:nil];
        if(failure)failure(error);
        return nil;
    }
    
    NSString *realURLStr = [HttpClient getRealURLStr:requestKey];
    
    return
    [[HttpClient sharedHTTPManager]
     GET:realURLStr
     parameters:params
     progress:^(NSProgress * _Nonnull downloadProgress) {
         if(progress)progress(downloadProgress);
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)failure(error);
    }];
}

- (NSURLSessionDataTask *)GETWithParams:(NSString *)requestKey
                                 params:(NSArray *)params
                                success:(successBlock)success
                                failure:(failureBlock)failure
                               progress:(progressBlock)progress {
    
    if ([HttpClient badNetState]) {
        NSError *error = [NSError errorWithDomain:@"无网络连接" code:300 userInfo:nil];
        if(failure)failure(error);
        return nil;
    }
    
    NSString *realURLStr = [HttpClient getRealURLStr:requestKey];
    
    __block NSMutableString *paramsURLStr = [NSMutableString new];
    [params enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [paramsURLStr appendFormat:@"/%@",obj];
    }];
    
    NSString *longURLStr = [NSString stringWithFormat:@"%@%@", realURLStr, paramsURLStr];
    
    return
    [[HttpClient sharedHTTPManager] GET:longURLStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if(progress)progress(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)failure(error);
    }];
}

- (NSURLSessionDataTask *)GETCache:(NSString *)requestKey
                            params:(NSDictionary *)params
                           success:(successBlock)success
                           failure:(failureBlock)failure
                          progress:(progressBlock)progress{
    
    NSString *realURLStr = [HttpClient getRealURLStr:requestKey];
    
    AFHTTPSessionManager *mgr = [HttpClient sharedHTTPManager];
    mgr.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    return
    [mgr GET:realURLStr
        parameters:params
        progress:^(NSProgress * _Nonnull downloadProgress) {
            if(progress)progress(downloadProgress);
        }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(success)success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(failure)failure(error);
     }];
}

- (NSURLSessionDataTask *)GETData:(NSString *)requestKey
                           params:(NSDictionary *)params
                          success:(successBlock)success
                          failure:(failureBlock)failure
                         progress:(progressBlock)progress{
    
    if ([HttpClient badNetState]) {
        NSError *error = [NSError errorWithDomain:@"无网络连接" code:300 userInfo:nil];
        failure(error);
        return nil;
    }
    
    NSString *realURLStr = [HttpClient getRealURLStr:requestKey];
    
    AFHTTPSessionManager *mgr = [HttpClient sharedHTTPManager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return
    [mgr GET:realURLStr
  parameters:params
    progress:^(NSProgress * _Nonnull downloadProgress) {
        if(progress)progress(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)failure(error);
    }];
}

- (NSURLSessionUploadTask *)POSTWithJson:(NSString *)requestKey
                              otherKey:(NSString *)otherKey
                                params:(NSDictionary *)params
                               success:(successBlock)success
                               failure:(failureBlock)failure
                              progress:(progressBlock)progress {
    
    if ([HttpClient badNetState]) {
        NSError *error = [NSError errorWithDomain:@"NoNet" code:300 userInfo:nil];
        failure(error);
        return nil;
    }
    
    NSString *realURLStr = [HttpClient getRealURLStr:requestKey];
    
    NSString *jsonStr = nil;
    if ([NSJSONSerialization isValidJSONObject:params]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
        if (!error){
            jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }else {
            if(failure)failure(error);
            return nil;
        }
    }else {
        NSError *error = [NSError errorWithDomain:@"参数无法Json格式化" code:300 userInfo:nil];
        if (failure)failure(error);
        return nil;
    }
    
    NSString *bodyStr = nil;
    if (otherKey) {
        bodyStr = [NSString stringWithFormat:@"%@=%@",otherKey,jsonStr];
    }else {
        bodyStr = jsonStr;
    }
    
    NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:realURLStr]];
    request.HTTPMethod = @"POST";   //将文件的二进制写入到HTTPBody中
    
    //定义一个完成闭包
    completionBlock completion = ^(id data, NSError *error) {
        if (error) {
            if (failure)failure(error);
        }else {
            if (success)success(data);
        }
    };
    
    if (bodyData) {
        NSURLSessionUploadTask *task =
        [[HttpClient sharedHTTPManager] uploadTaskWithRequest:request fromData:bodyData progress:^(NSProgress * _Nonnull uploadProgress) {
            if(progress)progress(uploadProgress);
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            completion(responseObject, error);
        }];
        
        [task resume];
        return task;
    }
    
    return nil;
    
}

- (NSURLSessionDataTask *)POST:(NSString *)requestKey
                        params:(NSDictionary *)params
                       success:(successBlock)success
                       failure:(failureBlock)failure
                      progress:(progressBlock)progress{
    
    if ([HttpClient badNetState]) {
        NSError *error = [NSError errorWithDomain:@"NoNet" code:300 userInfo:nil];
        if(failure)failure(error);
        return nil;
    }
    
    NSString *realURLStr = [HttpClient getRealURLStr:requestKey];
    
    return
    [[HttpClient sharedHTTPManager]
     POST:realURLStr
     parameters:params
     progress:^(NSProgress * _Nonnull uploadProgress) {
        if(progress)progress(uploadProgress);
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)failure(error);
    }];
}


- (NSURLSessionDataTask *)UPLoadByForm:(NSString *)requestKey
                              fileData:(NSData *)data
                             fileParam:(NSString *)fileParam
                              fileName:(NSString *)fileName
                              fileType:(NSString *)type
                                params:(NSDictionary *)params
                               success:(successBlock)success
                               failure:(failureBlock)failure
                              progress:(progressBlock)progress {
    
    if ([HttpClient badNetState]) {
        NSError *error = [NSError errorWithDomain:@"无网络连接" code:300 userInfo:nil];
        if(failure)failure(error);
        return nil;
    }
    
    NSString *realURLStr = [HttpClient getRealURLStr:requestKey];
    
    return 
    [[HttpClient sharedHTTPManager]
     POST:realURLStr
     parameters:params
     constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:fileParam fileName:fileName mimeType:type];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (NSURLSessionUploadTask *)UPLoadByBody:(NSString *)requestKey
                                fromFile:(NSURL *)fileURL
                          orFromBodyData:(NSData *)bodyData
                                progress:(progressBlock)progress
                                 success:(successBlock)success
                                 failure:(failureBlock)failure {
    
    if ([HttpClient badNetState]) {
        NSError *error = [NSError errorWithDomain:@"无网络连接" code:300 userInfo:nil];
        failure(error);
        return nil;
    }
    
    NSString *realURLStr = [HttpClient getRealURLStr:requestKey];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:realURLStr]];
    request.HTTPMethod = @"POST";   //将文件的二进制写入到HTTPBody中
    
    //定义一个完成闭包
    completionBlock completion = ^(id data, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        }else {
            if (success) {
                success(data);
            }
        }
    };
    
    if (fileURL) {
        NSURLSessionUploadTask *task =
        [[HttpClient sharedHTTPManager] uploadTaskWithRequest:request fromFile:fileURL progress:^(NSProgress * _Nonnull uploadProgress) {
            progress(uploadProgress);
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            completion(responseObject, error);
        }];
        
        [task resume];
        return task;
    }
    
    if (bodyData) {
        NSURLSessionUploadTask *task =
        [[HttpClient sharedHTTPManager] uploadTaskWithRequest:request fromData:bodyData progress:^(NSProgress * _Nonnull uploadProgress) {
            progress(uploadProgress);
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            completion(responseObject, error);
        }];
        
        [task resume];
        return task;
    }
    
    return nil;
}

- (NSURLSessionDownloadTask *)Download:(NSString *)requestKey
                              progress:(progressBlock)progress
                               success:(successBlock)success
                               failure:(failureBlock)failure {
    
    if ([HttpClient badNetState]) {
        NSError *error = [NSError errorWithDomain:@"无网络连接" code:300 userInfo:nil];
        failure(error);
        return nil;
    }
    
    
    //定义完成操作闭包
    completionBlock complete = ^(id data, NSError *error) {
        if (error) {
            failure(error);
        }else {
            success(data);
        }
    };
    
    NSString *realURLStr = [HttpClient getRealURLStr:requestKey];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:realURLStr]];
    
    AFURLSessionManager *mgr = [[AFURLSessionManager alloc] init];
    
    NSURLSessionDownloadTask *task =
    [mgr downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:documentsPath];
        NSURL *newFileLocation = [documentsDirectoryURL URLByAppendingPathComponent:[[response URL] lastPathComponent]];
        return newFileLocation;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        complete(filePath, error);
    }];
    
    [task resume];
    return task;
}

#pragma mark - 检测网络连接
- (BOOL)badNetState {
    return [XSHttpNetState isEqualToString:@"0"];
//    return [[UserDict objectForKey:kNetState] isEqualToString:@"0"];
}


- (NSString *)netType {
    return XSHttpNetState;
}

#pragma mark -  拼接出完整的URL
- (NSString *)getRealURLStr:(NSString *)requestKey
{
    /** 可以传入完整URL地址 会自动覆盖主API */
    if ([requestKey hasPrefix:@"http://"] || [requestKey hasPrefix:@"https://"]) {
        return requestKey;
    }
    
    NSString *URLStr = [[hostAddress stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",appPath,requestKey]] stringByRemovingPercentEncoding];
    
    return URLStr;
}

#pragma mark - 清空缓存
- (void)removeCache {
    
    //异步删除网络缓存
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *filePath = [[path stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:kNetCache];
        
        NSFileManager *mgr = [NSFileManager defaultManager];
        NSArray *cacheFiles = [mgr subpathsAtPath:filePath];
        
        for (NSString *file in cacheFiles) {
            NSString *cacheFilePath = [filePath stringByAppendingPathComponent:file];
            if ([mgr fileExistsAtPath:cacheFilePath]) {
                [mgr removeItemAtPath:cacheFilePath error:nil];
            }
        }
    });
    
    [HttpClient performSelectorOnMainThread:@selector(removeSuccess) withObject:nil waitUntilDone:YES];
}

#pragma mark - 清空完成回调
- (void)removeSuccess {
    NSLog(@"清理完成");
}

@end

