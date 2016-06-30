//
//  BezierPathLogoView.m
//  CNS
//
//  Created by Mac on 16/6/30.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "BezierPathLogoView.h"

@interface BezierPathLogoView ()

@property (nonatomic,strong) UIBezierPath *bezier1;

@property (nonatomic,strong) UIBezierPath *bezier2;

@property (nonatomic,strong) UIBezierPath *bezier3;

@property (nonatomic,strong) UIBezierPath *bezier4;

@property (nonatomic,strong) UIBezierPath *bezier5;

@property (nonatomic,strong) UIBezierPath *bezier6;

@property (nonatomic,strong) CAShapeLayer *coreLayer;


@end





@implementation BezierPathLogoView

+(instancetype)getLogo{
    
    return [[self alloc] init];
}

-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 60, 60);
        [self addLayerToLaunchView];
    }
    return self;
}

-(void)addLayerToLaunchView
{
    [self addBezizer];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    
    UIBezierPath *allPath = [UIBezierPath bezierPath];
    
    [allPath appendPath:self.bezier1];
    
    [allPath appendPath:self.bezier2];
    
    [allPath appendPath:self.bezier3];
    //
    [allPath appendPath:self.bezier4];
    //
    [allPath appendPath:self.bezier5];
    
    [allPath appendPath:self.bezier6];
    
    
    layer.strokeColor = [UIColor whiteColor].CGColor;
    
    layer.lineWidth = 15;
    
//    layer.strokeStart = 1;
    
    //    layer.strokeEnd = 0.5;
    
    layer.path = allPath.CGPath;
    
    
    layer.bounds = CGPathGetBoundingBox(layer.path);
    //    self.animationView.backgroundColor = jscolor;
    layer.position = CGPointMake(self.layer.bounds.size.width / 2, self.layer.bounds.size.height/ 2);
    
    layer.fillColor = [UIColor clearColor].CGColor;
    
    layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    
    [self.layer addSublayer:layer];
    
    self.coreLayer = layer;
}

-(void)setProgress:(CGFloat)progress{

    if (progress < 0) {
        _progress = 0;
    }else if(progress > 1){
        _progress = 1;
    }else{
        _progress = progress;
    }
    
    self.coreLayer.strokeStart = _progress;
}

