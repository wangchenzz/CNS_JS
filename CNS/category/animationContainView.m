//
//  animationScrollView.m
//  CNS
//
//  Created by Mac on 16/6/7.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "animationContainView.h"

@implementation animationContainView

-(instancetype)init{
    if (self = [super init]) {
        self.clipsToBounds = YES;
        self.picture = [[UIImageView alloc] init];
        self.picture.frame = CGRectMake(0, 0, JSFrame.size.width, JSFrame.size.height);
        self.picture.contentMode = UIViewContentModeScaleAspectFill;
//        self.picture.clipsToBounds = YES;
        [self addSubview:self.picture];
    }
    return self;
}
//
//-(void)layoutSubviews{
//    
//    CGRect selfRect ;
//    
//    selfRect = self.frame;
//    
//    self.picture.bounds = CGRectMake(0, 0, selfRect.size.width, selfRect.size.height);
//    
//    
////    self.picture.bounds = self.bounds;
////    sss = self.bounds.size;
//}


-(void)offset{
    CGRect rectInwindows = [self convertRect:self.bounds toView:nil];
    
//    CGFloat centerMinX = CGRectGetMinX(rectInwindows);
    
//    CGPoint windowCenter = self.window.center;
//    
//    CGFloat cellOffsetX = centerMinX - windowCenter.x;
//    s
//    CGFloat offsetDig =  cellOffsetX / self.window.frame.size.height *2;
    
    
    CGFloat bjZero = rectInwindows.origin.x;
    
    CGAffineTransform transX = CGAffineTransformMakeTranslation(-bjZero * 0.8, 0);
    
//    self.picture.transform = transX;
//    
//    CGAffineTransform transX = CGAffineTransformMakeTranslation(-offsetDig * self.width * 0.4, 0);
    
    
    self.picture.transform = transX;
}


@end
