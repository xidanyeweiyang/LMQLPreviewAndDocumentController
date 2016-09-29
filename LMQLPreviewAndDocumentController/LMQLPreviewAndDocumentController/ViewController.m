//
//  ViewController.m
//  LMQLPreviewAndDocumentController
//
//  Created by 刘明 on 16/9/28.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "ViewController.h"
#import "LMQLPreviewController.h"
#import "LMDocumentController.h"
#import "LMFileManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;

@end

@implementation ViewController


- (IBAction)clearCacheBtn:(id)sender {
    
    LMFileManager *fileManager = [LMFileManager shared];

    [fileManager lm_clearFileCachesFromPath:[LMFileManager lm_documentDirectory]];
    
    long long cacherSize = [fileManager lm_getFolderFileSizeAtPath:[LMFileManager lm_documentDirectory]];
    
    self.cacheLabel.text = [NSString stringWithFormat:@"%lld M",cacherSize];
    
}

- (IBAction)goToQLPreviewController:(id)sender {
    
    LMQLPreviewController *previewVC = [[LMQLPreviewController alloc] init];
    
    previewVC.urlString = @"http://10.19.0.81:8082/cofco/interface/attach/1658994";
    
    [self.navigationController pushViewController:previewVC animated:YES];

}
- (IBAction)goToDocumentController:(id)sender {
    
    LMDocumentController *documentVC = [[LMDocumentController alloc] init];
    
    documentVC.urlString = @"http://weixintest.ihk.cn/ihkwx_upload/1.pdf";
    
    [self.navigationController pushViewController:documentVC animated:YES];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    LMFileManager *fileManager = [LMFileManager shared];
    
    long long cacherSize = [fileManager lm_getFolderFileSizeAtPath:[LMFileManager lm_documentDirectory]];
    
    self.cacheLabel.text = [NSString stringWithFormat:@"%lld M",cacherSize];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"LMQLPreviewAndDocumentController";
    
    //临时存一个数据
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSLog(@"data == %@",data);
    
    [data writeToFile:[[LMFileManager lm_documentDirectory] stringByAppendingPathComponent:@"123"] atomically:YES];
    
    NSLog(@"%@",[LMFileManager lm_documentDirectory]);
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
