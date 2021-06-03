//
//  HttpManager.m
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import "HttpManager.h"
#import "McryptManager.h"
#import "AppDelegate.h"

typedef NS_ENUM(NSInteger, NSPUIImageType) {
    NSPUIImageType_JPEG,
    NSPUIImageType_PNG,
    NSPUIImageType_GIF,
    NSPUIImageType_Unknown
};

static NSSting *baseHost = @"";
static NSSting *testHost = @"";

@interface HttpManager ()

@end

@implementation HttpManager

+ (instancetype)share {
    static HttpManager *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[HttpManager alloc] init];
    });
    return obj;
}

- (void)resetUserToken {
    NSString *userToken = [[UserManger share] getUserToken];
    [_sessionManager.requestSerializer setValue:userToken forHTTPHeaderField:@"XX-Token"];
    [_jsonSessionManager.requestSerializer setValue:userToken forHTTPHeaderField:@"XX-Token"];
}

- (BOOL)isDevelopmentMode {
#ifdef DEBUG
    return true;
#else
    return false;
#endif
}

+ (NSString *)hostAutoChange:(NSString *)urlString port:(NSString *)port {
    NSURL *url = [NSURL URLWithString:urlString];
    
    if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
        return urlString;
    }
    NSString *urlHost;
    NSString *urlScheme;
    if ([[HttpManager share] isDevelopmentMode]) {//是开发环境
//#warning testServerHost
        urlScheme = @"http://";
        urlHost = baseHost;
    } else {
        urlScheme = @"http://";
        urlHost = testHost;
    }
    
    if (port.length) {
        urlHost = [urlHost stringByAppendingFormat:@":%@", port];
    }
    urlString = [NSString stringWithFormat:@"%@%@", urlScheme, [urlHost stringByAppendingPathComponent:url.path]];
    
    NSLog(@"urlString:%@", urlString);
    
    return urlString;
}

- (id)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest =  30;
        
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[configuration copy]];
        _sessionManager.operationQueue.maxConcurrentOperationCount = 10;
        
