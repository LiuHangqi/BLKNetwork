//
//  BLKViewController.m
//  BLKNetwork
//
//  Created by LiuHangqi on 10/21/2016.
//  Copyright (c) 2016 LiuHangqi. All rights reserved.
//

#import "BLKViewController.h"
#import "LDRequestManager.h"
#import "AFNetworking.h"

@interface BLKViewController ()

@end

@implementation BLKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
}


- (IBAction)click:(id)sender {
    
    [[AFHTTPSessionManager manager]GET:@"http://www.blkee.com" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
//    [[LDRequestManager sharedInstance]loginWithUsername:@"18560123803" password:@"12345qwert" completion:^(__kindof BLKRequest *request) {
//        
//        if (request.responseError) {
//            
//            NSLog(@"%@",request.responseError);
//            return ;
//        }
//        NSLog(@"%@",request.responseObject);
//    }];
    
    
    
//    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectZero];
//    [self.view addSubview:web];
//    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.blkee.com"]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
