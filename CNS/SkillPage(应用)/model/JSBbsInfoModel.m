//
//  JSBbsInfoModel.m
//  CNS
//
//  Created by Mac on 16/5/20.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "JSBbsInfoModel.h"

@implementation JSBbsInfoModel

/**
 *  评论次数
 */
-(void)setPCount:(NSString *)pCount{
    _pCount = pCount;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = iconFont;
    
    
    CGRect textRect = [_pCount boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    _pCountRect = textRect;
}


/**
 *  浏览次数
 */
-(void)setCtr:(NSString *)ctr{
    _ctr = ctr;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = iconFont;
    
    
    CGRect textRect = [_ctr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    _ctrRect = textRect;
    
}

/**
 *  时间
 */
-(NSString *)createtime{
    
    /**
     *  得到发帖时间,
     */
    NSDate *date = [NSDate JSDateFromString:_createtime];
    
    NSTimeInterval fromNow = [date timeIntervalSinceNow];
    
    /**
     *  或得到目前需要的时间.
     */
    
    int ms = (int)fromNow;
    
    if (ms/60 == 0) {
        return  @"刚刚";
    }else if(ms/60/60 == 0){
        
//        NSLog(@"%@",[NSString stringWithFormat:@"%d分钟前",-ms/60]);
        
        return [NSString stringWithFormat:@"%d分钟前",-ms/60];
    }else if(ms/60/60/24 ==0){
        
//        NSLog(@"%@",[NSString stringWithFormat:@"%d小时前",-ms/60/60]);
        return [NSString stringWithFormat:@"%d小时前",-ms/60/60];
    }else{
        return [_createtime substringWithRange:NSMakeRange(0, 10)];
    }
}


@end
