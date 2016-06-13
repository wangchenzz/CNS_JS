//
//  JSRefreshTableViewController.m
//  CNS
//
//  Created by Mac on 16/6/1.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "JSRefreshTableViewController.h"

#import "JSBallView.h"

@interface JSRefreshTableViewController ()

@end

@implementation JSRefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIImageView *backrounView = [[UIImageView alloc] init];
    [backrounView setFrame:CGRectMake(0, 0, self.view.width, self.tableView.height)];
    backrounView.image = [UIImage imageNamed:@"底色"];
    [_tableView setValue:backrounView forKeyPath:@"backgroundView"];
    _tableView.tableFooterView = [[UIView alloc] init];;
    [self.view addSubview:_tableView];
    
    _curpage = 1;
    _isRefreshHeader = NO;
    _isRefreshFooter = NO;
    _isShowNoDataImage= NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - setter

-(void)setIsRefreshFooter:(BOOL)isRefreshFooter{
    if (isRefreshFooter != _isRefreshFooter) {
        _isRefreshFooter = isRefreshFooter;
        __weak __typeof__(self) weakSelf = self;
        if (_isRefreshFooter) {
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
               
                [weakSelf tableViewRefreshFooter];
                
                [weakSelf.tableView.mj_footer beginRefreshing];
                
            }];
        }else{
        
        }
    }
}

-(void)setIsRefreshHeader:(BOOL)isRefreshHeader{
    if (isRefreshHeader != _isRefreshHeader) {
        _isRefreshHeader = isRefreshHeader;
        __weak __typeof__(self) weakSelf = self;
        if (_isRefreshFooter) {
            self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
                [weakSelf tableViewRefreshHeader];
                
                [weakSelf.tableView.mj_header beginRefreshing];
                
            }];
        }else{
            
        }
    }
}

#pragma mark - getter

-(NSMutableDictionary *)dataSourceDic{
    if (!_dataSourceDic) {
        _dataSourceDic = [NSMutableDictionary dictionary];
    }
    return _dataSourceDic;
}

-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}


/**
 *  是否显示无数据背景
 */
-(void)setIsShowNoDataImage:(BOOL)isShowNoDataImage{
    if (_isShowNoDataImage != isShowNoDataImage) {
        if (_isShowNoDataImage) {
//            [self backRoundImageShow];
        }else{
//            [self backRoundImageHide];
        }
    }
}


- (void)autoRefreshHeader{
    
    if (self.isRefreshHeader) {
        [self tableViewRefreshHeader];
    }
}

//-(void)backRoundImageHide{
//
//}
//
//-(void)backRoundImageShow{
//
//}

/**
 *  下拉刷新方法,
 */
-(void)tableViewRefreshHeader{

}

/**
 *  上拉刷新方法
 */
-(void)tableViewRefreshFooter{

}



-(void)tableViewDidFinshRefresh:(BOOL)isHeader reload:(BOOL)load{

    if (!load) {
        return;
    }
    
    if ([NSThread mainThread]) {
        [self.tableView reloadData];
    }else{
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
    if (isHeader) {
        [self.tableView.mj_header endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
