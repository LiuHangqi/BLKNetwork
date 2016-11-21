//
//  LedaoLoginApi.h
//  BLKNetworkDemo
//
//  Created by HangqiLiu on 2016/10/18.
//  Copyright © 2016年 bianlike. All rights reserved.
//

#import "BLKRequest.h"

@interface LDLoginApi : BLKRequest

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password;



@end
