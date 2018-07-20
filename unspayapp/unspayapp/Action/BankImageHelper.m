//
//  BankImageHelper.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/20.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "BankImageHelper.h"

@implementation BankImageHelper

+ (UIImage *)gainImage:(NSString *)imageName{
    
    UIImage *image = [UIImage imageNamed:[self gainRealImageName:imageName]];
    return image;
    
}

+ (NSArray *)resultOfSearchIn:(NSArray *)array with: (NSString *)name{
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",name];
    NSArray *resultArray = [array filteredArrayUsingPredicate:pred];
    return resultArray;
    
}

+ (NSString *)gainRealImageName:(NSString *)aImageName{
    
    NSString *result;

    if (aImageName.length > 4) {
       NSString * dealName = [aImageName substringFromIndex:2];
        result = [self gainImageName:dealName];
        if (result.length == 0) {
            result = [self gainImageName:aImageName];
        }

    }else{
        result = [self gainImageName:aImageName];
    }
    
    
    
    
    return result;
}

+ (NSString *)gainImageName:(NSString *)aPred{
    
    NSString *dealImageName = aPred;

    
    NSArray *imageNames = @[@"上海银行",
                            @"东亚银行",
                            @"东莞农村商业银行",
                            @"中信银行",
                            @"中国银行",
                            @"中国工商银行",
                            @"临商银行",
                            @"云南省农村信用社",
                            @"交通银行",
                            @"光大银行",
                            @"兰州银行",
                            @"兴业银行",
                            @"内蒙古银行",
                            @"农业银行",
                            @"包商银行",
                            @"北京农村商业银行",
                            @"北京银行",
                            @"华夏银行",
                            @"南京银行",
                            @"南昌银行",
                            @"南阳市商业银行",
                            @"台州银行",
                            @"吉林银行",
                            @"哈尔滨银行",
                            @"处理中",
                            @"外换银行",
                            @"天津农商银行",
                            @"天津银行",
                            @"安徽省农村信用社",
                            @"尧都农村商业银行",
                            @"常熟农村商业银行",
                            @"平安银行",
                            @"广发银行",
                            @"广州农村商业银行",
                            @"建设银行",
                            @"开封市商业银行",
                            @"张家口市商业银行11",
                            @"德阳银行",
                            @"恒丰银行",
                            @"成都银行",
                            @"承德银行",
                            @"招商银行",
                            @"攀枝花市商业银行",
                            @"新韩银行",
                            @"昆仑银行",
                            @"昆山农村商业银行",
                            @"晋商银行",
                            @"晋城银行",
                            @"杭州银行",
                            @"柳州银行",
                            @"民生银行",
                            @"江苏省农村信用社",
                            @"沧州银行",
                            @"洛阳银行",
                            @"济宁银行",
                            @"浙江民泰商业银行",
                            @"浙江泰隆商业银行",
                            @"浙江稠州商业银行",
                            @"浦发银行",
                            @"湖北农信",
                            @"湖州银行",
                            @"漯河市商业银行",
                            @"烟台银行",
                            @"福建海峡银行",
                            @"绍兴银行",
                            @"绵阳市商业银行",
                            @"花旗银行",
                            @"莱商银行",
                            @"葫芦岛银行",
                            @"贵阳银行",
                            @"赣州银行",
                            @"邢台银行",
                            @"邮政储蓄银行",
                            @"邯郸市商业银行",
                            @"郑州银行",
                            @"鄂尔多斯银行",
                            @"鄞州银行",
                            @"重庆银行",
                            @"锦州银行",
                            @"长沙银行",
                            @"阜新银行",
                            @"青岛银行",
                            @"青海银行",
                            @"鞍山市商业银行",
                            @"韩亚银行",
                            @"黄河农村商业银行",
                            @"龙江银行"];
    
    NSString *realImageName;
    if (dealImageName.length == 0) {
        return @"";
    }
    
    NSString *pred;
    NSArray *result;
    int i = 1;
    int j = 0;
    BOOL isFirst = YES;
    while (1) {
        
        if (isFirst) {
            pred = dealImageName;
            result =  [self resultOfSearchIn:imageNames with:pred];
            if (result.count == 1) {
                realImageName = result.firstObject;
                break;
            }
        }
        
        isFirst = NO;
        if(i < dealImageName.length && j < dealImageName.length - 1 && i + j <= dealImageName.length){
            pred = [dealImageName substringWithRange:NSMakeRange(j, i)];
            result =  [self resultOfSearchIn:imageNames with:pred];
            if (result.count == 1) {
                realImageName = result.firstObject;
                break;
            }
        }else{
            break;
        }
        
        i++;
        
        if (i == dealImageName.length - j && j < dealImageName.length - 1) {
            i = 1;
            j++;
        }
    }
    
    
    return realImageName;

    
}


@end
