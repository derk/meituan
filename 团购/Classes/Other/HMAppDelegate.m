//
//  HMAppDelegate.m
//  美团
//
//  Created by apple on 14-12-11.
//  Copyright (c) 2014年 Simple. All rights reserved.
//

#import "HMAppDelegate.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "HMNavigationController.h"
#import "HMDealsViewController.h"

// 支付宝
#import "AlixPayResult.h"
#import "DataVerifier.h"

//int const HMAge = 10;
//NSString  * const HMAppKey = @"53fb4899fd98c5a4db00a8a0";
// 友盟

@implementation HMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    HMDealsViewController *dealsVc = [[HMDealsViewController alloc] init];
    self.window.rootViewController = [[HMNavigationController alloc] initWithRootViewController:dealsVc];
    [self.window makeKeyAndVisible];
    
    // 1.注册友盟的appKey
    [UMSocialData setAppKey:UMAppKey];
    
    // 2.打开SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
    return YES;
}

- (void)setupAge:(int)age
{

}

#pragma mark - 从新浪客户端回到自己应用时会自动调用(友盟内部会处理返回的accessToken)
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	[self parse:url application:application];
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
	[self parse:url application:application];
    return  [UMSocialSnsService handleOpenURL:url];
}

- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    
	if (result.statusCode == 9000) { // 成功
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            //            NSString* key = @"签约帐户后获取到的支付宝公钥";
            //			id<DataVerifier> verifier;
            //            verifier = CreateRSADataVerifier(key);
            //
            //			if ([verifier verifyString:result.resultString withSign:result.signString])
            //            {
            //                //验证签名成功，交易结果无篡改
            //			}
            
    } else {
        // 失败
    }
    
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
	return [[AlixPayResult alloc] initWithString:query];
#endif
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearMemory];
}

@end
