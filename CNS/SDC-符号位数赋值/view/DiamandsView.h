//
//  DiamandsView.h
//  CNS
//
//  Created by Mac on 16/3/9.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiamandsView : UIView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *symbolView;

@property (weak, nonatomic) IBOutlet UITextField *digitView;

+(instancetype)getView;

@end
