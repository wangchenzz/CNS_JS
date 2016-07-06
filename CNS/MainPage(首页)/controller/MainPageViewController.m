//
//  MainPageViewController.m
//  CNS
//
//  Created by Mac on 16/4/25.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "MainPageViewController.h"

#import "NewsCell.h"

#import "JSNewsModel.h"

#import "newsDetailController.h"


@interface MainPageViewController ()

@property (nonatomic,strong) NSMutableArray *newsInfoArray;

@property (nonatomic,strong) NSMutableArray *ary;

@property (nonatomic,strong) NSMutableArray *scrollViewArray;

@property (nonatomic,retain) animationScroll *animationScrollView;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.isRefreshHeader = YES;
    
    
    self.isRefreshFooter = YES;
    
    self.newsInfoArray = [NSMutableArray array];
    
    self.scrollViewArray = [NSMutableArray array];
    
    self.ary = [NSMutableArray array];
    
    self.curpage = 1;
    
    [self loadInfoForIsHeader:YES];
    
    [self setUpScrollView];
    
    //
    //    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [selfWeak loadInfo];
    //
    //        [selfWeak.tableView.mj_header beginRefreshing];
    //
    //    }];
    ////    header.automaticallyChangeAlpha = YES;
    
    
    //    [header addOneAnimationView:[BezierPathLogoView getLogo]];
    
    //    [header setImages:ary forState:MJRefreshStateIdle]; /** 普通闲置状态 */
    //    [header setImages:ary forState:MJRefreshStatePulling]; /** 松开就可以进行刷新的状态 */
    //    [header setImages:ary forState:MJRefreshStateRefreshing]; /** 正在刷新中的状态 */
    
    //    [header setTitle:@"拖拽以刷新" forState:MJRefreshStateIdle];
    //    [header setTitle:@"放开我就刷新" forState:MJRefreshStatePulling];
    //    [header setTitle:@"读取中." forState:MJRefreshStateRefreshing];
    //
    //    header.lastUpdatedTimeLabel.hidden = YES;
    //
    //    // 设置字体
    //    header.stateLabel.font = [UIFont systemFontOfSize:15];
    //
    //    // 设置颜色
    //    header.stateLabel.textColor = [UIColor whiteColor];
    
    //    self.tableView.mj_header = header;
    
    
    
    
}

-(void)tableViewRefreshHeader{
    self.curpage = 1;
    [self loadInfoForIsHeader:YES];
    
}

-(void)tableViewRefreshFooter{
    [self loadInfoForIsHeader:NO];
}