//        [_sessionManager.requestSerializer setValue:[HTTPNetworking userAgent] forHTTPHeaderField:@"User-Agent"];
//        XX-Device-Type
        
        NSMutableSet *set = [NSMutableSet setWithSet:_sessionManager.responseSerializer.acceptableContentTypes];
        [set addObject:@"text/html"];
        [set addObject:@"text/plain"];
        [set addObject:@"image/jpeg"];
        [set addObject:@"multipart/form-data"];
        _sessionManager.responseSerializer.acceptableContentTypes = set;

        //用户token
        NSString *userToken = [[UserManger share] getUserToken];
        NSLog(@"userToken:%@", userToken);
        if (userToken) {
            [_sessionManager.requestSerializer setValue:userToken forHTTPHeaderField:@"XX-Token"];
        }
        [_sessionManager.requestSerializer setValue:@"iphone" forHTTPHeaderField:@"XX-Device-Type"];
        
        //获取版本号
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        [_sessionManager.requestSerializer setValue:app_Version forHTTPHeaderField:@"XX-Versioncode"];
        
        _jsonSessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[configuration copy]];
        _jsonSessionManager.operationQueue.maxConcurrentOperationCount = 10;
        _jsonSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];

        [_jsonSessionManager.requestSerializer setValue:@"application/json;multipart/form-data;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        if (userToken) {
            [_jsonSessionManager.requestSerializer setValue:userToken forHTTPHeaderField:@"XX-Token"];
        }
        [_jsonSessionManager.requestSerializer setValue:app_Version forHTTPHeaderField:@"XX-Versioncode"];
        [_jsonSessionManager.requestSerializer setValue:@"iphone" forHTTPHeaderField:@"XX-Device-Type"];
        
    }
    return self;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                  networkBlock:(NetworkBlock)networkBlock {
    //手动增加header内容
    NSString *timeString = [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970];
    NSString *time = [McryptManager encryptUseAESForString:timeString key:McryptSecretKey];
    NSString *encrypt = [McryptManager encryptUseAESForString:[NSString stringWithFormat:@"qukanjisu%@", timeString] key:McryptSecretKey];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if ([time isNotEmpty]) {
        [headers setValue:time forKey:@"XX-Time"];
    }
    if ([encrypt isNotEmpty]) {
        [headers setValue:encrypt forKey:@"XX-Encrypt"];
    }
    
    NSURLSessionDataTask *task = [_sessionManager POST:URLString parameters:parameters headers:headers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSDictionary *responseDict = (NSDictionary *)responseObject;
            
            //抓包存储，
            NSFileManager *fildManager = [NSFileManager defaultManager];
            NSString *docPath = [NSString stringWithFormat:@"%@/Documents/接口抓包/",NSHomeDirectory()];
            BOOL isDir;
            [fildManager fileExistsAtPath:docPath isDirectory:&isDir];
            if (!isDir) {
                NSError *errorDirectory = nil;
                BOOL createSuccess = [fildManager createDirectoryAtPath:docPath withIntermediateDirectories:true attributes:nil error:&errorDirectory];
                if (createSuccess) {
                    //写入数据
                }
            }
            
            NSURL *url = [NSURL URLWithString:URLString];
            NSString *newPathComponent = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            NSString *filePath = [docPath stringByAppendingFormat:@"%@.txt", newPathComponent];
            if (![fildManager fileExistsAtPath:filePath]) {
                if ([responseDict safeValueForKey:@"data"]) {
                    NSError *saveError = nil;
                    NSData *responseData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
                    if ([responseData writeToFile:filePath options:NSDataWritingAtomic error:&saveError]) {
                        NSLog(@"写入数据到%@", filePath);
                    } else {
                        NSLog(@"写入失败%@\n%@", filePath, saveError);
                    }
                }
            }
            
            NSString *message = [responseDict safeValueForKey:@"msg"];
            NSInteger code = [[responseDict safeValueForKey:@"code"] integerValue];
            switch (code) {
                case 10001:{
                    //用户未登录(在其他设备登录后token被清空)
//                    [ShowAlertTipHelper showInView:[UIApplication sharedApplication].keyWindow text:message time:0.5f completeBlock:^{
//                        [(AppDelegate *)[UIApplication sharedApplication].delegate setRootLoginViewController];
//                    }];
                }
                    break;
                default:{
                    if (networkBlock) {
                        networkBlock(responseObject, nil);
                    }
                }
                    break;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (networkBlock) {
            networkBlock(nil, error);
        }
    }];
    
    return task;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                 networkBlock:(NetworkBlock)networkBlock {
    //手动增加header内容
    NSString *timeString = [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970];
    NSString *time = [McryptManager encryptUseAESForString:timeString key:McryptSecretKey];
    NSString *encrypt = [McryptManager encryptUseAESForString:[NSString stringWithFormat:@"qukanjisu%@", timeString] key:McryptSecretKey];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if ([time isNotEmpty]) {
        [headers setValue:time forKey:@"XX-Time"];
    }
    if ([encrypt isNotEmpty]) {
        [headers setValue:encrypt forKey:@"XX-Encrypt"];
    }
    
    NSURLSessionDataTask *task = [_sessionManager GET:URLString parameters:parameters headers:headers progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSDictionary *responseDict = (NSDictionary *)responseObject;

            NSString *message = [responseDict safeValueForKey:@"msg"];
            NSInteger code = [[responseDict safeValueForKey:@"code"] integerValue];
            switch (code) {
                case 10001:{
                    //用户未登录(在其他设备登录后token被清空)
//                    [ShowAlertTipHelper showInView:[UIApplication sharedApplication].keyWindow text:message time:0.5f completeBlock:^{
//                        [(AppDelegate *)[UIApplication sharedApplication].delegate setRootLoginViewController];
//                    }];
                }
                    break;
                default:{
                    if (networkBlock) {
                        networkBlock(responseObject, nil);
                    }
                }
                    break;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (networkBlock) {
            networkBlock(nil, error);
        }
    }];
    
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(nullable id)parameters
     constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> _Nonnull))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    //手动增加header内容
    NSString *timeString = [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970];
    NSString *time = [McryptManager encryptUseAESForString:timeString key:McryptSecretKey];
    NSString *encrypt = [McryptManager encryptUseAESForString:[NSString stringWithFormat:@"qukanjisu%@", timeString] key:McryptSecretKey];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if ([time isNotEmpty]) {
        [headers setValue:time forKey:@"XX-Time"];
    }
    if ([encrypt isNotEmpty]) {
        [headers setValue:encrypt forKey:@"XX-Encrypt"];
    }
    
    return [_sessionManager POST:URLString parameters:parameters headers:headers constructingBodyWithBlock:block progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    //手动增加header内容
    NSString *timeString = [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970];
    NSString *time = [McryptManager encryptUseAESForString:timeString key:McryptSecretKey];
    NSString *encrypt = [McryptManager encryptUseAESForString:[NSString stringWithFormat:@"qukanjisu%@", timeString] key:McryptSecretKey];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if ([time isNotEmpty]) {
        [headers setValue:time forKey:@"XX-Time"];
    }
    if ([encrypt isNotEmpty]) {
        [headers setValue:encrypt forKey:@"XX-Encrypt"];
    }
    
    return [_sessionManager GET:URLString parameters:parameters headers:headers progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)JsonGET:(NSString *)URLString
                       parameters:(id)parameters
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    //手动增加header内容
    NSString *timeString = [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970];
    NSString *time = [McryptManager encryptUseAESForString:timeString key:McryptSecretKey];
    NSString *encrypt = [McryptManager encryptUseAESForString:[NSString stringWithFormat:@"qukanjisu%@", timeString] key:McryptSecretKey];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if ([time isNotEmpty]) {
        [headers setValue:time forKey:@"XX-Time"];
    }
    if ([encrypt isNotEmpty]) {
        [headers setValue:encrypt forKey:@"XX-Encrypt"];
    }
    
    return [_jsonSessionManager GET:URLString parameters:parameters headers:headers progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)JsonPOST:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    //手动增加header内容
    NSString *timeString = [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970];
    NSString *time = [McryptManager encryptUseAESForString:timeString key:McryptSecretKey];
    NSString *encrypt = [McryptManager encryptUseAESForString:[NSString stringWithFormat:@"qukanjisu%@", timeString] key:McryptSecretKey];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if ([time isNotEmpty]) {
        [headers setValue:time forKey:@"XX-Time"];
    }
    if ([encrypt isNotEmpty]) {
        [headers setValue:encrypt forKey:@"XX-Encrypt"];
    }
    
    return [_jsonSessionManager POST:URLString parameters:parameters headers:headers progress:nil success:success failure:failure];
}

