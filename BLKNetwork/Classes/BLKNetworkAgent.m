//
//  BLKNetworkAgent.m
//  Pods
//
//  Created by liu on 2017/1/16.
//
//

#import "BLKNetworkAgent.h"
#import "BLKNetworkConfig.h"
#import <pthread/pthread.h>

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

@implementation BLKNetworkAgent {
    AFHTTPSessionManager *_manager;
    BLKNetworkConfig *_config;
    AFJSONResponseSerializer *_jsonResponseSerializer;
    NSMutableDictionary<NSNumber *, BLKBaseRequest *> *_requestsRecord;
    
    dispatch_queue_t _processingQueue;
    pthread_mutex_t _lock;
    NSIndexSet *_allStatusCodes;
}

+ (instancetype)sharedAgent {
    
    static id sharedAgent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAgent = [[self alloc]init];
    });
    
    return sharedAgent;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        _config = [BLKNetworkConfig sharedConfig];
        
    }
    
    return self;
}

@end
