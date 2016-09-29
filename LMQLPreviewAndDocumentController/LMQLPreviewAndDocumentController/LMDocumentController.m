//
//  LMDocumentController.m
//  LMQLPreviewAndDocumentController
//
//  Created by 刘明 on 16/9/28.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "LMDocumentController.h"

@interface LMDocumentController ()<UIDocumentInteractionControllerDelegate,UIWebViewDelegate,UIAlertViewDelegate>

{
    NSURL *_fileURL;
    BOOL _isPreview;
    BOOL _isOpenInMenu;
}


@property (nonatomic, strong) LMWebView *webView;

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@property (nonatomic, copy) NSString *myURL;

@end

@implementation LMDocumentController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"LMDocumentController";
    
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
    
    self.myURL = urlString;
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSString *MIMEType = [self lm_getMIMEType:urlString];
    
    NSLog(@"MIMEType == %@",MIMEType);
    
    NSString *filePath = [self lm_getFilePath:urlString];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL hasExist =  [fileManager fileExistsAtPath:filePath];
    
    if (hasExist) {
        
        NSURL *URL = [NSURL fileURLWithPath:filePath];
//
//        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:URL];
//        
//        self.documentController.delegate = self;
//        
//        [self.documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        
        if (URL) {
            _fileURL = URL;
            _isPreview = NO;
            _isOpenInMenu = NO;
            self.documentController = [UIDocumentInteractionController interactionControllerWithURL:_fileURL];
            
            self.documentController.delegate = self;
            
            [self.documentController presentPreviewAnimated:YES];
            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkPreview) userInfo:nil repeats:NO];
        }
    
        
        NSLog(@"document");
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
    
    NSLog(@"responseSelf.MIMEType == %@",responseSelf.MIMEType);
    
    return responseSelf.MIMEType;
}

- (void)checkPreview{
    
    if(_isPreview == NO)
    {
        if (_fileURL) {
            // Initialize Document Interaction Controller
            self.documentController = [UIDocumentInteractionController
                                                  interactionControllerWithURL:_fileURL];
            // Configure Document Interaction Controller
            self.documentController.delegate = self;
            // Present Open In Menu
            [self.documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkOpenInMenu) userInfo:nil repeats:NO];
        }
    }

}

- (void)checkOpenInMenu{
    if(_isOpenInMenu == NO)
    {
        [self showWarning];
        [[UIApplication sharedApplication]openURL:_fileURL];
    }
}

- (void)showWarning{
    NSString *fileType = [[_fileURL.absoluteString componentsSeparatedByString:@"."]lastObject];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"出错提示" message:[NSString stringWithFormat:@"不支持%@格式，请下载相关播放器打开",fileType] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
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

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}

// Preview presented/dismissed on document.  Use to set up any HI underneath.
- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller{

    controller.name = @"附件预览";
    NSLog(@"%s",__func__);
    _isPreview = YES;
}

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller{
    NSLog(@"%s",__func__);
    [self.navigationController popViewControllerAnimated:YES];
}

// Options menu presented/dismissed on document.  Use to set up any HI underneath.
- (void)documentInteractionControllerWillPresentOptionsMenu:(UIDocumentInteractionController *)controller{
    NSLog(@"%s",__func__);
}

- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller{
    NSLog(@"%s",__func__);
    
}

// Open in menu presented/dismissed on document.  Use to set up any HI underneath.
- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller{
    NSLog(@"%s",__func__);
    _isOpenInMenu = YES;
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller{
    NSLog(@"%s",__func__);
    [self.navigationController popViewControllerAnimated:YES];
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

@end
