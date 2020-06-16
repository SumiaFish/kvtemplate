//
//  KVHttpOpration.h
//  kvtemplate
//
//  Created by kevin on 2020/5/14.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "KVOperation.h"
#import "KVHttpToolInfos.h"

NS_ASSUME_NONNULL_BEGIN

@interface KVHttpOpration : KVOperation

@property (strong, nonatomic, readonly) KVHttpToolInfos *info;
@property (copy, nonatomic, readonly) NSString *url;
@property (strong, nonatomic, readonly) NSURLSessionTask *task;

- (instancetype)initWithUrl:(NSString *)url info:(KVHttpToolInfos *)info;

@end

@interface KVHttpUploadOpration : KVHttpOpration

/** 待上传文件路径 */
@property (copy, nonatomic, readonly, nullable) NSString *filePath;

//@property (copy, nonatomic, readonly, nullable) NSString *name;
@property (copy, nonatomic, readonly, nullable) NSString *fileName;
@property (copy, nonatomic, readonly, nullable) NSString *mimeType;

- (instancetype)initWithUrl:(NSString *)url info:(KVHttpToolInfos *)info NS_UNAVAILABLE;;

- (instancetype)initWithUrl:(NSString *)url info:(KVHttpToolInfos *)info filePath:(NSString *)filePath name:(NSString * _Nonnull)name fileName:(NSString * _Nonnull)fileName mimeType:(NSString * _Nonnull)mimeType;

@end

@interface KVHttpDownloadOpration : KVHttpOpration

@property (strong, nonatomic, readonly) NSURL *fileURL;

@end

NS_ASSUME_NONNULL_END
