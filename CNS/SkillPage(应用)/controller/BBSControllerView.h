//
//  BBSControllerView.h
//  CNS
//
//  Created by Mac on 16/5/19.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSControllerView : UITableViewController


@property(nonatomic,assign) NSInteger BBSType;


@property(nonatomic,weak) UINavigationController *navi;

-(instancetype)initWithType:(NSInteger)typeNum;

@end

@interface MJRefreshGifHeader (loadingAnimation)

@property (nonatomic,retain) UIView *animationView;

-(void)addOneAnimationView:(UIView *)animationView;

@end

