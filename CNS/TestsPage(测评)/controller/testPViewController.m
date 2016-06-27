//
//  testPViewController.m
//  CNS
//
//  Created by Mac on 16/5/17.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "testPViewController.h"

#import "buttonView.h"

#import "ModuleChooseController.h"


/**
 *  显示标准测试结果.
 */
#import "normalShowLevelController.h"

/**
 *  显示2种查询信息和模块测试结果..
 */
#import "showLevelController.h"


#import "FirstViewController.h"

@interface testPViewController ()

@property (nonatomic,retain) buttonView *view1;


@property (nonatomic,retain) buttonView *view2;


@property (nonatomic,retain) buttonView *view3;


@property (nonatomic,retain) UITapGestureRecognizer *tap1;

@property (nonatomic,retain) UITapGestureRecognizer *tap2;

@property (nonatomic,retain) UITapGestureRecognizer *tap3;



@end

@implementation testPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpBack];

    [self setUpUi];
    
}

-(void)setUpBack{
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"底色"]];
    
    iv.frame = self.view.bounds;
    
    [self.view addSubview:iv];
}

-(void)setUpUi{

    
    self.view1 = [buttonView viewWithTile:@"标准测试" withHeadImage:@"s" withIntroduce:@"系统的测试各项模块" withEnglishStr:@"Standard Assessment"] ;
    self.view1.width = JSFrame.size.width - 30;
    self.view1.height = self.view.height * .15;
    
    self.view1.centerX = self.view.centerX;
    
    self.view1.centerY = self.view.height * .2;
    
    [self.view addSubview:self.view1];
    
    self.view2 = [buttonView viewWithTile:@"模块测试" withHeadImage:@"e" withIntroduce:@"自选模块,专项训练" withEnglishStr:@"Evaluation Module"];
    self.view2.width = JSFrame.size.width - 30;
    self.view2.height = self.view.height * .15;
    
    self.view2.centerX = self.view.centerX;
    
    self.view2.centerY = self.view.height * .4;
    
    [self.view addSubview:self.view2];

    
    self.view3 = [buttonView viewWithTile:@"记录查询" withHeadImage:@"r" withIntroduce:@"查看更多历史测评记录" withEnglishStr:@"Records Check"] ;
    self.view3.width = JSFrame.size.width - 30;
    self.view3.height = self.view.height * .15;
    
    self.view3.centerX = self.view.centerX;
    
    self.view3.centerY = self.view.height * .6;
    
    [self.view addSubview:self.view3];
    
    
    _tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBut:)];
    _tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBut:)];
    _tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBut:)];
    
    
    [self.view1 addGestureRecognizer:_tap1];
    
    [self.view2 addGestureRecognizer:_tap2];
    
    [self.view3 addGestureRecognizer:_tap3];
    
    
}


-(void)clickBut:(UITapGestureRecognizer *)tap{
    if (tap == _tap1) {
        /**
         *标准测试
         */
        FirstViewController *fc = [[FirstViewController alloc] init];
        
        [self.navigationController pushViewController:fc animated:YES];
        
        
    }else if(tap == _tap2){
        /**
         *模块测试
         */
        ModuleChooseController *vc = [[ModuleChooseController alloc] init];
        
        vc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
        JSLog(@"2");
    }else if (tap == _tap3){
        
        showLevelController *level = [[showLevelController alloc] init];
        
        [self.navigationController pushViewController:level animated:YES];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.tabBarController.tabBar.hidden = NO;

}

@end
