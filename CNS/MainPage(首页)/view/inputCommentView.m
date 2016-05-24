
//
//  inputCommentView.m
//  CNS
//
//  Created by Mac on 16/5/16.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "inputCommentView.h"

@implementation inputCommentView

-(instancetype)init{
    if (self = [super init]) {
        
//        self.frame = CGRectMake(0, JSFrame.size.height - 40, JSFrame.size.width, 40);
        
        self.frame = CGRectMake(0, 0, JSFrame.size.width, 50);
        
        
        /**
         添加一个背景图片
         */
        UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
        
        backView.backgroundColor = JSColor(202, 84, 56);
        
        [self addSubview:backView];
        
        
        /**
         
         */
        
        UITextView *textV = [[UITextView alloc] init];
        
        textV.height = 30;
        
        textV.width = self.width - 30 - 8 - 8 - 8;
        
        textV.centerY = self.centerY;
        
        textV.x = 8;
        
        textV.textColor = [UIColor whiteColor];
        
        textV.font = JSFont(15);
        
        [self addSubview:textV];
        
        textV.backgroundColor = [UIColor clearColor];
        
        textV.delegate = self;
        
        self.inputTextView = textV;
        
        
        
        UIView *lineView = [[UIView alloc] init];
        
        lineView.frame = CGRectMake(textV.x, CGRectGetMaxY(textV.frame), textV.width, 1);
        
        
        [lineView setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:lineView];
        
        
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.width = button.height = 25;
        
        button.centerY = self.centerY;
        
        button.x = CGRectGetMaxX(self.inputTextView.frame)+8;
        
        
        
        [button setBackgroundImage:[UIImage imageNamed:@"jiantou-y"] forState:UIControlStateNormal];
        
        button.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:button];
        
        [button addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        
        self.sendButton = button;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
        
          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoard) name:UIKeyboardWillHideNotification object:nil];
        
        
        /**
         *  加点阴影;
         */
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        
        self.layer.shadowOffset = CGSizeMake(0,-2);
        
        self.layer.shadowOpacity = 0.8;
        
        
    }
    return self;
}


-(void)send{
    
    [self.delegate clickSend:self];
    
    self.inputTextView.text = @"";
    
    [self endEditing:YES];
}


-(void)showKeyBoard:(NSNotification *)notification{

    
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
   [self.delegate inputCommentViewShowKeyBord:self with:keyboardEndFrameWindow.size.height];
}

-(void)hideKeyBoard{
    [self.delegate inputCommentViewHideKeyBord:self];
    
}


+(instancetype)put{
    return [[self alloc] init];
}

- (void)textViewDidChange:(UITextView *)textView{

//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    
//    dic[NSFontAttributeName] = self.inputTextView.font;
//    
//    CGRect commentrect = [textView.text boundingRectWithSize:CGSizeMake(textView.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
//    
//    CGFloat nowHeight = commentrect.size.height;
//    
//    self.inputTextView.height = nowHeight;
//    
//    self.height += nowHeight - self.inputTextView.height;
//    
//    
//    JSLog(@"%f",self.height);

}


@end
