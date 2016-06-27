//
//  UIButton+Extension.h
//  1.5-2015
//
//  Created by Mac on 16/2/1.
//  Copyright © 2016年 竞思. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^addBlock)(UIButton *but);

@interface UIButton (Extension)

//@property (nonatomic,copy) addBlock doingBlock;


/**
 *  代码简化
 *
 *  @param color         背景颜色
 *  @param target        target
 *  @param action        方法
 *  @param controlEvents 状态
 *  @param normalImage   普通状态下的图片
 *  @param highlighImage 高亮状态下的图片
 *  @param title         标题
 *  @param titlecolor    标题颜色
 *
 *  @return 按钮
 */
+(UIButton *)buttonWithColor:(UIColor*)color target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents imageForNormal:(UIImage *)normalImage selectImage:(UIImage *)highlighImage titleForNoraml:(NSString *)title titleColor:(UIColor*)titlecolor whsize:(CGFloat)whsize;

/**
 *  为 button添加一个 block
 *
 *  @param event  执行状态
 *  @param block 代码块
 */

-(void)addBlockToButton:(UIControlEvents)event withBlock:(addBlock)block;

@end