-(void)addBezizer{
    {
        UIColor *strokeColor = [UIColor colorWithRed:170/255.0 green:60/255.0 blue:99/255.0 alpha:1.0];
        
        
        UIBezierPath* path1Path = [UIBezierPath bezierPath];
        [path1Path moveToPoint: CGPointMake(35.18, 9.58)];
        [path1Path addLineToPoint: CGPointMake(0.23, 68.51)];
        [path1Path addCurveToPoint: CGPointMake(18.82, 75.84) controlPoint1: CGPointMake(0.23, 68.51) controlPoint2: CGPointMake(-4.89, 70.44)];
        [path1Path addCurveToPoint: CGPointMake(136.26, 68.51) controlPoint1: CGPointMake(44.01, 81.57) controlPoint2: CGPointMake(97.38, 61.51)];
        [path1Path addCurveToPoint: CGPointMake(256.13, 126.74) controlPoint1: CGPointMake(175.13, 75.51) controlPoint2: CGPointMake(256.13, 126.74)];
        [path1Path addLineToPoint: CGPointMake(256, 130.87)];
        [path1Path addLineToPoint: CGPointMake(125.45, 207.41)];
        [path1Path addLineToPoint: CGPointMake(125.08, 237.17)];
        [path1Path addLineToPoint: CGPointMake(169.74, 263.59)];
        [path1Path addLineToPoint: CGPointMake(195.47, 247.85)];
        [path1Path addLineToPoint: CGPointMake(161.13, 227.65)];
        [path1Path addLineToPoint: CGPointMake(161.31, 216.85)];
        [path1Path addLineToPoint: CGPointMake(292.16, 140.39)];
        [path1Path addLineToPoint: CGPointMake(292.16, 115.8)];
        [path1Path addCurveToPoint: CGPointMake(145.96, 42.88) controlPoint1: CGPointMake(292.16, 115.8) controlPoint2: CGPointMake(198.96, 56.35)];
        [path1Path addCurveToPoint: CGPointMake(41.39, 52.03) controlPoint1: CGPointMake(115.37, 35.1) controlPoint2: CGPointMake(41.39, 52.03)];
        [path1Path addLineToPoint: CGPointMake(51.68, 32.68)];
        [path1Path addCurveToPoint: CGPointMake(133.61, 24.24) controlPoint1: CGPointMake(51.68, 32.68) controlPoint2: CGPointMake(120.22, 22.44)];
        [path1Path addCurveToPoint: CGPointMake(206.4, 53.49) controlPoint1: CGPointMake(171.79, 29.38) controlPoint2: CGPointMake(206.4, 53.49)];
        [path1Path addLineToPoint: CGPointMake(226.26, 42.51)];
        [path1Path addCurveToPoint: CGPointMake(139.3, 0.67) controlPoint1: CGPointMake(226.26, 42.51) controlPoint2: CGPointMake(178.02, 7.76)];
        [path1Path addCurveToPoint: CGPointMake(43.72, 9.09) controlPoint1: CGPointMake(117.17, -3.38) controlPoint2: CGPointMake(43.72, 9.09)];
        [path1Path addLineToPoint: CGPointMake(35.18, 9.58)];
        [path1Path closePath];
        path1Path.miterLimit = 4;
        
        path1Path.usesEvenOddFillRule = YES;
        
        [strokeColor setStroke];
        path1Path.lineWidth = 1;
        [path1Path stroke];
        
        
        //// Path-2 Drawing
        UIBezierPath* path2Path = [UIBezierPath bezierPath];
        [path2Path moveToPoint: CGPointMake(352.13, 8.17)];
        [path2Path addCurveToPoint: CGPointMake(309.45, 1.63) controlPoint1: CGPointMake(339.12, 6.98) controlPoint2: CGPointMake(324.08, 4.56)];
        [path2Path addCurveToPoint: CGPointMake(273.29, 1.63) controlPoint1: CGPointMake(294.81, -1.31) controlPoint2: CGPointMake(281.65, 0.84)];
        [path2Path addCurveToPoint: CGPointMake(217.78, 23.61) controlPoint1: CGPointMake(245.61, 4.23) controlPoint2: CGPointMake(217.78, 23.61)];
        [path2Path addLineToPoint: CGPointMake(236.19, 37.48)];
        [path2Path addCurveToPoint: CGPointMake(283.85, 26.31) controlPoint1: CGPointMake(236.19, 37.48) controlPoint2: CGPointMake(261.76, 26.31)];
        [path2Path addCurveToPoint: CGPointMake(307.28, 26.31) controlPoint1: CGPointMake(288.83, 26.31) controlPoint2: CGPointMake(297.17, 25.23)];
        [path2Path addCurveToPoint: CGPointMake(361.72, 34.31) controlPoint1: CGPointMake(323.61, 28.05) controlPoint2: CGPointMake(344.36, 32.49)];
        [path2Path addCurveToPoint: CGPointMake(396.79, 36.63) controlPoint1: CGPointMake(381.35, 36.37) controlPoint2: CGPointMake(396.79, 36.63)];
        [path2Path addLineToPoint: CGPointMake(381.9, 8.17)];
        [path2Path addCurveToPoint: CGPointMake(352.13, 8.17) controlPoint1: CGPointMake(381.9, 8.17) controlPoint2: CGPointMake(368.6, 9.69)];
        [path2Path closePath];
        path2Path.miterLimit = 4;
        
        path2Path.usesEvenOddFillRule = YES;
        
        [strokeColor setStroke];
        path2Path.lineWidth = 1;
        [path2Path stroke];
        
        
        //// Path-3 Drawing
        UIBezierPath* path3Path = [UIBezierPath bezierPath];
        [path3Path moveToPoint: CGPointMake(168.94, 91.26)];
        [path3Path addLineToPoint: CGPointMake(126.46, 114.15)];
        [path3Path addLineToPoint: CGPointMake(126.39, 140.38)];
        [path3Path addLineToPoint: CGPointMake(169.18, 166.27)];
        [path3Path addLineToPoint: CGPointMake(194.19, 151.44)];
        [path3Path addLineToPoint: CGPointMake(160.72, 130.16)];
        [path3Path addLineToPoint: CGPointMake(160.2, 126.2)];
        [path3Path addLineToPoint: CGPointMake(194.47, 106.09)];
        [path3Path addLineToPoint: CGPointMake(168.94, 91.26)];
        [path3Path closePath];
        path3Path.miterLimit = 4;
        
        path3Path.usesEvenOddFillRule = YES;
        
        [strokeColor setStroke];
        path3Path.lineWidth = 1;
        [path3Path stroke];
        
        
        //// Path-4 Drawing
        UIBezierPath* path4Path = [UIBezierPath bezierPath];
        [path4Path moveToPoint: CGPointMake(247.63, 181.93)];
        [path4Path addLineToPoint: CGPointMake(220.39, 196.63)];
        [path4Path addLineToPoint: CGPointMake(255.57, 217.48)];
        [path4Path addLineToPoint: CGPointMake(255.76, 227.22)];
        [path4Path addLineToPoint: CGPointMake(161.29, 282.71)];
        [path4Path addLineToPoint: CGPointMake(125.24, 282.71)];
        [path4Path addLineToPoint: CGPointMake(124.74, 312.59)];
        [path4Path addLineToPoint: CGPointMake(165.01, 312.06)];
        [path4Path addLineToPoint: CGPointMake(291.31, 236.48)];
        [path4Path addLineToPoint: CGPointMake(290.1, 205.93)];
        [path4Path addLineToPoint: CGPointMake(247.63, 181.93)];
        [path4Path closePath];
        path4Path.miterLimit = 4;
        
        path4Path.usesEvenOddFillRule = YES;
        
        [strokeColor setStroke];
        path4Path.lineWidth = 1;
        [path4Path stroke];
        
        
        //// Path-5 Drawing
        UIBezierPath* path5Path = [UIBezierPath bezierPath];
        [path5Path moveToPoint: CGPointMake(247.96, 276.56)];
        [path5Path addLineToPoint: CGPointMake(221.8, 293.39)];
        [path5Path addLineToPoint: CGPointMake(251.98, 311.46)];
        [path5Path addLineToPoint: CGPointMake(291.29, 311.15)];
        [path5Path addLineToPoint: CGPointMake(291.1, 282.97)];
        [path5Path addLineToPoint: CGPointMake(257.63, 283.45)];
        [path5Path addLineToPoint: CGPointMake(247.96, 276.56)];
        [path5Path closePath];
        path5Path.miterLimit = 4;
        
        path5Path.usesEvenOddFillRule = YES;
        
        [strokeColor setStroke];
        path5Path.lineWidth = 1;
        [path5Path stroke];
        
        UIBezierPath* path6Path = [UIBezierPath bezierPath];
        [path6Path moveToPoint: CGPointMake(220.28, 60.04)];
        [path6Path addLineToPoint: CGPointMake(245.61, 75.76)];
        [path6Path addCurveToPoint: CGPointMake(282.62, 65.93) controlPoint1: CGPointMake(245.61, 75.76) controlPoint2: CGPointMake(267.84, 65.72)];
        [path6Path addCurveToPoint: CGPointMake(352.53, 77.78) controlPoint1: CGPointMake(299.84, 66.17) controlPoint2: CGPointMake(329.51, 74.75)];
        [path6Path addCurveToPoint: CGPointMake(388.71, 77.78) controlPoint1: CGPointMake(373.51, 80.54) controlPoint2: CGPointMake(388.71, 77.78)];
        [path6Path addLineToPoint: CGPointMake(396.66, 52.97)];
        [path6Path addCurveToPoint: CGPointMake(361.75, 50.93) controlPoint1: CGPointMake(396.66, 52.97) controlPoint2: CGPointMake(381.46, 53.6)];
        [path6Path addCurveToPoint: CGPointMake(314.32, 42.51) controlPoint1: CGPointMake(347.25, 48.96) controlPoint2: CGPointMake(330.6, 43.79)];
        [path6Path addCurveToPoint: CGPointMake(294.54, 40.38) controlPoint1: CGPointMake(307.53, 41.98) controlPoint2: CGPointMake(300.56, 40.34)];
        [path6Path addCurveToPoint: CGPointMake(272.73, 42.51) controlPoint1: CGPointMake(286.19, 40.44) controlPoint2: CGPointMake(279.19, 42.34)];
        [path6Path addCurveToPoint: CGPointMake(227.22, 57.49) controlPoint1: CGPointMake(253.77, 43.02) controlPoint2: CGPointMake(227.22, 57.49)];
        [path6Path addLineToPoint: CGPointMake(220.28, 60.04)];
        [path6Path closePath];
        path6Path.miterLimit = 4;
        
        path6Path.usesEvenOddFillRule = YES;
        
        [strokeColor setStroke];
        path6Path.lineWidth = 1;
        [path6Path stroke];
        
        
        self.bezier1 = path1Path;
        self.bezier2 = path2Path;
        self.bezier3 = path3Path;
        self.bezier4 = path4Path;
        self.bezier5 = path5Path;
        self.bezier6 = path6Path;
        
        
    }
    
}


@end
