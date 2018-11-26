//
//  HeadPortraitViewController.m
//  unspayapp
//
//  Created by 李志敬 on 2018/7/31.
//  Copyright © 2018年 李志敬. All rights reserved.
//

#import "HeadPortraitViewController.h"
#import "ImagePickUtil.h"
#import "NetworkingUtils.h"

@interface HeadPortraitViewController ()<UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *photoAlbumBtn;
@property (strong, nonatomic) IBOutlet UIButton *takingPicturesBtn;
@property (nonatomic, copy) ReturnBlock returnBlock;

@end

@implementation HeadPortraitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidLayoutSubviews{
    
    
    self.imageView.layer.cornerRadius = CGRectGetWidth(self.imageView.frame) / 2.0;
    self.imageView.clipsToBounds = YES;
    
    self.photoAlbumBtn.layer.cornerRadius = kAutoScaleNormal(6);
    self.takingPicturesBtn.layer.cornerRadius = kAutoScaleNormal(6);

}

- (void)createUI{
    
    self.navigationItem.title = @"设置个人头像";
    self.navigationItem.leftBarButtonItem = [BackBtn createBackButtonWithAction:@selector(leftBtnAction) target:self];
    
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    if (defaultMessage.baseMsg.headPortraitImage.length > 0) {
        UIImage *image = [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:defaultMessage.baseMsg.headPortraitImage options:(NSDataBase64DecodingIgnoreUnknownCharacters)]];
        self.imageView.image = image;
    }
}

- (void)leftBtnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)callBack:(ReturnBlock)callback{
    if (callback) {
        self.returnBlock = callback;
    }
}


- (IBAction)takingPicturesBtnAction:(id)sender {
    
    // 拍照
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
    BOOL onlyImage = YES;
    BOOL onlyMovie = NO;
    [ImagePickUtil getMediaFromSource:type onlyImage:onlyImage onlyMovie:onlyMovie presentedTarget:self delegateTarget:self];
    
}

- (IBAction)photoAlbumBtnAction:(id)sender {
    
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    BOOL onlyImage = YES;
    BOOL onlyMovie = NO;
    [ImagePickUtil getMediaFromSource:type onlyImage:onlyImage onlyMovie:onlyMovie presentedTarget:self delegateTarget:self];
    
}

#pragma mark - Networking
- (void)networking{
    
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.2);
    NSString *base64 = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    DefaultMessage *defaultMessage = [DefaultMessage shareMessage];
    NSDictionary *params = @{@"accountId" : defaultMessage.accountId, @"headPortraitImage" : base64};
    [ProgressHUB show];
    [NetworkingUtils baseMsg:params upateNetworking:^(BOOL flag, NSString *message) {
        [ProgressHUB dismiss];
        if (flag) {
            defaultMessage.isUpdateBaseMsg = YES;
            self.returnBlock(YES, @"头像更换成功", self.imageView.image);
            [PopupAction alertMsg:@"头像更换成功" of:self];
        }else{
            [PopupAction alertMsg:message of:self];

        }
    
    }];
}


#pragma mark - UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
    // 源图
    UIImage* chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    [self networking];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
