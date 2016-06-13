//
//  JSNewVisionViewControler.m
//  CNS
//
//  Created by Mac on 16/6/2.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "JSNewVisionViewControler.h"

#import "animationContainView.h"

@interface JSNewVisionViewControler ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *scrollview;

@property (nonatomic,weak) UIPageControl *pagecontrol;

@property (nonatomic,retain) NSArray * imageAry;

@end

@implementation JSNewVisionViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageAry = @[@"lunchBackRound",@"lunchBackRound",@"lunchBackRound",@"lunchBackRound"];
    
    UIScrollView *scrollview = [[UIScrollView alloc]init];
    
    scrollview.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
    scrollview.pagingEnabled = YES;
    
    scrollview.alwaysBounceHorizontal = NO;
    
    self.view.backgroundColor = [UIColor redColor];
    
    scrollview.delegate = self;
    
    scrollview.contentSize = CGSizeMake(self.view.width*self.imageAry.count, 0);
    
    scrollview.bounces = NO;
    
    [self.view addSubview:scrollview];
    
    self.scrollview = scrollview;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [pageControl setFrame:CGRectMake(self.view.width*.5-30, self.view.height*0.93, 60, 0)];
    pageControl.numberOfPages = self.imageAry.count;
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:59/255.0 blue:70/255.0 alpha:1];
    pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    //    pageControl.centerX = scrollW * 0.5;
    //    pageControl.centerY = scrollH - 50;
    [self.view addSubview:pageControl];
    
    self.pagecontrol = pageControl;
    
    for (int i = 0; i < self.imageAry.count; i++) {
//        UIImageView *inImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width*i, 0, self.view.width, self.view.height)];
//        
//        inImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageAry[i]]];

        animationContainView *inImage = [[animationContainView alloc] init];
        
        [inImage setFrame:CGRectMake(self.view.width*i, 0, self.view.width, self.view.height)];
        inImage.picture.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageAry[i]]];
        
        
        if (i == self.imageAry.count - 1) {
            
            [self addButton:inImage];
        }
        
        [self.scrollview addSubview:inImage];
    }
}

-(void)addButton:(animationContainView*)imageView{
    
//    imageView.userInteractionEnabled = YES;
    
    UIButton*button = [[UIButton alloc]init];
    
    [button setFrame:CGRectMake(self.view.width*.5-75, self.view.width*0.78, 150, 40)];
    
    [button setBackgroundColor:[UIColor colorWithRed:255/255.0 green:59/255.0 blue:70/255.0 alpha:1]];
    
    button.layer.cornerRadius = 9;
    
    button.layer.masksToBounds = YES;
    
    [button setTitle:@"开始使用吧" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(beginLeeNote:) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:button];
    
}

-(void)beginLeeNote:(UIButton*)button{
    
    NSString *versionKey = @"CFBundleVersion";
    
    NSString*currentVersion = [[NSBundle mainBundle].infoDictionary objectForKey:versionKey];
    
     [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:versionKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CNSgameHWMCD" object:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.frame.size.width;
    // 四舍五入计算出页码
    self.pagecontrol.currentPage = (int)(page + 0.5);
    
    for ( animationContainView*subView in self.scrollview.subviews) {
        
        if ([subView respondsToSelector:@selector(offset)] ) {
            [subView offset];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    JSLog(@"newVersionController dealloc");
    
}

@end
