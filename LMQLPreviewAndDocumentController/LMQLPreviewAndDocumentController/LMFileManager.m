//
//  LMFileManager.m
//  LMQLPreviewAndDocumentController
//
//  Created by 刘明 on 16/9/28.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "LMFileManager.h"

@implementation LMFileManager

+ (instancetype)shared{
    
    static LMFileManager *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[LMFileManager alloc] init];
    });
    
    return manager;
}


/**
 *  读取单个文件大小
 */
- (long long)lm_getFileSizeAtPath:(NSString *)filePath{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        
        return [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
    }else{
        
        return 0;
    }
}

/**
 *  读取整个文件夹大小
 */
- (long long)lm_getFolderFileSizeAtPath:(NSString *)folderPath{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[fileManager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString *fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self lm_getFileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize / 1024.0;
}

/**
 *  清理缓存
 */
- (void)lm_clearFileCachesFromPath:(NSString *)folderPath{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *files = [fileManager subpathsAtPath:folderPath];
    
    for (NSString *path in files) {
        
        NSError *error = nil;
        
        NSString *childPath = [folderPath stringByAppendingPathComponent:path];
        
        if ([fileManager fileExistsAtPath:childPath]) {
            
            [fileManager removeItemAtPath:childPath error:&error];
        }
    }
    
    [self performSelectorOnMainThread:@selector(lm_clearSuccess:) withObject:nil waitUntilDone:YES];
    
}

- (void)lm_clearSuccess:(clearSuccessBlock)successBlock{
    
    NSLog(@"清理成功");
}

/**
 *  获取沙盒主目录路径
 */
+ (NSString *)lm_homeDirectory{
    
    return NSHomeDirectory();
}

/**
 *  获取Documents目录路径
 */
+ (NSString *)lm_documentDirectory{
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

/**
 *  获取Caches目录路径
 */
+ (NSString *)lm_cachesDirectory{
    
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

/**
 *  获取tmp目录路径
 */
+ (NSString *)lm_tmpDirectory{
    
    return NSTemporaryDirectory();
}
@end
