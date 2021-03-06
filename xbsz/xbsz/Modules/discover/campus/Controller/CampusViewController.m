//
//  CampusViewController.m
//  xbsz
//
//  Created by 陈鑫 on 17/2/21.
//  Copyright © 2017年 lotus. All rights reserved.
//

#import "CampusViewController.h"
#import "CXBaseTableView.h"
#import "CampusTableViewCell.h"
#import "CXUser.h"
#import "CampusNote.h"
#import "CampusNoteList.h"

@interface CampusViewController ()<CXBaseTableViewDelegate>

@property (nonatomic, strong) CXBaseTableView *tableView;

@property (nonatomic, strong) CampusNoteList *noteList;

@end

@implementation CampusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = CXWhiteColor;
    [self.contentView addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    [self loadDataAtPageIndex:InitialLoadPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark getter / setter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[CXBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped enablePullRefresh:YES];
        _tableView.baseDelegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = NO;
        _tableView.showEmptyTips = YES;
    }
    return _tableView;
}

#pragma mark  CXBaseTableViewDelegate

- (void)loadDataAtPageIndex:(NSUInteger )pageIndex{

    NSString *fileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"notes.json"];
    NSString *jsonStr = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    
//    CXUser *user = [CXUser yy_modelWithJSON:jsonStr];
    
//    CampusNote *note = [CampusNote yy_modelWithJSON:jsonStr];
    
    if(_noteList && [_noteList.notes count]>0){
        [_noteList.notes addObjectsFromArray:[CampusNoteList yy_modelWithJSON:jsonStr].notes];
    }else{
        _noteList = [CampusNoteList yy_modelWithJSON:jsonStr];
    }
    
    
    [_tableView reloadData];
    
    
    CXLog(@"开始加载校园动态");
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    CXLog(@"%@",[NSString stringWithFormat:@"点击了第%lu行",indexPath.row])
}




#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_noteList.notes count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CXLog(@"显示第%ld行",indexPath.row);
    CampusTableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil){
        cell = [[CampusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    CampusNote *note = [_noteList.notes objectAtIndex:indexPath.row];
    BOOL hasLiked = [[_noteList.likes objectForKey:note.noteID] isEqualToString:@"1"] ? YES:NO;
    [cell updateUIWithModel:[_noteList.notes objectAtIndex:indexPath.row] hasLiked:hasLiked action:^(id model, CellActionType actionType) {
        [self handleAction:actionType model:(CampusNote *)model];
    }];

    return cell;
}

#pragma mark private method

- (void)handleAction:(CellActionType )type model:(CampusNote *)model{
    switch (type) {
        case CellActionTypeLike:
            if([[_noteList.likes objectForKey:model.noteID] isEqualToString:@"1"] == YES){
                CXLog(@"已经点过赞了");
            }else{
                CXLog(@"开始点赞");
                [_noteList.likes setValue:@"1" forKey:model.noteID];
            }
            break;
        case CellActionTypeReply:
            CXLog(@"点击了回复");
            break;
        case CellActionTypeShare:
            CXLog(@"点击了分享");
            break;
        case CellActionTypeMore:
            CXLog(@"点击了更多");
            break;
        case CellActionTypeUserInfo:
            CXLog(@"进入个人信息详细页面");
            break;
        case CellActionTypeComment:
            CXLog(@"进入评论列表界面");
            break;
        default:
            break;
    }
}



@end
