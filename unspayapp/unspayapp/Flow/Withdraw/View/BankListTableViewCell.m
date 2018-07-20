//
//  BankListTableViewCell.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/19.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "BankListTableViewCell.h"

@implementation BankListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self createUI];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createUI{
    
    self.backView.layer.cornerRadius = kAutoScaleNormal(6);
    self.backView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(0, 2);
    self.backView.layer.shadowOpacity = 0.08;
    
    
}

- (void)setBankListModel:(BankListModel *)bankListModel{
    _bankListModel = bankListModel;
    
    if (_bankListModel) {
        _bankNameLabel.text = _bankListModel.bankName;
        _bankCardNumLabel.text = _bankListModel.bankCardNo;
        _bankTypeLabel.text = _bankListModel.bankType;
        _bankImageView.image = [UIImage imageNamed:_bankListModel.bankImageName];
        [self setIsSelected:_bankListModel.isSelected];
    }
    
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (_isSelected) {
        _indicatorImagView.hidden = NO;
    }else{
        _indicatorImagView.hidden = YES;
    }
}



@end
