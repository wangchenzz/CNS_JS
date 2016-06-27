//
//  JSRefreshTableViewController.h
//  CNS
//
//  Created by Mac on 16/6/1.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSRefreshTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) NSMutableArray *dataSourceArray;

@property (nonatomic,strong) NSMutableDictionary *dataSourceDic;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger curpage;

@property (nonatomic,assign) BOOL isRefreshHeader;

@property (nonatomic,assign) BOOL isRefreshFooter;

@property (nonatomic,assign) BOOL isShowNoDataImage;


-(void)tableViewRefreshHeader;

-(void)tableViewRefreshFooter;

-(void)tableViewDidFinshRefresh:(BOOL)isHeader reload:(BOOL)load;


@end
