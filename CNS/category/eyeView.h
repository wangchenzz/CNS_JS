//
//  eyeView.h
//  1.5-2015
//
//  Created by Mac on 16/2/16.
//  Copyright © 2016年 竞思. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  渐变的眼睛动画,使用了贝塞尔曲线和 cashapelayer 完成.
 */

@interface eyeView : UIView

/**
 *  value 0~100  default = 0  value 将决定眼睛的完成度;
 */
@property (nonatomic ,assign) float value;

/**
 *  眼睛的颜色;
 */
@property (nonatomic ,retain) UIColor *eyeColor;


@end
