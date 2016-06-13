//
//  TheRerunSgViewContoller.m
//  CNS
//
//  Created by Mac on 16/6/2.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "TheRerunSgViewContoller.h"

#import "addSUGController.h"

#import "ShowSegModel.h"

#import "ShowSegCell.h"

@interface TheRerunSgViewContoller ()

@end

@implementation TheRerunSgViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isRefreshFooter = YES;
    self.isRefreshHeader = YES;
    self.curpage = 1;
    
    [self setUpButtonItem];
    
    self.title = @"反馈";
}

#pragma private

-(void)setUpButtonItem{
//    UIButton *buton = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [buton setFrame:CGRectMake(0, 0, 44, 44)];
//    
//    [buton setTitle:@"反馈" forState: UIControlStateNormal];
//    
//    [buton addTarget:self action:@selector(returnSEG:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbut = [UIBarButtonItem itemWithTitle:@"攥写" andImage: nil targat:self action:@selector(returnSEG:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barbut;
}

-(void)returnSEG:(UIButton *)sender{
    addSUGController *sc = [[addSUGController alloc] init];
    
    [self.navigationController pushViewController:sc animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

-(void)tableViewRefreshHeader{
    self.curpage = 1;
    __weak __typeof(self)weakSelf = self;
    NSMutableDictionary *dic = [[JSUserManager shareManager] getUserDic];
    dic[@"curPage"] = [NSString stringWithFormat:@"%ld",self.curpage];
    [[INetworking shareNet] GET:getLeavemsgByPage withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.dataSourceArray removeAllObjects];
            NSArray *dataArray = returnObject[@"list"];
            for (NSDictionary *dic in dataArray) {
             
                ShowSegModel *model = [[ShowSegModel alloc] initWithDic:dic];
                
                [weakSelf.dataSourceArray addObject:model];
                
            }
            
            [self tableViewDidFinshRefresh:YES reload:YES];
        }
        
    }];

}

-(void)tableViewRefreshFooter{
    self.curpage ++;
    __weak __typeof(self)weakSelf = self;
    NSMutableDictionary *dic = [[JSUserManager shareManager] getUserDic];
    dic[@"curPage"] = [NSString stringWithFormat:@"%ld",self.curpage];
    [[INetworking shareNet] GET:getLeavemsgByPage withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        if (isSuccess) {
            NSArray *dataArray = returnObject[@"list"];
            for (NSDictionary *dic in dataArray) {
                
                ShowSegModel *model = [[ShowSegModel alloc] initWithDic:dic];
                
                [weakSelf.dataSourceArray addObject:model];
                
            }
            
            [self tableViewDidFinshRefresh:NO reload:YES];
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.dataSourceArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShowSegCell *cell = [ShowSegCell cellForTableview:tableView];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowSegCell *cel = (ShowSegCell *)cell;
    cel.model = self.dataSourceArray[indexPath.row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [ShowSegCell cellHeightWithModel:self.dataSourceArray[indexPath.row]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
