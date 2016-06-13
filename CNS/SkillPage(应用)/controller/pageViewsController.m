//
//  pageViewsController.m
//  CNS
//
//  Created by Mac on 16/5/23.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "pageViewsController.h"

#import "BBSControllerView.h"

#import "sendBBSController.h"

#import "tableHeaderButtonView.h"

@interface pageViewsController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,tableHeaderButtonViewDelegate>

@property (nonatomic,retain) UIPageViewController *pvc;

@property (nonatomic,retain) NSMutableArray *vcArray;

@property (nonatomic,retain) tableHeaderButtonView *headerView;

@property (nonatomic,assign) NSInteger willIndex;

@end

@implementation pageViewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatController];
    
    [self setUpPageControll];
    self.title = @"最新帖子";
    
    self.view.backgroundColor = JSCOLOR;
    
    [self setUpRightSendBar];
    
}

-(void)setUpRightSendBar{
    UIBarButtonItem *rightBar = [UIBarButtonItem itemWithTitle:@"发帖" andImage: nil targat:self action:@selector(sendBBS:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = rightBar;
}

-(void)setUpPageControll{
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]forKey:UIPageViewControllerOptionSpineLocationKey];
    UIPageViewController *pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options: options];
    pageViewController.delegate = self;
    pageViewController.dataSource = self;
    [[pageViewController view] setFrame:[[self view] bounds]];
    
    pageViewController.view.backgroundColor = [UIColor blackColor];
    BBSControllerView *initialViewController =[_vcArray firstObject];
    
    NSArray *array = @[initialViewController];
    [pageViewController setViewControllers:array direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    
    pageViewController.view.frame = CGRectMake(0, CGRectGetMaxY(JSNavigationBounds)+40, self.view.width, self.view.height - CGRectGetMaxY(JSNavigationBounds)-40-40) ;
    
    [self.view addSubview: pageViewController.view];
    
    
    self.pvc = pageViewController;
    
    [self.view addSubview:self.headerView];
    
}

-(void)creatController{
    self.vcArray = [[NSMutableArray alloc] init];
    for (int i = 1 ;  i <= 8; i ++) {
        BBSControllerView *vc = [[BBSControllerView alloc] initWithType:i];
        [self.vcArray addObject:vc];
        vc.navi = self.navigationController;
        [self addChildViewController:vc];
    }
}

-(void)sendBBS:(UIBarButtonItem *)item{
    sendBBSController *vc = [[sendBBSController alloc] init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    //    UINavigationController *bv = (UINavigationController *)viewController;
    
    BBSControllerView *gv = (BBSControllerView *)viewController;
    if (gv.BBSType == 1) {
        return nil;
    }else{
        
        //         UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:_vcArray[gv.BBSType - 2]];
        return _vcArray[gv.BBSType - 2];
    }
}

// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    //    UINavigationController *bv = (UINavigationController *)viewController;
    
    BBSControllerView *gv = (BBSControllerView *)viewController;
    
    if (gv.BBSType == 8) {
        return nil;
    }else{
        return _vcArray[gv.BBSType];
    }
    
}



-(tableHeaderButtonView *)headerView{
    if (!_headerView) {
        _headerView = [tableHeaderButtonView getHeader];
        
        _headerView.frame = CGRectMake(12, CGRectGetMaxY(JSNavigationBounds), self.view.width-24, 40);
        
        _headerView.delegare = self;
    }
    return _headerView;
    
}
-(NSArray *)titleArrayForTableHeaderButtonView:(tableHeaderButtonView *)view{
    
    return @[@"最新帖子",@"注意力",@"社交能力",@"记忆力",@"阿斯伯格",@"反应能力",@"睡眠",@"冥想"];
}



- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    NSInteger index = [_vcArray indexOfObject:[pendingViewControllers firstObject]];
    _willIndex = index;
    
    
    BBSControllerView *bb =self.vcArray[_willIndex];
    
    [bb.tableView.mj_header beginRefreshing];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if(completed){
        NSInteger index = [_vcArray indexOfObject:[previousViewControllers firstObject]];
        
        NSInteger nextIndex = 0;
        if (index > self.willIndex) {
            nextIndex = index - 1;
        }else if (index < self.willIndex){
            nextIndex = index + 1;
        }
        [self.headerView setCurrentIndex:self.willIndex];
        
        
    }
}


-(void)tableHeaderButtonView:(tableHeaderButtonView *)view didSelecte:(NSInteger)index{
    if (index > view.currentIndex) {
        [self.pvc setViewControllers:@[self.vcArray[index]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
    }else{
        [self.pvc setViewControllers:@[self.vcArray[index]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    self.title = @[@"最新帖子",@"注意力",@"社交能力",@"记忆力",@"阿斯伯格",@"反应能力",@"睡眠",@"冥想"][index];
    
    BBSControllerView *bb =self.vcArray[index];
    
    [bb.tableView.mj_header beginRefreshing];
}


@end
