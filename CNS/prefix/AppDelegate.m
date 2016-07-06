//
//  AppDelegate.m
//  CNS
//
//  Created by Mac on 16/2/29.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "AppDelegate.h"

#import "AppDelegate+lunchAnimation.h"

#import "JSTabBarController.h"

#import "loginViewController.h"

#import "AppDelegate+NewVision.h"

#import "JSNewVisionViewControler.h"

@interface AppDelegate ()

@property (nonatomic,assign) BOOL isAnimation;

@property (nonatomic,retain) JSTabBarController *mainViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //    _isAnimation = YES;
    //
    //    /**
    //     *  先判断是否是新的版本,  1.是新版本就进入新版界面. 要求登录 进入.....
    //     */
    //
    //    if ([self decideIsNewVisionCome]) {
    //        /**
    //         *  确定显示新版本的更新
    //         */
    //        _isAnimation = NO;
    //        JSNewVisionViewControler *vc = [[JSNewVisionViewControler alloc] init];
    //
    //        self.window.rootViewController =vc;
    //
    //
    //        [self.window makeKeyAndVisible];
    //
    //        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firstVisit) name:@"CNSgameHWMCD" object:nil];
    //
    //        return YES;
    //    }
    
    
    /**
    决定根试图是什么的时候，先要进行判读览，是否包含 token 值。如果未包含，即可直接进入登录界面。
    如果有 token，且不为空，那就需要把 token 进行验证，验证完毕后才能继续判断。如果发送请求成功且返回登录成功就进入首页，否则进行登录。 --  将 token 直接置空 会造成在没有网络或者服务器出问题的是将用户的信息消除掉了。
     */
    
    [self decideVC];
    
    return YES;
}

///Users/Mac/Desktop/ios_IM_sdk_V3.1.3

-(JSTabBarController *)mainViewController{
    if (!_mainViewController) {
        _mainViewController = [[JSTabBarController alloc] init];
        
    }
    return _mainViewController;
}

-(void)decideVC{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"loginName"] = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginName"];
    
    dic[@"token"] = [[NSUserDefaults standardUserDefaults]valueForKey:@"token"];
    
    NSString *tokenStr = dic[@"token"];
    
    if ([tokenStr isEqualToString:@"null"] || !tokenStr.length) {
        
        loginViewController *lc = [[loginViewController alloc] init];
        
        self.window.rootViewController = lc;
        
        [self.window makeKeyAndVisible];
        
        //        if (_isAnimation) {
        ////            [self animationComeOn];
        //        }
        
    }else{
        
        __weak __typeof__(self) weakSelf = self;
        [[INetworking shareNet] GET:loginUrl withParmers:dic do:^(id returnObject, BOOL isSuccess) {
            NSDictionary *dic = (NSDictionary *)returnObject;
            if (isSuccess && [dic[@"msg"]isEqualToString:@"1"]) {
                
                weakSelf.window.rootViewController = self.mainViewController;
                
                [weakSelf.window makeKeyAndVisible];
                
            }else{
                
                [[NSUserDefaults standardUserDefaults]setValue:@"null" forKey:@"token"];
                
                loginViewController *lc = [[loginViewController alloc] init];
                
                weakSelf.window.rootViewController = lc;
                
                [weakSelf.window makeKeyAndVisible];
                
                //                if (_isAnimation) {
                ////                    [self animationComeOn];
                //
            }
        }];
    }
}


-(void)firstVisit{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CNSgameHWMCD" object:nil];
    [self decideVC];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window{
    
    /**
     *  禁止 iPad 横屏;
     */
    return UIInterfaceOrientationMaskPortrait;
    
}

@end
