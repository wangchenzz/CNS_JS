//
//  testBaseView.m
//  CNS
//
//  Created by Mac on 16/6/3.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "testBaseView.h"

@interface testBaseView ()

@property (nonatomic,retain) CAShapeLayer *coreLayer;


@property (nonatomic,retain) UIBezierPath *path1;


@property (nonatomic,retain) UIBezierPath *path2;


@property (nonatomic,retain) CABasicAnimation *animation;

@end

@implementation testBaseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (self.setAnimationOn) {
        _path1 = nil;
        
        _animation = nil;
        
        CGPoint touchPoint = [[touches anyObject] locationInView:self];
        
        [self.path1 addArcWithCenter:touchPoint radius:0.01 startAngle:0 endAngle:M_PI *2 clockwise:YES];
        
        [self.coreLayer addAnimation:self.animation forKey:nil];
    }
}

-(CAShapeLayer *)coreLayer{
    if (!_coreLayer) {
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        
        layer.fillColor = [UIColor clearColor].CGColor;
        
        layer.strokeColor = [UIColor greenColor].CGColor;
        
        layer.strokeStart = 0;
        
        layer.lineWidth = 4;
        
        layer.path = self.path1.CGPath;
        
        [self.layer addSublayer:layer];
        
        self.coreLayer = layer;
    }
    return _coreLayer;
}

-(UIBezierPath *)path1{
    if (!_path1) {
        
        UIBezierPath *path1 =[UIBezierPath bezierPath];
        
//        [path1 addArcWithCenter:self.center radius:0.01 startAngle:0 endAngle:M_PI *2 clockwise:YES];
        
        _path1 = path1;
        
    }
    return _path1;
}

-(UIBezierPath *)path2{
    if (!_path2) {
        
        UIBezierPath *path2 =[UIBezierPath bezierPath];
        
        [path2 addArcWithCenter:self.center radius:self.bounds.size.width startAngle:0 endAngle:M_PI *2 clockwise:YES];
        _path2 = path2;
        
    }
    return _path2;
}

-(CABasicAnimation *)animation{
    if (!_animation) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.fromValue = (id) self.path1.CGPath;
        animation.toValue = (id) self.path2.CGPath;
        
        animation.duration = 0.8;
        animation.repeatCount = 1;
        animation.delegate = self;
        _animation = animation;
    }
    return _animation;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    

}



@end
