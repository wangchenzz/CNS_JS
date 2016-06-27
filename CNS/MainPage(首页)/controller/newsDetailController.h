//
//  newsDetailController.h
//  CNS
//
//  Created by Mac on 16/5/12.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSRefreshTableViewController.h"

#import "JSNewsModel.h"

#import "JSNewsFrameModel.h"




@interface newsDetailController : JSRefreshTableViewController

@property (nonatomic,strong) JSNewsModel *currentModel;



@end
