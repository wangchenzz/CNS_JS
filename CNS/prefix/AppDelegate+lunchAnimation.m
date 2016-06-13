//
//  AppDelegate+lunchAnimation.m
//  CNS
//
//  Created by Mac on 16/6/3.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "AppDelegate+lunchAnimation.h"


static NSString * const Setpkey = @"animationKey";

static void *mainImageKey = &mainImageKey;

static void *wordsImageKey = &wordsImageKey;

@implementation AppDelegate (lunchAnimation)

-(void)animationComeOn{
    [self doStep1];
}

-(void)doStep1{
    
    UIImageView *mainImageView = [[UIImageView alloc] init];
    
    mainImageView.image = [UIImage imageNamed:@"lunchBackRound"];
    
    [mainImageView setFrame:CGRectMake(0, 0, JSFrame.size.width * 3, JSFrame.size.height)];
    
    UIWindow *windows = [[UIApplication sharedApplication] keyWindow];
    
    mainImageView.center = windows.center;
    
    [windows addSubview:mainImageView];
    
//    [windows insertSubview:mainImageView atIndex:0];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    
    animation.delegate = self;
    
    mainImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    animation.fromValue = [NSNumber numberWithInteger:300];
    
    animation.toValue = [NSNumber numberWithInteger:150];;
    
    animation.duration = 0.8;
    
    animation.repeatCount = 1;
    
    animation.autoreverses = NO;
    
    mainImageView.userInteractionEnabled = YES;
    
    animation.removedOnCompletion = NO;

    [animation setValue:@"step1" forKey:Setpkey];
    
    animation.fillMode = kCAFillModeBoth;

    [mainImageView.layer addAnimation:animation forKey:nil];
    
    self.mainImageView = mainImageView;
    
}

-(void)doStep2{
    /**
     出现图像的过渡动画:
     */
    self.wordsImageView = [[UIImageView alloc] init];
    
    UIImage * image = [UIImage imageNamed:@"lunchWords"];
    
    CGRect bounds = {{0,0},image.size};
    
    self.wordsImageView.bounds = bounds;
    
    CABasicAnimation *imageAnimation = [CABasicAnimation animationWithKeyPath:@"contents"];
    
    imageAnimation.removedOnCompletion = YES;
    
    imageAnimation.repeatCount = 1;
    
    imageAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    imageAnimation.duration = 1.0f;
    
    [self.wordsImageView.layer addAnimation:imageAnimation forKey:nil];
    
    
    self.wordsImageView.image = image;

    /**
     *  图像出现之后;先图像上移
     */
    CABasicAnimation *imageMoveAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.wordsImageView];
    
    self.wordsImageView.x = 500;
    
    self.wordsImageView.y = 100;
    
    imageMoveAnimation.fromValue = @220;
    
    imageMoveAnimation.toValue = @130;
    
    imageMoveAnimation.duration = 1.5;
    
    imageMoveAnimation.repeatCount = 1;
    
    imageMoveAnimation.autoreverses = NO;
    
    imageMoveAnimation.removedOnCompletion = NO;
    
    
    imageMoveAnimation.fillMode = kCAFillModeBoth;
    
    imageMoveAnimation.delegate = self;
    
    /**
     *  组合起来
     */
    //5700
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    group.animations = @[imageMoveAnimation,imageAnimation];
    
    group.duration = 0.8f;
    
    group.repeatCount = 1;
    
    group.delegate = self;
    
    [imageMoveAnimation setValue:@"step2" forKey:Setpkey];
    
    [self.wordsImageView.layer addAnimation:imageMoveAnimation forKey:nil];
    
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if ([[anim valueForKey:Setpkey] isEqualToString:@"step1"]) {
        
        [self doStep2];
    
    }
    if ([[anim valueForKey:Setpkey] isEqualToString:@"step2"]) {
        
        [self.wordsImageView removeFromSuperview];
        [self.mainImageView removeFromSuperview];
    
    }
}

#pragma mark - property

-(UIImageView *)mainImageView{
    return objc_getAssociatedObject(self, &mainImageKey);
}

-(void)setMainImageView:(UIImageView *)mainImageView{
    objc_setAssociatedObject(self, &mainImageKey, mainImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIImageView *)wordsImageView{
    return objc_getAssociatedObject(self, &wordsImageKey);
}

-(void)setWordsImageView:(UIImageView *)wordsImageView{
    objc_setAssociatedObject(self, &wordsImageKey, wordsImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
