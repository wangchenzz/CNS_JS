//
//  JSLoading.h
//  1.5-2015
//
//  Created by Mac on 16/2/25.
//  Copyright © 2016年 竟思. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSLoading : UIView



+ (void)loadSuccessCompletion:(void (^)(BOOL))completion;

+ (void)loadFailCompletion:(void (^)(BOOL))completion;






@end