-(void)loadInfoForIsHeader:(BOOL)isHeader{
    
    __weak MainPageViewController *weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"curPage"] = [NSString stringWithFormat:@"%ld",self.curpage];
    
    dic[@"type"] = @"1";
    
    dic[@"loginName"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginName"];
    
    dic[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    [[INetworking shareNet] GET:newsUrl withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        NSArray *infoAry;
        if (isSuccess) {
            
            infoAry = returnObject[@"list"];
            
        }
        if (isHeader) {
            [self.newsInfoArray removeAllObjects];
        }
        
        if (isSuccess && infoAry.count != 0) {
            

            
            for (NSDictionary *dic in infoAry) {
                
                JSNewsModel *model = [[JSNewsModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [weakSelf.newsInfoArray addObject:model];
                
            }
            
            weakSelf.curpage ++ ;
            
            [self tableViewDidFinshRefresh:isHeader reload:YES];
            
        }
        
        else{
            
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        
    }];
    
    
//    - - - - -18106530602- - - - -
    NSMutableDictionary *dicScro = [NSMutableDictionary dictionary];
    dicScro[@"type"] = @"0";
    //    dic[@"loginName"] = ec8a48252a6f3e0b49435a22d843862a;
    dicScro[@"loginName"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginName"];
    
    dicScro[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    //extension -- apple iOS
    
    [[INetworking shareNet] GET:newsUrl withParmers:dicScro do:^(id returnObject, BOOL isSuccess) {
        NSArray *infoAry;
        if (isSuccess) {
            infoAry = returnObject[@"list"];
        }
        if (isSuccess && infoAry.count != 0) {
            
            for (NSDictionary *dic in infoAry) {
                JSNewsModel *model = [[JSNewsModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [weakSelf.scrollViewArray addObject:model];
                
            }
            [weakSelf.animationScrollView showAnimation];
        }
    }];
    
}

/**
 *  创建 scrollview
 */
-(void)setUpScrollView{
    
    animationScroll *imaegView = [animationScroll getScroll];
    
    [imaegView setFrame:CGRectMake(0, 0, self.view.width,self.view.height * .4)];
    
    imaegView.delegate = self;
    
    self.animationScrollView = imaegView;
    
    self.tableView.tableHeaderView = (UIView *)imaegView;
    
}


#pragma mark - animationScrollDelegate

-(void)animationScroll:(animationScroll *)scroll didClickInIndex:(NSInteger)index{
    JSNewsModel *model = self.scrollViewArray [index];
    
    newsDetailController *newVC = [[newsDetailController alloc] init];
    
    newVC.hidesBottomBarWhenPushed = YES;
    
    newVC.currentModel = model;
    
    [self.navigationController pushViewController:newVC animated:YES];
    
    
}


-(NSString *)animationScroll:(animationScroll *)scroll imageForIndex:(NSInteger)index{
    JSNewsModel *model = self.scrollViewArray [index];
    NSArray *imageArray = [model.images componentsSeparatedByString:@","];
    
    NSString *imastr = [NSString stringWithFormat:@"%@%@",basicUrlStr,imageArray.firstObject];
    __block UIImage *ima;
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imastr] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        ima = image;
        
    }];
    return imastr;
    
    
}

-(NSString *)animationScroll:(animationScroll *)scroll textForIndex:(NSInteger)index{
    JSNewsModel *model = self.scrollViewArray [index];
    return model.title;
}

-(NSInteger)numberOfImageInScrollView:(animationScroll *)scroll{
    
    return 4;
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsInfoArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsCell *cell = [NewsCell cellForTableview:tableView];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsCell *cel  =  (NewsCell *)cell;
    cel.model = self.newsInfoArray[indexPath.row];
    
    if (![_ary containsObject:@(indexPath.row)]) {
        CATransform3D rotation;//3D旋转
        
        rotation = CATransform3DMakeTranslation(0 ,50 ,20);
        //    rotation = CATransform3DMakeRotation( M_PI_4 , 0.0, 0.7, 0.4);
        //逆时针旋转
        
        rotation = CATransform3DScale(rotation, 0.9, .9, 1);
        
        rotation.m34 = 1.0/ -800;
        
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        //        cell.alpha = 0;
        
        cell.layer.transform = rotation;
        
        [UIView beginAnimations:@"rotation" context:NULL];
        //旋转时间
        [UIView setAnimationDuration:1];
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        [UIView commitAnimations];
    }
    
    [_ary addObject:@(indexPath.row)];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

/**
 *  跳转页面展示新闻
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JSNewsModel *currentModel = self.newsInfoArray[indexPath.row];
    
    newsDetailController *newVC = [[newsDetailController alloc] init];
    
    newVC.hidesBottomBarWhenPushed = YES;
    
    newVC.currentModel = currentModel;
    
    [self.navigationController pushViewController:newVC animated:YES];
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view =[[UIView alloc] init];

    [view setBackgroundColor:[UIColor clearColor]];

    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.width, 38)];

    backView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
    [view addSubview:backView];

    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 24, 24)];
    imageview.image = [UIImage imageNamed:@"new"];

    UILabel *titleLbale =[[UILabel alloc] init];

    titleLbale.frame = CGRectMake(38, 3, 140, 32);

    titleLbale.font = [UIFont boldSystemFontOfSize:20];

    titleLbale.textColor = [UIColor whiteColor];

    titleLbale.text = @"竞思新闻";

    [backView addSubview:imageview];

    [backView addSubview:titleLbale];
    
    return view;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 50;
}

@end
