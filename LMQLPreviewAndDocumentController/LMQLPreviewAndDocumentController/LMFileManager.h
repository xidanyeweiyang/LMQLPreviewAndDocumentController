//
//  LMFileManager.h
//  LMQLPreviewAndDocumentController
//
//  Created by 刘明 on 16/9/28.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^clearSuccessBlock)();

@interface LMFileManager : NSObject

+ (instancetype)shared;

/**
 *  读取单个文件大小
 */
- (long long)lm_getFileSizeAtPath:(NSString *)filePath;

/**
 *  读取整个文件夹大小
 */
- (long long)lm_getFolderFileSizeAtPath:(NSString *)folderPath;

/**
 *  清理缓存
 */
- (void)lm_clearFileCachesFromPath:(NSString *)folderPath;

/**
 *  成功回调
 */
- (void)lm_clearSuccess:(clearSuccessBlock)successBlock;
/**
 *  获取沙盒主目录路径
 */
+ (NSString *)lm_homeDirectory;

/**
 *  获取Documents目录路径
 */
+ (NSString *)lm_documentDirectory;

/**
 *  获取Caches目录路径
 */
+ (NSString *)lm_cachesDirectory;

/**
 *  获取tmp目录路径
 */
+ (NSString *)lm_tmpDirectory;

@end
