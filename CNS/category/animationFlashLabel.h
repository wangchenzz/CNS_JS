//
//  animationFlashLabel.h
//  1.5-2015
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 竞思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface animationFlashLabel : UILabel


/**
 * 一个一个出现字的 label;
 */

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

-(void)showAnimation:(float)animationSpace completion:(void (^)(BOOL finished))completion;

/**
 *  将要显示的字;
 */
@property (nonatomic,copy) NSString *willShowText;

@property (nonatomic,assign)VerticalAlignment verticalAlignment;

/**
 *  第一个问题,如果当第一个动画还没做完之前 又给值 text 如何解决?
 *  第二个问题,如果       -- 痛苦的解决了.
 */


@end
