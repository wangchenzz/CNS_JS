//
//  tableHeaderButton.h
//  CNS
//
//  Created by Mac on 16/5/20.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import <UIKit/UIKit.h>

@class tableHeaderButtonView;
@protocol tableHeaderButtonViewDelegate <NSObject>

@optional

-(NSArray *)titleArrayForTableHeaderButtonView:(tableHeaderButtonView *)view;

-(void)tableHeaderButtonView:(tableHeaderButtonView *)view didSelecte:(NSInteger)index;

@end

@interface tableHeaderButtonView : UIView

/**
 *  用代理来返回 按钮的标题和个数 并不好. 这样就不能对按钮进行编辑和操作;
 */

@property (nonatomic,weak) id <tableHeaderButtonViewDelegate> delegare;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,retain) UIFont *titleFont;

+(instancetype)getHeader;



@end
