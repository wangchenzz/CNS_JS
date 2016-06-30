//
//  addCommentController.m
//  CNS
//
//  Created by Mac on 16/5/25.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "addCommentController.h"

typedef NS_ENUM(NSInteger,JSEditingState) {
    JSEditingStateEdit = 0 ,
    
    JSEditingStateNormal
};

@interface addCommentController ()


@property (nonatomic,assign) CGFloat kbHeight;

@property (nonatomic,assign) CGFloat visiableViewHeight;

@property (nonatomic,assign) JSEditingState JSEditingState;

@end

@implementation addCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
    
    self.navigationController.navigationBar.alpha = 1;

//    self.navigationController.navigationBar.hidden = NO;
    
    [self setUpBackColor];
    
    [self setUpTextView];
    
    [self setUpSureBut];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    
    
    self.visiableViewHeight = self.commentView.height;
    
}

-(void)setUpBackColor{
    UIImageView *backrounView = [[UIImageView alloc] init];
    
    [backrounView setFrame:CGRectMake(0, 0, self.view.width, self.view.height+CGRectGetMaxY(JSNavigationBounds))];
    
    backrounView.image = [UIImage imageNamed:@"底色"];
    
    [self.view addSubview:backrounView];

}


-(void)setUpTextView{

    UITextView *textView = [[UITextView alloc] init];
    
    textView.frame = CGRectMake(0, CGRectGetMaxY(JSNavigationBounds), self.view.width, self.view.height-CGRectGetMaxY(JSNavigationBounds));
    
    textView.font = JSFont(17);
    
//    [textView becomeFirstResponder];
    
    textView.backgroundColor = [UIColor clearColor];
    
    [textView setTextColor:[UIColor whiteColor]];
    
    [self.view addSubview:textView];
    
    
    self.commentView = textView;

}

-(void)setUpSureBut{

    UIBarButtonItem *rightBar = [UIBarButtonItem itemWithTitle:@"发送" andImage: nil targat:self action:@selector(sureSend:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightBar;

}

-(void)showKeyBoard:(NSNotification *)notification{
    CGRect keyboardEndFrameWindow;
    
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    
    _kbHeight = keyboardEndFrameWindow.size.height;
    
    self.commentView.height =self.visiableViewHeight - _kbHeight;
    
    self.JSEditingState = JSEditingStateEdit;
    
    
}


-(void)hideKeyBoard:(NSNotification *)notification{
    
    
    self.commentView.height =self.visiableViewHeight + _kbHeight;
    
    
    self.JSEditingState = JSEditingStateNormal;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if (self.JSEditingState == JSEditingStateEdit) {
        
        [self.view endEditing:YES];
    }else{
        [self.commentView becomeFirstResponder];
    }

}

-(void)sureSend:(UIBarButtonItem *)item{

    
    if (!self.commentView.text.length) {
        [MBProgressHUD showError:@"未填写任何内容"];
    }else{
    
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic[@"loginName"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginName"];
        
        dic[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        
        dic[@"content"] = self.commentView.text;
        
        dic[@"cardid"] = self.BBSid;
        
        
        [[INetworking shareNet] GET:addPlunge withParmers:dic do:^(id returnObject, BOOL isSuccess) {
            
            if (isSuccess) {
                [self.navigationController popViewControllerAnimated:YES];
                if ([self.delegate respondsToSelector:@selector(addCommentController:didSendComment:)]) {
                    [self.delegate addCommentController:self didSendComment:dic];
                }
            }else{
            
                [MBProgressHUD showError:@"发送失败"];
            }
        }];
    }
}


-(void)dealloc{
    JSLog(@"addCommentController _ dealloc");
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
