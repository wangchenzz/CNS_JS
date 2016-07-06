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

#import "eyeView.h"

#import "BezierPathLogoView.h"

#import <objc/runtime.h>




@implementation MJRefreshGifHeader (loadingAnimation)


-(void)addOneAnimationView:(UIView *)animationView{
    [self addSubview:animationView];
    
    self.animationView = animationView;
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    BezierPathLogoView *logo = (BezierPathLogoView *)self.animationView;
    
    JSLog(@"%ld",(long)self.state);
    
//    NSArray *images = self.stateImages[@(MJRefreshStateIdle)];
    if (self.state != MJRefreshStateIdle) return;
//    // 停止动画
    
    logo.progress = (1-pullingPercent);
    
    JSLog(@"%f",pullingPercent);
    
//    [self.animationView stop];
//    // 设置当前需要显示的图片
//    NSUInteger index =  images.count * pullingPercent;
//    if (index >= images.count) index = images.count - 1;
//    self.gifView.image = images[index];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
//    
    self.animationView.frame = self.bounds;
    if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
        self.animationView.contentMode = UIViewContentModeCenter;
    } else {
        self.animationView.mj_w = 60;
        self.animationView.mj_x = self.mj_w * .5 - 60 - 60;
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    // 根据状态做事情
//    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
//        NSArray *images = self.stateImages[@(state)];
//        if (images.count == 0) return;
//        
//        [self.gifView stopAnimating];
//        if (images.count == 1) { // 单张图片
//            self.gifView.image = [images lastObject];
//        } else { // 多张图片
//            self.gifView.animationImages = images;
//            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
//            [self.gifView startAnimating];
//        }
//    } else if (state == MJRefreshStateIdle) {
//        [self.gifView stopAnimating];
//    }
    
}

-(void)setAnimationView:(UIView *)animationView{
    objc_setAssociatedObject(self, @selector(setAnimationView:), animationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView *)animationView{
    return objc_getAssociatedObject(self, @selector(setAnimationView:));
}
@end


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
    header.automaticallyChangeAlpha = YES;
    
    [header addOneAnimationView:[BezierPathLogoView getLogo]];
    
//    [header setImages:ary forState:MJRefreshStateIdle]; /** 普通闲置状态 */
//    [header setImages:ary forState:MJRefreshStatePulling]; /** 松开就可以进行刷新的状态 */
//    [header setImages:ary forState:MJRefreshStateRefreshing]; /** 正在刷新中的状态 */
    
    [header setTitle:@"拖拽以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"放开我就刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"读取中." forState:MJRefreshStateRefreshing];
    
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


/**
 *  只有真正加载到了新的一页才能读取新的一页的东西;
 */

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
        if (!isHeader) {
            self.dataSourceModelArray = [self.dataSourceModelArray subarrayWithRange:NSMakeRange(0, (self.currentPage - 1) * 10)].mutableCopy;
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
        if (listArray.count >= 10) {
            self.currentPage ++;  //修改好了的
        }
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
