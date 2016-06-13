//
//  BBSControllerView.m
//  CNS
//
//  Created by Mac on 16/5/19.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "BBSControllerView.h"

#import "BBSInfoListCell.h"

#import "DetailBBSController.h"

#import "JSBallView.h"

@interface BBSControllerView ()

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,retain) NSMutableArray *dataSourceModelArray;

@property (nonatomic,assign) BOOL isLoading;


@end

@implementation BBSControllerView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPage = 1;
    
    self.dataSourceModelArray = [NSMutableArray array];
    
    
    [self setUpTablevewBackColor];

    [self setUpReFresh];
}


-(instancetype)initWithType:(NSInteger)typeNum{

    if (self = [super init]) {
        self.BBSType = typeNum;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_dataSourceModelArray.count == 0&&!_isLoading) {
        [self loadBBSInfoForHeader:YES];
    }
}

-(void)setUpReFresh{
    __weak __typeof__(self) weakSelf = self;
    /**
     *  下拉刷新
     */
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadBBSInfoForHeader:YES];
        
        [weakSelf.tableView.mj_header beginRefreshing];
        
    }];
    NSMutableArray *gifArray = [NSMutableArray array];
    for (int i = 1; i < 11 ; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [gifArray addObject:image];
    }
    
    header.automaticallyChangeAlpha = YES;
    
//    [header setImages:@[] forState:MJRefreshStateIdle]; /** 普通闲置状态 */
//    [header setImages:@[] forState:MJRefreshStatePulling]; /** 松开就可以进行刷新的状态 */
//    [header setImages:gifArray forState:MJRefreshStateRefreshing]; /** 正在刷新中的状态 */
    
    
    [header setTitle:@"拖拽以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"放开我就刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"读取中..." forState:MJRefreshStateRefreshing];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor whiteColor];
    
    self.tableView.mj_header = header;
    
    /**
     *  上拉刷新
     */
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadBBSInfoForHeader:NO];
        
        [weakSelf.tableView.mj_footer beginRefreshing];
    }];
}


-(void)loadBBSInfoForHeader:(BOOL)isHeader{
    
    self.isLoading = YES;
    
    if (isHeader) {
        self.currentPage = 1;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"curPage"] = [NSString stringWithFormat:@"%ld",self.currentPage];
    if (self.BBSType != 1) {
        dic[@"type"] = [NSString stringWithFormat:@"%ld",self.BBSType];
    }
    dic[@"loginName"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginName"];
    
    dic[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    [[INetworking shareNet] GET:getCard withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        
        if (!isSuccess) {
            
            [MBProgressHUD showError:@"链接失败"];
            self.isLoading = NO;
            return ;
        }
        if (isHeader) {
            [self.dataSourceModelArray removeAllObjects];
        }
    
        NSArray *listArray = returnObject[@"list"];
        for (NSDictionary *dic in listArray) {
            JSBbsInfoModel *model = [[JSBbsInfoModel alloc] init];
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
            [self.dataSourceModelArray addObject:model];
        }
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        
        if (listArray.count == 0) {
            return;
        }
        self.currentPage ++;
        [self.tableView reloadData];
        self.isLoading = NO;
        
    }];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceModelArray.count;
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BBSInfoListCell *cell = [BBSInfoListCell cellForTableview:tableView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    
    BBSInfoListCell *cel = (BBSInfoListCell *)cell;
    
    cel.model = self.dataSourceModelArray[indexPath.row];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailBBSController *dc = [[DetailBBSController alloc] init];
    
    dc.basicModel = self.dataSourceModelArray[indexPath.row];
    
    dc.hidesBottomBarWhenPushed = YES;
    
    [self.navi pushViewController:dc animated:YES];
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 116;
}



@end
