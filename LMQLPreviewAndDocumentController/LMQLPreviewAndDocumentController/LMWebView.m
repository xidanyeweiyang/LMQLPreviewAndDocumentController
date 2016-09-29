//
//  LMWebView.m
//  附件处理
//
//  Created by 刘明 on 16/9/28.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "LMWebView.h"

@implementation LMWebView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.scalesPageToFit = YES;
        self.dataDetectorTypes = UIDataDetectorTypeAll;
        
    }
    
    return self;
}

@end
