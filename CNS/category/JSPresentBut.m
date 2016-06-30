//
//  JSPresentBut.m
//  1.5-2015
//
//  Created by Mac on 16/2/22.
//  Copyright © 2016年 竟思. All rights reserved.
//

#import "JSPresentBut.h"

@implementation JSPresentBut

+(instancetype)flash{

    return [[self alloc]init];
    
}

-(instancetype)init{
    
    if (self = [super init]) {
        
        [self setUpAl];
    
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        
        /**
         *  这里会自动调 init 方法;
         */
        [self setUpAl];
    }
    return self;
}
-(void)setUpAl{
    
    self.frame = JSFrame;
    
    UIButton *butto1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [butto1 setBackgroundColor:[UIColor blueColor]];
    
    butto1.width = butto1.height = self.width * .15;
    
    butto1.y = self.height;
    
    butto1.centerX = self.width * .3;
    
    butto1.layer.cornerRadius = self.frame.size.width *.075;
    
    [self addSubview:butto1];
    
    self.leftButton = butto1;
    
    UIButton *but2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [but2 setBackgroundColor:[UIColor redColor]];
    
    but2.width = but2.height = self.width * .15;
    
    but2.y = self.height;
    
    but2.centerX = self.width * .65;
    
    but2.layer.cornerRadius = self.width *.075;
    
    [self setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.8]];
    
    [self addSubview:but2];
    
    self.rightButton = but2;

    self.alpha = 0;
    
    /**
     *  如何制作视屏播放器
     *
     *  @return ..
     */
}

-(void)show{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    
    [UIView animateWithDuration:1.2 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.leftButton.transform = CGAffineTransformMakeTranslation(0, - self.height * .6);
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:1.2 delay:0.1 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.rightButton.transform = CGAffineTransformMakeTranslation(0, - self.height * .6);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self hide];

}

-(void)hide{
    [UIView animateWithDuration:0.8 animations:^{
        self.alpha = 0;
    }];
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.leftButton.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    
    [UIView animateWithDuration:0.8 delay:0.1 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.rightButton.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
//        [self.leftButton removeFromSuperview];
//        
//        [self.rightButton removeFromSuperview];
//        
//        [self removeFromSuperview];
        
    }];
    
}

-(void)dealloc{
    
    JSLog(@"不需要重复创建,创建一次就够了");
    
}


@end
