//
//  CampusTableViewCell.m
//  xbsz
//
//  Created by 陈鑫 on 17/2/21.
//  Copyright © 2017年 lotus. All rights reserved.
//

#import "CampusTableViewCell.h"
#import "ToolBarView.h"
#import <YYImage/YYAnimatedImageView.h>

@interface CampusTableViewCell ()

//用户信息View  包含头像 昵称  地点等
@property (nonatomic, strong) UIView *userInfoView;
@property (nonatomic, strong) UIButton *headBtn;
@property (nonatomic, strong) UILabel *nickNameLabel;
//@property (nonatomic, strong) UILabel *locationLabel;         //暂时不显示地址  后续版本考虑添加

//用户分享的图片
@property (nonatomic, strong) UIImageView *sharedImageView;
@property (nonatomic, strong) ToolBarView *toolBarView;      //点赞 留言 分享 更多等功能

@property (nonatomic, strong) UIView *lineView;     //工具栏下的分割线


@property (nonatomic, strong) UILabel *likeNumLabel;        //显示点赞数量
@property (nonatomic, strong) UILabel *sharedMessageLabel;          //用户分享时的留言
@property (nonatomic, strong) UILabel *moreReplyLabel;          //更多回复提示

@property (nonatomic, strong) UILabel *dateLabel;       //发布日期


@end

@implementation CampusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initTableViewCell];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark private method

- (void)initTableViewCell{
    
    [self.contentView addSubview:self.userInfoView];
    
    [_userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(50);
        make.left.top.right.mas_equalTo(self.contentView);
    }];
    
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(8);
        make.centerY.mas_equalTo(_userInfoView.mas_centerY);
    }];
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headBtn.mas_right).mas_offset(15);
        make.centerY.mas_equalTo(_userInfoView.mas_centerY);
    }];
    
    [self.contentView addSubview:self.sharedImageView];

    
    [_sharedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_userInfoView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
//    [self.contentView addSubview:self.toolBarView];
//    
//    [_toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.contentView);
//        make.top.mas_equalTo(_sharedImageView.mas_bottom);
//        make.height.mas_equalTo(45);
////        make.bottom.mas_equalTo(self.contentView.mas_bottom);
//    }];
//
//    [self.contentView addSubview:self.lineView];
//    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_toolBarView.mas_bottom);
//        make.width.left.right.mas_equalTo(self.contentView);
//        make.height.mas_equalTo(1/CXMainScale);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom);
//    }];
}


#pragma mark getter / setter

- (UIView *)lineView{
    if(!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = CXLineColor;
    }
    return _lineView;
}
- (UIView *)userInfoView{
    if(!_userInfoView){
        _userInfoView = [[UIView alloc] init];
        _userInfoView.backgroundColor = CXWhiteColor;
        [_userInfoView addSubview:self.headBtn];
        [_userInfoView addSubview:self.nickNameLabel];
    }
    return _userInfoView;
}

- (UIButton *)headBtn{
    if(!_headBtn){
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headBtn.frame = CGRectMake(0, 0, 36, 36);
          [_headBtn setImage:[[[UIImage imageNamed:@"avatar1.jpg"] imageByResizeToSize:CGSizeMake(36, 36) contentMode:UIViewContentModeScaleToFill] imageByRoundCornerRadius:18] forState:UIControlStateNormal];
        _headBtn.layer.cornerRadius = 18;
        _headBtn.clipsToBounds = YES;
//        [_headBtn addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];          //暂时取消头像按钮  击事件
    }
    return _headBtn;
}

- (UILabel *)nickNameLabel{
    if(!_nickNameLabel){
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = CXSystemFont(12);
        _nickNameLabel.text = @"默认昵称";
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.textColor = CXBlackColor;
    }
    return _nickNameLabel;
}

- (UIImageView *)sharedImageView{
    if(!_sharedImageView){
        _sharedImageView = [[YYAnimatedImageView alloc] init];
    }
    return _sharedImageView;
}

- (ToolBarView *)toolBarView{
    if(!_toolBarView){
        _toolBarView = [[ToolBarView alloc] initWithFrame:CGRectMake(0, 0, CXScreenWidth, 45)];
    }
    return _toolBarView;
}

//注：UITableView重用机制会出问题  解决方案如下:http://www.jianshu.com/p/70d6200b097a

- (void)updateUIWithModel:(CampusNote *)model{
//    [_sharedImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"cell%ld.jpg",index]]];
//    _sharedImageView.contentMode = UIViewContentModeScaleAspectFill;

//    [_sharedImageView setImage:[YYImage imageNamed:@"cell_gif.gif"]];
    NSURL *url = [NSURL URLWithString:model.imageUrl];
    
    [_sharedImageView yy_setImageWithURL:url options:YYWebImageOptionProgressiveBlur
     |YYWebImageOptionSetImageWithFadeAnimation];
    
    _nickNameLabel.text = model.user.nickName;
    
    
    CGFloat height = model.height;
    CGFloat width = model.width;
    CXLog(@"高度为：%d",(int)(CXScreenWidth * height/width));
    //必须要强制转换成 整形 否则会约束冲突   我也不知道为什么
    [_sharedImageView mas_updateConstraints:^(MASConstraintMaker *make) {
          make.height.mas_equalTo((int)(CXScreenWidth * height/width));
    }];
    
}

@end
