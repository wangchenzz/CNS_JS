//
//  UIButton+Extension.m
//  1.5-2015
//
//  Created by Mac on 16/2/1.
//  Copyright © 2016年 竞思. All rights reserved.
//

#import "UIButton+Extension.h"

#import <objc/runtime.h>


static void *buttonKey = &buttonKey;

@implementation UIButton (Extension)


-(void)addBlockToButton:(UIControlEvents)event withBlock:(addBlock)block{
    
    objc_setAssociatedObject(self, &buttonKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self addTarget:self action:@selector(blockMethd:) forControlEvents:event];
    
}

-(void)blockMethd:(UIButton *)but{

    addBlock add = objc_getAssociatedObject(self, &buttonKey);
    
    if (add) {
        add(self);
    }
}


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
+(UIButton *)buttonWithColor:(UIColor*)color target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents imageForNormal:(UIImage *)normalImage selectImage:(UIImage *)highlighImage titleForNoraml:(NSString *)title titleColor:(UIColor*)titlecolor whsize:(CGFloat)whsize{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.showsTouchWhenHighlighted = YES;
    
    button.backgroundColor = color;
    
    [button addTarget:target action:action forControlEvents:controlEvents];
    
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    
    [button setBackgroundImage:highlighImage forState:UIControlStateHighlighted];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:titlecolor forState:UIControlStateNormal];
    
    [button.titleLabel setFont:JSFont(33)];
    
    [button.titleLabel sizeToFit];
    
    button.width = button.height = whsize;
    
    button.layer.cornerRadius = button.width *.5;
    
    button.layer.masksToBounds = YES;
    
    return button;
}

@end
