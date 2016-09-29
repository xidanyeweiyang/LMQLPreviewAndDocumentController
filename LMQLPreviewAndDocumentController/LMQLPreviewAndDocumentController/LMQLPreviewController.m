
//
//  LMQLPreviewController.m
//  附件处理
//
//  Created by 刘明 on 16/9/28.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "LMQLPreviewController.h"

@interface LMQLPreviewController ()<UIWebViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>

@property (nonatomic, strong) LMWebView *webView;

@property (nonatomic, strong) QLPreviewController *previewControler;

@property (nonatomic, copy) NSString *myUrlString;

@end

@implementation LMQLPreviewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"LMQLPreviewController";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    
    [self lm_openFileWithURL:self.urlString];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)setupUI{
    
    LMWebView *webView = [[LMWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [self.view addSubview:webView];
    
    self.webView = webView;
    
    self.webView.delegate = self;
    
}
- (void)lm_openFileWithURL:(NSString *)urlString{
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSString *MIMEType = [self lm_getMIMEType:urlString];
    
    NSString *filePath = [self lm_getFilePath:urlString];
    
    self.myUrlString = filePath;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL hasExist =  [fileManager fileExistsAtPath:filePath];
    
    if (hasExist) {
        
        QLPreviewController *previewControler = [[QLPreviewController alloc] init];
        
        self.previewControler = previewControler;
        self.previewControler.delegate   = self;
        self.previewControler.dataSource = self;
        
        self.previewControler.view.frame = CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height);
        self.previewControler.currentPreviewItemIndex = 0;
        
        [self.view addSubview:self.previewControler.view];
        
        [self.previewControler reloadData];
        
        [self.navigationController pushViewController:previewControler animated:NO];
        
        NSLog(@"previewControler");
    }else{
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        [data writeToFile:filePath atomically:YES];
        
        [self.webView loadRequest:request];
    }
    
}

- (NSString *)lm_getFilePath:(NSString *)urlString{
    
    //
    NSString *urlStringLastComponet = [urlString lastPathComponent];
    
    NSLog(@"urlStringLastComponet = %@",urlStringLastComponet);
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    filePath = [filePath stringByAppendingPathComponent:urlStringLastComponet];
    
    NSLog(@"filePath = %@",filePath);
    
    return filePath;
}

- (NSString *)lm_getMIMEType:(NSString *)urlString{
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __block NSURLResponse *responseSelf;
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        responseSelf = response;
    }];
    
    NSLog(@"responseSelf == %@",responseSelf.MIMEType);
    
    return responseSelf.MIMEType;
}


#pragma mark - webView代理
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"%s",__func__);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSLog(@"%s",__func__);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@"%s",__func__);
    
    return YES;
}

#pragma mark - previewControler代理

- (id <QLPreviewItem>) previewController: (QLPreviewController *) controller previewItemAtIndex: (NSInteger) index{
    
    return [NSURL fileURLWithPath:self.myUrlString];
}
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}


- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
    NSLog(@"previewControllerWillDismiss");
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller {
    NSLog(@"previewControllerDidDismiss");
}

- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item{
    return YES;
}

- (CGRect)previewController:(QLPreviewController *)controller frameForPreviewItem:(id <QLPreviewItem>)item inSourceView:(UIView * __nullable * __nonnull)view{
    return CGRectZero;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
