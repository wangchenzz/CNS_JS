//
//  JSUserManager.m
//  CNS
//
//  Created by Mac on 16/6/2.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "JSUserManager.h"

@interface JSUserManager ()
{
    NSUserDefaults *_defaults;
}

@end

static JSUserManager *shareManager = nil;

@implementation JSUserManager

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

-(instancetype)init{
    if (self = [super init]) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

-(NSMutableDictionary *)getUserDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"loginName"] = [_defaults objectForKey:@"loginName"];
    dic[@"token"] = [_defaults objectForKey:@"token"];
    return dic;
}



@end
