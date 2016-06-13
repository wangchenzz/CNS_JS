
//
//  AddCommentController.m
//  CNS
//
//  Created by Mac on 16/5/25.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "sendBBSController.h"

@interface sendBBSController ()


@property (nonatomic,retain) UITextField *titleFiled;

@property (nonatomic,retain) UILabel *titleTipsLabel;

@property (nonatomic,retain) UIButton *typeButton;

@property (nonatomic,assign) CGFloat kbHeight;

@property (nonatomic,assign) NSInteger selectType;

@property (nonatomic,retain) NSMutableArray *buttonArray;

@property (nonatomic,retain) NSArray *typeNameArray;

@property (nonatomic,retain) UITextView *commentView;

@property (nonatomic,assign) CGFloat contentHeight;


@property (nonatomic,assign) CGFloat HidecontentHeight;

@property (nonatomic,assign) BOOL isAnimation;


@end

@implementation sendBBSController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"发帖";
    
    [self setUpBack];
    
    [self setUpView];
    
    [self setUpRightSendBar];
    
    [self setUpAllButton];
    
}



-(void)setUpBack{
    UIImageView *backrounView = [[UIImageView alloc] init];
    
    [backrounView setFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    
    backrounView.image = [UIImage imageNamed:@"底色"];
    
    [self.view addSubview:backrounView];
    
    
    UIColor *color = [UIColor colorWithRed:57/255.0 green:104/255.0 blue:55/255.0 alpha:0];
    
    UIImage *image = [UIImage imageWithBgColor:color];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //去掉底部线条
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}
-(void)setUpRightSendBar{
    UIBarButtonItem *rightBar = [UIBarButtonItem itemWithTitle:@"发布" andImage: nil targat:self action:@selector(sendBBS:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightBar;
}

-(void)setUpView{
    
    CGFloat yBJ = 8;
    CGFloat xBJ = 13;
    CGFloat labelHeigt = 44;
    self.titleTipsLabel = ({
        
        self.titleTipsLabel = [[UILabel alloc] init];
        
        self.titleTipsLabel.width = (self.view.width - 2 * xBJ) / 3;
        
        self.titleTipsLabel.height = labelHeigt;
        
        self.titleTipsLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
        
        self.titleTipsLabel.x = xBJ;
        
        self.titleTipsLabel.y = yBJ + CGRectGetMaxY(JSNavigationBounds);
        
        self.titleTipsLabel.text = @"帖子标题";
        
        self.titleTipsLabel.textColor = [UIColor whiteColor];
        
        self.titleTipsLabel.textAlignment = NSTextAlignmentCenter;
        
        self.titleTipsLabel.font = JSFont(16);
        
        [self.view addSubview:self.titleTipsLabel];
        
        self.titleTipsLabel;
        
    } );
    
    
    self.titleFiled = ({
        
        self.titleFiled = [[UITextField alloc] init];
        
        self.titleFiled.height = self.titleTipsLabel.height;
        
        self.titleFiled.width = self.view.width - CGRectGetMaxX(self.titleTipsLabel.frame) - 2 * xBJ;
        
        self.titleFiled.backgroundColor = self.titleTipsLabel.backgroundColor;
        
        self.titleFiled.textColor = self.titleTipsLabel.textColor;
        
        self.titleFiled.font = [UIFont boldSystemFontOfSize:15];
        
        self.titleFiled.x = CGRectGetMaxX(self.titleTipsLabel.frame) + xBJ;
        
        self.titleFiled.placeholder = @"此处填写标题";
        
        self.titleFiled.y = self.titleTipsLabel.y;
        
        [self.view addSubview:self.titleFiled];
        
        self.titleFiled;
    });
    
    self.typeButton = ({
        
        self.typeButton = [[UIButton alloc] init];
        
        self.typeButton.width = self.titleTipsLabel.width;
        
        self.typeButton.height = labelHeigt;
        
        self.typeButton.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
        
        self.typeButton.x = xBJ;
        
        self.typeButton.y = yBJ + CGRectGetMaxY(self.titleFiled.frame);
        
        [self.typeButton setTitle: @"选择类型" forState:UIControlStateNormal];
        
        [self.typeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.typeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.typeButton.titleLabel.font = JSFont(16);
        
        [self.view addSubview:self.typeButton];
        
        [self.typeButton setImage:[UIImage imageNamed:@"jiantou-y"] forState:UIControlStateNormal];
        
        self.typeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 100, 0 , 0);
        
        self.typeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0 , 20);
        
        [self.typeButton addTarget:self action:@selector(chooseTypeAnimation:) forControlEvents:UIControlEventTouchUpInside];
        
        self.typeButton;
        
    });
    
    self.commentView = ({
        
        self.commentView = [[UITextView alloc] init];
        
        self.commentView.width = self.view.width - 2 * xBJ;
        
        self.commentView.height = self.view.height - CGRectGetMaxY(self.typeButton.frame) - 2 * yBJ;
        
        self.commentView.backgroundColor = self.titleTipsLabel.backgroundColor;
        
        self.commentView.textColor = self.titleTipsLabel.textColor;
        
        self.commentView.font = [UIFont boldSystemFontOfSize:15];
        
        self.commentView.x = self.titleTipsLabel.x;
        
        self.commentView.y = CGRectGetMaxY(self.typeButton.frame) + yBJ;
        
        [self.view addSubview:self.commentView];
        
        self.contentHeight = self.commentView.height;
        
        self.commentView;
    });
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    
    
    /**
     *  设置圆角
     */
    
    self.titleTipsLabel.layer.cornerRadius = 8;
    
    self.titleFiled.layer.cornerRadius = 8;
    
    self.typeButton.layer.cornerRadius = 8;
    
    self.commentView.layer.cornerRadius = 8;
    
    self.titleTipsLabel.layer.masksToBounds = YES;
    
    self.typeButton.layer.masksToBounds = YES;
    
}

-(void)setUpAllButton{
    
    NSArray *array = @[@"注意力",@"社交能力",@"记忆力",@"阿斯伯格",@"反应能力",@"睡眠",@"冥想"];
    
    self.typeNameArray = array;
    
    self.buttonArray = [NSMutableArray array];
    
    for (NSString *str in array) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.width = self.titleTipsLabel.width;
        
        button.height = 44;
        
        
        
        //        button.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
        
        [button setBackgroundImage:[UIImage imageNamed:@"fatie"] forState:UIControlStateNormal];
        
        button.x = self.titleFiled.x;
        
        
        NSInteger index = [array indexOfObject:str];
        
        button.tag = index;
        
        button.y = self.typeButton.y + index*(button.height + 8) + self.view.height;
        
        //        self.typeButton.x = xBJ;
        //
        //        self.typeButton.y = yBJ + CGRectGetMaxY(self.titleFiled.frame);
        
        [button setTitle:str forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        button.titleLabel.font = JSFont(16);
        
        button.layer.cornerRadius = 8;
        
        [button addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        
        button.hidden = YES;
        
        [self.buttonArray addObject:button];
        
    }
    
}




-(void)showKeyBoard:(NSNotification *)notification{
    CGRect keyboardEndFrameWindow;
    
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    
    _kbHeight = keyboardEndFrameWindow.size.height;
    
    self.commentView.height = self.HidecontentHeight;
}

-(void)setKbHeight:(CGFloat)kbHeight{
    if (_kbHeight!=kbHeight) {
        
        self.HidecontentHeight = self.contentHeight - self.kbHeight;
    }
}


-(void)hideKeyBoard:(NSNotification *)notification{
    
    
    self.commentView.height = self.contentHeight;
    
}

-(void)chooseTypeAnimation:(UIButton *) but{
    
    [self showBeginAnimation];
    
    
}

-(void)chooseType:(UIButton *)but{
    
    [self showEndAnimation];
    
    [self.typeButton setTitle:self.typeNameArray[but.tag] forState:UIControlStateNormal];
    
    self.selectType = but.tag;
}

-(void)showBeginAnimation{
    
    [self.view endEditing:YES];
    
    if (_isAnimation) {
        return;
    }
    
    _isAnimation = YES;
    
    UIView *mb = [[UIView alloc] initWithFrame:self.view.bounds];
    
    mb.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    
    [self.view addSubview:mb];
    
    [self.view insertSubview:mb belowSubview:[self.buttonArray firstObject]];
    
    [mb setTag:7];
    
    for (UIButton *but in self.buttonArray) {
        
        NSInteger count = [self.buttonArray indexOfObject:but];
        
        [UIView animateWithDuration:1.2 delay:0+count * 0.1 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            but.hidden = NO;
            
            but.transform = CGAffineTransformMakeTranslation(0, -self.view.height);
            
        } completion:^(BOOL finished) {
            
            if (but == [self.buttonArray lastObject]) {
                
                _isAnimation = NO;
            }
            
        }];
    }
}

-(void)showEndAnimation{
    
    if (_isAnimation) {
        return;
    }
    
    _isAnimation = YES;
    
    
    for (UIButton *but in self.buttonArray) {
        
        NSInteger count = [self.buttonArray indexOfObject:but];
        
        [UIView animateWithDuration:1.2 delay:0+count * 0.1 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            UIView *mb = [self.view viewWithTag:7];
            but.transform = CGAffineTransformIdentity;
            
            mb.alpha = 0;
            
        } completion:^(BOOL finished) {
            but.hidden = YES;
            UIView *mb = [self.view viewWithTag:7];
            [mb removeFromSuperview];
            if (but == [self.buttonArray lastObject]) {
                
                _isAnimation = NO;
            }
            
        }];
    }
}


-(void)sendBBS:(UIBarButtonItem *)item{
    
    if (!self.titleFiled.text.length || !self.commentView.text.length || [self.typeButton.titleLabel.text isEqualToString:@"选择类型"]) {
        [MBProgressHUD showError:@"信息不完整"];
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"type"] = [NSString stringWithFormat:@"%ld",self.selectType + 2];
        dic[@"content"] = self.commentView.text;
        dic[@"title"] = self.titleFiled.text;
        
        dic[@"loginName"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginName"];
        
        dic[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        
        dic[@"ctr"] = @"0";
        
        [[INetworking shareNet] GET:addCard withParmers:dic do:^(id returnObject, BOOL isSuccess) {
            
            if (isSuccess) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [MBProgressHUD showError:@"发送失败"];
                
            }
            
        }];
        
    }
}



@end
