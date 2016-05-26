//
//  XSHttpClient.h
//  testRealReachability
//
//  Created by xiaos on 16/3/1.
//  Copyright © 2016年 QCStudio. All rights reserved.
//

#import <AFNetworking.h>
#import "Singleton.h"

#define HttpClient [XSHttpClient sharedXSHttpClient]//单例

#define kProgressKey         @"fractionCompleted"   //可KVO监听上传/下载进度数值
#define kCompleteProgressKey @"completedUnitCount"  //可KVO监听已经完成的数值 单位bytes
#define kTotalProgressKey    @"totalUnitCount"      //文件总大小 单位bytes

/** 成功/失败/进度/完成的闭包 */
typedef void(^successBlock)(id data);
typedef void(^failureBlock)(NSError * error);
typedef void(^progressBlock)(NSProgress *progress);
typedef void(^completionBlock)(id data, NSError * error);


@interface XSHttpClient : NSObject

#pragma mark - HttpClient单例
singleton_interface(XSHttpClient)

/**
 *  初始化配置 需要在appDelegate中调用
 *  1 开启网络连接检测
 *  2 开启磁盘缓存
 *  3 设置默认主机地址
 */
//- (void)config;
- (void)config:(NSString *)hostStr
       appPath:(NSString *)path;


/**
 *  Http请求管理器 控制请求头的一些设置 控制缓存策略
 *
 *  @return Http请求管理
 */
- (AFHTTPSessionManager *)sharedHTTPManager;

/**
 *  网络是否可访问 未ping
 *  通过ping判断是否可访问公网 判断离线模式
 *  [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {}];
 *  @return YES 不可访问  NO 可正常访问
 */
- (BOOL)badNetState;

/**
 *  网络类型
 *
 *  @return @"0":无网络  @"1":流量  @"2":wifi
 */
- (NSString *)netType;


/**
 *  清除磁盘缓存
 */
- (void)removeCache;


/**
 *  普通GET请求
 *
 *  @param requestKey 请求路径
 *  @param params     请求参数
 *  @param success    成功回调 返回的data为json化后的数据
 *  @param failure    失败回调
 *  @param progress   进度回调
 *  @return 数据任务
 */
- (NSURLSessionDataTask *)GET:(NSString *)requestKey
                       params:(NSDictionary *)params
                      success:(successBlock)success
                      failure:(failureBlock)failure
                     progress:(progressBlock)progress;

/**
 *  GET参数都跟在路径后的请求e.g. http://223.220.254.68:8013/ocma/datapool/getThreeHeartUserList/30/1000074080/3668/1/12/0
 *
 *  @param requestKey 请求路径
 *  @param params     参数数组
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @param progress   进度回调
 *
 *  @return 数据任务
 */
- (NSURLSessionDataTask *)GETWithParams:(NSString *)requestKey
                                 params:(NSArray *)params
                                success:(successBlock)success
                                failure:(failureBlock)failure
                               progress:(progressBlock)progress;

/**
 *  带磁盘缓存的GET请求
 *
 *  @param requestKey 请求路径
 *  @param params     请求参数
 *  @param success    成功回调 返回的data为json化后的数据
 *  @param failure    失败回调
 *  @param progress   进度回调
 *  @return 数据任务
 */
- (NSURLSessionDataTask *)GETCache:(NSString *)requestKey
                            params:(NSDictionary *)params
                           success:(successBlock)success
                           failure:(failureBlock)failure
                          progress:(progressBlock)progress;

/**
 *  GET二进制数据的请求
 *
 *  @param requestKey 请求路径
 *  @param params     请求参数
 *  @param success    成功回调 返回的data为服务器获得的二进制数据
 *  @param failure    失败回调
 *  @param progress   进度回调
 *  @return 数据任务
 */
- (NSURLSessionDataTask *)GETData:(NSString *)requestKey
                           params:(NSDictionary *)params
                          success:(successBlock)success
                          failure:(failureBlock)failure
                         progress:(progressBlock)progress;

/**
 *  普通的POST请求
 *
 *  @param requestKey 请求路径
 *  @param params     请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @param progress   进度回调
 *  @return 数据任务
 */
- (NSURLSessionDataTask *)POST:(NSString *)requestKey
                        params:(NSDictionary *)params
                       success:(successBlock)success
                       failure:(failureBlock)failure
                      progress:(progressBlock)progress;


/**
 *  在请求体中添加json字符串的POST
 *
 *  @param requestKey 请求路径
 *  @param otherKey   参数key
 *  @param params     字典参数(内部转换成Json)
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @param progress   进度回调
 *  @return post任务
 */
- (NSURLSessionUploadTask *)POSTWithJson:(NSString *)requestKey
                                otherKey:(NSString *)otherKey
                                  params:(NSDictionary *)params
                                 success:(successBlock)success
                                 failure:(failureBlock)failure
                                progress:(progressBlock)progress;



/**
 *  以表单形式 上传数据的POST请求 
 *  适用于客户端与web前端统一处理上传数据 以及多文件上传
 *
 *  @param requestKey 请求路径
 *  @param data       上传的文件二进制数据流
 *  @param fileParam  文件参数名
 *  @param fileName   文件名
 *  @param type       文件类型 e.g. image/jpeg video/mp4
 *  @param params     请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @param progress   进度回调 返回NSProgress对象,KVO监听该对象的kProgressKey属性
 *  @return 数据任务
 */
- (NSURLSessionDataTask *)UPLoadByForm:(NSString *)requestKey
                                fileData:(NSData *)data
                               fileParam:(NSString *)fileParam
                                fileName:(NSString *)fileName
                                fileType:(NSString *)type
                                  params:(NSDictionary *)params
                                 success:(successBlock)success
                                 failure:(failureBlock)failure
                                progress:(progressBlock)progress;


/**
 *  在请求体的HTTPBody中写入文件的二进制数据 适用于单个文件上传
 *
 *  @param requestKey 请求路径
 *  @param fileURL    文件URL路径
 *  @param bodyData   文件二进制数据
 *  @param progress   上传进度
 *  @param success    成功回调
 *  @param failure    失败回调
 */
- (NSURLSessionUploadTask *)UPLoadByBody:(NSString *)requestKey
                                fromFile:(NSURL *)fileURL
                          orFromBodyData:(NSData *)bodyData
                                progress:(progressBlock)progress
                                 success:(successBlock)success
                                 failure:(failureBlock)failure;


/**
 *  简单的下载文件
 *
 *  @param requestKey 下载文件路径
 *  @param progress   下载进度回调 fractionCompleted属性表示进度
 *  @param success    请求成功回调 返回下载文件的本地路径
 *  @param failure    请求失败回调
 */
- (NSURLSessionDownloadTask *)Download:(NSString *)requestKey
                              progress:(progressBlock)progress
                               success:(successBlock)success
                               failure:(failureBlock)failure;

@end

