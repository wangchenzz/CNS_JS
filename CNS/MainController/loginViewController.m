//
//  loginViewController.m
//  CNS
//
//  Created by Mac on 16/4/25.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "loginViewController.h"

#import "JSTabBarController.h"


@interface loginViewController ()<UITextFieldDelegate>

@property (nonatomic,retain) UITextField *nameText;

@property (nonatomic,retain) UITextField *passCodeText;

@property (nonatomic,retain) UILabel *tipsLabel;

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tabBarController.tabBar.hidden = YES;
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self setUpLogo];
    
    
    
    [self setUpTextF];
    
    [self setTips];
    
}

-(void)setUpLogo{
    
    UIImageView *backRound = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backRound.image = [UIImage imageNamed:@"底色"];
    [self.view addSubview:backRound];
    
    
    UIImageView *logoView = [[UIImageView alloc] init];
    
    UIImage *logo = [UIImage imageNamed:@"l"];
    
    logoView.image = logo;
    logoView.width = logo.size.width;
    
    logoView.height = logo.size.height;
    
    logoView.centerX = self.view.centerX;
    
    logoView.centerY =  self.view.height * .25;
    
    [self.view addSubview:logoView];
    
    
    UILabel *logoName = [[UILabel alloc] init];
    
    logoName.width = JSFrame.size.width;
    
    logoName.height = 30;
    
    logoName.text = @"杭州竞思教育科技有限公司";
    
    logoName.textAlignment = NSTextAlignmentCenter;
    
    logoName.textColor = [UIColor whiteColor];
    
    logoName.font = [UIFont boldSystemFontOfSize:13];
    
    logoName.centerX = self.view.centerX;
    
    logoName.centerY = self.view.height * .9;
    
    [self.view addSubview:logoName];
    
    
    
    UIView *lineView = [[UIView alloc] init];
    
    lineView.height = 1;
    
    lineView.width = 50;
    
    lineView.centerX = self.view.centerX;
    
    lineView.centerY = CGRectGetMaxY(logoName.frame);
    
    [lineView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    
    [self.view addSubview:lineView];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan: touches withEvent:event];
    
    [self.view endEditing:YES];
    
}




-(void)setUpTextF{
    
    UITextField *name = [[UITextField alloc] init];
    
    name.height = self.view.height * .08;
    name.width = self.view.width * .7;
    
    name.centerX = self.view.centerX;
    name.centerY = self.view.height * .44;
    
    name.textColor = [UIColor whiteColor];
    
    name.textAlignment = NSTextAlignmentCenter;
    
    name.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    
    [self.view addSubview:name];
    
    name.placeholder = @"账号";
    
    
    
    
    //    UIImageView *leftPic = [[UIImageView alloc] init];
    //
    //    leftPic.height = leftPic.width = name.height *.3;
    
    /**
     *  左侧图标
     */
    //    leftPic.image = [UIImage imageNamed:@"visualImage1"];
    
    //    leftPic.backgroundColor = [UIColor redColor];
    //    name.leftViewMode = UITextFieldViewModeAlways;
    //    name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    name.leftView = leftPic;
    
    self.nameText = name;
    
    self.nameText.delegate = self;
    
    UITextField *pwd = [[UITextField alloc] init];
    
    pwd.height = self.view.height * .08;
    pwd.width = self.view.width * .7;
    
    pwd.centerX = self.view.centerX;
    pwd.centerY = self.view.height * .53;
    
    pwd.placeholder = @"密码";
    pwd.textColor = [UIColor whiteColor];
    
    pwd.textAlignment = NSTextAlignmentCenter;
    
    pwd.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    
    [self.view addSubview:pwd];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(name.x, CGRectGetMaxY(name.frame)+1, name.width, 1)];
    
    [lineView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    
    [self.view addSubview:lineView];
    
    
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(pwd.x, CGRectGetMaxY(pwd.frame)+1, pwd.width, 1.5)];
    
    [lineView2 setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    
    [self.view addSubview:lineView2];
    
    
    //    UIImageView *leftPic2 = [[UIImageView alloc] init];
    //
    //    leftPic2.height = leftPic2.width = pwd.height *.3;
    /**
     *  右侧图标
     */
    //    leftPic2.image = [UIImage imageNamed:@"visualImage1"];
    
    //    leftPic2.backgroundColor = [UIColor redColor];
    //
    //    pwd.leftViewMode = UITextFieldViewModeAlways;
    //
    pwd.secureTextEntry = YES;
    //
    //    pwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    pwd.leftView = leftPic2;
    
    self.passCodeText = pwd;
    
    self.passCodeText.delegate = self;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.height = self.view.height * .07;
    button.width = self.view.width * .7;
    
    button.centerX = self.view.centerX;
    button.centerY = self.view.height * .7;
    
    [button setTitle:@"登录" forState: UIControlStateNormal];
    
    [button setTitleColor:JSColor(50, 50, 50) forState:UIControlStateNormal];
    
    
    button.backgroundColor = JSColor(249, 208, 169);
    
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(loginIn) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    
    
    
    
}

-(void)setTips{
    
    UILabel *label = [[UILabel alloc] init];
    
    
    label.textColor = [UIColor whiteColor];
    
    label.height = self.view.height *.05;
    
    label.width = self.view.width;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
    
    label.font = JSFont(14);
    
    label.centerY = self.view.height *.62;
    label.centerX = self.view.centerX;
    
    self.tipsLabel = label;
    
    
    
    //    self.tipsLabel.text = @"你的密码输入错误!";
}

-(void)loginIn{
    
    [MBProgressHUD showMessage:@"正在登陆"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"loginName"] = self.nameText.text;
    
    dic[@"password"] = self.passCodeText.text;
    
    [[INetworking shareNet] GET:loginUrl withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        
        if (isSuccess&&returnObject[@"msg"]) {
            self.tipsLabel.text = returnObject[@"msg"];
            self.passCodeText.text = @"";
            [MBProgressHUD hideHUD];
        }else if (isSuccess&&returnObject[@"user"]){
            
            NSDictionary *dic = returnObject[@"user"];
            
            NSString *personToken = dic[@"token"];
            NSString *loginName = dic[@"loginName"];
            NSString *mobile = dic[@"mobile"];
            NSString *img = dic[@"img"];
            NSString *nickName = dic[@"nickName"];
           
            [[NSUserDefaults standardUserDefaults] setObject:personToken forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:loginName forKey:@"loginName"];
            [[NSUserDefaults standardUserDefaults] setObject:mobile forKey:@"mobile"];
            [[NSUserDefaults standardUserDefaults] setObject:img forKey:@"img"];
            [[NSUserDefaults standardUserDefaults] setObject:nickName forKey:@"nickName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [MBProgressHUD hideHUD];
            
            /**
             *  这里进行跳转
             */
            
//           [MBProgressHUD showError:@"please dont say this"];
//           NSString *lonlyWords = @"hello hello~ kamisama dududuududududduddududu÷"
            
//           [self.tabBarController setSelectedIndex:1];
            JSTabBarController *jstc = [[JSTabBarController alloc]init];
            [UIApplication sharedApplication].keyWindow.rootViewController = jstc;

            [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        }else{
            [MBProgressHUD hideHUD];
            self.passCodeText.text = @"";
            [self.tipsLabel setText:@"登陆失败"];
        }
    }];
}


#pragma mark - textFieldDelegate;

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.nameText) {
        [self.passCodeText becomeFirstResponder];
    }else{
        [self.passCodeText resignFirstResponder];       }
    return YES;
}

@end