#pragma mark 上传单张图片
- (void)uploadImageWithURLString:(NSString *)URLString image:(UIImage *)image imageName:(NSString *)imageName params:(NSDictionary *)params progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress block:(NetworkBlock)networkBlock {
    NSArray *array = [NSArray arrayWithObject:image];
    NSArray *nameArray = [NSArray arrayWithObject:imageName];
    [self uploadImageWithURLString:URLString photos:array imageNames:nameArray params:params progress:uploadProgress block:networkBlock];
}

#pragma mark 上传图片
- (void)uploadImageWithURLString:(NSString *)URLString photos:(NSArray *)photos imageNames:(NSArray *)imageNames params:(NSDictionary *)params progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress block:(NetworkBlock)networkBlock {
    //手动增加header内容
    NSString *timeString = [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970];
    NSString *time = [McryptManager encryptUseAESForString:timeString key:McryptSecretKey];
    NSString *encrypt = [McryptManager encryptUseAESForString:[NSString stringWithFormat:@"qukanjisu%@", timeString] key:McryptSecretKey];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if ([time isNotEmpty]) {
        [headers setValue:time forKey:@"XX-Time"];
    }
    if ([encrypt isNotEmpty]) {
        [headers setValue:encrypt forKey:@"XX-Encrypt"];
    }
    
    [_sessionManager POST:URLString parameters:params headers:headers constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
//        RALog(@"%@====>%@", params, formData);
        //压缩方法耗时且阻挡了主线程？
        for (int i = 0; i < photos.count; i ++) {
            NSString *imageName = [imageNames objectAtSafeIndex:i];
            if (!imageName) {
                imageName = imageNames.firstObject ?  : [NSString stringWithFormat:@"photo[]"];
            }
            UIImage *image;
            NSData *imageData;
            if ([[photos objectAtSafeIndex:i] isKindOfClass:[UIImage class]]) {
                image = [photos objectAtSafeIndex:i];
                if (image.size.width != 0 && image.size.height != 0) {
//                    imageData = [UIImage compressImageDataWithImage:image toByte:1024*1024];
                } else {
//                    imageData = [NSData dataWithBytes:NULL length:0];
                }
            }
            if ([[photos objectAtSafeIndex:i] isKindOfClass:[NSData class]] ) {
                imageData = [photos objectAtSafeIndex:i];
                if (imageData.length) {
//                    imageData = [UIImage compressImageDataWithData:imageData toByte:1024*1024];
                }
            }
//            NSPUIImageType imageType = NSPUIImageTypeFromData(imageData);
            NSString *imageMimeType;
            NSString *extensionName;
//            switch (imageType) {
//                case NSPUIImageType_PNG:{
//                    imageMimeType = @"image/png";
//                    extensionName = @"png";
                    
//                    imageData = [UIImage compressImageDataWithData:imageData toByte:1024*1024];
//                }
//                    break;
//                case NSPUIImageType_JPEG:{
//                    imageMimeType = @"image/jpeg";
//                    extensionName = @"jpg";
                    
//                    imageData = [UIImage compressImageDataWithData:imageData toByte:1024*1024];
//                }
//                    break;
//                case NSPUIImageType_GIF:{
//                    imageMimeType = @"image/gif";
//                    extensionName = @"gif";
//                }
//                    break;
//                default:{
                    imageMimeType = @"image/jpeg";
                    extensionName = @"jpg";
                    
//                    imageData = [UIImage compressImageDataWithData:imageData toByte:1024*1024];
//                }
//                    break;
//            }
//            if (imageData.length) {
                [formData appendPartWithFileData:imageData name:imageName fileName:[NSString stringWithFormat:@"%@.%@", imageName, extensionName] mimeType:imageMimeType];
//            } else {
//                [formData appendPartWithFormData:imageData name:imageName];
//            }
        }
    } progress:^(NSProgress * _Nonnull progress) {
        NSLog(@"uploadProgress is %lld,总字节 is %lld",progress.completedUnitCount,progress.totalUnitCount);
        if (uploadProgress) {
            uploadProgress(progress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSDictionary *responseDict = (NSDictionary *)responseObject;
            NSString *message = [responseDict safeValueForKey:@"msg"];
            NSInteger code = [[responseDict safeValueForKey:@"code"] integerValue];
            switch (code) {
                case 10001:{
                    //用户未登录(在其他设备登录后token被清空)
//                    [ShowAlertTipHelper showInView:[UIApplication sharedApplication].keyWindow text:message time:0.5f completeBlock:^{
//                        [(AppDelegate *)[UIApplication sharedApplication].delegate setRootLoginViewController];
//                    }];
                }
                    break;
                default:{
                    if (networkBlock) {
                        networkBlock(responseObject, nil);
                    }
                }
                    break;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (networkBlock) {
            networkBlock(nil, error);
        }
    }];
}


@end
