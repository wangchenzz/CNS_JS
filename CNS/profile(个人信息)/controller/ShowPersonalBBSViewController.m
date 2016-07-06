//
//  ShowPersonalBBSViewController.m
//  CNS
//
//  Created by Mac on 16/5/30.
//  Copyright © 2016年 竞思教育. All rights reserved.
//


/**
 *  显示我个人的帖子
 */

#import "ShowPersonalBBSViewController.h"

#import "searchPersonBBsModel.h"

#import "showPersonnalBBSCell.h"

#import "DetailBBSController.h"

@interface ShowPersonalBBSViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSourceArray;
@end

@implementation ShowPersonalBBSViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTableView];
    
    [self loadInfo];
    
    self.title = @"我的帖子";
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTableView{

    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    UIImageView *backrounView = [[UIImageView alloc] init];
    [backrounView setFrame:CGRectMake(0, 0, self.view.width, self.tableView.height)];
    backrounView.image = [UIImage imageNamed:@"底色"];
    [self.tableView setValue:backrounView forKeyPath:@"backgroundView"];
}

-(void)loadInfo{
    /**
     *  ?loginName=yxj&token=00aa0725202d66ab147ff636a19d6c6e
     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    dic[@"loginName"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginName"];
    
    dic[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    [[INetworking shareNet] GET:getPersonBBs withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        
        if (!isSuccess) {
            return;
        }
        
        
        self.dataSourceArray  = [@[] mutableCopy];
        
        NSArray *listArray = returnObject[@"list"];
        for (NSDictionary *dic in listArray) {
            
//                        JSLog(@"%@",dic);
            JSBbsInfoModel *model = [[JSBbsInfoModel alloc] init];
            searchPersonBBsModel *railModel = [[searchPersonBBsModel alloc] init];
            
            railModel.state = dic[@"state"];
            model.tureLoginName = dic[@"loginName"];
            model.loginName = dic[@"nickName"];
            model.createtime = dic[@"createtime"];
            model.ctr = dic[@"ctr"];
            model.headerImageUrlStr = dic[@"img"];
            model.type = dic[@"type"];
            model.num = dic[@"id"];
            model.title = dic[@"title"];
            model.content = dic[@"content"];
            model.pCount = dic[@"pCount"];
            
            railModel.basicModel = model;
            
            [self.dataSourceArray addObject:railModel];
        }
        
        [self.tableView reloadData];

        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    searchPersonBBsModel *model = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    return model.totalHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShowPersonnalBBSCell *cell = [ShowPersonnalBBSCell cellForTableview:tableView];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShowPersonnalBBSCell *ral = (ShowPersonnalBBSCell *)cell;
    
    ral.frameModel = self.dataSourceArray[indexPath.row];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    searchPersonBBsModel *model = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    DetailBBSController * bbc = [[DetailBBSController alloc] init];
    
    bbc.basicModel = model.basicModel;
    
    bbc.hidesBottomBarWhenPushed = YES;
    
    model.state = @"1";
    
    
    
    
    [self.navigationController pushViewController:bbc animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];

}


@end
