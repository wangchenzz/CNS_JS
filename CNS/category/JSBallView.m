
//
//  JSLoding.m
//  testHowToAddEmoji
//
//  Created by Mac on 16/6/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "JSBallView.h"

#import <objc/runtime.h>

const static void *animation1Key = &animation1Key;
const static void *animation2Key = &animation2Key;


@interface JSBallView ()

@property (nonatomic,retain) CAShapeLayer *leftLayer;

@property (nonatomic,retain) CAShapeLayer *RightLayer;

@property (nonatomic,retain) UIBezierPath *littlePath;

@property (nonatomic,retain) UIBezierPath *bigPath;

@property (nonatomic,retain) CABasicAnimation *animation1;

@property (nonatomic,retain) CABasicAnimation *animation2;

@end

@implementation JSBallView

+(instancetype)loding{

    return [[self alloc] init];

}

-(instancetype)init{
    if (self = [super init]) {
        [self setLayer];
    }
    
    return self;
}

-(void)setLayer{
    self.bounds = CGRectMake(0, 0, 56, 32);
    
    UIBezierPath *littleBezier = [UIBezierPath bezierPath];
    
    [littleBezier addArcWithCenter:CGPointZero radius:16 startAngle:0 endAngle:M_PI *2 clockwise:YES];
    
    UIBezierPath *bigBezier = [UIBezierPath bezierPath];
    
    [bigBezier addArcWithCenter:CGPointZero radius:8 startAngle:0 endAngle:M_PI *2 clockwise:YES];
    
    self.bigPath = bigBezier;
    
    self.littlePath = littleBezier;
    
    self.leftLayer = [CAShapeLayer layer];
    
    self.RightLayer = [CAShapeLayer layer];
    
    self.leftLayer.fillColor = JSColor(5, 161, 238).CGColor;
    
    self.leftLayer.path = littleBezier.CGPath;
    
    [self.layer addSublayer:self.leftLayer];
    
    self.leftLayer.opacity = 1;
    
    self.leftLayer.position = CGPointMake(16, 16);
    
    self.RightLayer.fillColor = JSColor(32, 231, 131).CGColor;
    
    self.RightLayer.path = bigBezier.CGPath;
    
    [self.layer addSublayer:self.RightLayer];
    
    self.RightLayer.opacity = 1;
    
    self.RightLayer.position = CGPointMake(40, 16);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (id) self.littlePath.CGPath;
    animation.toValue = (id) self.bigPath.CGPath;
    animation.duration = 0.4;
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = YES;
    [self.leftLayer addAnimation:animation forKey:nil];
    self.animation1 = animation;
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"path"];
    animation2.fromValue = (id) self.bigPath.CGPath;
    animation2.toValue = (id) self.littlePath.CGPath;
    
    animation2.duration = 0.4;
    animation2.repeatCount = MAXFLOAT;
    animation2.autoreverses = YES;
    self.animation2 = animation2;
    [self.RightLayer addAnimation:animation2 forKey:nil];
}

-(void)layoutSubviews{
    self.bounds = CGRectMake(0, 0, 56, 32);
}

//-(void)setAnimation1:(CABasicAnimation *)animation1{
//    objc_setAssociatedObject(self, &animation1Key, animation1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//-(void)setAnimation2:(CABasicAnimation *)animation2{
//    objc_setAssociatedObject(self, &animation2Key, animation2, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//-(CABasicAnimation *)animation1{
//  return  objc_getAssociatedObject(self, animation1Key);
//}
//
//-(CABasicAnimation *)animation2{
//    return  objc_getAssociatedObject(self, animation2Key);
//}

@end
