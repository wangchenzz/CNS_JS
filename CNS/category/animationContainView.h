//
//  animationScrollView.h
//  CNS
//
//  Created by Mac on 16/6/7.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface animationContainView : UIView

/**
 *  配合 scrollview 的 imageview;
 */

@property (nonatomic,retain) UIImageView *picture;

-(void)offset;

@end
