//
//  RechargeRecordTableViewCell.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/20.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "RechargeRecordTableViewCell.h"

@interface RechargeRecordTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;


@end

@implementation RechargeRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRecordListType:(RecordListType)recordListType{
    _recordListType = recordListType;
    switch (_recordListType) {
        case RecordListTypeTotalProperty:
            
            self.titleLabel.font = [UIFont systemFontOfSize:15];
            self.dateLabel.font = [UIFont systemFontOfSize:12];
            self.amountLabel.font = [UIFont systemFontOfSize:15];
            self.statusLabel.font = [UIFont systemFontOfSize:12];
            self.statusLabel.textColor = KHexColor(0x0068b7);
            self.dateLabel.textColor = [UIColor blackColor];
            break;
            
        default:
            break;
    }
}


@end
