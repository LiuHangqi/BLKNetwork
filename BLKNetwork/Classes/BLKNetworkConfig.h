//
//  BLKNetworkConfig.h
//  BLKNetworkDemo
//
//  Created by HangqiLiu on 2016/10/18.
//  Copyright © 2016年 bianlike. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BLKBaseRequest;
@class AFSecurityPolicy;

@protocol BLKUrlFilterProtocol <NSObject>


/**
 请求之前重新配置URL

 @param originUrl 原URL
 @param request   request

 @return 返回配置后的URL
 */
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(BLKBaseRequest *)request;

@end

@protocol BLKParameterFilterProtocol <NSObject>


/**
 请求之前重新配置parameters

 @param originParameter 原parameters
 @param request         request

 @return 返回配置后的parameters
 */
- (NSDictionary *)filterParameter:(NSDictionary *)originParameter withRequest:(BLKBaseRequest *)request;

@end

@protocol BLKRequestSuccessFilterProtocol <NSObject>


/**
 请求服务器成功后，对request进行重新配置

 @param request rquest

 @return 请求是否成功
 */
- (BOOL)filterSuccessWithRequest:(BLKBaseRequest *)request;

@end

@interface BLKNetworkConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedConfig;

@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;

@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

/**
 重新配置url
 */
@property (nonatomic, strong) id <BLKUrlFilterProtocol> urlFilter;


/**
 重新配置parameter
 */
@property (nonatomic, strong) id <BLKParameterFilterProtocol> parameterFilter;


/**
 成功后重新配置request
 */
@property (nonatomic, strong) id <BLKRequestSuccessFilterProtocol> requestSuccessFilter;

@end
